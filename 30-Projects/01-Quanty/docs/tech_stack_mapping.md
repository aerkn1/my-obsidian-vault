# Tech Stack Mapping (per service)

This document maps each service to language, architecture, key libraries, transports, storage, and rationale. It aligns with the service tickets, authentication guide, and data layer docs.

- Authentication & Authorization (Keycloak)
  - Architecture: Externalized IAM (IdP pattern)
  - Language: Java (Keycloak)
  - Libs: Keycloak core (OIDC/OAuth2), Admin API
  - Transports: OIDC/OAuth2 flows, JWKS for verification
  - Storage: Postgres (Keycloak DB)
  - Rationale: Centralized identity, roles/scopes, tenant claims; services trust JWTs.

- GraphQL-Gateway
  - Architecture: BFF/layered with JWT middleware; ports/adapters for TS/Redis/RMQ
  - Language: Go (gqlgen)
  - Libs: gqlgen, go-oidc or keyfunc+golang-jwt, pgx v5, amqp091-go, OpenTelemetry
  - Transports: HTTPS GraphQL; WS subscriptions; internal DB/RMQ fan-in
  - Storage: Timescale (candles/trades), Redis (feature peeks)
  - Rationale: Central authorization (roles/scopes/tenant), unified API surface.

- Symbol-Registry
  - Architecture: Hexagonal (ports & adapters: vendor REST, DB, RMQ)
  - Language: Go
  - Libs: pgx v5, amqp091-go, go-redis v9, chi, cenkalti/backoff, OpenTelemetry
  - Transports: HTTP to vendors; publishes to RabbitMQ
  - Storage: TimescaleDB (core.coin_registry)
  - Rationale: Clear domain rules; idempotent upserts; vendor adapters.

- Macro On-Chain Ingestor
  - Architecture: Hexagonal (polling adapters; DB/RMQ adapters)
  - Language: Go
  - Libs: net/http & WS, amqp091-go, backoff, OpenTelemetry
  - Transports: HTTP/WS to providers; publishes to RabbitMQ
  - Storage: TimescaleDB (macro.onchain_15m, macro.btc_daily)
  - Rationale: Resilient polling with jitter/circuit breakers.

- OHLCV-Ingestor
  - Architecture: Hexagonal streaming processor (WS adapter; REST backfill; DB/RMQ)
  - Language: Go
  - Libs: gorilla/websocket, amqp091-go, pgx v5, OpenTelemetry
  - Transports: Exchange WS/REST → RabbitMQ
  - Storage: TimescaleDB (core.raw_bars, footprint_1s)
  - Rationale: Deterministic bar finalization; idempotent inserts; backfill.

- Metric-Ingestor
  - Architecture: Hexagonal (REST/WS adapters; DB/RMQ adapters)
  - Language: Go
  - Libs: net/http, amqp091-go, OpenTelemetry
  - Transports: HTTP/WS to exchanges → RabbitMQ
  - Storage: TimescaleDB (core.metric_15s)
  - Rationale: Periodic snapshots with retries; NaN-tolerant.

- LOB-Sampler
  - Architecture: Hexagonal streaming processor (WS adapter → compute → DB/RMQ)
  - Language: Go
  - Libs: websocket, amqp091-go, OpenTelemetry
  - Transports: Exchange WS → RabbitMQ (optional fan-out)
  - Storage: TimescaleDB (core.lob_1s)
  - Rationale: Efficient 1s downsampling, low GC pressure.

- Feature-Engine
  - Architecture: Clean Architecture; functional core + imperative shell; adapters for TS/RMQ/Redis
  - Language: Python (Polars)
  - Libs: polars, numpy, aio-pika, redis-py, asyncpg/psycopg, OpenTelemetry
  - Transports: Consumes RMQ; writes Redis; emits RMQ feats_ready
  - Storage: Redis (vec:*), Timescale (reads CA views and inputs)
  - Rationale: Deterministic vector compute; fast rolling stats with Polars.

- Pattern-Classifier (serving)
  - Architecture: Hexagonal microservice (gRPC port; ONNX runtime adapter)
  - Language: Python
  - Libs: onnxruntime, grpc, FastAPI (admin/health), OpenTelemetry
  - Transports: gRPC for inference (preferred)
  - Storage: N/A (stateless serving)
  - Rationale: Train in PyTorch → ONNX; low-latency CPU inference.

- Similarity-API
  - Architecture: Hexagonal (HTTP port; repository adapter to Postgres/pgvector)
  - Language: Python (FastAPI)
  - Libs: fastapi, asyncpg/psycopg, pgvector, pydantic, OpenTelemetry
  - Transports: REST (POST /similar)
  - Storage: Postgres/pgvector (ml.pattern_embeds)
  - Rationale: Simple HTTP API; tight DB integration; sub-5ms lookups with HNSW.

- Inference-API
  - Architecture: Hexagonal orchestrator (RMQ input; gRPC clients; Redis adapter)
  - Language: Go
  - Libs: onnxruntime-go, grpc-go, amqp091-go, go-redis v9, OpenTelemetry
  - Transports: Consumes RMQ; gRPC to model services; emits RMQ ml.candidate
  - Storage: Redis (feature fetch)
  - Rationale: Multi-model fan-out; predictable latency; circuit-breakers per dependency.

- Confirm-Service
  - Architecture: Hexagonal process manager (event ports; time-windowed state)
  - Language: Go
  - Libs: amqp091-go, go-redis v9, grpc-go, gobreaker, OpenTelemetry
  - Transports: Consumes RMQ; publishes ml.confirmed & bias.*
  - Storage: Redis (bias:*), Timescale (optional reads)
  - Rationale: Fast flow/bias gating and inversions; idempotent windows.

- Reco-Orchestrator
  - Architecture: Hexagonal (domain calculators core; adapters for Redis/TS/RMQ/models)
  - Language: Go
  - Libs: amqp091-go, grpc-go, pgx v5 (audit), go-redis v9, OpenTelemetry
  - Transports: Consumes ml.confirmed; publishes validated.recs
  - Storage: Timescale (core.trades/explain_log), Redis (overlays)
  - Rationale: Deterministic entry/SL/TP/size; CVaR/HRP overlays applied.

- Position-Monitor
  - Architecture: Hexagonal event-driven worker (exchange WS/API; DB/RMQ adapters)
  - Language: Go
  - Libs: pgx v5, amqp091-go, go-redis v9, OpenTelemetry
  - Transports: Exchange API WS; publishes trade.adjust.*
  - Storage: Timescale (core.trade_execs)
  - Rationale: Durable execution trail and adjustments; idempotency by exec id.

- Exit-Advisor
  - Architecture: Hexagonal rules-engine worker (RMQ inputs; TS/Redis adapters)
  - Language: Python
  - Libs: aio-pika, numpy, redis-py, asyncpg/psycopg, OpenTelemetry
  - Transports: Consumes price/metrics/trade.adjust; publishes adjustments
  - Storage: Timescale (updates to trades), Redis (live snapshots)
  - Rationale: Timeframe-aware trailing/early-exit logic with rate limits.

- Notification-Worker
  - Architecture: Hexagonal worker (RMQ input; Telegram/Web push adapters)
  - Language: Go
  - Libs: amqp091-go, HTTP clients, rate limiter, OpenTelemetry
  - Transports: Consumes validated.recs/trade.adjust; sends Telegram/Web push
  - Storage: Redis (rate limit)
  - Rationale: I/O fan-out with concurrency control and retries.

- HRP Overlay
  - Architecture: Hexagonal batch service (TS adapters; Redis/RMQ outputs)
  - Language: Go
  - Libs: gonum/stat, pgx v5, go-redis v9, OpenTelemetry
  - Transports: Cron/CLI; emits hrp.update.daily via RMQ and writes Redis
  - Storage: Timescale (historical closes); Redis (hrp:budget:*)
  - Rationale: Daily cluster budgets; fast compute; simple deployment.

- CVaR Guard
  - Architecture: Hexagonal service (TS & Similarity-API adapters; Redis/RMQ outputs)
  - Language: Go (Python viable if EVT-heavy)
  - Libs: gonum/stat, pgx v5, go-redis v9, OpenTelemetry
  - Transports: REST/gRPC (optional); emits cvar.update.*
  - Storage: Timescale (trade outcomes), Redis (cvar:*)
  - Rationale: Tail-risk sizing in critical path; conservative fallbacks.

- MLOps (Back-Labeler, Train-Runner, Model-Watcher)
  - Architecture: Pipelines & daemons (batch jobs + sidecar watcher)
  - Language: Python (Back-Labeler, Train-Runner), Go (Model-Watcher)
  - Libs: pandas/polars, lightgbm/scikit, DVC, onnxruntime, AWS/GCP SDK (watcher)
  - Transports: Batch via K8s Jobs/CronJobs; RMQ for status; S3/OCI for artifacts
  - Storage: S3/Registry; Timescale for labels; Git for configs
  - Rationale: Reproducible training, artifacted models, hot-reload via watcher.

- Observability Stack
  - Architecture: IaC (Helm/Kubernetes manifests)
  - Language: YAML/Helm
  - Libs: Prometheus, Grafana, Loki, Tempo, Alertmanager
  - Transports: Scrape/exporters; OTLP; log shipping
  - Storage: TSDB for Prom; object storage for Loki (as configured)
  - Rationale: SLIs/SLOs, central logs/traces, alerting.

- Retention & Gating Controller
  - Architecture: Hexagonal controller/operator (events in; control/S3 out)
  - Language: Go
  - Libs: amqp091-go, AWS SDK (S3), pgx v5, OpenTelemetry
  - Transports: Consumes symbol_events.updated; publishes control.*; writes S3 manifests
  - Storage: S3 (archives), Timescale (metadata as needed)
  - Rationale: Status-based feed control, archival, and backfill orchestration.

