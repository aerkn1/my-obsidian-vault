# Dev Tickets — Ingest & Registry Layer (v1.0)
> Scope: 4 services — **Symbol-Registry**, **Macro On‑Chain Ingestor**, **OHLCV‑Ingestor**, **Metric‑Ingestor**  
> Bus: RabbitMQ `trading.bus` (topic exchange). DSNs via env. Timezone = UTC.  
> Analogy: think of this layer as the **radar & control tower inputs** — everything downstream trusts these feeds.

---

## 1) SYMBOL‑REGISTRY (Nightly cron)

### Goal
Maintain the authoritative set of symbols with **status** (ACTIVE/PROBATION/EXCLUDED), **data_health (0‑100)** and **liquidity_cluster (H/M/L)**. Publish diffs.

### Inputs
- REST:
  - Binance `/api/v3/exchangeInfo`, `/api/v3/ticker/bookTicker` (to derive tickSize & spreads)
  - OKX `/api/v5/public/instruments`
  - CoinGecko `/coins/markets?vs_currency=usd` (mcap, categories)
- Local: `banlist.yml`, `centroids.json` (K‑means), thresholds in `symbol_registry.toml`

### Outputs
- Timescale `coin_registry`:
  ```sql
  CREATE TABLE coin_registry(
    symbol TEXT PRIMARY KEY,
    status TEXT,               -- ACTIVE | PROBATION | EXCLUDED | ACTIVE_OVERRIDE
    data_health INT,           -- 0..100
    liquidity_cluster TEXT,    -- H | M | L
    age_days INT,
    vol_24h NUMERIC,
    spread_pct NUMERIC,
    updated_at TIMESTAMPTZ DEFAULT now()
  );
  ```
- RMQ topic `symbol_events.updated` (JSON):
  ```json
  {"symbol":"SOL","status":"ACTIVE","cluster":"M","health":89}
  ```

### Core Logic
1) Pull vendor payloads with 10s timeout, 3x retries w/ backoff (100ms→1s→3s).  
2) Compute: `age_days`, `vol_24h` (spot), `spread_pct` (median over 24h), funding gaps (count), LOB depth availability (median L10 from archive if present).  
3) **Data‑Health score** (0–100): history coverage (35%), liquidity (25%), derivatives depth (15%), metric stability (15%), pump penalty (10%).  
4) **Status rules**:  
   - `ACTIVE` if score ≥ 70 && not banned  
   - `PROBATION` if < 70 (grace 7d)  
   - `EXCLUDED` after 7d probation  
   - `ACTIVE_OVERRIDE` via whitelist (log reason)  
5) K‑means (pre‑trained centroids) → `liquidity_cluster` H/M/L.  
6) Upsert table; publish `symbol_events.updated` only if any column changed.

### Config
- `REGISTRY_PULL_TIME=02:00:00Z`
- API keys (if required), DSNs: `TS_DSN`, `RMQ_URL`

### Non‑Functional
- Run time ≤ 60s for 200 symbols.  
- Idempotent upserts. Logs explain rejects (score breakdown).

### Acceptance Tests
- Given an asset dips to spread 0.5% → status flips to PROBATION and bus event fires.  
- Whitelisted new coin w/ high vol but low age → ACTIVE_OVERRIDE; cluster M/H set correctly.

---

## 2) MACRO ON‑CHAIN INGESTOR (15‑minute snapshots)

### Goal
Ingest small set of **market‑wide on‑chain metrics** (BTC/ETH/SOL + USDT/USDC). Produce macro indices for every coin to consume.

### Inputs
- Providers (Covalent/Bitquery/Glassnode‑like):  
  - BTC/ETH/SOL: `exchange_netflow`, BTC: `exchange_reserve_pct`, ETH: `gas_price`  
  - USDT, USDC: `cex_netflow_usd`
- Daily BTC regime: **MVRV, aSOPR(7d), NUPL** (once/day)

### Outputs
- TS tables:
  ```sql
  CREATE TABLE macro_onchain_15m(
    time TIMESTAMPTZ PRIMARY KEY,
    btc_ex_netflow NUMERIC,
    btc_ex_reserve_pct NUMERIC,
    eth_ex_netflow NUMERIC,
    eth_gas_price NUMERIC,
    sol_ex_netflow NUMERIC,
    stbl_cex_netflow NUMERIC
  );
  CREATE TABLE macro_btc_daily(
    day DATE PRIMARY KEY,
    mvrv NUMERIC,
    asopr_7d NUMERIC,
    nupl NUMERIC
  );
  ```
- (Optional) RMQ `onchain.macro.15m` with the same columns (fan‑out).

### Core Logic
- Every :00,:15,:30,:45 pull; upsert row.  
- Compute **indices in Feature‑Engine**, not here (keep this service dumb/IO‑bound).  
- Vendor delays tolerated; timestamp with vendor cursor time; never extrapolate.

### Config
- `ONCHAIN_SOURCES=covalent,bitquery`
- Retries with jitter; circuit‑break on 429.

### Acceptance
- Missing vendor → fallback works; produces row from alt source.  
- 24h outage → engine keeps old macro row; downstream uses last known state (feature vector shows previous macro state).

---

## 3) OHLCV‑INGESTOR (real‑time)

### Goal
Stream `aggTrade` ticks, build **1m OHLCV bars** and **1s footprint**; publish bars for downstream features and archive to Timescale.

### Inputs
- WS: `wss://stream.binance.com/stream?streams=<sym>@aggTrade`  
- Failover to OKX on disconnect > 5s

### Outputs
- TS `raw_bars` (hypertable), `footprint_1s`  
- RMQ `price_updates.<SYM>.1m` (bar JSON)

### Bar JSON
```json
{"time":"2025-08-13T09:15:00Z","symbol":"BTCUSDT","o":64500,"h":64580,"l":64490,"c":64560,"v":312.5}
```
### Footprint JSON (1s)
```json
{"time":"2025-08-13T09:15:01Z","symbol":"BTCUSDT","buy_vol":2.3,"sell_vol":3.1,"high":64562,"low":64552,"close":64555}
```

### Core Logic
- Ring‑buffer per symbol; flush 1s bricks; finalize bar on minute boundary.  
- Heartbeat: if no ticks within 2s, publish noop beat with last close to keep downstream clocks deterministic.  
- Idempotent inserts using `(time,symbol)` PK.  
- Backfill gaps on reconnect using REST `klines` (last 100 minutes).

### Config & Perf
- `AGG_WS_URL`, `TS_DSN`, `RMQ_URL`  
- 1 vCPU handles ~50 pairs; memory ~100MB per 100 pairs.

### Acceptance
- WS disconnect → REST backfill yields no duplicate bars.  
- Minute with zero ticks still produces a bar copied from last close (volume=0).

---

## 4) METRIC‑INGESTOR (15s cadence)

### Goal
Capture **funding rate**, **open interest**, and compute **CVD deltas**. Publish to DB + bus.

### Inputs
- REST/WS per exchange (Binance Futures):  
  - `/futures/data/fundingRate?symbol=...&limit=1`
  - `/futures/data/openInterestHist?...&period=5m&limit=1`
  - Ticks from OHLCV‑Ingestor (for CVD buckets)

### Outputs
- TS `metric_15s`:
  ```sql
  CREATE TABLE metric_15s(
    time TIMESTAMPTZ, symbol TEXT,
    funding FLOAT, open_interest FLOAT,
    cvd_delta FLOAT,
    PRIMARY KEY (time,symbol)
  );
  ```
- RMQ `metric_updates.<SYM>.15s`

### Core Logic
- Every 15s upsert latest funding/OI; aggregate tick side to `cvd_delta` per 15s window.  
- Normalize funding by 90‑day z‑score later in Feature‑Engine.  
- Ensure monotonic time (vendor timestamps).

### Acceptance
- Funding or OI endpoint fails → publish with `null` for that field; Feature‑Engine must tolerate NaN.  
- Clock skew detection: drop samples ahead of server time > 5s.

---

### Cross‑Service Bindings
- **Symbol‑Registry → Ingestors**: listen `symbol_events.updated` to subscribe/unsubscribe pairs; apply status flags.  
- **OHLCV/Metric → Feature‑Engine**: `price_updates`, `metric_updates` power feature computations.  
- **Macro On‑Chain → Feature‑Engine**: index row read once per bar.

