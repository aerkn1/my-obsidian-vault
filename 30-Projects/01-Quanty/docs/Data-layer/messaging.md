
# Messaging Handbook — RabbitMQ Topic Bus

**Purpose:** Define exchanges, routing keys, payload schemas, delivery guarantees, DLQs, and consumer behavior.

> Analogy: This is our **air-traffic control** doc—who speaks, what they say, and who must hear it.

---

## 1) Exchange & Queues
- **Exchange:** `trading.bus` (type **topic**, durable, vhost `/trading`)  
- **Dead‑letter exchange:** `trading.dlx` (topic)  
- **Content‑Type:** `application/json` (gzip if >1KB)  
- **Headers:** `schema_ver`, `producer`, `ts_ms`, `env`

**Queues (durable):** `q.registry`, `q.ohlcv_ingest`, `q.metric_ingest`, `q.lob_sampler`, `q.feature_engine`, `q.inference_api`, `q.confirm`, `q.reco`, `q.notification`, `q.exit_advisor`, `q.position_monitor`, `q.overlays` (+ `-dlq` for each).

**QoS / Prefetch:**  
- `feature_engine`: 50, `inference_api`: 10, `confirm`: 100, `reco`: 50.

---

## 2) Routing Keys & Schemas

### 2.1 Registry
- RK: `symbol_events.updated`  
```json
{"msg_id":"<uuid>","ts":1736294400000,"symbol":"SOLUSDT","status":"ACTIVE","liquidity_cluster":"H","data_health":87}
```

### 2.2 Prices & Metrics
- RK: `price_updates.<SYMBOL>.1m`  
```json
{"msg_id":"u","ts":1736294460000,"symbol":"SOLUSDT","o":173.20,"h":173.48,"l":172.90,"c":173.30,"v":12543.2}
```
- RK: `metric_updates.<SYMBOL>.15s`  
```json
{"msg_id":"u","ts":1736294475000,"symbol":"SOLUSDT","funding":0.00012,"open_interest":1.2e8,"cvd_delta":-1432.5}
```
- RK: `lob.snap.<SYMBOL>.1s`  
```json
{"msg_id":"u","ts":1736294475000,"symbol":"SOLUSDT","sum_bid1":4.2e6,"sum_ask1":3.8e6,"sum_bid10":2.1e7,"sum_ask10":2.0e7}
```

### 2.3 Features & Patterns
- RK: `feats_ready.<SYMBOL>.<TF>`  
```json
{"msg_id":"u","ts":1736294460000,"symbol":"SOLUSDT","tf":"15m","schema_ver":7,"redis_key":"vec:SOLUSDT:15m"}
```
- RK: `pattern.found` (optional debug)  
```json
{"msg_id":"u","ts":1736294460000,"symbol":"SOLUSDT","tf":"15m","pattern":"flag","quality":0.82,"pole_kATR":2.1}
```

### 2.4 Inference
- RK: `ml.candidate.<SYMBOL>.<TF>`  
```json
{"msg_id":"u","ts":1736294460000,"symbol":"SOLUSDT","tf":"15m","side":1,"Conf_pat":0.68,"pattern":"flag","sim_conf":0.71,"pole_kATR":2.0,"sl_kATR":1.2,"rr_target":2.4,"offset_kATR":0.15,"entry_style":"STOP"}
```

### 2.5 Confirm & Bias
- RK: `ml.confirmed.<SYMBOL>.<TF>`  
```json
{"msg_id":"u","ts":1736294480000,"symbol":"SOLUSDT","tf":"15m","decision":"approve","Conf_conf":0.73}
```
- RK: `bias.update` / `bias.cancel`  
```json
{"symbol":"SOLUSDT","tf":"4h","bias":1,"conf":0.62,"status":"provisional"}
```

### 2.6 Recommendations & Adjustments
- RK: `validated.recs.<SYMBOL>`  
```json
{"trade_id":"t","ts_open":1736294520000,"symbol":"SOLUSDT","tf":"15m","side":1,"entry":173.55,"stop":171.90,"take_profit":177.45,"rr_target":2.4,"risk_pct":1.0,"max_leverage":4,"hold_policy":{"min_min":120,"max_min":720},"reasons":["flag","sim","flow_ok","macro_neutral"]}
```
- RK: `trade.adjust.<USER>.<SYMBOL>`  
```json
{"trade_id":"t","kind":"FILL","ts":1736294540000,"px":173.55,"qty":100.0}
```

### 2.7 Macro & Overlays
- RK: `onchain.macro.15m`, `hrp.update.daily`, `cvar.update`

---

## 3) Delivery Guarantees
- **At‑least‑once** with publisher confirms + consumer acks.  
- **Idempotency:** `msg_id` + Redis `done:<queue>:<msg_id>` (TTL 24h).  
- **Retries:** Dead‑letter with exponential backoff (5s, 30s, 2m, 10m).  
- **Ordering:** Not guaranteed across shards; partition by `(symbol, tf)` if strict.

---

## 4) Security
- VHost `/trading`; least‑privilege users per service; TLS; mandatory `producer`/`service` headers.  
- Segregate `-stg` and `-prod` exchanges/queues.

---

## 5) Observability
- Per‑queue publish/ack rates, **consumer lag**, requeues, DLQ depth.  
- Alerts: `lag > 1m` for 15m TF / `>5m` for 1h TF.

---

## 6) Local Dev
```yaml
services:
  rmq:
    image: rabbitmq:3.12-management
    ports: ["5672:5672","15672:15672"]
    environment: { RABBITMQ_DEFAULT_USER: dev, RABBITMQ_DEFAULT_PASS: dev }
```
