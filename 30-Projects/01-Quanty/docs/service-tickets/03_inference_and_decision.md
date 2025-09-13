# Dev Tickets — Inference & Decision Layer (v1.0)
> Scope: 4 services — **Inference‑API**, **Confirm‑Service**, **Reco‑Orchestrator**, **Position‑Monitor**  
> Analogy: this is the **pilot cockpit** turning sensor fusion into a flight plan (a recommendation).

---

## 9) INFERENCE‑API (Go)

### Goal
For each `feats_ready` event, assemble all model calls and produce an `ml.candidate` with direction, confidence, and numeric knobs (SL/TP/offset factors).

### Inputs
- RMQ `feats_ready.<SYM>.<TF>` → pull Redis `vec:<SYM>:<TF>`
- gRPC clients to:
  - Pattern‑Classifier
  - Similarity‑API
  - Entry‑Expert (H/M/L LightGBM‑ONNX)
  - Risk‑Model (Quantile LGBM‑ONNX) → `sl_kATR`
  - RR‑Model (Quantile LGBM‑ONNX) → `rr_target`
  - Offset‑Model (Quantile LGBM‑ONNX) → `offset_kATR`

### Output (RMQ `ml.candidate.<SYM>.<TF>`)
```json
{
  "time":"2025-08-13T09:15:00Z","symbol":"ETHUSDT","tf":"15m",
  "side":"LONG", "conf_pat":0.78, "sim_conf":0.70,
  "sl_kATR":0.9, "rr_target":2.3, "offset_kATR":0.25,
  "entry_style":"STOP", "pattern":"flag","pole_kATR":5.9
}
```

### Core Logic
- Choose Expert variant by `liquidity_cluster`.  
- `Conf_total = f(Conf_pat, sim_conf, bias_4h/conf_4h_prov, status_flag)` inside model; also expose it for Confirm gate.  
- Attach SHAP top‑5 features (optional lightweight) to payload for audit.

### Non‑Functional
- p95 end‑to‑end ≤ 10ms (cached gRPC channels).  
- Circuit‑break per downstream (skip if service down; still publish minimal candidate).

### Acceptance
- If vector lacks LOB fields (EXCLUDED coin), still emits candidate with NaNs handled.  
- Offsets positive → `entry_style=STOP`, negative → `LIMIT`.

---

## 10) CONFIRM‑SERVICE (Go)

### Goal
Short **wait‑window** to approve/veto/invert candidates (15m=10min, 1h=45min). For 4h/1d publish **provisional bias immediately**, confirm/cancel next bar with **slow metrics only**.

### Inputs
- RMQ `ml.candidate.*`, plus stream access to `price_updates`, `metric_updates`, `lob.snap`

### Decisions
- **15m/1h** (fast flow‑check):
  - Veto if `spoof_ratio > 3` against side
  - Veto if `cvd_slope_z` fails to flip toward side within window
  - Invert if sustained spoof wall opposite & `absorp_score < 0.2`
- **4h/1d** (trend‑check):
  - Immediately publish provisional bias: `bias.update.<SYM>.<TF> {provisional:true}`
  - Next bar: confirm if **funding trend**, **basis trend**, **4h CVD dir** support; else `bias.cancel`

### Outputs
- Approvals: RMQ `ml.confirmed.<SYM>.<TF>` (copy candidate + `conf_total` used)  
- Bias topics: `bias.update.*`, `bias.cancel.*`

### Non‑Functional
- Internal window map keyed by `<SYM>:<TF>`; single‑flight per candidate.  
- Idempotent: multiple identical candidates suppressed.

### Acceptance
- Spoof detected → inversion emits within window; otherwise veto after timeout.  
- Provisional bias boosts low‑TF trades softly; confirmation increases weight.

---

## 11) RECO‑ORCHESTRATOR (Go)

### Goal
Build the **final recommendation**: entry price, SL, TP (RR or flag‑pole), risk %, max leverage, hold time; enforce **CVaR guard** and **HRP cluster budget**.

### Inputs
- RMQ `ml.confirmed.*`  
- Redis (latest ATR) and TS (latest close)  
- Model services (for recalcs if needed)  
- Portfolio overlays:
  - **CVaR Guard** (symbol‑level tail loss estimate)
  - **HRP Overlay** (cluster‑level budget today)

### Calculations
- **Entry**: `entry = last + offset_kATR × ATR` (STOP if +, LIMIT if −).  
- **SL**: `SL = sl_kATR × ATR`, adjust ±10% by ATR_z, liquidity L, spoof/absorption flags.  
- **TP**: `TP = max(rr_target, 0.9 × pole_kATR) × SL`.  
- **Daily bands cap**: keep SL/TP inside `(dip/peak/tr)_hard` limits.  
- **Macro nudges** (BTC MVRV/SOPR/NUPL): trim RR / risk / leverage in euphoria; boost on healing.  
- **Risk %**: 0.25–1.5 % (confidence & macro & probation).  
- **MaxLev** tiers: ATR_z/Spread/Spot vs Perp flow rules (1–7×).  
- **CVaR guard**: ensure `maxLossAtStop ≤ risk_budget` → downscale size or cap leverage.  
- **HRP overlay**: if cluster over budget, downscale size factor for new trades.

### Output (RMQ `validated.recs.<SYM>` & TS `trades`)
```json
{
 "id":"01J...ULID","symbol":"SOLUSDT","tf":"15m","side":"LONG",
 "entry":45.12,"stop":44.80,"take":47.31,
 "rr":2.3,"risk_pct":1.0,"max_lev":5,"hold_min":360,
 "reasons":["flag","bias_4h_up","macro_dpi_up"]
}
```

### Non‑Functional
- Deterministic rounding (tick size).  
- All numbers signed & timestamped for audit.  
- Write‑ahead to TS; publish only after DB success.

### Acceptance
- Flag with big pole gets pole override.  
- Euphoria regime trims RR/risk appropriately.  
- HRP reduces size when cluster saturated.

---

## 12) POSITION‑MONITOR (Go)

### Goal
Watch user fills/executions; keep live P/L and pass execution events to Exit‑Advisor and UI.

### Inputs
- User exchange WS/API (per account), mapping trade ULIDs → client order IDs.

### Logic
- On fill: update TS `trades` executions table; emit `trade.adjust.<USER>/<SYM>` with fill price/qty and new avg price.  
- On partial fills: multiple adjust events; idempotency key is exchange execution ID.

### Output
- RMQ `trade.adjust.*`  
- TS `trade_execs`

### Acceptance
- Duplicate fills ignored by idempotency key.  
- P/L displayed live in GraphQL queries after fills.
