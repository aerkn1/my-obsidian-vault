
# ML Models Guide & Training Playbook (v1.0)

**Project:** Trade‑Analytics Platform  
**Audience:** Backend/ML engineers building, training, shipping, and monitoring models in this system.  
**Goal:** Explain **what each model does**, **its inputs/outputs**, **how to train/evaluate it**, and **how models work together**—end‑to‑end. Includes best practices for **data quality**, **model quality**, and **operational safety**.

> Analogy: Think of our ML stack like a **pit crew**. The Feature‑Engine prepares the car (feature vectors), the Pattern CNN spots track shapes from a drone view, the Similarity‑API looks up past laps on similar tracks, Entry/Risk/RR/Offset decide tires, fuel, and pit windows, the Confirm‑Service is Race Control, and Reco/Exit are the driver’s radio and strategy engineer.

---

## 0) Model Inventory (at a glance)

| Model | Type | Purpose | Inputs | Outputs | Train Cadence |
|---|---|---|---|---|---|
| **Pattern‑Classifier** | CNN (PyTorch → ONNX) | Detect price patterns & produce latent **embed** | 64×64×3 image (last 64 bars) | `pattern`, `quality`, `pole_kATR`, `embed(64)` | Nightly |
| **Similarity‑API** | Vector search (pgvector, HNSW) | Retrieve nearest historical analogs | `embed(64)` | `sim_conf`, `hist_rr_pct` | Continuous indexing |
| **Entry‑Expert (H/M/L)** | LightGBM (binary) | Probability the **proposed side** is favorable | Feature vector (68+) | `Conf_pat` ∈ [0,1], `side` | Nightly |
| **Risk‑Model** | LightGBM‑Quantile | Estimate stop distance in **ATR units** | Feature vector | `sl_kATR` | Nightly |
| **RR‑Model** | LightGBM‑Quantile | Estimate **target R** (risk‑reward) | Feature vector | `rr_target` | Nightly |
| **Entry‑Offset** | LightGBM‑Quantile | Predict optimal **entry offset** (±k·ATR) → STOP/LIMIT | Feature vector | `offset_kATR` (+/−) | Nightly |
| **Confirm‑Service** | Logistic/GBM + calibrator | Approve/Invert/Veto **candidates** using real‑time flow | Windowed footprint/OI/LOB/funding features | `Conf_conf`, decision | Online (scores per event) |
| **HRP Overlay** | Deterministic (no ML) | Cluster budgets for portfolio risk | Return matrix | `hrp:budget` | Daily |
| **CVaR Guard** | Statistical (EVT optional) | Cap position size/leverage by tail‑risk | Realized R losses | `cvar:SYMBOL:TF`, sizing | Daily |
| **(Optional) RL tuner** | Contextual bandit | Fine‑tune RR/leverage w/ logged feedback | Context + chosen action + reward | Action policy | Experimental |

---

## 1) Shared Data Assets

### 1.1 Feature Vector (68+ dims)
- Produced by **Feature‑Engine** per `(symbol, TF)` at each bar close; packed `float32[]` in Redis `vec:SYMBOL:TF`.
- Categories: **Volatility**, **Momentum**, **Trend**, **Daily Bands**, **Flow (CVD/OI)**, **Footprint/LOB**, **Derivatives (funding/basis)**, **Cross‑pair vs BTC/ETH**, **Higher‑TF bias**, **Macro (MVRV/aSOPR/NUPL, netflows)**.
- **Schema versioning:** bump `FEATURE_SCHEMA_VER` when reordering/adding; include in `metrics.json`.

### 1.2 Pattern Images (for CNN)
- Shape `64×64×3`, channels:
  1) **Candle texture** (H−L scaled, wick/body encoding)
  2) **EMA distance** (`C / EMA21`, clipped/log)
  3) **RSI momentum** (RSI normalized with slope)
- Normalized to [0,1]; optional Gaussian noise jitter 0.01–0.02 for robustness.

### 1.3 Outcome Labels (from Back‑Labeler)
For each **simulated trade** or **real alert**:
- `runup_R`, `drawdown_R` (in units of initial **R**); `realised_R`; `t_hit_TP`, `t_hit_SL` (mins); `max_favorable_excursion`, `max_adverse_excursion` in **ATR** and **R**.
- Used across Entry, Risk, RR, Offset training.

### 1.4 Splits & Leakage Prevention
- **Temporal split**: `train:val:test = 70:15:15` on **time blocks** (no random split). Ensure **future bars never leak** into features/labels.
- **Symbol stratification**: preserve proportion of H/M/L liquidity clusters.
- **De‑dup**: remove overlapping samples using hash of `(symbol, TF, bar_id)`.

---

## 2) Pattern‑Classifier (CNN → ONNX)

**Objective:** Detect shape regimes (flag, wedge, blowoff, wick exhaustion, none) and produce a robust **latent embedding**. Also estimate **pole_kATR** for flags.

**Inputs:** `64×64×3` image (last 64 bars).

**Labels:** Weak‑supervised + curated seeds. Use rule‑based detectors to generate candidates; hand‑verify a small seed; expand via pseudo‑labels with confidence thresholds. Handle class imbalance via **class weights** or **focal loss**.

**Architecture (reference):**
- `Conv(32,3x3) → BN → ReLU` × 2 → `MaxPool(2)`  
- `Conv(64,3x3) → BN → ReLU` × 2 → `MaxPool(2)`  
- `Conv(128,3x3,dilation=2) → BN → ReLU` × 2 → `GlobalAvgPool`  
- `FC(128) → ReLU → Dropout(0.2)` → **`FC(64)` = embedding**  
- Heads: classification (Cross‑Entropy or FocalLoss γ=2) + pole regression (Smooth‑L1; masked to flags).

**Training:** AdamW(lr=1e‑3), cosine schedule, 30–50 epochs, early stop 8; augment (time‑warps, scale jitter ±10%, MixUp α=0.2). Calibrate probs (temperature / isotonic).

**Metrics:** top1 acc, macro F1, per‑class PR‑AUC, ECE (calibration), MAE for pole_kATR.

**Export:** ONNX with dynamic axes; save `/pattern_cnn/vX_Y_Z/model.onnx` + `metrics.json` (class map, calibration, schema ver).

---

## 3) Similarity‑API (pgvector)

**Objective:** Retrieve historical analogs for current embedding.

**Data/Index:** `pattern_embeds(symbol, tf, ts, embed[64], pattern, quality, pole_kATR, realised_R)`; HNSW (cosine) M=16, ef_c=200; ef_search=64.

**Outputs:**  
- `sim_conf = mean(topk.quality) × mean(cosine_sim)`  
- `hist_rr_pct = percentile(topk.realised_R, p)` (p≈0.6–0.7).

---

## 4) Entry‑Expert (H/M/L, LightGBM)

**Objective:** Probability that the proposed side is favorable.

**Inputs:** Feature vector (68+) + liquidity cluster.

**Targets:** y=1 if a canonical **sim entry** reaches **+1R before −1R** within horizon (e.g., 6×TF).

**Model:** LightGBM (binary). Suggested params: `num_leaves=64, feature_fraction=0.9, bagging_fraction=0.8, min_data_in_leaf=50, lambda_l2=1.0`. Class weights for balance.

**Metrics:** AUC, PR‑AUC, Precision@k per symbol/day, expected R at threshold. **Calibrate** to get `Conf_pat` in [0,1].

---

## 5) Risk‑Model (LightGBM‑Quantile)

**Objective:** Predict stop distance `sl_kATR` in ATR units.

**Target:** Quantiles of **max drawdown** from entry within horizon (e.g., 4×TF). Use α∈{0.6,0.7,0.8}; default α=0.7 online.

**Metrics:** Pinball loss, coverage (Pr[DD ≤ pred]), SL hit‑rate in backtest.

---

## 6) RR‑Model (LightGBM‑Quantile)

**Objective:** Predict **target R** (`rr_target`).

**Target:** Quantiles of **realised_R**; default α=0.6 online (mild optimism with CVaR guard).

**Features:** Same as Entry + `pattern`, `pole_kATR`, `sim_conf`.

**Metrics:** Pinball loss, SMAPE on median, utility@k uplift vs fixed 2R.

---

## 7) Entry‑Offset (LightGBM‑Quantile)

**Objective:** Predict optimal **entry offset** (±k·ATR). Sign decides STOP (>0) vs LIMIT (<0).

**Target:** For each historical case, grid simulate offsets `{−0.25, −0.15, 0, +0.15, +0.25}·ATR`, pick the best expected R; set `Y = chosen_offset_kATR`.

**Metrics:** Pinball loss, correct entry‑style %, slippage/fill uplift vs baseline.

---

## 8) Confirm‑Service Model

**Objective:** Approve/invert/veto candidates using **real‑time flow**.

**Inputs:** Windowed aggregates over wait window (10m 15mTF / 45m 1hTF): `cvd_slope_z, oi_delta_z, absorption_score, spoof_ratio, heat_bias, basis_trend, funding_prem_z, %time_above_entry, vol_spike_z, bias_4h/conf, ATR_bucket`.

**Target:** y=1 if approving would yield `realised_R ≥ θ` (e.g., 0.8R) within horizon.

**Model:** Logistic (interpretable) or GBM. Output `Conf_conf`. Threshold by ATR bucket {0.48,0.52,0.56}.

**Metrics:** AUC, PR‑AUC, decision utility uplift.

---

## 9) Overlays (HRP & CVaR)

**HRP:** Correlation tree on 1h/4h returns → recursive bisection → cluster budgets → publish `hrp:budget`. Validate stability/turnover.

**CVaR:** Empirical tail loss or EVT (GPD). Expose `cvar:SYMBOL:TF` and **sizing API** so `tail loss ≤ budget`.

---

## 10) Optional RL Tuner

Contextual bandit to adjust RR/MaxLev around model suggestions. Offline eval via IPS/DR; shadow mode; strict bounds & CVaR guard.

---

## 11) Training Workflow

1. **Build datasets** (nightly): features parquet; pattern images; join labels from Back‑Labeler.  
2. **Time‑based splits** with symbol stratification.  
3. **Train** CNN (PyTorch) and GBMs (LightGBM). Quantile heads for Risk/RR/Offset.  
4. **Evaluate** (AUC/PR‑AUC, Pinball, ECE, utility/backtest uplift).  
5. **Export** to ONNX + `metrics.json` (schema ver, ranges, calibration).  
6. **Publish** to S3 `/family/vX_Y_Z/`; **Model‑Watcher** hot‑reloads.  
7. **Monitor** drift, calibration, win rate, realised R; rollback if SLO violated.

---

## 12) Data & Model Quality

- **Data integrity:** monotonic ts, OHLC invariants, non‑neg vol.  
- **Missingness:** impute short gaps; never forward‑fill flow/LOB beyond short windows.  
- **Stationarity:** prefer z‑scores, ratios; winsorize ±3σ; EWMA smoothing.  
- **Label leakage:** fixed management for Entry labels; avoid using future trailing outcomes.  
- **Calibration:** Platt/Isotonic for Entry & Confirm.  
- **Explainability:** SHAP for GBMs; monitor feature importance drift.

---

## 13) Training Data Requirements

| Model | Rows | Balance | Extras |
|---|---:|---|---|
| Pattern‑CNN | 200k+ images | ≥10k/class (weights ok) | pole_kATR head needs flag subset |
| Entry‑Expert H/M/L | 2–5M per cluster | y≈30–60% | horizon ≈ 6×TF |
| Risk‑Model | 2M+ | n/a | DD_kATR quantiles |
| RR‑Model | 2M+ | n/a | include pattern/pole/sim_conf |
| Offset‑Model | 2M+ | balanced by side | grid simulated offsets |
| Confirm | 500k+ candidates | pos 20–50% | windowed flow/LOB |

Storage (DVC/S3):
```
datasets/
  features/ver=7/TF=*/
  images/pattern/TF=*/
  labels/{entry,risk_rr,confirm}/
```

---

## 14) How‑to Train (scripts outline)

- **CNN:** `make_images.py` → `train_cnn.py` → `eval_cnn.py` → `export_onnx.py`  
- **GBMs:** `build_tabular.py` → `train_lgbm.py --task {entry|risk|rr|offset}` → `export_onnx_lgbm.py`  
- **Confirm:** `build_confirm_dataset.py` → `train_confirm.py --calibrate isotonic`  
- **Similarity:** `embed_dump.py` → `pgvector_ingest.py` (HNSW M=16, ef=200)

---

## 15) Runtime Contracts

- gRPC `Classify(Image) → {pattern, quality, pole_kATR, embed}`  
- gRPC/HTTP `Nearest(embed,k) → {sim_conf, hist_rr_pct}`  
- ONNX runtimes for Entry/Risk/RR/Offset return scalars; served inside Inference‑API.  
- Confirm subscribes `ml.candidate.*` and publishes `ml.confirmed.*` + `bias.update/cancel`.

---

## 16) Drawbacks & Mitigations

- **Regime shift**: ATR buckets, daily retrain, quantile models.  
- **Label noise**: weak‑supervision + manual seeds + MixUp + confidence filtering.  
- **Selection bias (Confirm)**: train on candidates and simulate counterfactuals.  
- **Drift**: PSI alarms, semver rollback, canaries.

---

## 17) Deliverables (S3 layout)

```
/family/vX_Y_Z/
  pattern_cnn.onnx
  entry_H.onnx  entry_M.onnx  entry_L.onnx
  risk.onnx     rr.onnx       offset.onnx
  metrics.json
```
