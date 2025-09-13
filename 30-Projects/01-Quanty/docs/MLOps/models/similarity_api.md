# Similarity‑API — Deep Dive

## 1) Purpose
Retrieve nearest historical analogs of current **embedding** to compute:
- `sim_conf` — how trustworthy is the current pattern
- `hist_rr_pct` — percentile of realized R from analogs

## 2) Data
- Table `pattern_embeds(embed(64), pattern, quality, pole_kATR, realised_R, symbol, tf, ts)`
- Rolling window ~ 18 months.

## 3) Index
- pgvector HNSW (cosine) `M=16`, `ef_construction=200`.  
- Query `ef_search=64`; `k=25 (default)`.

## 4) API
- gRPC/HTTP `Nearest(embed, k, filters)` → returns neighbors.
- `sim_conf = mean(quality) × mean(cosine)`; clamp to [0,1].
- `hist_rr_pct = percentile(neighbors.realised_R, 0.65)`.

## 5) Build Pipeline
```
embed_dump.py --onnx /pattern_cnn/vX/model.onnx --bars parquet --out pattern_embeds.parquet
pgvector_ingest.py --file pattern_embeds.parquet --rebuild_index
```
- Ensure **test window** is excluded when evaluating.

## 6) Monitoring
- Recall@k vs exact search on sample; latency p95 < 50ms; index size growth.
