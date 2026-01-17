# Loki Tutorial: Complete Guide to Log Aggregation and Analysis

## Table of Contents
1. [Introduction to Loki](#introduction)
2. [Architecture and Components](#architecture)
3. [Installation and Setup](#installation)
4. [Configuration](#configuration)
5. [LogQL - Query Language](#logql)
6. [Log Collection with Promtail](#promtail)
7. [Integration with Grafana](#grafana)
8. [Labels and Indexing Strategy](#labels)
9. [Performance and Scaling](#performance)
10. [Best Practices](#best-practices)
11. [Real-World Examples](#examples)

---

## Introduction to Loki {#introduction}

### What is Loki?

Loki is a horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus. Created by Grafana Labs, it's designed to be cost-effective and easy to operate, storing only metadata about logs (labels) and not indexing the log content itself.

### Key Features

- **Cost-effective**: Only indexes metadata (labels), not log content
- **Efficient storage**: Compressed log chunks stored in object storage
- **Label-based indexing**: Similar to Prometheus metrics
- **LogQL query language**: Familiar syntax for Prometheus users
- **Native Grafana integration**: Seamless log visualization
- **Multi-tenancy**: Built-in support for multiple tenants
- **Horizontal scalability**: Can scale components independently

### Loki vs. Traditional Log Systems

| Feature | Loki | Elasticsearch |
|---------|------|---------------|
| Indexing | Only labels | Full-text index |
| Storage Cost | Lower | Higher |
| Query Speed | Fast for label-based | Fast for text search |
| Setup Complexity | Simple | Complex |
| Resource Usage | Lower | Higher |
| Best For | Structured logs | Full-text search |

### Use Cases

- Container and Kubernetes log aggregation
- Application log monitoring
- Infrastructure log collection
- Distributed tracing correlation
- Security and audit logging
- Cost-effective log retention

---

## Architecture and Components {#architecture}

### Core Components

#### 1. Distributor
- Entry point for log data
- Validates incoming logs
- Applies rate limiting
- Distributes logs to ingesters

#### 2. Ingester
- Writes log data to storage
- Creates compressed chunks
- Maintains in-memory logs
- Flushes to long-term storage

#### 3. Querier
- Handles LogQL queries
- Queries both ingesters and storage
- Merges results
- Returns logs to clients

#### 4. Query Frontend (Optional)
- Splits large queries
- Caches query results
- Queues queries
- Improves query performance

#### 5. Compactor
- Compacts index files
- Marks old data for deletion
- Improves query performance

#### 6. Ruler
- Evaluates LogQL rules
- Generates alerts
- Records derived metrics

### Architecture Diagram

```
                    ┌────────────────┐
                    │   Promtail     │
                    │  (Log Agent)   │
                    └────────┬───────┘
                             │
                             ▼
                    ┌────────────────┐
                    │  Distributor   │
                    └────────┬───────┘
                             │
                   ┌─────────┴─────────┐
                   ▼                   ▼
            ┌──────────┐        ┌──────────┐
            │ Ingester │        │ Ingester │
            └─────┬────┘        └────┬─────┘
                  │                  │
                  └─────────┬────────┘
                            ▼
                   ┌─────────────────┐
                   │ Object Storage  │
                   │  (S3, GCS, etc) │
                   └─────────┬───────┘
                             │
                             ▼
                   ┌─────────────────┐
                   │    Querier      │
                   └─────────┬───────┘
                             │
                             ▼
                   ┌─────────────────┐
                   │     Grafana     │
                   └─────────────────┘
```

### Storage

#### Index Store
Stores label index:
- **BoltDB**: Single-process mode
- **BoltDB-Shipper**: Distributed mode with object storage
- **Cassandra**: Large-scale deployments
- **Bigtable**: Google Cloud

#### Chunk Store
Stores compressed log data:
- **Filesystem**: Local development
- **Amazon S3**: AWS
- **Google Cloud Storage**: GCP
- **Azure Blob Storage**: Azure
- **MinIO**: Self-hosted S3-compatible

---

## Installation and Setup {#installation}

### Single Binary Installation

#### Download and Run

```bash
# Download Loki
wget https://github.com/grafana/loki/releases/download/v2.9.3/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
chmod +x loki-linux-amd64

# Download Promtail
wget https://github.com/grafana/loki/releases/download/v2.9.3/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
chmod +x promtail-linux-amd64

# Download config files
wget https://raw.githubusercontent.com/grafana/loki/main/cmd/loki/loki-local-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml

# Run Loki
./loki-linux-amd64 -config.file=loki-local-config.yaml

# Run Promtail (in another terminal)
./promtail-linux-amd64 -config.file=promtail-local-config.yaml
```

### Docker Installation

#### Docker Compose Setup

Create `docker-compose.yml`:

```yaml
version: "3"

services:
  loki:
    image: grafana/loki:2.9.3
    container_name: loki
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
      - loki-data:/loki
    networks:
      - loki

  promtail:
    image: grafana/promtail:2.9.3
    container_name: promtail
    volumes:
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - ./promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
    networks:
      - loki

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana-datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml
    networks:
      - loki

volumes:
  loki-data:
  grafana-data:

networks:
  loki:
    driver: bridge
```

### Kubernetes Installation with Helm

```bash
# Add Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Loki Stack (Loki + Promtail + Grafana)
helm install loki grafana/loki-stack \
  --namespace=logging \
  --create-namespace \
  --set grafana.enabled=true \
  --set prometheus.enabled=true \
  --set promtail.enabled=true

# Or install components separately
helm install loki grafana/loki \
  --namespace=logging \
  --create-namespace \
  --set persistence.enabled=true \
  --set persistence.size=10Gi

helm install promtail grafana/promtail \
  --namespace=logging \
  --set config.lokiAddress=http://loki:3100/loki/api/v1/push
```

### Verify Installation

```bash
# Check Loki is running
curl http://localhost:3100/ready

# Check metrics endpoint
curl http://localhost:3100/metrics

# Query labels
curl -G -s "http://localhost:3100/loki/api/v1/label" | jq
```

---

## Configuration {#configuration}

### Loki Configuration

#### Basic Configuration (`loki-config.yaml`)

```yaml
# Authentication and multi-tenancy
auth_enabled: false

# Server configuration
server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: info

# Ingester configuration
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s
  max_transfer_retries: 0
  wal:
    enabled: true
    dir: /loki/wal

# Schema configuration
schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

# Storage configuration
storage_config:
  boltdb_shipper:
    active_index_directory: /loki/boltdb-shipper-active
    cache_location: /loki/boltdb-shipper-cache
    cache_ttl: 24h
    shared_store: filesystem
  filesystem:
    directory: /loki/chunks

# Compactor
compactor:
  working_directory: /loki/compactor
  shared_store: filesystem
  compaction_interval: 10m
  retention_enabled: true
  retention_delete_delay: 2h
  retention_delete_worker_count: 150

# Limits configuration
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 10
  ingestion_burst_size_mb: 20
  per_stream_rate_limit: 5MB
  per_stream_rate_limit_burst: 20MB
  max_streams_per_user: 10000
  max_global_streams_per_user: 100000
  max_query_length: 721h
  max_query_parallelism: 32
  max_cache_freshness_per_query: 10m

# Chunk cache
chunk_store_config:
  max_look_back_period: 0s
  chunk_cache_config:
    enable_fifocache: true
    fifocache:
      max_size_bytes: 1GB
      ttl: 1h

# Table manager
table_manager:
  retention_deletes_enabled: true
  retention_period: 336h  # 14 days

# Ruler (for alerts)
ruler:
  storage:
    type: local
    local:
      directory: /loki/rules
  rule_path: /loki/rules-temp
  alertmanager_url: http://alertmanager:9093
  ring:
    kvstore:
      store: inmemory
  enable_api: true
```

#### Production Configuration with S3

```yaml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

ingester:
  lifecycler:
    address: 0.0.0.0
    ring:
      kvstore:
        store: consul
        consul:
          host: consul:8500
      replication_factor: 3
  chunk_idle_period: 5m
  max_chunk_age: 1h
  chunk_retain_period: 30s
  wal:
    enabled: true
    dir: /loki/wal

schema_config:
  configs:
    - from: 2023-01-01
      store: boltdb-shipper
      object_store: s3
      schema: v11
      index:
        prefix: loki_index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/cache
    shared_store: s3
  aws:
    s3: s3://us-east-1/my-loki-bucket
    s3forcepathstyle: false
    bucketnames: my-loki-bucket
    region: us-east-1
    access_key_id: ${AWS_ACCESS_KEY_ID}
    secret_access_key: ${AWS_SECRET_ACCESS_KEY}

limits_config:
  ingestion_rate_mb: 50
  ingestion_burst_size_mb: 100
  max_streams_per_user: 100000
  max_global_streams_per_user: 1000000
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  chunk_cache_config:
    memcached:
      batch_size: 100
      parallelism: 100
    memcached_client:
      addresses: dnssrvnoa+memcached.loki.svc.cluster.local:11211
      consistent_hash: true
```

#### Retention Rules

```yaml
limits_config:
  retention_period: 744h  # 31 days

# Stream-based retention
retention_stream:
  - selector: '{environment="dev"}'
    priority: 1
    period: 168h  # 7 days
  
  - selector: '{environment="staging"}'
    priority: 2
    period: 336h  # 14 days
  
  - selector: '{environment="production"}'
    priority: 3
    period: 2160h  # 90 days
  
  - selector: '{level="debug"}'
    priority: 4
    period: 24h  # 1 day
```

---

## LogQL - Query Language {#logql}

### Basic Query Syntax

#### Log Stream Selectors

```logql
# Select all logs from a job
{job="varlogs"}

# Multiple labels
{job="mysql", instance="localhost"}

# Label matching operators
{name=~"mysql.+"} # Regex match
{name!="mysql"}   # Not equal
{name!~"mysql.*"} # Regex not match
```

#### Line Filter Expressions

```logql
# Contains
{job="mysql"} |= "error"

# Does not contain
{job="mysql"} != "error"

# Regex match
{job="mysql"} |~ "error|warning"

# Regex not match
{job="mysql"} !~ "debug|trace"

# Chain filters
{job="mysql"} |= "error" != "timeout"
```

### LogQL Operators

#### Parser Expressions

##### JSON Parser

```logql
# Parse JSON logs
{job="api"} | json

# Access specific fields
{job="api"} | json | status_code="200"

# Rename fields
{job="api"} | json status="status_code", method="http_method"
```

Example log:
```json
{"level":"info","method":"GET","path":"/api/users","status_code":200,"duration_ms":45}
```

Query:
```logql
{job="api"} | json | status_code="200" | line_format "{{.method}} {{.path}} took {{.duration_ms}}ms"
```

##### Logfmt Parser

```logql
# Parse logfmt logs
{job="app"} | logfmt

# Filter by parsed fields
{job="app"} | logfmt | level="error"
```

Example log:
```
level=info method=GET path=/api/users status=200 duration=45ms
```

##### Pattern Parser

```logql
# Define pattern
{job="nginx"} | pattern `<ip> - - <_> "<method> <path> <_>" <status> <size>`

# Use extracted fields
{job="nginx"} | pattern `<ip> - - <_> "<method> <path> <_>" <status> <size>` | status="200"
```

##### Regex Parser

```logql
# Extract with regex
{job="app"} | regexp `(?P<level>\w+) (?P<msg>.*)`

# Named capture groups become labels
{job="app"} | regexp `level=(?P<level>\w+)` | level="error"
```

#### Label Format Expressions

```logql
# Rename label
{job="mysql"} | label_format new_name=old_name

# Create computed labels
{job="app"} | json | label_format status_category=`{{if eq .status_code "200"}}success{{else}}failure{{end}}`
```

#### Line Format Expressions

```logql
# Custom output format
{job="app"} | json | line_format "{{.timestamp}} [{{.level}}] {{.message}}"

# Conditional formatting
{job="app"} | json | line_format `{{if eq .level "error"}}ERROR: {{.message}}{{else}}{{.message}}{{end}}`
```

### Metric Queries

#### Rate

```logql
# Logs per second
rate({job="mysql"}[5m])

# Filtered rate
rate({job="mysql"} |= "error"[5m])

# Rate by label
sum(rate({job="mysql"}[5m])) by (level)
```

#### Count Over Time

```logql
# Count logs in range
count_over_time({job="mysql"}[5m])

# Count errors
count_over_time({job="mysql"} |= "error"[5m])

# Sum by host
sum by (host) (count_over_time({job="mysql"}[5m]))
```

#### Bytes Rate and Bytes Over Time

```logql
# Bytes per second
bytes_rate({job="app"}[5m])

# Total bytes in range
bytes_over_time({job="app"}[1h])
```

#### Aggregate Functions

```logql
# Sum
sum(rate({job="app"}[5m]))

# Average
avg(count_over_time({job="app"}[5m]))

# Max
max(rate({job="app"}[5m])) by (instance)

# Min
min(rate({job="app"}[5m]))

# Count (number of streams)
count(rate({job="app"}[5m]))

# Top K
topk(5, sum by (endpoint) (rate({job="api"}[5m])))

# Bottom K
bottomk(3, rate({job="app"}[5m]))
```

### Advanced Queries

#### Unwrap

Extract numeric values from logs:

```logql
# Average duration
avg_over_time({job="api"} | json | unwrap duration_ms[5m])

# Sum bytes
sum_over_time({job="nginx"} | logfmt | unwrap bytes[1h])

# Rate of unwrapped value
rate({job="api"} | json | unwrap duration_ms[5m])

# Quantile
quantile_over_time(0.95, {job="api"} | json | unwrap duration_ms[5m])
```

#### Label Extraction and Filtering

```logql
# Extract and filter
{job="app"} 
  | json 
  | user_id="12345" 
  | line_format "User {{.user_id}} performed {{.action}}"

# Multiple conditions
{job="api"} 
  | json 
  | status_code >= 200
  | status_code < 300
  | duration_ms > 100
```

#### Error Rate Calculation

```logql
# Error rate percentage
100 * (
  sum(rate({job="api"} |= "error"[5m]))
  /
  sum(rate({job="api"}[5m]))
)

# By endpoint
100 * (
  sum by (endpoint) (rate({job="api"} | json | status_code >= 500[5m]))
  /
  sum by (endpoint) (rate({job="api"} | json[5m]))
)
```

#### P95 Latency

```logql
# 95th percentile latency
quantile_over_time(0.95,
  {job="api"} | json | unwrap duration_ms[5m]
) by (endpoint)
```

#### Log Volume Analysis

```logql
# Top log producers
topk(10, sum by (container) (rate({namespace="production"}[1h])))

# Compare volumes
sum(rate({environment="production"}[1h])) 
/ 
sum(rate({environment="staging"}[1h]))
```

---

## Log Collection with Promtail {#promtail}

### Promtail Configuration

#### Basic Configuration

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0
  log_level: info

# Loki endpoint
clients:
  - url: http://loki:3100/loki/api/v1/push
    tenant_id: tenant1  # Optional for multi-tenancy
    batchwait: 1s
    batchsize: 1048576  # 1MB
    
    # External labels applied to all logs
    external_labels:
      cluster: production
      region: us-east-1

# Log file discovery and parsing
scrape_configs:
  # System logs
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*.log

  # Application logs
  - job_name: app
    static_configs:
      - targets:
          - localhost
        labels:
          job: application
          environment: production
          __path__: /app/logs/*.log

  # Nginx access logs
  - job_name: nginx
    static_configs:
      - targets:
          - localhost
        labels:
          job: nginx
          __path__: /var/log/nginx/access.log
    
    pipeline_stages:
      # Parse nginx log format
      - regex:
          expression: '^(?P<ip>\S+) \S+ \S+ \[(?P<timestamp>.*?)\] "(?P<method>\S+) (?P<path>\S+) \S+" (?P<status>\d+) (?P<size>\d+)'
      
      # Add labels from parsed fields
      - labels:
          method:
          status:
      
      # Parse timestamp
      - timestamp:
          source: timestamp
          format: "02/Jan/2006:15:04:05 -0700"
      
      # Output formatting
      - output:
          source: method

  # JSON logs
  - job_name: json-logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: json-app
          __path__: /app/logs/*.json
    
    pipeline_stages:
      - json:
          expressions:
            level: level
            message: message
            timestamp: timestamp
            user_id: user_id
      
      - labels:
          level:
      
      - timestamp:
          source: timestamp
          format: RFC3339
```

#### Kubernetes Configuration

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

clients:
  - url: http://loki:3100/loki/api/v1/push

positions:
  filename: /tmp/positions.yaml

scrape_configs:
  # Kubernetes pod logs
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    
    relabel_configs:
      # Only scrape pods with annotation
      - source_labels:
          - __meta_kubernetes_pod_annotation_prometheus_io_scrape
        action: keep
        regex: true
      
      # Extract namespace
      - source_labels:
          - __meta_kubernetes_namespace
        target_label: namespace
      
      # Extract pod name
      - source_labels:
          - __meta_kubernetes_pod_name
        target_label: pod
      
      # Extract container name
      - source_labels:
          - __meta_kubernetes_pod_container_name
        target_label: container
      
      # Set log path
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
          - __meta_kubernetes_pod_uid
          - __meta_kubernetes_pod_container_name
        target_label: __path__
    
    pipeline_stages:
      # Parse CRI format
      - cri: {}
      
      # Extract JSON if present
      - json:
          expressions:
            level: level
            message: msg
      
      # Add level label
      - labels:
          level:
```

#### Docker Configuration

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          __path__: /var/lib/docker/containers/*/*.log
    
    pipeline_stages:
      # Parse Docker JSON format
      - json:
          expressions:
            stream: stream
            log: log
            time: time
      
      - timestamp:
          source: time
          format: RFC3339Nano
      
      # Extract container info from path
      - regex:
          expression: '.*/(?P<container_id>[^/]+)/.*'
          source: filename
      
      - labels:
          container_id:
          stream:
```

### Pipeline Stages

#### Drop Stage

```yaml
pipeline_stages:
  # Drop debug logs
  - drop:
      expression: "level=debug"
  
  # Drop by regex
  - drop:
      expression: ".*healthcheck.*"
      drop_counter_reason: "healthcheck"
```

#### Match Stage

```yaml
pipeline_stages:
  # Different processing for different log types
  - match:
      selector: '{job="app"} |= "error"'
      stages:
        - json:
            expressions:
              error_msg: error
        - labels:
            error_msg:
  
  - match:
      selector: '{job="app"} |= "request"'
      stages:
        - json:
            expressions:
              method: method
              path: path
        - labels:
            method:
```

#### Metrics Stage

```yaml
pipeline_stages:
  # Count errors
  - metrics:
      error_total:
        type: Counter
        description: "Total errors"
        source: level
        config:
          action: inc
          match_all: true
          value: "error"
  
  # Track request duration
  - metrics:
      request_duration:
        type: Histogram
        description: "Request duration"
        source: duration_ms
        config:
          buckets: [10, 50, 100, 500, 1000, 5000]
```

---

## Integration with Grafana {#grafana}

### Adding Loki Data Source

#### Via UI

1. **Configuration** → **Data Sources** → **Add data source**
2. Select **Loki**
3. Configure:
   - **Name**: Loki
   - **URL**: `http://loki:3100`
   - **Max lines**: 1000
4. **Save & Test**

#### Via Provisioning

Create `/etc/grafana/provisioning/datasources/loki.yaml`:

```yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    jsonData:
      maxLines: 1000
      derivedFields:
        - datasourceUid: prometheus
          matcherRegex: "trace_id=(\\w+)"
          name: TraceID
          url: "$${__value.raw}"
```

### Explore Logs in Grafana

#### Basic Log Exploration

1. Navigate to **Explore**
2. Select **Loki** data source
3. Enter LogQL query:
```logql
{job="app"} |= "error"
```
4. View results in **Logs** panel

#### Live Tailing

Enable **Live** mode in top-right to stream logs in real-time.

#### Log Context

Click on a log line → **Show context** to see surrounding logs.

### Creating Log Dashboards

#### Log Panel Configuration

```json
{
  "type": "logs",
  "title": "Application Errors",
  "datasource": "Loki",
  "targets": [
    {
      "expr": "{job=\"app\"} |= \"error\"",
      "refId": "A"
    }
  ],
  "options": {
    "showTime": true,
    "showLabels": true,
    "showCommonLabels": false,
    "wrapLogMessage": true,
    "prettifyLogMessage": false,
    "enableLogDetails": true,
    "sortOrder": "Descending"
  }
}
```

#### Time Series from Logs

```json
{
  "type": "timeseries",
  "title": "Error Rate",
  "datasource": "Loki",
  "targets": [
    {
      "expr": "sum(rate({job=\"app\"} |= \"error\"[5m]))",
      "refId": "A",
      "legendFormat": "Errors/sec"
    }
  ]
}
```

#### Stat Panel with Log Count

```json
{
  "type": "stat",
  "title": "Total Errors (24h)",
  "datasource": "Loki",
  "targets": [
    {
      "expr": "sum(count_over_time({job=\"app\"} |= \"error\"[24h]))",
      "refId": "A"
    }
  ],
  "options": {
    "reduceOptions": {
      "values": false,
      "fields": "",
      "calcs": ["lastNotNull"]
    }
  }
}
```

### Complete Dashboard Example

```json
{
  "title": "Application Logs",
  "panels": [
    {
      "title": "Log Volume",
      "type": "timeseries",
      "targets": [
        {
          "expr": "sum(rate({job=\"app\"}[1m])) by (level)"
        }
      ]
    },
    {
      "title": "Error Rate",
      "type": "stat",
      "targets": [
        {
          "expr": "sum(rate({job=\"app\"} |= \"error\"[5m]))"
        }
      ]
    },
    {
      "title": "Recent Errors",
      "type": "logs",
      "targets": [
        {
          "expr": "{job=\"app\"} |= \"error\""
        }
      ],
      "options": {
        "showTime": true,
        "showLabels": false,
        "wrapLogMessage": true
      }
    },
    {
      "title": "Top Error Messages",
      "type": "table",
      "targets": [
        {
          "expr": "topk(10, sum by (message) (count_over_time({job=\"app\"} | json | level=\"error\"[24h])))"
        }
      ]
    }
  ]
}
```

---

## Labels and Indexing Strategy {#labels}

### Label Design Principles

#### Good Labels (Low Cardinality)

```yaml
# Environment
{environment="production"}
{environment="staging"}
{environment="development"}

# Service/Application
{app="api-server"}
{app="worker"}
{app="frontend"}

# Log level
{level="error"}
{level="warning"}
{level="info"}

# Cluster/Region
{cluster="us-east-1"}
{region="eu-west-1"}

# Namespace (Kubernetes)
{namespace="default"}
{namespace="monitoring"}
```

#### Bad Labels (High Cardinality)

❌ Avoid these:
```yaml
# User IDs
{user_id="12345"}

# Request IDs
{request_id="abc-123-def"}

# Timestamps
{timestamp="2024-01-15T10:30:00"}

# IP addresses
{ip="192.168.1.100"}

# URLs
{url="/api/users/12345/profile"}
```

### Label Cardinality Impact

**Example of cardinality explosion:**

```yaml
# Bad: Creates thousands of streams
{app="api", endpoint="/api/users", user_id="12345", request_id="abc123"}

# Good: Creates manageable streams
{app="api"} | json | endpoint="/api/users" | user_id="12345"
```

### Optimal Label Strategy

```yaml
# Index labels (low cardinality)
{
  cluster="prod",
  namespace="default",
  app="api-server",
  level="error"
}

# Filter in query (high cardinality)
{app="api-server"} 
  | json 
  | user_id="12345" 
  | endpoint="/api/users"
```

### Dynamic Labels with Relabeling

```yaml
# Promtail relabel config
relabel_configs:
  # Add environment based on namespace
  - source_labels: [__meta_kubernetes_namespace]
    regex: prod-.*
    target_label: environment
    replacement: production
  
  # Normalize app names
  - source_labels: [__meta_kubernetes_pod_label_app]
    regex: (.+)-deployment
    target_label: app
    replacement: ${1}
  
  # Drop unwanted labels
  - regex: __meta_kubernetes_pod_label_.*
    action: labeldrop
```

---

## Performance and Scaling {#performance}

### Query Optimization

#### 1. Use Time Ranges

```logql
# Good: Limited time range
{job="app"}[5m]

# Bad: No time range (scans everything)
{job="app"}
```

#### 2. Leverage Label Filters

```logql
# Good: Filter early with labels
{job="app", level="error"} |= "timeout"

# Bad: Scan all logs then filter
{job="app"} |= "error" |= "timeout"
```

#### 3. Use Line Filters Before Parsing

```logql
# Good: Filter then parse
{job="app"} |= "error" | json | user_id="12345"

# Bad: Parse everything
{job="app"} | json | level="error" | user_id="12345"
```

### Scaling Considerations

#### Horizontal Scaling

**Ingesters:**
- Run multiple ingesters with replication factor 3
- Each handles subset of streams based on hash ring

**Queriers:**
- Scale based on query load
- Run 3-5 queriers minimum

**Distributors:**
- Stateless, scale based on ingestion rate
- 1 distributor per 10-20 GB/day ingestion

#### Vertical Scaling

**Memory:**
```yaml
# Per ingester
ingester:
  chunk_target_size: 1572864  # 1.5MB
  max_chunk_age: 2h
  chunk_idle_period: 30m
```

**Storage:**
- Use object storage (S3, GCS) for chunks
- Local SSD for index (BoltDB-Shipper)

### Caching Strategy

```yaml
# Query results cache (Redis)
query_range:
  results_cache:
    cache:
      redis_config:
        endpoint: redis:6379
        timeout: 500ms
        expiration: 1h

# Chunk cache (Memcached)
chunk_store_config:
  chunk_cache_config:
    memcached:
      batch_size: 100
      parallelism: 100
    memcached_client:
      addresses: memcached:11211
      timeout: 500ms
      max_idle_conns: 100
```

### Retention and Compaction

```yaml
# Compactor configuration
compactor:
  working_directory: /loki/compactor
  shared_store: s3
  compaction_interval: 10m
  retention_enabled: true
  retention_delete_delay: 2h
  
  # Compact small chunks
  retention_delete_worker_count: 150
  
  # Compact old indices
  compaction_interval: 10m

# Table manager (deprecated but still used)
table_manager:
  retention_deletes_enabled: true
  retention_period: 2160h  # 90 days
```

---

## Best Practices {#best-practices}

### 1. Label Design

✅ **Do:**
- Use labels for dimensions you'll aggregate by
- Keep label cardinality under 10,000 per label
- Use semantic labels (environment, cluster, app)
- Limit to 10-15 labels per stream

❌ **Don't:**
- Use labels for high-cardinality values
- Create labels for every field
- Use dynamic labels from log content
- Over-index

### 2. Log Structure

**Structured Logs (JSON/Logfmt):**

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "error",
  "message": "Database connection failed",
  "error": "connection timeout",
  "user_id": "12345",
  "duration_ms": 5000
}
```

Benefits:
- Easy parsing in LogQL
- Consistent structure
- Extract metrics from logs

### 3. Query Patterns

**Efficient:**
```logql
# Filter early, parse later
{app="api", level="error"} |= "database" | json | duration_ms > 1000
```

**Inefficient:**
```logql
# Parse everything first
{app="api"} | json | level="error" | message |= "database"
```

### 4. Retention Policy

```yaml
# Different retention for different log types
limits_config:
  retention_stream:
    # Debug logs: 1 day
    - selector: '{level="debug"}'
      priority: 1
      period: 24h
    
    # Info logs: 7 days
    - selector: '{level="info"}'
      priority: 2
      period: 168h
    
    # Error logs: 90 days
    - selector: '{level="error"}'
      priority: 3
      period: 2160h
```

### 5. Monitoring Loki

**Key Metrics:**

```promql
# Ingestion rate
sum(rate(loki_distributor_bytes_received_total[1m]))

# Query latency
histogram_quantile(0.99, 
  sum(rate(loki_request_duration_seconds_bucket[5m])) by (le)
)

# Number of streams
loki_ingester_memory_streams

# Chunk utilization
loki_ingester_chunk_utilization

# Failed requests
sum(rate(loki_request_duration_seconds_count{status_code!="200"}[5m]))
```

### 6. Cost Optimization

- Use compression (default: snappy or gzip)
- Implement proper retention policies
- Drop unnecessary logs early (Promtail pipeline)
- Use object storage (cheaper than block storage)
- Compact regularly to reduce storage overhead

---

## Real-World Examples {#examples}

### Complete Stack Example

#### Docker Compose

```yaml
version: "3.8"

services:
  loki:
    image: grafana/loki:2.9.3
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/config.yaml
    volumes:
      - ./loki-config.yaml:/etc/loki/config.yaml
      - loki-data:/loki
    networks:
      - monitoring

  promtail:
    image: grafana/promtail:2.9.3
    volumes:
      - ./promtail-config.yaml:/etc/promtail/config.yaml
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yaml
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana-datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml
    networks:
      - monitoring

volumes:
  loki-data:
  grafana-data:

networks:
  monitoring:
```

### Application Logging Example

#### Python Application with Structured Logging

```python
import logging
import json
from datetime import datetime

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno
        }
        
        # Add extra fields
        if hasattr(record, 'user_id'):
            log_data['user_id'] = record.user_id
        if hasattr(record, 'request_id'):
            log_data['request_id'] = record.request_id
        if hasattr(record, 'duration_ms'):
            log_data['duration_ms'] = record.duration_ms
        
        return json.dumps(log_data)

# Configure logging
handler = logging.FileHandler('/var/log/app/application.log')
handler.setFormatter(JSONFormatter())

logger = logging.getLogger('myapp')
logger.addHandler(handler)
logger.setLevel(logging.INFO)

# Usage
logger.info("User logged in", extra={"user_id": "12345", "request_id": "abc-123"})
logger.error("Database connection failed", extra={"error": "timeout", "duration_ms": 5000})
```

### Kubernetes DaemonSet Example

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: promtail
  namespace: logging
spec:
  selector:
    matchLabels:
      app: promtail
  template:
    metadata:
      labels:
        app: promtail
    spec:
      serviceAccountName: promtail
      containers:
        - name: promtail
          image: grafana/promtail:2.9.3
          args:
            - -config.file=/etc/promtail/config.yaml
          volumeMounts:
            - name: config
              mountPath: /etc/promtail
            - name: varlog
              mountPath: /var/log
              readOnly: true
            - name: varlibdockercontainers
              mountPath: /var/lib/docker/containers
              readOnly: true
          env:
            - name: HOSTNAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
      volumes:
        - name: config
          configMap:
            name: promtail-config
        - name: varlog
          hostPath:
            path: /var/log
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
```

---

## Conclusion

Loki provides a cost-effective, scalable solution for log aggregation that integrates seamlessly with Grafana and Prometheus. Its label-based indexing approach reduces storage costs while maintaining query performance for most use cases.

### Key Takeaways

1. **Keep label cardinality low** - Use labels for dimensions, not unique values
2. **Structure your logs** - JSON or logfmt for easier parsing
3. **Filter early** - Use line filters before parsing
4. **Plan retention** - Different retention for different log types
5. **Monitor Loki itself** - Track ingestion, queries, and storage
6. **Use object storage** - S3/GCS for cost-effective long-term storage
7. **Optimize queries** - Limit time ranges and use appropriate filters

### Further Resources

- Official Documentation: https://grafana.com/docs/loki/
- LogQL Reference: https://grafana.com/docs/loki/latest/logql/
- Best Practices: https://grafana.com/docs/loki/latest/best-practices/
- Community: https://community.grafana.com/

---

**Tags**: #devops #loki #logging #log-aggregation #observability #grafana #logql