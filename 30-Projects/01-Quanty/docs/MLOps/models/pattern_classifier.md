# Pattern‑Classifier — Deep Dive

## 1) Purpose & Scope
Detect **shape regimes** (flag, wedge, blowoff, wick exhaustion, none) and produce:
- `quality` (calibrated confidence)
- `pole_kATR` for flags
- `embed (64‑d)` for retrieval

## 2) Inputs
- Image `(64×64×3)` built from last 64 bars in a given TF.
- **Channels:**
  1. **Candle Texture**: encode body/wicks scaled by per‑bar `hl_range / max(H-L, ε)`, clipped to [0,1].
  2. **EMA Distance**: `log1p( max(0, C/EMA21 − 1) )` mapped to [0,1]; symmetric map for below EMA.
  3. **RSI Momentum**: `RSI_14/100` plus finite difference (1‑lag) concatenated then PCA‑reduced to one channel.

> Tip: If memory tight, pre‑quantize to uint8 [0,255] with min‑max params persisted per symbol/TF.

## 3) Dataset Build
```python
# make_images.py (Python)
for (symbol, tf) in universe:
    bars = load_bars(symbol, tf, lookback_days=540)
    for t in range(63, len(bars)):
        window = bars[t-63:t+1]
        img = compose_channels(window)
        label, pole = weak_label(window)   # see §4
        save_npz(symbol, tf, bars[t].ts, img, meta=...)
        write_row(parquet_labels, symbol, tf, bars[t].ts, label, pole)
```
**Weak‑labels:**  
- **Flag:** pre‑pole rally kATR≥1.5, then consolidation: range ≤ 0.5·ATR, duration 12–40 bars, breakout direction coherent last 3 bars.  
- **Wedge:** converging highs/lows; slope magnitude decreases; range ratio (last/first) ≤0.6.  
- **Blowoff:** top wick ratio ≥ 0.6 of HL, and intrabar volume spike z≥2.  
- **Wick exhaustion:** bottom wick ratio ≥ 0.6 with CVD flip in ±2 bars.  
- **None:** otherwise.

Seed with **manually reviewed 2–5k** examples/class, then **self‑training**: train v0, pick predictions with `p>0.9`, add to train.

## 4) Architecture
```
Input(64,64,3)
→ Conv(32,3x3) → BN → ReLU → Conv(32,3x3) → BN → ReLU → MaxPool(2)
→ Conv(64,3x3) → BN → ReLU → Conv(64,3x3) → BN → ReLU → MaxPool(2)
→ Conv(128,3x3,dil=2) → BN → ReLU → Conv(128,3x3,dil=2) → BN → ReLU
→ GlobalAvgPool
→ FC(128) → ReLU → Dropout(0.2)
→ FC(64)  # embedding
Heads:
  Class: FC(#classes), loss = Focal(γ=2) + label_smoothing(ε=0.05)
  Pole : FC(1), loss = SmoothL1 (apply only if class==flag)
```
**Calibrated probabilities:** temperature scaling per class on validation.

## 5) Training
- Optimizer: AdamW(lr=1e‑3, wd=1e‑4), Cosine decay, Epochs: 40–50, Batch: 256.
- Augmentations: time‑warps (±10%), horizontal stretch (±10%), CutMix p=0.1.
- Early stop: 8 epochs patience on **macro‑F1**.
- Class weights to correct imbalance.

## 6) Evaluation
- `macro‑F1 ≥ 0.60`, per‑class PR‑AUC tracked; `ECE ≤ 0.12`.
- `pole_kATR` MAE ≤ 0.25 ATR for flag subset.

## 7) Export & Registry
- Torch → ONNX (opset 13) with dynamic axes.  
- Save: `/pattern_cnn/vX_Y_Z/model.onnx`, `metrics.json` (`class_map`, `temp_scaling`, `dataset_hash`, `feature_schema_ver`).  
- Emit `pattern_embeds.parquet` for `pgvector` ingestion.

## 8) Inference Contract
- **gRPC** `Classify(Image64x64x3) → PatternReply` (see `proto/pattern.proto`).  
- Latency target: ≤ 10ms per image on CPU.

## 9) Monitoring
- Mean `quality` drift, confusion changes, sim_conf via Similarity.  
- Alert if per‑class F1 drops >15% week‑over‑week.

## 10) Failure Modes
- Over‑sensitivity in blowoff during high ATR regime; mitigate via ATR_z channel in image or as auxiliary input.
- Distribution shift (listing spikes) → refresh seeds periodically.
