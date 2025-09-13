# Entry‑Expert (LightGBM H/M/L) — Deep Dive

## 1) Goal
Estimate probability **`Conf_pat`** that the proposed side will reach +1R before −1R within horizon `H=6×TF`.

## 2) Inputs
- Feature vector (see `data_contracts.md`), plus liquidity cluster one‑hot.
- Optional: `pattern`, `sim_conf` as features — include only if improves AUC without leakage.

## 3) Labels
- **Canonical policy**: entry at `P_last + offset0·ATR` (offset0=+0.15 STOP for longs, −0.15 LIMIT for shorts), `SL=1.0R`, horizon `H`.
- y=1 if price path hits `+1R` first; else 0.
- Side determined by historical **pattern+trend** heuristic to avoid hindsight bias.

## 4) Dataset Builder
Columns: `symbol, tf, ts, features[59], y, side, atr_z, spread_pct`
- Drop samples with feature_missing_ratio>0.05.
- Winsorize features ±3σ; z‑norm using train stats.

## 5) Model & HP
- LightGBM binary: `num_leaves=64`, `feature_fraction=0.9`, `bagging_fraction=0.8`, `min_data_in_leaf=50`, `lambda_l2=1.0`.
- Class weights inversely to freq. Early stop=200 rounds.

## 6) Metrics
- AUC>0.62, PR‑AUC, **Precision@5** per symbol/day, and expected R uplift at threshold τ.
- **Calibration**: Isotonic on validation; store calibrator.

## 7) Export
- ONNX `entry_H.onnx`, `entry_M.onnx`, `entry_L.onnx`
- Sidecar `feature_index_map.json` and `calibration.json`

## 8) Online Use
- Inference‑API requests **Conf_pat** and combines into `Conf_total=Conf_pat×sim_conf×Conf_conf`.

## 9) Monitoring
- Reliability plots; ECE < 0.1; win_rate drift; feature importance drift.

## 10) Pitfalls
- Label leakage from dynamic management. Use **fixed** policy here.
