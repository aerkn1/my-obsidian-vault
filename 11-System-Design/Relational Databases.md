# **Relational Databases**

  

_An exhaustive, evergreen reference of everything we discussed: relational theory, MVCC internals, query plans, storage layout, memory knobs, pooling, idempotency, DataLoader, connection storms, WAL/​checkpoints, HA, partitioning, pre‑aggregation, BRIN vs B‑tree, and GraphQL/REST interaction._

---

## **Table of Contents**

1. [Relational & MVCC Foundations](#foundations)
    
2. [Physical Storage: Heap, Pages, WAL](#storage)
    
3. [Planner & Executors: Seq Scan → Merge Join](#planner)
    
4. [Memory Pools: shared_buffers, work_mem, hash_mem_multiplier](#memory)
    
5. [Index Catalogue](#indexes)
    
6. [Partitioning Strategies](#partitioning)
    
7. [Pre‑Aggregation & Materialised Views](#preaggregation)
    
8. [WAL, Checkpoints, wal_writer_delay](#wal)
    
9. [Pooling & PgBouncer Deep‑Dive](#pooling)
    
10. [GraphQL DataLoader & N+1 Cure](#dataloader)
    
11. [HTTP Idempotency Keys](#idempotency)
    
12. [HA, Replication & Read Routing](#ha)
    
13. [Real‑World Scenarios & Fixes](#scenarios)
    
14. [Sizing Cheat‑Sheets & Knob Reference](#cheatsheets)
    
15. [Glossary](#glossary)
    

---

  

  

## **1  Relational & MVCC Foundations**

  

### **1.1  ACID recap**

- **Atomicity** – one COMMIT writes WAL once.
    
- **Consistency** – constraints (CHECK, FK) validated before commit.
    
- **Isolation** – default READ COMMITTED; SERIALIZABLE uses SSI.
    
- **Durability** – WAL flushed (fsync) before ReadyForQuery.
    

  

### **1.2  MVCC tuple anatomy**

```
PageHeader (LSN, checksum)
LinePointer[]   -- 4 B each
HeapTupleHeader -- xmin, xmax, ctid, infomask
User columns    -- stored row data
```

- **HOT Update** stays on same page → no index rewrite.
    
- Visibility decided at snapshot time, not by locks.
    

  

### **1.3  Choosing data types for storage‑efficiency**

|**Domain**|**Type & bytes**|**Why**|
|---|---|---|
|PK under 2.1 B rows|integer (4 B)|Room for decades, small index.|
|Money|numeric(12,2) or bigint cents|Exact, fits in 8 B.|
|Small finite enum|ENUM (4 B)|Prevents typos, tiny.|
|Latitude/longitude|double precision (8 B)|Adequate precision, no rounding errors.|
|Log payload|jsonb (TOAST-able)|Flexible, compressible.|

---

  

  

## **2  Physical Storage: Heap, Pages, WAL**

  

### **2.1  Heap & 8 KB Pages**

- Each table = one heap file → pages numbered 0..n.
    
- PostgreSQL always requests _whole_ page; never single row.
    

  

### **2.2  WAL segments**

- Default 16 MB segment files.
    
- Each INSERT/UPDATE generates an **XLOG record**; crash‑recovery replays them.
    
- wal_compression=on saves 30‑50 % I/O on repeat‑pattern inserts.
    

  

### **2.3  Checkpoints**

- Flush dirty shared‑buffer pages; write CHECKPOINT record.
    
- Tune with checkpoint_timeout + max_wal_size.
    

```
checkpoint_timeout = 15min   # cohesive batches
max_wal_size       = 8GB     # delay checkpoints under bursts
wal_writer_delay   = 1000ms  # smooth out tiny flushes
```

---

  

  

## **3  Planner & Executors**

  

### **3.1  Operator cheat‑sheet**

|**Keyword**|**What it does**|**Memory need**|
|---|---|---|
|Seq Scan|read every page|Relies on shared_buffers|
|Index Scan|B‑tree walk + heap fetch|few random pages|
|Index Only|Skip heap, uses Visibility Map|index only|
|Nested Loop|outer row ⇒ inner index lookup|low|
|Memoize|cache inner lookups|< work_mem|
|Hash Join|hash build side, probe outer|work_mem×multiplier|
|Merge Join|two sorted streams|tiny|
|Sort (top‑N)|keep N rows in heap|N×row_width|

### **3.2  Example plan walkthrough**

```
EXPLAIN (ANALYZE,BUFFERS)
SELECT c.name, o.qty
FROM   orders o JOIN customer c ON c.id=o.customer_id
ORDER  BY o.qty;
```

Output contained Gather Merge, per‑worker external merge because no index on qty and work_mem=2 MB.  Add

```
CREATE INDEX idx_orders_qty ON orders(qty DESC) INCLUDE(customer_id);
```

and plan flips to Limit → Index Only Scan – 5 ms, no temp spill.

---

  

  

## **4  Memory Pools**

  

### **4.1**  

### **shared_buffers**

- Global 8 KB page cache.  25‑40 % of RAM on dedicated host.
    

  

### **4.2**  

### **work_mem**

- Per sort/hash/memoize node per back‑end.  Compute worst case:
    

```
work_mem × active_nodes × max_backends ≤ RAM‑headroom
```

- OLTP primary often 16–32 MB; analytics replica 256‑512 MB.
    

  

### **4.3**  

### **hash_mem_multiplier**

- Allows hash joins/aggregates to exceed work_mem×multiplier before spill.
    

---

  

  

## **5  Index Catalogue**

|**Use case**|**Index flavour**|**DDL**|
|---|---|---|
|Latest row fast|Covering DESC|CREATE INDEX idx_ping_latest ON ping(vehicle_id, ts DESC) INCLUDE (lat,lon);|
|Time‑series scan|**BRIN**|CREATE INDEX brin_log_ts ON log(ts) WITH (pages_per_range=32);|
|Expression search|Functional|CREATE INDEX idx_lower_name ON users(lower(name));|
|Unique + lookup|PARTIAL|CREATE UNIQUE INDEX uniq_active_email ON users(email) WHERE active;|

---

  

  

## **6  Partitioning**

- **Range** by date for append‑only sensors.  DROP PARTITION = instant purge.
    
- **Hash** by tenant for multi‑tenant isolation.
    
- **List OF Range** for dual pruning (tenant, day).
    

```
CREATE TABLE position_ping (
  vehicle_id bigint,
  ping_ts    timestamptz,
  lat double precision,
  lon double precision
) PARTITION BY RANGE (ping_ts);
```

---

  

  

## **7  Pre‑Aggregation & MVs**

```
CREATE MATERIALIZED VIEW mv_hourly_revenue AS
SELECT depot_id,
       date_trunc('hour', processed_at) AS hr,
       sum(amount_cents) AS cents
FROM payment_txn
GROUP BY 1,2
WITH NO DATA;

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_hourly_revenue;
```

Dashboard now index‑scans MV instead of hashing 50 M rows.

---

  

  

## **8  WAL & Checkpoints Deep‑Dive**

- **wal_writer_delay** 1000 ms: batches small commits into single fsync.
    
- **synchronous_commit** off for ETL replay on replica.
    
- **Cross‑region replication**: DR node retraces WAL; commit latency ≈ RTT if synchronous_standby_names used.
    

---

  

  

## **9  Pooling & PgBouncer**

```
[databases]
app = host=postgres port=5432 dbname=app user=app

[pgbouncer]
pool_mode          = transaction
default_pool_size  = 20
reserve_pool_size  = 5
max_client_conn    = 1500
server_idle_timeout= 300
query_wait_timeout = 5
```

- 1 socket ↔ back‑end only while txn open.
    
- Excess sockets queue; PgBouncer never lets PG spawn > pool_size PIDs.
    

---

  

  

## **10  GraphQL DataLoader**

- Batches N resolver calls into 1 SQL.
    
- Lives **inside** the pod; PgBouncer sees one transaction.
    
- Prevents “N + 1” connection blizzards.
    

```
const ordersByUser = new DataLoader(keys =>
  pool.query('SELECT * FROM orders WHERE user_id = ANY($1)', [keys])
);
```

---

  

  

## **11  HTTP Idempotency Keys**

- Header: Idempotency-Key: <uuid>
    
- Lookup/insert in side‑table with PK.
    
- Second attempt hits fast path, no double row.
    

```
INSERT INTO idem (key,response) VALUES ($1,$2)
ON CONFLICT (key) DO UPDATE SET key=EXCLUDED.key
RETURNING response;
```

---

  

  

## **12  High Availability & Read Routing**

|**Tier**|**Tool**|**Notes**|
|---|---|---|
|Fail‑over|Patroni|VIP switch ≤30 s.|
|Read scale|Logical & physical replicas|API routes SELECTs by intent; replica lag guard.|
|Global|Aurora global DB / Bucardo|Local reader reduce RTT.|

---

  

  

## **13  Real‑World Scenarios**

  

### **13.1  Flash‑Sale surge**

- 64 pods, PgBouncer 20 back‑ends, SKIP LOCKED pattern.
    
- Latency flat at 40 ms.
    

  

### **13.2  Chat N+1 meltdown fixed**

- DataLoader batches 600 item look‑ups into 1 query; back‑ends remain 25.
    

  

### **13.3  Autoscaling storm**

- Session→transaction pool switch; max_client_conn cap.
    

  

### **13.4  IoT ingest with UNLOGGED staging**

- COPY 10 k rows, commuter inserts, synchronous_commit=off, WAL 40 % lighter.
    

  

### **13.5  ETL hash spill cured**

- work_mem 1GB on replica only; primary remains 32 MB.
    

---

  

  

## **14  Sizing Cheat‑Sheets**

  

### **14.1  Pool sizes**

```
backends = cores × 2 + 4
clientconns = replicas × 30 (≈ 5× backends)
```

### **14.2  Memory formula**

```
shared_buffers + work_mem × backends + OS cache ≤ RAM × 0.9
```

---

  

  

## **15  Glossary**

- **Back‑end** – one PostgreSQL server process.
    
- **Pod** – container running API.
    
- **Transaction pooling** – PgBouncer strategy: socket ↔ back‑end for txn only.
    
- **RTT** – round‑trip time client ↔ server.
    
- **Idempotency key** – unique token ensuring one‑and‑only‑one effect.
    
- **HOT update** – Heap‑Only Tuple update that avoids index changes.
    
- **BRIN** – Block Range Index, min/max per page range.
    

---

### 

> **“Everything’s a trade‑off.”**

>   

> Maximise cache hits, keep transactions tiny, and pool connections—then scale read replicas or partition when the maths shows you must.

---

## **16  Supplementary Notes & Quick Facts**

  

_Added from live session notes—kept verbatim so you have a one-scroll cheat sheet._

  

### **16.1  Foreign-Key & Insert Optimisations**

- **FK = extra CPU** on every INSERT/UPDATE and row-level share locks on UPDATE.
    
    → Bulk-load in FK order **or** SET CONSTRAINTS ALL DEFERRED; (DEFERRABLE INITIALLY DEFERRED).
    
- Batch inserts in FK order to minimise lock waits.
    

  

### **16.2  Wide-Row Impact**

- Wide tables = more pages, more I/O, more shared-buffer churn.
    
    → Always SELECT column_list not SELECT * in hot paths.
    

  

### **16.3  Normalisation vs Footprint vs Joins**

- Normalised = smaller heap = safer updates.
    
- Downside: more joins → CPU/RAM.
    
    → Pre-aggregate or **index FK columns** (e.g., (customer_id) on order lines).
    

  

### **16.4  WAL Best Practice**

- Keep **transactions short**; set statement_timeout so long txns roll back before WAL piles up.
    

  

### **16.5  B-tree Split Storm**

- Frequent insert on indexed column forces splits.
    
    → Disable index during COPY, then CREATE INDEX.
    
    → Or use **covering INCLUDE** index to remove extra heap visits.
    

  

### **16.6  Quick Operator Rules**

- **FK style look-ups** → Nested Loop + Memoize (tiny memory).
    
- **Hash Join** great when build side tiny & no order needed.
    
- Enough work_mem + parallel workers turns spilling sort into in-RAM sort.
    

  

### **16.7  Index-size Pro Tips**

- Recurrent query on subset? Build **partial index** on that slice.
    
- Seq Scan seen → consider index or partition.
    

  

### **16.8  Index Types Recap**

|**Scan type**|**When**|**Notes**|
|---|---|---|
|Seq Scan|No usable index|Full table read.|
|Index Scan|Index guides start|Needs heap fetch.|
|Index Only|Index covers data|No heap I/O.|

> **Indexes store keys + row addresses—never full rows.**

  

### **16.9  Data-Type Sizing Cheat-list**

```
smallint 2B  – IDs ≤ 32k
integer  4B  – PK/FK ≤ 2.1B
bigint   8B  – money cents, epoch
boolean  1B  – use bool, not 'Y'/'N'
numeric(p,s)  – 2B/4 digits
real/double  – sensor floats
uuid     16B – only if global uniqueness needed
enum     4B  – status fields
jsonb    var – 10–20% overhead but compressible
```

- Narrow rows pack more tuples per 8 kB page ⇒ better cache, lower work_mem.
![[Screenshot 2025-07-25 at 17.01.44.png]]

> Remember: **choose smallest fixed-width type that still covers lifetime range**, prefer enum/FK over free-text, use jsonb only when agility outweighs bytes.
