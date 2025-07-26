
Foreign keys add CPU overhead in every insert/update and lock contention in every update -> batch inserts in FK order - defer FK checks (DEFERRABLE INITIALLY DEFERRED) when loading bulk data.

Wide rows (too much columns in table) -> more disk pages and consumes more buffer size. If the table is too big (too many rows) strains indexes and sequential scans. --> Trim the column selection with SELECT in query.

Normalization (parititioning the row elements in a table into corresponding tables to avoid duplication) has smaller footprint, safer updates but more joins (costs CPU & RAM and may overload the disk) --> pre-aggregate or index FK columns.

WAL writes -> disk I/O latency --> always keep transactions short with timeout setting

Frequent inserts on an indexed column force B-tree splits -> CPU and buffer bloat --> - bulk-load with indexes disabled then CREATE INDEX, - use _covering_ indexes (INCLUDE columns) to avoid heap visits on hot reads.

PRIMARY KEY makes the column non-null, auto-indexed and unique
SERIAL adds a sequence to rows and each newly generated row gets sequential unique integer.

For FK style lookups --> Nested-Loop + Memoize is ideal and insensitive to small work_mem.

Hash Join is perfect when one side is tiny and you don’t request a sort order.

Enough work_mem + parallel workers convert a spilling sort into multiple in-RAM sorts; runtime and temp I/O drop dramatically.

For recurrent queries that always asks the same thing, we can introduce a smaller index that only hits the part of the table that we ask instead scanning thorugh entire table pages.

Seq Scan -> planner reads through all pages (entire table scan) --> create index or partition based on conditions.

Index Scan -> having an index that shows exactly where to start scanning from --> reduces scan burden in disk/buffer(memory).

Index Only Scan -> same as index scan + index also covers the data we are scanning for --> no I/O needed(faster)

Indexes do not contain rows/tuples , they only hold keys + row addresses
----

**DATA TYPES**

IDs that never exceeds amount 32,667 -> smallint (2B)
PK,  FK that never exceeds 2.1 billion -> integer (4B)
Event streams, money amounts, UNIX Epoch -> bigint (8B) 
Booleans (1B) -> True/false, not use char 'Y' - 'N' etc.
NUMERIC(p,s) -> 2B per group of 4 digits
real (4 B) · double precision (8 B) -> where tiny errors are OK -> Sensor feeds, analytics etc.
date (4 B) · timestamp (8 B) · timestamptz (8 B) -> If you **only** need the day, store date. Time-zone unaware logs? timestamp. User-facing or cross-TZ? timestamptz.
enum (4 B) or lookup-table FK (2–4 B) -> Small, immutable domain (status, gender). enum keeps rows tight and sorts by ordinal.
integer, bigint, or uuid (16 B) -> If global uniqueness isn’t needed, avoid 16-byte uuid.
jsonb (binary) -> var-len + structural bytes -> Great flexibility; expect ~10 – 20 % overhead vs raw text; still toastable/compressible. 
bytea, lo -> blobs -> Store in object storage if >1 MB.

If rows are narrowed (covering columns) -> heaps can hold more tuples -> faster scanning + more tuples can be buffered + less memory overhead for work_mem + shared buffer

![[Screenshot 2025-07-25 at 17.01.44.png]]

**Note:** choose the smallest fixed-width type that still covers lifetime range, prefer enums / FKs over free-text, and recognise when a flexible column (jsonb, text) wins you schema agility worth the extra bytes.