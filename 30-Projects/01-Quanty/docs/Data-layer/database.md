
# Database Handbook — TimescaleDB/PostgreSQL (Authoritative)

**Purpose:** Define the complete relational storage layer for ingestion, features, ML artifacts, recommendations, and ops.

> Analogy: TimescaleDB is our **warehouse**. This doc is the aisle map, bin labels, and forklift rules.

---

## 0) Conventions
- All times are **UTC** (`TIMESTAMPTZ`), bar timestamps are **bar-close**.
- Symbol format: `AASSETQUOTE`, e.g., `SOLUSDT`.
- Timeframes: `'1m','15m','1h','4h','1d'`.
- Naming: schema prefixes `core`, `ml`, `macro`, `ops`.
- Primary keys cover `(symbol, ts)` for time series; hypertables chunked by `ts`.

---

## 1) Extensions & Global Setup
```sql
CREATE EXTENSION IF NOT EXISTS timescaledb;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS uuid-ossp;
CREATE EXTENSION IF NOT EXISTS vector;   -- pgvector for embeddings
```

**Settings (postgresql.conf):**
- `shared_buffers` ≥ 25% RAM, `work_mem` 64–256MB, `effective_cache_size` 50–75% RAM.
- `timescaledb.telemetry_level=off` (prod).
- WAL: `wal_compression=on`, `max_wal_size` sized for ingest spikes.

---

## 2) Raw Time Series (Ingest)

### 2.1 Bars — `core.raw_bars`
```sql
CREATE TABLE core.raw_bars (
  symbol   TEXT NOT NULL,
  tf       TEXT NOT NULL CHECK (tf='1m'),
  ts       TIMESTAMPTZ NOT NULL,  -- bar close
  open     DOUBLE PRECISION NOT NULL,
  high     DOUBLE PRECISION NOT NULL,
  low      DOUBLE PRECISION NOT NULL,
  close    DOUBLE PRECISION NOT NULL,
  volume   DOUBLE PRECISION NOT NULL,
  trades   INTEGER DEFAULT 0,
  vwap     DOUBLE PRECISION,
  source   TEXT DEFAULT 'binance',
  PRIMARY KEY (symbol, ts)
);
SELECT create_hypertable('core.raw_bars','ts',chunk_time_interval => INTERVAL '7 days', if_not_exists => TRUE);
CREATE INDEX ON core.raw_bars (symbol, ts DESC);
SELECT add_retention_policy('core.raw_bars', INTERVAL '365 days');
SELECT compress_chunk_policy('core.raw_bars', INTERVAL '14 days');  -- compress chunks older than 14d
```

**Producers:** OHLCV‑Ingestor.  
**Consumers:** Feature‑Engine, GraphQL (candles).  
**Invariants:** `low ≤ min(open,close) ≤ max(open,close) ≤ high`.

---

### 2.2 Derivatives/Flow — `core.metric_15s`
```sql
CREATE TABLE core.metric_15s (
  symbol         TEXT NOT NULL,
  ts             TIMESTAMPTZ NOT NULL,
  funding        DOUBLE PRECISION,     -- normalized per hour
  open_interest  DOUBLE PRECISION,     -- notional quote
  cvd_delta      DOUBLE PRECISION,     -- 15s cumulative vol delta
  source         TEXT DEFAULT 'binance',
  PRIMARY KEY (symbol, ts)
);
SELECT create_hypertable('core.metric_15s','ts',chunk_time_interval => INTERVAL '7 days', if_not_exists => TRUE);
CREATE INDEX ON core.metric_15s (symbol, ts DESC);
SELECT add_retention_policy('core.metric_15s', INTERVAL '365 days');
```

**Producers:** Metric‑Ingestor (15s).  
**Consumers:** Feature‑Engine, Confirm‑Service.

---

### 2.3 Order Book — `core.lob_1s` (optional)
```sql
CREATE TABLE core.lob_1s (
  symbol     TEXT NOT NULL,
  ts         TIMESTAMPTZ NOT NULL,
  sum_bid1   DOUBLE PRECISION,
  sum_ask1   DOUBLE PRECISION,
  sum_bid10  DOUBLE PRECISION,
  sum_ask10  DOUBLE PRECISION,
  PRIMARY KEY (symbol, ts)
);
SELECT create_hypertable('core.lob_1s','ts',chunk_time_interval => INTERVAL '7 days', if_not_exists => TRUE);
CREATE INDEX ON core.lob_1s (symbol, ts DESC);
SELECT add_retention_policy('core.lob_1s', INTERVAL '90 days');
SELECT compress_chunk_policy('core.lob_1s', INTERVAL '7 days');
```

**Producers:** LOB‑Sampler (1s).  
**Consumers:** Feature‑Engine (spoofing/absorption), Confirm‑Service.

---

## 3) Continuous Aggregates (CAs)
We roll up raw bars for higher TFs.

```sql
-- 15m bars
CREATE MATERIALIZED VIEW core.bar15m WITH (timescaledb.continuous) AS
SELECT symbol,
       time_bucket('15 minutes', ts) AS ts,
       first(open, ts)   AS open,
       max(high)         AS high,
       min(low)          AS low,
       last(close, ts)   AS close,
       sum(volume)       AS volume,
       sum(trades)       AS trades
FROM core.raw_bars
GROUP BY symbol, time_bucket('15 minutes', ts);
CREATE INDEX ON core.bar15m (symbol, ts DESC);
SELECT add_continuous_aggregate_policy('core.bar15m',
  start_offset => INTERVAL '30 days',
  end_offset   => INTERVAL '1 minute',
  schedule_interval => INTERVAL '1 minute');
-- Repeat for bar1h, bar4h, bar1d
```

**Consumers:** Feature‑Engine, GraphQL.

---

## 4) Macro & On‑Chain Schemas

### 4.1 `macro.onchain_15m`
```sql
CREATE TABLE macro.onchain_15m (
  ts                  TIMESTAMPTZ PRIMARY KEY,
  btc_ex_netflow      DOUBLE PRECISION,
  btc_ex_reserve_pct  DOUBLE PRECISION,
  eth_ex_netflow      DOUBLE PRECISION,
  sol_ex_netflow      DOUBLE PRECISION,
  stbl_cex_netflow    DOUBLE PRECISION,
  eth_gas_price       DOUBLE PRECISION
);
SELECT create_hypertable('macro.onchain_15m','ts', if_not_exists => TRUE);
CREATE INDEX ON macro.onchain_15m (ts DESC);
```

### 4.2 `macro.btc_daily`
```sql
CREATE TABLE macro.btc_daily (
  d            DATE PRIMARY KEY,
  mvrv         DOUBLE PRECISION,
  a_sopr_7d    DOUBLE PRECISION,
  nupl         DOUBLE PRECISION,
  nupl_regime  SMALLINT  -- 0=capitulation,1=hope,2=belief,3=euphoria
);
```

---

## 5) Registry & Governance

### 5.1 `core.coin_registry`
```sql
CREATE TABLE core.coin_registry (
  symbol            TEXT PRIMARY KEY,
  status            TEXT NOT NULL,          -- ACTIVE|PROBATION|EXCLUDED|ACTIVE_OVERRIDE
  liquidity_cluster TEXT NOT NULL,          -- H|M|L
  data_health       SMALLINT NOT NULL,      -- 0..100
  first_listed_at   TIMESTAMPTZ,
  vol_24h_usd       DOUBLE PRECISION,
  spread_pct        DOUBLE PRECISION,
  depth10_usd       DOUBLE PRECISION,
  last_updated      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX ON core.coin_registry (status, liquidity_cluster);
```

**Producers:** Symbol‑Registry (nightly).  
**Consumers:** Ingest subscription control, Feature‑Engine, Reco sizing.

---

## 6) ML Artifacts & Trades

### 6.1 Embeddings — `ml.pattern_embeds`
```sql
CREATE TABLE ml.pattern_embeds (
  symbol     TEXT NOT NULL,
  tf         TEXT NOT NULL,
  ts         TIMESTAMPTZ NOT NULL,
  embed      VECTOR(64) NOT NULL,
  pattern    TEXT NOT NULL,
  quality    DOUBLE PRECISION NOT NULL,
  pole_kATR  DOUBLE PRECISION,
  realised_R DOUBLE PRECISION,
  PRIMARY KEY (symbol, tf, ts)
);
CREATE INDEX ON ml.pattern_embeds (symbol, tf, ts DESC);
CREATE INDEX ON ml.pattern_embeds USING hnsw (embed vector_cosine_ops);
```

### 6.2 Recommendations — `core.trades`, `core.trade_execs`
```sql
CREATE TABLE core.trades (
  trade_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ts_open      TIMESTAMPTZ NOT NULL,
  symbol       TEXT NOT NULL,
  tf           TEXT NOT NULL,
  side         SMALLINT NOT NULL,         -- +1 long, -1 short
  entry        DOUBLE PRECISION NOT NULL,
  stop         DOUBLE PRECISION NOT NULL,
  take_profit  DOUBLE PRECISION NOT NULL,
  rr_target    DOUBLE PRECISION NOT NULL,
  sl_katr      DOUBLE PRECISION NOT NULL,
  offset_katr  DOUBLE PRECISION NOT NULL,
  risk_pct     DOUBLE PRECISION NOT NULL,
  max_leverage DOUBLE PRECISION NOT NULL,
  conf_pat     DOUBLE PRECISION,
  sim_conf     DOUBLE PRECISION,
  conf_conf    DOUBLE PRECISION,
  pattern      TEXT,
  pole_katr    DOUBLE PRECISION,
  hold_policy  JSONB,
  reasons      JSONB,
  state        TEXT NOT NULL DEFAULT 'OPEN'   -- OPEN|CLOSED|CANCELLED
);
CREATE INDEX ON core.trades (symbol, ts_open DESC);

CREATE TABLE core.trade_execs (
  trade_id  UUID REFERENCES core.trades(trade_id),
  ts        TIMESTAMPTZ NOT NULL,
  px        DOUBLE PRECISION NOT NULL,
  qty       DOUBLE PRECISION NOT NULL,
  side      SMALLINT NOT NULL,
  kind      TEXT NOT NULL,                  -- FILL|PARTIAL|ADJUST|CLOSE
  PRIMARY KEY (trade_id, ts)
);
CREATE INDEX ON core.trade_execs (trade_id, ts);
```

### 6.3 Audit — `ops.explain_log`
```sql
CREATE TABLE ops.explain_log (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ts           TIMESTAMPTZ NOT NULL,
  symbol       TEXT NOT NULL,
  tf           TEXT NOT NULL,
  model        TEXT NOT NULL,    -- entry|risk|rr|offset|confirm
  inputs_json  JSONB NOT NULL,
  outputs_json JSONB NOT NULL,
  extra        JSONB
);
CREATE INDEX ON ops.explain_log (model, ts DESC);
```

---

## 7) Roles & Access
- `svc_ingest`: INSERT on `core.raw_bars`, `core.metric_15s`, `core.lob_1s`  
- `svc_feature`: SELECT raw/CAs; INSERT `ops.explain_log`  
- `svc_ml`: SELECT raw/CAs; SELECT `ml.pattern_embeds`  
- `svc_reco`: SELECT above; INSERT `core.trades`, `core.trade_execs`  
- `svc_gql`: READONLY for client views

**Row‑level security (optional multi‑tenant):** Add `tenant_id` column + RLS policies.

---

## 8) Maintenance
- Retention policies as defined; daily `VACUUM/ANALYZE` on hot tables.
- Backups: nightly base + WAL (pgBackRest or similar).
- Compression for >14d chunks to reduce storage.

---

## 9) Common Queries (examples)
```sql
-- Latest 200 bars for UI
SELECT * FROM core.bar15m WHERE symbol='SOLUSDT' ORDER BY ts DESC LIMIT 200;

-- Last 24h metrics stitched per minute
SELECT b.ts, b.close, m.funding, m.open_interest
FROM core.bar15m b
LEFT JOIN LATERAL (
  SELECT funding, open_interest FROM core.metric_15s m
  WHERE m.symbol=b.symbol AND m.ts BETWEEN b.ts - INTERVAL '14 seconds' AND b.ts + INTERVAL '1 second'
  ORDER BY m.ts DESC LIMIT 1
) m ON TRUE
WHERE b.symbol='SOLUSDT' AND b.ts >= NOW() - INTERVAL '24 hours'
ORDER BY b.ts;
```
