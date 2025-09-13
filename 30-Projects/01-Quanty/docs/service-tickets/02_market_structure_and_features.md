# Dev Tickets — Market Structure & Features Layer (v1.0)
> Scope: 4 services — **LOB‑Sampler**, **Feature‑Engine**, **Pattern‑Classifier**, **Similarity‑API**  
> Analogy: this is the **kitchen** converting raw ingredients (ticks, depth, macro) into a compact, chef‑ready dish (feature vector + pattern info).

---

## 5) LOB‑SAMPLER (optional, 1s)

### Goal
Downsample exchange order‑book (`depth@100ms`) to **1s frames** and compute basic depth aggregates.

### Inputs
- WS: `depth@100ms` for symbols in ACTIVE/PROBATION.

### Outputs
- TS `lob_1s` (hypertable)
  ```sql
  CREATE TABLE lob_1s(
    time TIMESTAMPTZ, symbol TEXT,
    sum_bid1 NUMERIC, sum_ask1 NUMERIC,
    sum_bid10 NUMERIC, sum_ask10 NUMERIC,
    PRIMARY KEY(time,symbol)
  );
  ```
- RMQ `lob.snap.<SYM>.1s` (optional fan‑out)

### Core Logic
- Within each second: keep latest snapshot; sum top 1 & top 10 levels on both sides.  
- Compute in Feature‑Engine (`spoof_ratio = maxAskDepth/medianAskDepth`, `heat_bias = (sum_bid10 - sum_ask10)/(sum_bid10 + sum_ask10)`).

### Acceptance
- Sequence gap recovery: if book IDs jump, resubscribe.  
- Backpressure: drop frames (not queue) if downstream is slow; TS remains the source of truth.

---

## 6) FEATURE‑ENGINE (Polars / Python)

### Goal
For each bar close and symbol+TF, produce a **float32[]** feature vector (~68 dims) and publish `feats_ready` event.

### Inputs
- RMQ: `price_updates`, `metric_updates`, `lob.snap` (fan‑in)  
- TS: `bar15m/1h/4h/1d` CA views, `metric_15s`, `lob_1s`, `macro_onchain_15m`, `macro_btc_daily`  
- Registry: `coin_registry` (status, cluster, chain)  
- Bias topics from Confirm: `bias.update.*`, `bias.cancel.*`

### Feature Set (illustrative; keep fixed order & index map)
- **Seasonal & daily bands**: `up_z`, `down_z`, `daily_dip_soft/hard`, `daily_peak_soft/hard`, `daily_tr_soft/hard`  
- **Volatility & momentum**: `ATR14`, `ATR_z`, `BB_width`, `RSI_14`, `rsi_zone/mom/div`  
- **Trend & structure**: `ema_ratio_21/60/200`, `slope60`, `trend_flag`, `pole_kATR` (if available)  
- **Flow**: `cvd_slope_z`, `oi_delta_z`, `whale_vol_z`, `cnt_delta_z`  
- **Footprint/LOB**: `absorp_score`, `spoof_ratio`, `heat_bias`, `vacuum_bid`  
- **Derivatives**: `funding_prem_z`, `basis_z`, `basis_trend`  
- **Cross‑pair**: `rel_z_btc/eth`, `dir_btc/eth`  
- **Higher‑TF bias**: `bias_4h`, `conf_4h` (provisional/confirmed), `bias_1d`  
- **Macro on‑chain** (market‑wide): `macro_spi/dpi/srs/act`, `chain_spi`  
- **BTC regime**: `mvrv_z`, `sopr_above1`, `sopr_trend`, `nupl_regime`  
- **Meta**: `status_flag`, `liquidity_cluster`

### Output
- **Redis** `vec:<SYM>:<TF>` (packed little‑endian float32).  
- **RMQ** `feats_ready.<SYM>.<TF>`:
  ```json
  {"time":"2025-08-13T09:15:00Z","symbol":"SOLUSDT","tf":"15m"}
  ```

### Calculations (high‑risk parts)
- **Z‑scores**: 90–120d rolling mean/std, winsorize ±3σ, EWMA smoothing (λ≈0.2).  
- **Divergence**: correlate 1s delta with 1s price within the last minute; negative corr with rising price → `delta_div`.  
- **Absorption**: % of 1s bricks with price advance despite net selling (or vice versa).  
- **Daily bands**: compute rolling median ± k·σ for `(OPEN‑LOW)/OPEN`, `(HIGH‑OPEN)/OPEN`, `(HIGH‑LOW)/OPEN`.  
- **Bias hand‑off**: write `bias_4h` as +1/−1/0 and `conf_4h` [0..1]; set provisional bit separately for model to use softer weight.

### Non‑Functional
- Per‑bar compute budget ≤ 10ms at p95.  
- Strict index map versioning; bump `FEATURE_SCHEMA_VER` upon change.  
- Safe on NaN: fill only where expressly permitted; otherwise leave NaN (LightGBM handles).

### Acceptance
- When `spoof_ratio>3` while price flat → `absorp_score` low; vector reflects both.  
- Macro outage → previous macro row reused; vector still published.

---

## 7) PATTERN‑CLASSIFIER (CNN → ONNX, gRPC)

### Goal
Detect multi‑bar chart patterns and extract an embedding for similarity search.

### API (protobuf)
```proto
service Pattern {
  rpc Classify (ClassifyReq) returns (ClassifyResp);
}
message ClassifyReq { bytes image64x3 = 1; } // float32 HWC
message ClassifyResp {
  string pattern = 1;   // flag, wedge, blowoff, wick_exhaustion, none
  float  quality = 2;   // 0..1
  float  pole_kATR = 3; // for flags
  repeated float embed = 4; // 64-d
}
```

### Inputs
- Built from last 64 bars (see image construction spec).

### Outputs
- Pattern label + quality + pole height + 64‑d embed.

### Non‑Functional
- p95 latency < 2ms per call (ONNX Runtime, CPU ok).  
- Deterministic (set seeds).

### Acceptance
- Synthetic flag windows score > 0.8; random walk windows near 0 (“none”).

---

## 8) SIMILARITY‑API (FastAPI + pgvector)

### Goal
Given a 64‑d embedding, find k nearest neighbors and return **sim_conf** and **hist_rr_pct** (realised‑R percentile).

### API
- `POST /similar` → `{ "embed":[...64], "k":32 }`  
- Returns: `{ "sim_conf":0.74, "hist_rr_pct":0.82 }`

### Data
- Postgres table with `embedding vector(64)`, `pattern_type`, `realised_r`.  
- Build HNSW index; refresh daily.

### Logic
- `sim_conf = mean(quality of top‑k) * cosSimMean`  
- `hist_rr_pct = percentile(rank(realised_r), k)`

### Acceptance
- For known look‑alikes, `hist_rr_pct` tracks backtest results within ±5 p.p.  
- k adjustable; latency < 5ms.
