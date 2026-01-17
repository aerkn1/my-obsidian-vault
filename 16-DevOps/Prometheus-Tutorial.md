# Prometheus Tutorial: Complete Guide to Monitoring and Alerting

## Table of Contents
1. [Introduction to Prometheus](#introduction)
2. [Architecture and Components](#architecture)
3. [Installation and Setup](#installation)
4. [Configuration](#configuration)
5. [Metrics and Data Model](#metrics)
6. [PromQL - Query Language](#promql)
7. [Exporters and Instrumentation](#exporters)
8. [Alerting](#alerting)
9. [Best Practices](#best-practices)
10. [Real-World Examples](#examples)

---

## Introduction to Prometheus {#introduction}

### What is Prometheus?

Prometheus is an open-source monitoring and alerting toolkit originally built at SoundCloud in 2012. It has become the de facto standard for monitoring cloud-native applications and is a graduated project of the Cloud Native Computing Foundation (CNCF).

### Key Features

- **Multi-dimensional data model**: Time series data identified by metric name and key-value pairs
- **Flexible query language**: PromQL for querying and aggregating data
- **Pull-based model**: Scrapes metrics from targets via HTTP
- **Service discovery**: Automatic discovery of targets
- **No dependency on distributed storage**: Single server nodes are autonomous
- **Time series collection**: Via pull model over HTTP
- **Alert management**: Built-in alerting with Alertmanager integration

### Use Cases

- Infrastructure monitoring (servers, containers, networks)
- Application performance monitoring (APM)
- Service-level indicator (SLI) tracking
- Capacity planning
- Incident response and debugging

---

## Architecture and Components {#architecture}

### Core Components

#### 1. Prometheus Server
- Scrapes and stores time series data
- Evaluates alert rules
- Serves queries via HTTP API

#### 2. Client Libraries
- Instrument application code
- Available for Go, Java, Python, Ruby, and more
- Expose metrics in Prometheus format

#### 3. Pushgateway
- For short-lived jobs that can't be scraped
- Batch jobs push metrics to Pushgateway
- Prometheus scrapes from Pushgateway

#### 4. Exporters
- Bridge between Prometheus and third-party systems
- Examples: Node Exporter, MySQL Exporter, Blackbox Exporter

#### 5. Alertmanager
- Handles alerts sent by Prometheus
- Deduplication, grouping, routing
- Notifications via email, Slack, PagerDuty, etc.

### Architecture Diagram (Conceptual)

```
┌─────────────────────────────────────────────────────────┐
│                    Prometheus Server                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Retrieval   │  │   Storage    │  │   HTTP API   │  │
│  │   (Scrape)   │──│   (TSDB)     │──│   (PromQL)   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
           │                    │                │
           │ scrape            │ alerts         │ queries
           ▼                    ▼                ▼
    ┌──────────┐        ┌──────────┐    ┌──────────┐
    │ Exporters│        │  Alert   │    │ Grafana  │
    │ Services │        │ Manager  │    │   UI     │
    └──────────┘        └──────────┘    └──────────┘
```

---

## Installation and Setup {#installation}

### Installing Prometheus on Linux

#### Method 1: Binary Installation

```bash
# Download the latest version
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz

# Extract
tar xvfz prometheus-*.tar.gz
cd prometheus-*

# Run Prometheus
./prometheus --config.file=prometheus.yml
```

#### Method 2: Docker Installation

```bash
# Run Prometheus in Docker
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus
```

#### Method 3: Kubernetes Installation (using Helm)

```bash
# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --create-namespace
```

### Installing Node Exporter

```bash
# Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz

# Extract and run
tar xvfz node_exporter-*.tar.gz
cd node_exporter-*
./node_exporter
```

### Verifying Installation

Access the Prometheus web UI at `http://localhost:9090`

Check targets at `http://localhost:9090/targets`

---

## Configuration {#configuration}

### Basic prometheus.yml

```yaml
# Global configuration
global:
  scrape_interval: 15s      # How often to scrape targets
  evaluation_interval: 15s  # How often to evaluate rules
  external_labels:
    cluster: 'production'
    region: 'us-east-1'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - 'localhost:9093'

# Rule files
rule_files:
  - 'alerts/*.yml'
  - 'recording_rules/*.yml'

# Scrape configurations
scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
        labels:
          env: 'production'
          role: 'webserver'

  # Application metrics
  - job_name: 'myapp'
    scrape_interval: 5s
    static_configs:
      - targets: ['app1:8080', 'app2:8080']
```

### Service Discovery

#### File-based Service Discovery

```yaml
scrape_configs:
  - job_name: 'file_sd'
    file_sd_configs:
      - files:
          - 'targets/*.json'
        refresh_interval: 30s
```

Example target file (`targets/web-servers.json`):
```json
[
  {
    "targets": ["server1:9100", "server2:9100"],
    "labels": {
      "job": "node",
      "env": "production"
    }
  }
]
```

#### Kubernetes Service Discovery

```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
```

---

## Metrics and Data Model {#metrics}

### Metric Types

#### 1. Counter
Cumulative metric that only increases (or resets to zero).

**Use cases**: Request counts, error counts, task completions

```go
// Go example
requestsTotal := prometheus.NewCounter(prometheus.CounterOpts{
    Name: "http_requests_total",
    Help: "Total number of HTTP requests",
})
requestsTotal.Inc()
```

#### 2. Gauge
Metric that can go up or down.

**Use cases**: Memory usage, temperature, concurrent requests

```go
cpuTemp := prometheus.NewGauge(prometheus.GaugeOpts{
    Name: "cpu_temperature_celsius",
    Help: "Current CPU temperature",
})
cpuTemp.Set(65.5)
```

#### 3. Histogram
Samples observations and counts them in configurable buckets.

**Use cases**: Request durations, response sizes

```go
requestDuration := prometheus.NewHistogram(prometheus.HistogramOpts{
    Name:    "http_request_duration_seconds",
    Help:    "HTTP request duration",
    Buckets: prometheus.DefBuckets,
})
timer := prometheus.NewTimer(requestDuration)
// ... handle request ...
timer.ObserveDuration()
```

#### 4. Summary
Similar to histogram but calculates quantiles on the client side.

**Use cases**: Request latencies, response sizes (when you need exact quantiles)

```go
requestDuration := prometheus.NewSummary(prometheus.SummaryOpts{
    Name:       "http_request_duration_seconds",
    Help:       "HTTP request duration",
    Objectives: map[float64]float64{0.5: 0.05, 0.9: 0.01, 0.99: 0.001},
})
```

### Label Best Practices

**Good labels** (low cardinality):
```
http_requests_total{method="GET", status="200", endpoint="/api/users"}
```

**Bad labels** (high cardinality - avoid):
```
http_requests_total{user_id="12345", timestamp="1234567890"}
```

### Naming Conventions

- Use snake_case: `http_requests_total`
- Add unit suffix: `_seconds`, `_bytes`, `_total`
- Counter metrics should end with `_total`
- Base unit usage: seconds (not milliseconds), bytes (not kilobytes)

---

## PromQL - Query Language {#promql}

### Basic Queries

#### Instant Vector Selectors

```promql
# Select all time series with a metric name
http_requests_total

# Filter by labels
http_requests_total{job="api-server", status="200"}

# Regular expressions
http_requests_total{status=~"2.."}

# Negative matching
http_requests_total{status!="200"}
```

#### Range Vector Selectors

```promql
# Last 5 minutes of data
http_requests_total[5m]

# Last hour
http_requests_total[1h]
```

### Operators and Functions

#### Arithmetic Operators

```promql
# Addition
node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes

# Division (calculate percentage)
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))

# Multiplication
rate(http_requests_total[5m]) * 60
```

#### Comparison Operators

```promql
# Greater than
up == 1

# Not equal
http_requests_total != 0
```

#### Aggregation Operators

```promql
# Sum across all instances
sum(rate(http_requests_total[5m]))

# Average by job
avg by (job)(node_cpu_seconds_total)

# Count instances
count(up == 1)

# Max value
max(node_memory_MemAvailable_bytes)

# Top 5 by value
topk(5, rate(http_requests_total[5m]))

# Bottom 3
bottomk(3, node_filesystem_avail_bytes)
```

### Essential Functions

#### rate() and irate()

```promql
# Average rate over 5 minutes (for counters)
rate(http_requests_total[5m])

# Instant rate (last 2 data points)
irate(http_requests_total[5m])
```

#### increase()

```promql
# Total increase over 1 hour
increase(http_requests_total[1h])
```

#### histogram_quantile()

```promql
# 95th percentile latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# 50th percentile (median)
histogram_quantile(0.5, rate(http_request_duration_seconds_bucket[5m]))
```

#### predict_linear()

```promql
# Predict disk full in 4 hours
predict_linear(node_filesystem_avail_bytes[1h], 4*3600) < 0
```

#### delta() and deriv()

```promql
# Delta over range
delta(cpu_temp_celsius[1h])

# Derivative (per second change)
deriv(node_filesystem_avail_bytes[1h])
```

### Advanced Query Examples

#### Request Rate and Error Rate

```promql
# Request rate
sum(rate(http_requests_total[5m])) by (endpoint)

# Error rate
sum(rate(http_requests_total{status=~"5.."}[5m])) 
/ 
sum(rate(http_requests_total[5m]))
```

#### Memory Usage Percentage

```promql
100 * (1 - (
  node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes
))
```

#### CPU Usage by Core

```promql
100 - (avg by (instance, cpu) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

#### Disk Usage Forecast

```promql
(
  node_filesystem_avail_bytes{mountpoint="/"} 
  / 
  node_filesystem_size_bytes{mountpoint="/"}
) < 0.1
and
predict_linear(node_filesystem_avail_bytes{mountpoint="/"}[1h], 4*3600) < 0
```

---

## Exporters and Instrumentation {#exporters}

### Popular Exporters

#### Node Exporter (System Metrics)

Exposes hardware and OS metrics from Linux systems.

**Installation**:
```bash
./node_exporter --collector.systemd --collector.processes
```

**Key Metrics**:
- `node_cpu_seconds_total`
- `node_memory_MemAvailable_bytes`
- `node_filesystem_avail_bytes`
- `node_network_receive_bytes_total`
- `node_disk_io_time_seconds_total`

#### Blackbox Exporter (Probing)

Probes endpoints over HTTP, HTTPS, DNS, TCP, and ICMP.

**Configuration** (`blackbox.yml`):
```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET
      preferred_ip_protocol: "ip4"
```

**Prometheus config**:
```yaml
scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
          - https://example.com
          - https://api.example.com/health
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115
```

#### MySQL Exporter

**Installation**:
```bash
docker run -d \
  -p 9104:9104 \
  -e DATA_SOURCE_NAME="user:password@(hostname:3306)/" \
  prom/mysqld-exporter
```

**Key Metrics**:
- `mysql_global_status_threads_connected`
- `mysql_global_status_queries`
- `mysql_global_status_slow_queries`

### Application Instrumentation

#### Python Flask Example

```python
from prometheus_client import Counter, Histogram, generate_latest
from flask import Flask, Response
import time

app = Flask(__name__)

# Define metrics
REQUEST_COUNT = Counter(
    'http_requests_total', 
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency',
    ['endpoint']
)

@app.route('/api/users')
@REQUEST_LATENCY.labels(endpoint='/api/users').time()
def get_users():
    REQUEST_COUNT.labels(method='GET', endpoint='/api/users', status=200).inc()
    return {"users": []}

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

#### Go Example

```go
package main

import (
    "net/http"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    httpRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
        []string{"method", "endpoint", "status"},
    )
    
    httpRequestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "HTTP request duration",
            Buckets: prometheus.DefBuckets,
        },
        []string{"endpoint"},
    )
)

func init() {
    prometheus.MustRegister(httpRequestsTotal)
    prometheus.MustRegister(httpRequestDuration)
}

func handler(w http.ResponseWriter, r *http.Request) {
    timer := prometheus.NewTimer(httpRequestDuration.WithLabelValues(r.URL.Path))
    defer timer.ObserveDuration()
    
    // Handle request
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("Hello"))
    
    httpRequestsTotal.WithLabelValues(r.Method, r.URL.Path, "200").Inc()
}

func main() {
    http.HandleFunc("/", handler)
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":8080", nil)
}
```

---

## Alerting {#alerting}

### Alert Rules

Create alert rules in `alerts.yml`:

```yaml
groups:
  - name: example_alerts
    interval: 30s
    rules:
      # High CPU usage
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% (current value: {{ $value }}%)"

      # Instance down
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
          team: sre
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute."

      # High memory usage
      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is above 90% (current: {{ $value | humanize }}%)"

      # Disk space low
      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100 < 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Low disk space on {{ $labels.instance }}"
          description: "Disk space is below 10% (current: {{ $value | humanize }}%)"

      # High error rate
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m])) 
          / 
          sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} (threshold: 5%)"

      # API response time
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High API latency detected"
          description: "95th percentile latency is {{ $value }}s (threshold: 1s)"
```

### Recording Rules

Pre-compute expensive queries:

```yaml
groups:
  - name: recording_rules
    interval: 30s
    rules:
      # Pre-calculate request rate
      - record: job:http_requests:rate5m
        expr: sum(rate(http_requests_total[5m])) by (job)

      # Pre-calculate error rate
      - record: job:http_requests:error_rate5m
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m])) by (job)
          /
          sum(rate(http_requests_total[5m])) by (job)

      # Pre-calculate instance CPU usage
      - record: instance:node_cpu:usage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

      # Pre-calculate memory usage percentage
      - record: instance:node_memory:usage_percent
        expr: 100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```

### Alertmanager Configuration

`alertmanager.yml`:

```yaml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'default'
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true
    
    - match:
        severity: warning
      receiver: 'slack'
    
    - match:
        team: database
      receiver: 'database-team'

receivers:
  - name: 'default'
    email_configs:
      - to: 'team@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alerts@example.com'
        auth_password: 'password'

  - name: 'slack'
    slack_configs:
      - channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_KEY'

  - name: 'database-team'
    email_configs:
      - to: 'dba-team@example.com'

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']
```

---

## Best Practices {#best-practices}

### 1. Metric Design

- **Use appropriate metric types** for your use case
- **Keep label cardinality low** (avoid user IDs, timestamps as labels)
- **Follow naming conventions** consistently
- **Use base units** (seconds, bytes, not milliseconds, kilobytes)

### 2. Query Optimization

- **Use recording rules** for expensive queries
- **Limit time ranges** in dashboards
- **Use `rate()` instead of `irate()`** for alerting (more stable)
- **Aggregate before arithmetic** operations when possible

### 3. Storage and Retention

```yaml
# Prometheus configuration
storage:
  tsdb:
    path: /prometheus
    retention.time: 15d
    retention.size: 50GB
```

### 4. High Availability

- Run multiple Prometheus instances with identical configurations
- Use Thanos or Cortex for long-term storage and global view
- Implement Alertmanager clustering for alert deduplication

### 5. Security

```yaml
# Enable basic auth
basic_auth_users:
  admin: $2y$10$hashed_password

# TLS configuration
tls_server_config:
  cert_file: /path/to/cert.pem
  key_file: /path/to/key.pem
```

### 6. Monitoring Prometheus

Monitor your monitoring system:

```yaml
# Self-monitoring queries
up{job="prometheus"}
rate(prometheus_tsdb_head_samples_appended_total[5m])
prometheus_tsdb_storage_blocks_bytes
rate(prometheus_http_requests_total[5m])
```

---

## Real-World Examples {#examples}

### Complete Monitoring Stack Setup

#### Docker Compose Configuration

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./alerts:/etc/prometheus/alerts
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    restart: unless-stopped
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager_data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    restart: unless-stopped

volumes:
  prometheus_data:
  alertmanager_data:
  grafana_data:
```

### Kubernetes Monitoring Example

```yaml
# ServiceMonitor for automatic scraping
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
    - port: metrics
      interval: 30s
      path: /metrics
```

### Application Dashboard Queries

```promql
# Request rate by endpoint
sum(rate(http_requests_total[5m])) by (endpoint)

# Error rate percentage
100 * (
  sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
  sum(rate(http_requests_total[5m]))
)

# P95 latency
histogram_quantile(0.95, 
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le, endpoint)
)

# Request duration heatmap
sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
```

---

## Conclusion

Prometheus is a powerful monitoring solution that excels in cloud-native environments. Its pull-based model, dimensional data model, and powerful query language make it ideal for modern infrastructure monitoring.

### Key Takeaways

1. Start with Node Exporter for system metrics
2. Instrument your applications early
3. Design metrics with appropriate types and low cardinality
4. Use PromQL effectively for insights
5. Implement meaningful alerts (avoid alert fatigue)
6. Leverage Grafana for visualization
7. Plan for high availability and long-term storage

### Further Resources

- Official Documentation: https://prometheus.io/docs/
- PromQL Basics: https://prometheus.io/docs/prometheus/latest/querying/basics/
- Best Practices: https://prometheus.io/docs/practices/
- Awesome Prometheus: https://github.com/roaldnefs/awesome-prometheus

---

**Tags**: #devops #monitoring #prometheus #observability #metrics #alerting