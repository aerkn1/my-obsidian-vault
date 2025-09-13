# Entry‑Offset (LightGBM‑Quantile) — Deep Dive

## 1) Goal
Predict optimal entry offset (`offset_kATR`), where sign → STOP (>0) vs LIMIT (<0).

## 2) Label
- Grid simulate offsets `{−0.25, −0.15, 0, +0.15, +0.25}·ATR`, SL from Risk α=0.7; pick offset maximizing expected R (or P(hit TP)).

## 3) Inputs
- Compression (`BB_width`), momentum (`rsi_mom`), flow (`cvd_slope_z`), daily bands (`up_z/down_z`), trend flags, bias_4h.

## 4) Eval
- Pinball loss; correct entry‑style%; fill/slippage improvement vs baseline.

## 5) Export/Monitor
- ONNX `offset.onnx`; track fill rate, avg slippage in live.
