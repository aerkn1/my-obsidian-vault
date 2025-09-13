# RR‑Model (LightGBM‑Quantile) — Deep Dive

## 1) Goal
Predict **target RR** (`rr_target` in R) for take‑profit construction.

## 2) Target
- `realised_R` under **standard management** (static SL/TP, no trail) over policy horizon.
- Train α∈{0.6,0.7,0.8}; online use α=0.6 with CVaR guard.

## 3) Inputs
- Feature vector + `pattern`, `pole_kATR`, `sim_conf` + macro flags.

## 4) Eval
- Pinball loss, SMAPE on median; backtest **utility** uplift vs fixed 2R baseline by TF/cluster.

## 5) Export/Monitor
- ONNX `rr.onnx`; monitor realised_R drift, compare to expected; alert if −20% from baseline.
