# Confirm‑Service Model — Deep Dive

## 1) Goal
Approve/invert/veto `ml.candidate` with real‑time **flow** checks.

## 2) Inputs (window aggregates)
- `cvd_slope_z`, `oi_delta_z`, `absorption_score`, `spoof_ratio`, `heat_bias`
- `basis_trend`, `funding_prem_z`, `%time_above_entry` (longs), `vol_spike_z`
- `bias_4h`, `conf_4h`, `ATR_bucket`

## 3) Labeling
- Build dataset from **historic candidates**. y=1 if approving yields `realised_R ≥ θR` within horizon; else 0.
- **Counterfactual approximation:** replay approvals on historical windows; exclude collided trades to reduce interference.

## 4) Model
- Logistic regression (L2=1.0) for interpretability; optionally GBM if AUC gain >0.02.
- Calibrate with isotonic; thresholds by ATR bucket: {0.48, 0.52, 0.56}.

## 5) Outputs
- `Conf_conf` ∈ [0..1], `decision ∈ {approve, invert, veto}`.

## 6) Monitoring
- Decision utility uplift vs naive approve‑all; PR‑AUC; calibration ECE.
