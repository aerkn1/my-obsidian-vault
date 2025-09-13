# Dev Tickets — Delivery & MLOps Layer (v1.0)
> Scope: 4 services — **Exit‑Advisor**, **Notification‑Worker**, **GraphQL‑Gateway**, **MLOps Pipeline** (Back‑Labeler + Train‑Runner + Model‑Watcher)  
> Analogy: this is the **gate & maintenance crew** — closing trades cleanly and keeping the models fresh & explainable.

---

## 13) EXIT‑ADVISOR (Python)

### Goal
Manage open trades: trail TP, tighten SL, early close on hostile flow; emit adjustments for UI and logs.

### Inputs
- RMQ `trade.adjust.*` (fills & P/L), `price_updates`, `metric_updates`
- TS `trades` (open positions list)

### Logic
- For each open trade, every 5–15m (TF‑aware):
  - If unrealised ≥ +1 R → trail TP by +0.5 R
  - If unrealised ≥ +0.7 R → move SL to break‑even
  - If `cvd_slope_z` flips hard against AND `absorp_score` > 0.6 on opposite side → **close early**
  - Cap max hold time; decay RR as we approach expiry

### Output
- RMQ `trade.adjust.<SYM>` with new SL/TP or close command
- TS updates on trade row

### Acceptance
- No churn: adjustments rate‑limited (min 5m).  
- All moves monotonic (TP only widens favorably; SL only tightens).

---

## 14) NOTIFICATION‑WORKER (Go)

### Goal
Turn `validated.recs` and `trade.adjust` into **human‑readable alerts** on Telegram + Web push, with reasons & badges.

### Inputs
- RMQ `validated.recs.*`, `trade.adjust.*`

### Logic
- On new reco: open a Telegram thread; include entry/SL/TP/RR/risk/maxLev/hold + reason pills (pattern, bias, macro).  
- On adjust: `editMessageText` to keep a single evolving thread per trade.  
- Errors: retry w/ backoff, dead‑letter after 3 failures.

### Output
- Telegram messages (Bot API)
- WebSocket/FCM push for app clients

### Acceptance
- Unicode & markdown safe; numbers match TS record exactly (audit).

---

## 15) GRAPHQL‑GATEWAY (Go gqlgen)

### Goal
Single API for UI (web/mobile) to query data & subscribe to streams.

### Schema (excerpt)
```graphql
type Query {
  candles(pair:String!, tf:String!, limit:Int=500): [Candle!]!
  trades(limit:Int=50): [Trade!]!
}
type Subscription {
  alerts: AlertEvent!
  price(pair:String!): PriceTick!
}
```
**AlertEvent** mirrors `validated.recs` with friendly names.

### Inputs
- TS (candles, trades), Redis (feature peeks), RMQ fan‑in for subscriptions.

### Non‑Functional
- JWT auth; tenant_id in claims propagated.  
- Backpressure: drop oldest WS messages if client slow.  
- CORS & rate limits (e.g., 60 req/min).

### Acceptance
- Subscribing to `alerts` shows newly published recos within <200ms.  
- Query returns consistent pagination; timestamps UTC ISO‑8601.

---

## 16) MLOps PIPELINE (Back‑Labeler + Train‑Runner + Model‑Watcher)

### Goal
Close the loop: label outcomes, train nightly, compare vs prod, hot‑reload winners.

### Back‑Labeler
- Trigger: trade closed (TS notify).  
- Compute: realised R, run‑up, draw‑down. Append to `data/labels/trade_labels.parquet` (DVC tracked).  
- Push: `dvc add && dvc push` to S3.

### Train‑Runner (GitHub Actions)
- `dvc pull` → get `features.parquet`, `labels.parquet`, `pattern_img/`.  
- Train:
  - Pattern‑CNN (PyTorch → ONNX)
  - Entry‑Expert (H/M/L), Risk, RR, Offset (LightGBM → ONNX)
- Compare:
  - precision@5 gain ≥ +0.05 **and** avg realised‑R gain ≥ +0.05  
- Deploy:
  - Upload to `s3://trade-ml-models/<family>/<semver>` with `metrics.json`

### Model‑Watcher (sidecar)
- `aws s3 sync` every 15m → if newer, send `SIGUSR1` to inference pods (re‑load).  
- Health log: prints currently loaded semver for each model.

### Audit & Explainability
- SHAP logger: for each `validated.recs` write top‑5 feature attributions to TS `explain_log(trade_id, feature, gain)`.  
- EU AI transparency friendly; GraphQL exposes `/alertDetail?id=...` with attribution bar chart.

### Acceptance
- New model family auto‑reloads without pod restart.  
- Rollback by flipping semver pointer in Registry SQLite + S3 alias.

---

## Global NFRs & Ops

- **Latency SLA**: bar→feats_ready < 100ms p95; feats_ready→validated.recs < 500ms p95.  
- **Reliability**: RMQ quorum queues; persistent messages for `validated.recs` & `trade.adjust`.  
- **Security**: JWT HS256 rotate 30d; secrets via Kubernetes secrets.  
- **Retention**: heavy feeds paused for EXCLUDED after 0d, purged after 90d (S3 archive).  
- **Cost**: all CPU‑only in prod; single T4 optional for CNN training.
