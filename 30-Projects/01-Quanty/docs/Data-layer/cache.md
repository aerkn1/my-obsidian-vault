
# Cache & Key‑Value Handbook — Redis

**Purpose:** Define all Redis keys, value encodings, TTLs, atomic ops, and ACLs.

> Analogy: Redis is our **prep counter**—hot items, small portions, super fast.

---

## 1) Deployment & SLOs
- **Topology:** Redis Cluster (3 masters + 3 replicas).  
- **Persistence:** AOF `everysec` + daily RDB snapshot.  
- **Latency SLO:** p95 GET/SET < 2ms for keys < 64KB.  
- **Security:** TLS, ACL per service, `requirepass`/user tokens.

---

## 2) Namespaces & Contracts

### 2.1 Feature Vectors (primary ML input)
- **Key**: `vec:<SYMBOL>:<TF>` → **String (binary)**  
  - **Value**: `float32[]` packed little‑endian per `FEATURE_SCHEMA_VER` index map.  
  - **TTL**: none; overwritten on each bar close.  
  - **Size**: ~236–300 bytes per TF.

- **Meta**: `vecmeta:<SYMBOL>:<TF>` → **Hash**  
  - Fields: `schema_ver`, `bar_ts`, `updated_at`, `missing_ratio`, `source='Feature-Engine'`.

**Atomic write pattern (Go):**
```go
pipe := rdb.TxPipeline()
pipe.Set(ctx, key, packedBytes, 0)
pipe.HSet(ctx, meta, map[string]interface{}{"schema_ver":7, "bar_ts":ts, "updated_at":now, "missing_ratio":mr})
_, err := pipe.Exec(ctx)
```

### 2.2 Bias & Overlays
- `bias:<SYMBOL>:<TF>` → **Hash** `{bias:-1/0/1, conf:float, status:'provisional'|'confirmed', updated_at}` (TTL=2×TF in seconds)  
- `hrp:budget:<YYYYMMDD>` → **Hash** `{cluster:Gaming:0.8, cluster:L1:0.6, ...}`  
- `cvar:<SYMBOL>:<TF>` → **String** (float, R units), TTL 24h.

### 2.3 Live Trades & PnL
- `trade:open:<TRADE_ID>` → **Hash** `{symbol, tf, side, entry, stop, tp, rr, risk_pct, max_lev, state}`  
- `trade:index:<SYMBOL>` → **Set** of `TRADE_ID` (open trades per symbol)  
- `pl:live:<TRADE_ID>` → **Hash** `{unrealised_R, pnl_quote, last_price, updated_at}` (TTL 2h after close)

### 2.4 Idempotency & Rate Limits
- `done:<QUEUE>:<MSG_ID>` → **String** (value `1`, TTL 24h) — dedupe for consumers  
- `ratelimit:notify:<USER>` → **Counter** (TTL 60s) — Telegram/WS spam guard

### 2.5 Locks
- `lock:reco:<SYMBOL>:<TF>` → **String** (NX, PX=60000) — prevent concurrent reco build  
- Use RedLock only if cross‑process; prefer queue partitioning by `(symbol, tf)`.

---

## 3) Encoding Rules
- **Float arrays:** `np.float32.tobytes()` (Python) or `binary.LittleEndian` (Go).  
- **JSON:** Use MessagePack/CBOR if >1KB; otherwise plain JSON.  
- **Compression:** Avoid for hot keys (adds latency).

---

## 4) TTL, Eviction, Memory
- Eviction policy: `allkeys-lru`.  
- Monitor memory; keep per‑key <64KB.  
- Bias TTL ensures provisional bias expires if not refreshed.

---

## 5) Observability
- Export `feature_missing_ratio`, GET/SET latencies, hit rate, memory usage.  
- Alerts: replication lag > 2s; mem > 80%; evictions > 0.

---

## 6) ACL Matrix
| Service | Access |
|---|---|
| Feature‑Engine | `SET vec:*`, `HSET vecmeta:*`, read bias/overlays |
| Inference‑API | `GET vec:*`, `HGETALL vecmeta:*`, read overlays |
| Confirm‑Service | reads bias, writes bias updates |
| Reco‑Orchestrator | reads overlays, trades hashes; sets `trade:open:*` |
| Notification‑Worker | reads trade hashes, PnL |
| Position‑Monitor | updates PnL hashes |
| Overlays (HRP/CVaR) | writes `hrp:*`, `cvar:*` |

---

## 7) Disaster Recovery
- Restore from AOF/RDB; rebuild hot keys by replaying last N hours from DB + bus if needed.

---

## 8) Local Dev
- Single‑node Redis; disable TLS; use `redisinsight` for inspection.
