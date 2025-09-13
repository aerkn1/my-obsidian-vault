# Dev Tickets — Auxiliary Overlays & Ops (v1.0)
> Scope: **4 auxiliary services** — **HRP Overlay**, **CVaR Guard**, **Observability Stack**, **Retention & Gating Controller**  
> Purpose: portfolio‑level risk control, tail‑risk caps, health monitoring, and lifecycle management for symbols & heavy feeds.

---

## 17) HRP OVERLAY (Hierarchical Risk Parity) — daily portfolio budgeter (Go)

### Goal
Allocate **cluster‑level risk budgets** using Hierarchical Risk Parity (HRP) so that simultaneous trades don’t overload a single theme (e.g., L1 alts). Provide **scale factors** that Reco‑Orchestrator applies to new trades.

### Inputs
- Timescale (TS):
  - `bar1h` or `bar4h` (close prices for last 60–90 trading days)
  - `trades` (open positions: symbol, side, risk_pct, tf)
  - `coin_registry` (liquidity_cluster H/M/L and `chain`/category if present)
- Config:
  - `HRP_LOOKBACK_D=90`
  - `TARGET_RISK_BUDGET=K%` of equity (e.g., 10–15% across all clusters)
  - `CLUSTER_MAP`: by `liquidity_cluster` + `chain` (e.g., {Majors, L1, DeFi, Memes})

### Outputs
- **Redis Hash** `hrp:budget:<YYYYMMDD>`:
  ```
  majors: {max_equity_risk:0.06, scale:0.92}
  l1:     {max_equity_risk:0.05, scale:0.75}
  defi:   {max_equity_risk:0.02, scale:1.00}
  memes:  {max_equity_risk:0.01, scale:0.60}
  ```
- **RMQ** `hrp.update.daily` (JSON same as hash) to notify Reco‑Orchestrator.

### Core Logic
1) **Returns matrix**: compute log‑returns on 1h/4h closes; winsorize ±3σ.  
2) **Distance matrix**: `d_ij = sqrt(0.5*(1 - corr_ij))`.  
3) **Hierarchical clustering**: single linkage → dendrogram.  
4) **Quasi‑diagonalization**: reorder covariance by tree.  
5) **Recursive bisection**: allocate weights inversely to sub‑cluster variances.  
6) **Map to cluster budgets**: sum per cluster → normalize to `TARGET_RISK_BUDGET`.  
7) **Compute scale factors**: compare **current open risk** per cluster (sum of `risk_pct` of open positions) to budget; define `scale = max(0, 1 - overage)`; min scale clamp (e.g., 0.5).  
8) **Publish** scale factors; Reco‑Orchestrator multiplies `risk_pct *= scale(cluster)` for *new* trades.

### APIs (optional)
- `GET /hrp/budget/today` → JSON current budgets & scales
- `GET /hrp/budget/backtest?date=YYYY-MM-DD`

### Acceptance
- If L1 coins become highly correlated, the L1 cluster budget reduces and `scale < 1`.  
- If no open risk in a cluster, `scale=1` (no penalty).  
- Run‑time < 2s for ≤ 200 symbols.

---

## 18) CVaR GUARD — tail‑risk sizing oracle (Go or Python)

### Goal
Estimate **Conditional Value‑at‑Risk (CVaRα)** per symbol/timeframe and provide a **max allowed position size/leverage** so that the **expected tail loss at the stop** is under a configured budget.

### Inputs
- TS: `trades` outcomes (realised R, side), `bar15m/1h` (ATR series), latest `ATR`, `sl_kATR` from candidate.  
- Similarity‑API (optional): historical distribution of `realised_r` for look‑alike patterns (`hist_rr` sample).  
- Config:
  - `ALPHA=0.95` (or 0.975)
  - `RISK_BUDGET_PER_TRADE=0.5%` of equity (default)
  - `CV` estimation mode: `empirical` | `EVT` (gen‑Pareto tail fit)

### Outputs
- **Redis** `cvar:<SYM>:<TF>`:
  ```json
  {"alpha":0.95,"cvar_r":-1.35,"last_update":"2025-08-13T00:00:00Z"}
  ```
  where `cvar_r` is tail loss in **R units** (negative).  
- **RMQ** `cvar.update.<SYM>.<TF>` with same payload.

### Core Logic
1) Build **loss samples** in R units: for closed trades with same `SYM` and `TF`, or broader class (cluster/side) if few samples.  
2) Optionally **blend** with `hist_rr` from Similarity‑API (Bayesian shrinkage toward class prior).  
3) Compute **CVaRα**: mean of worst α‑tail of the empirical distribution (or EVT tail).  
4) **Max size calculator** (used by Reco‑Orchestrator): ensure `maxLossAtStop ≤ risk_budget` → downscale size or cap leverage.  

### API (optional)
- `POST /sizing` with `{equity, price, sl_kATR, atr, alpha}` → `{max_size, max_lev}`

### Acceptance
- In volatile regime CVaR magnitude increases (more negative) → max_lev decreases.  
- With sparse data, guard falls back to cluster‑level CVaR (still conservative).

---

## 19) OBSERVABILITY STACK — metrics, logs, traces (Helm Manifests)

### Goal
Provide end‑to‑end **SLIs/SLOs**, dashboards, and alerts for the pipeline.

### Components
- **Prometheus**: scrape Go/Python exporters.  
- **Grafana**: dashboards as JSON.  
- **Loki**: log aggregation (labels: service, symbol, tf, level).  
- **Tempo**: traces; propagate `traceparent` via RMQ headers.  
- **Alertmanager**: email/Slack hooks.

### Required Metrics (export from every service)
- **Latency SLIs**:
  - `bar_to_feats_ready_ms` (Feature‑Engine)
  - `feats_to_candidate_ms` (Inference)
  - `candidate_to_confirm_ms` (Confirm)
  - `confirm_to_alert_ms` (Reco → Notification)
- **Quality**:
  - `win_rate_24h`, `avg_realised_r_7d` (Back‑Labeler summary)
  - `feature_missing_ratio` (per symbol, per field)
  - `model_drift_psi` (population stability index) for top features
- **Throughput & health**:
  - RMQ consumer lag per topic
  - WS reconnect counts per ingestor
  - Error rates, retry counts

### Dashboards (Grafana panels)
1) **Pipeline Latency**: stacked stages p50/p95; alerted if any > SLO (500ms from feats→alert).  
2) **Signal Quality**: win rate, avg R, RR distribution vs recommended.  
3) **Data Health**: missing feature ratios, macro feed lags, registry scores.  
4) **Model Inference**: per‑model latency, version (semver), success rate.  
5) **RMQ Health**: per‑topic message rates & consumer lag.

### Alerts
- `latency_p95 > 2s` for 5 min.  
- `win_rate_24h < 0.50` AND `avg_realised_r_24h < 0.1` → warn.  
- `feature_missing_ratio > 0.02` for any core metric.  
- `macro_feed_delay > 30m`.

### Acceptance
- Synthetic load shows dashboards populate; alerts fire & resolve.  
- Trace view shows a single trade’s journey with consistent `trace_id` across messages.

---

## 20) RETENTION & GATING CONTROLLER — symbol lifecycle manager (Go)

### Goal
Apply **status‑based feed control** and storage retention (light vs heavy feeds), and manage **re‑activation backfill** cleanly.

### Inputs
- RMQ `symbol_events.updated` (status, data_health)
- Config thresholds:
  - `HEAVY_FEEDS=["depth","footprint","onchain_per_symbol"]`
  - `PURGE_AFTER=90d` (archive to S3 before purge)
  - `KEEP_LIGHT_FEEDS=true` (1m OHLCV, funding, OI always on)

### Outputs
- **RMQ** control topics (to ingestors):  
  - `control.unsubscribe.<SYM>.<feed>` / `control.subscribe.<SYM>.<feed>`  
- **S3** archival manifests for heavy tables per symbol.  
- **RMQ** `retention.events` for audit:
  ```json
  {"symbol":"FTMUSDT","action":"purge_heavy","range":"2025-04-01..2025-07-01"}
  ```

### Core Logic
1) On **EXCLUDED**: immediately publish `control.unsubscribe` for heavy feeds; schedule purge at `now+90d`.  
2) On **PROBATION**: keep heavy feeds on; set **probation flag** (down‑weight in models handled elsewhere).  
3) On **ACTIVE** after exclusion: publish `control.subscribe` to restart heavy feeds; trigger **backfill** job:
   - Only for **light feeds** (bars, funding, OI) if gaps exist; heavy feeds **not** reconstructed.  
4) Purge executor: dump heavy tables for symbol range to S3 (CSV/Parquet), then `DELETE` from Timescale.  
5) Health report: weekly summary of symbols by status and storage footprint saved.

### Acceptance
- Excluding a symbol stops heavy feed topics within ≤1s (ingestors confirm).  
- After 90d, heavy tables for the symbol are archived & purged; DB size drops accordingly.  
- Reactivation triggers backfill; Feature‑Engine operates immediately using uninterrupted light feeds.

---

## Shared Config & Protocols

- **Messaging**: RabbitMQ topic exchange `trading.bus`; JSON payloads; include `traceparent`.  
- **Time**: all services run on UTC; timestamps ISO‑8601.  
- **Security**: JWT for control APIs; RMQ credentials per microservice user.  
- **Infra**: Kubernetes `Deployment` with liveness/readiness; resource requests:
  - HRP/CVaR: 0.5–1 vCPU, 512MB RAM (CPU‑only)
  - Retention Controller: 0.3 vCPU, 256MB
  - Observability: as per Helm charts

---

## Wiring to Core Pipeline

- **Reco‑Orchestrator** reads **HRP** scales & **CVaR** caps during final sizing:  
  `risk_pct *= hrp_scale(cluster)`; `max_lev = min(max_lev, cvar_cap(sym,tf))`  
- **Feature‑Engine** unaffected; vectors remain the same size.  
- **Confirm‑Service** unaffected; overlays apply **after** confirm.  
- **Notification‑Worker** can append reason pills:
  - `pill: "Cluster budget tight"` (HRP)
  - `pill: "Tail‑risk cap applied"` (CVaR)

---

## End‑to‑End Acceptance (Golden Path)

1) Multiple L1 alts trigger longs on the same day. HRP budget marks L1 cluster overweight → Reco sizes each new trade at 70% of normal risk.  
2) BTC volatility spikes; CVaR guard lowers max leverage to 2× for majors. Reco reflects the cap; alerts show the “Tail‑risk cap” pill.  
3) Several meme coins degrade to EXCLUDED → Retention Controller stops depth/footprint immediately and purges after 90 days; DB size drops; core bars continue uninterrupted.  
4) Grafana shows bar→alert latency p95 under 500 ms; Alerts fire when macro_onchain feed lags > 30 min.

---

## Deliverables Checklist

- [ ] HRP overlay service with Redis+RMQ outputs, daily cron and CLI backtest.  
- [ ] CVaR guard service with Redis key writer and `/sizing` API.  
- [ ] Helm stack for Prometheus+Grafana+Loki+Tempo with dashboards JSON.  
- [ ] Retention controller with RMQ control topics, S3 archiver, purge worker, reactivation backfill job.  
- [ ] End‑to‑end tests simulating symbol status flips and cluster crowding.
