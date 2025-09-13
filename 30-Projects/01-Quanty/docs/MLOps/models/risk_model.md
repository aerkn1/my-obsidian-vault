# Risk‑Model (LightGBM‑Quantile) — Deep Dive

## 1) Goal
Predict stop distance `sl_kATR` (k in ATR units) to minimize premature stop while capping tail risk.

## 2) Target
- For historical canonical entries, compute **max adverse excursion** (MAE) in ATR units over `H=4×TF`.
- Train quantile α∈{0.6,0.7,0.8}; default α=0.7 online.

## 3) Inputs
- Full feature vector + LOB thinness flags (`vacuum_*`), distance to 1D S/R (`dist_to_sr_1d`).

## 4) Training
- LightGBM with `objective='quantile'`, `alpha=α`.  
- Custom loss pinball; early stop 200; grid search `num_leaves` {31,63,127}.

## 5) Constraints
- Clip `sl_kATR ∈ [0.5, 3.5]`.  
- +10% widen if `vacuum_*` true or `ATR_z>1.5`.

## 6) Eval
- Pinball loss; **coverage** target 65–75% (for α=0.7).  
- Backtest SL‑hit rate vs baseline.

## 7) Export & Monitor
- ONNX `risk.onnx`; monitor coverage stability; alert if <60% or >85% for 3 days.
