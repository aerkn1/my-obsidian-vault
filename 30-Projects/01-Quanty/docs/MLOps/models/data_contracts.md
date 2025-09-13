# Data Contracts & Schemas (Authoritative)

This file defines **every dataset schema** consumed/produced by ML models.

> Analogy: This is the **blueprint** of our kitchen pantry—every jar is labeled, weighed, and dated. No unlabeled spice jars.

---

## 1) Feature Vector (Redis → vec:SYMBOL:TF)

- **Key:** `vec:<symbol>:<tf>`
- **Type:** float32 array (packed, little-endian), versioned
- **Metadata sidecar:** `vecmeta:<symbol>:<tf>` JSON with `schema_ver`, `updated_at`, `source_bar_ts`

### 1.1 Schema (FEATURE_SCHEMA_VER=7)
| idx | name | type | unit | description |
|---:|---|---|---|---|
| 0 | ATR14 | float32 | price | Wilder ATR(14) |
| 1 | ATR_z | float32 | z | ATR z-score vs rolling |
| 2 | BB_width | float32 | ratio | Bollinger bandwidth (N=20, ±2σ) |
| 3 | RSI_14 | float32 | 0..100 | Relative Strength Index |
| 4 | rsi_zone | int8 | enum | 0=OS,1=NEU,2=OB |
| 5 | rsi_mom | float32 | /bar | RSI slope over k bars |
| 6 | rsi_div | int8 | flag | 1 if divergence detected |
| 7 | ema_ratio_21 | float32 | ratio | C/EMA21 |
| 8 | ema_ratio_60 | float32 | ratio | C/EMA60 |
| 9 | ema_ratio_200 | float32 | ratio | C/EMA200 |
| 10 | slope60 | float32 | %/yr | OLS slope last 60 bars |
| 11 | trend_flag | int8 | {-1,0,1} | EMA stack + slope |
| 12 | align_score | float32 | 0..1 | TF agreement fraction |
| 13 | dist_to_sr_1d | float32 | ATR | to nearest 1D S/R |
| 14 | atr_bucket_1d | int8 | enum | 0=low,1=mid,2=high |
| 15 | up_z | float32 | z | intraday up move z |
| 16 | down_z | float32 | z | intraday down move z |
| 17 | daily_tr_soft | float32 | ratio | soft daily TR |
| 18 | daily_tr_hard | float32 | ratio | hard daily TR |
| 19 | cvd_slope_z | float32 | z | 1m CVD slope z |
| 20 | oi_delta_z | float32 | z | OI delta z |
| 21 | whale_vol_z | float32 | z | top-size buy/sell vol z |
| 22 | cnt_delta_z | float32 | z | trade count z |
| 23 | absorption_score | float32 | 0..1 | absorption fraction |
| 24 | spoof_ratio | float32 | ratio | depth spike vs median |
| 25 | heat_bias | float32 | -1..1 | (bid10-ask10)/(sum) |
| 26 | vacuum_bid | int8 | flag | 1 if thin bids |
| 27 | vacuum_ask | int8 | flag | 1 if thin asks |
| 28 | funding_prem_z | float32 | z | funding premium z |
| 29 | basis | float32 | ratio | perp-spot/spot |
| 30 | basis_z | float32 | z | z-score of basis |
| 31 | basis_trend | float32 | /bar | slope of EMA(basis) |
| 32 | beta_btc | float32 | unit | rolling OLS beta |
| 33 | rel_z_btc | float32 | z | residual z vs BTC |
| 34 | dir_btc | int8 | sign | -1/0/1 trend of residual |
| 35 | beta_eth | float32 | unit | rolling OLS beta |
| 36 | rel_z_eth | float32 | z | residual z vs ETH |
| 37 | dir_eth | int8 | sign | -1/0/1 trend of residual |
| 38 | bias_4h | int8 | {-1,0,1} | high TF bias |
| 39 | conf_4h | float32 | 0..1 | confidence (prov/confirm) |
| 40 | mvrv_z | float32 | z | BTC regime z |
| 41 | sopr_above1 | int8 | flag | SOPR>1 |
| 42 | sopr_trend | float32 | /day | SOPR slope |
| 43 | nupl_regime_onehot_0 | int8 | 0/1 | cap |
| 44 | nupl_regime_onehot_1 | int8 | 0/1 | hope |
| 45 | nupl_regime_onehot_2 | int8 | 0/1 | belief |
| 46 | nupl_regime_onehot_3 | int8 | 0/1 | euphoria |
| 47 | macro_spi | float32 | z | spot pressure index |
| 48 | dpi | float32 | z | derivatives pressure index |
| 49 | srs | float32 | z | stable reserve stress |
| 50 | act | float32 | z | activity heat |
| 51 | chain_spi | float32 | z | chain local pressure |
| 52 | liquidity_H | int8 | 0/1 | cluster one-hot |
| 53 | liquidity_M | int8 | 0/1 | cluster one-hot |
| 54 | liquidity_L | int8 | 0/1 | cluster one-hot |
| 55 | tf_15m | int8 | 0/1 | TF one-hot |
| 56 | tf_1h | int8 | 0/1 | TF one-hot |
| 57 | tf_4h | int8 | 0/1 | TF one-hot |
| 58 | tf_1d | int8 | 0/1 | TF one-hot |

> Inference models read these **by index**. Keep `artifacts/feature_index_map.json` in sync with ONNX metadata.

---

## 2) Pattern Images Dataset

- **Path:** `datasets/images/pattern/TF=*/symbol=*/YYYYMM/*.npz`
- **NPZ content:**  
  - `img` → float32 `(64,64,3)` normalized to [0,1]  
  - `meta` → dict: `{symbol, tf, ts, bar_id, atr_at_ts, ema21_at_ts, rsi_at_ts}`

---

## 3) Labels

### 3.1 Entry Labels (`labels/entry/*.parquet`)
Columns:
- `symbol (str)`, `tf (str)`, `ts (int64 ms)`
- `y (int8)` — 1 if `+1R` hit before `-1R` within `H=6×TF` (canonical policy)
- `side (int8)` — 1 long, -1 short
- `confounders` — `atr_z (float32)`, `spread_pct (float32)` used for stratified analysis

### 3.2 Risk/RR/Offset (`labels/risk_rr/*.parquet`)
- `sl_kATR (float32)` — quantile target of MAE in ATR units (α grid)
- `rr_target (float32)` — quantile of realised_R (α grid)
- `offset_kATR (float32)` — optimal offset from grid simulation
- `aux` — `pole_kATR`, `pattern`, `sim_conf`

### 3.3 Confirm (`labels/confirm/*.parquet`)
- One row per **candidate** with window aggregates
- `approve_good (int8)` — 1 if approving yields `realised_R≥θ`

---

## 4) Pattern Embeddings (pgvector)

- **Table:** `pattern_embeds`
- **Columns:** `symbol text`, `tf text`, `ts timestamptz`, `embed vector(64)`, `pattern text`, `quality float`, `pole_kATR float`, `realised_R float`
- **Index:** HNSW (cosine) `M=16`, `ef_construction=200`

---

## 5) Trades / Back-Labeler

- **Source:** Timescale `trades` + `trade_execs`
- **Outputs (labels):** `realised_R`, `runup_R`, `drawdown_R`, `t_hit_TP`, `t_hit_SL`, `MFE/MFE_ATR`

---

## 6) File Naming & Versioning

- All derived datasets include `feature_schema_ver` in metadata footer.  
- Model families follow semver: `vMAJOR_MINOR_PATCH`.
