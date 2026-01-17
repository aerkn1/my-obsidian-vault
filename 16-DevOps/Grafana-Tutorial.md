# Grafana Tutorial: Complete Guide to Data Visualization and Dashboarding

## Table of Contents
1. [Introduction to Grafana](#introduction)
2. [Installation and Setup](#installation)
3. [Data Sources](#datasources)
4. [Building Dashboards](#dashboards)
5. [Visualization Types](#visualizations)
6. [Variables and Templating](#variables)
7. [Alerting](#alerting)
8. [User Management and Teams](#users)
9. [Provisioning and Configuration as Code](#provisioning)
10. [Best Practices](#best-practices)
11. [Real-World Examples](#examples)

---

## Introduction to Grafana {#introduction}

### What is Grafana?

Grafana is an open-source analytics and interactive visualization platform. It provides charts, graphs, and alerts when connected to supported data sources. It's widely used for monitoring infrastructure, applications, and business metrics.

### Key Features

- **Multi-datasource support**: Prometheus, InfluxDB, Elasticsearch, MySQL, PostgreSQL, and more
- **Rich visualization library**: Graphs, heatmaps, histograms, geo maps, and more
- **Dashboard templating**: Create reusable, dynamic dashboards
- **Alerting**: Native alert engine with multiple notification channels
- **Plugin ecosystem**: Extend functionality with community and custom plugins
- **Organization & teams**: Multi-tenant architecture with role-based access
- **Annotations**: Mark points in time on graphs with events

### Use Cases

- Infrastructure monitoring dashboards
- Application performance monitoring (APM)
- Business intelligence and analytics
- IoT device monitoring
- Log analytics visualization
- Real-time data streaming

---

## Installation and Setup {#installation}

### Installing Grafana on Linux

#### Method 1: Using APT (Debian/Ubuntu)

```bash
# Add GPG key
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update and install
sudo apt-get update
sudo apt-get install grafana

# Start service
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

#### Method 2: Using YUM (RHEL/CentOS)

```bash
# Create repo file
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

# Install
sudo yum install grafana

# Start service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

#### Method 3: Docker Installation

```bash
# Run Grafana in Docker
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana-oss:latest

# With custom config
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  -v $(pwd)/grafana.ini:/etc/grafana/grafana.ini \
  -e "GF_SECURITY_ADMIN_PASSWORD=secret" \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel" \
  grafana/grafana-oss:latest
```

#### Method 4: Kubernetes with Helm

```bash
# Add Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm install grafana grafana/grafana \
  --namespace monitoring \
  --create-namespace \
  --set persistence.enabled=true \
  --set persistence.size=10Gi \
  --set adminPassword=admin

# Get admin password
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

### Initial Configuration

**Default Access:**
- URL: `http://localhost:3000`
- Default username: `admin`
- Default password: `admin` (you'll be prompted to change it)

**Configuration File Location:**
- Linux: `/etc/grafana/grafana.ini`
- Docker: `/etc/grafana/grafana.ini`

---

## Data Sources {#datasources}

### Adding a Prometheus Data Source

#### Via UI

1. Navigate to **Configuration** → **Data Sources**
2. Click **Add data source**
3. Select **Prometheus**
4. Configure:
   - **Name**: Prometheus
   - **URL**: `http://prometheus:9090` (or your Prometheus URL)
   - **Access**: Server (default) or Browser
5. Click **Save & Test**

#### Via Configuration File

Create `/etc/grafana/provisioning/datasources/prometheus.yml`:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    jsonData:
      timeInterval: 15s
      queryTimeout: 60s
      httpMethod: POST
    editable: true
```

### Common Data Sources Configuration

#### InfluxDB

```yaml
apiVersion: 1

datasources:
  - name: InfluxDB
    type: influxdb
    access: proxy
    url: http://influxdb:8086
    database: telegraf
    jsonData:
      httpMode: GET
      timeInterval: 30s
    secureJsonData:
      token: your-influxdb-token
```

#### Loki (for Logs)

```yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    jsonData:
      maxLines: 1000
```

#### MySQL

```yaml
apiVersion: 1

datasources:
  - name: MySQL
    type: mysql
    url: mysql-server:3306
    database: myapp
    user: grafana
    secureJsonData:
      password: 'secure_password'
    jsonData:
      maxOpenConns: 100
      maxIdleConns: 100
      connMaxLifetime: 14400
```

#### Elasticsearch

```yaml
apiVersion: 1

datasources:
  - name: Elasticsearch
    type: elasticsearch
    access: proxy
    url: http://elasticsearch:9200
    database: "[logs-]YYYY.MM.DD"
    jsonData:
      interval: Daily
      timeField: "@timestamp"
      esVersion: "8.0.0"
      logMessageField: message
      logLevelField: level
```

---

## Building Dashboards {#dashboards}

### Creating Your First Dashboard

#### Step 1: Create a New Dashboard

1. Click **+** icon → **Dashboard**
2. Click **Add new panel**

#### Step 2: Configure Query

**Example: System CPU Usage**

```promql
# Query
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Panel Settings:**
- **Title**: CPU Usage
- **Description**: Current CPU usage percentage
- **Unit**: Percent (0-100)
- **Min**: 0
- **Max**: 100

#### Step 3: Choose Visualization

Select visualization type:
- **Time series** for trends over time
- **Stat** for single value
- **Gauge** for threshold visualization
- **Bar chart** for comparisons

#### Step 4: Apply and Save

Click **Apply** → **Save dashboard** → Name it and save

### Dashboard Organization

#### Row Structure

```json
{
  "title": "System Overview",
  "panels": [
    {
      "type": "row",
      "title": "CPU Metrics",
      "collapsed": false
    },
    {
      "type": "graph",
      "title": "CPU Usage",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0}
    },
    {
      "type": "graph",
      "title": "CPU Load",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0}
    }
  ]
}
```

### Panel Settings

#### General Settings

```yaml
Title: API Request Rate
Description: Requests per second across all endpoints
Transparent: false
Links:
  - title: Runbook
    url: https://wiki.example.com/runbooks/api
```

#### Display Options

- **Draw Modes**: Lines, bars, points
- **Stack**: None, normal, percent
- **Line interpolation**: Linear, smooth, step
- **Fill opacity**: 0-100%
- **Point size**: 1-10

---

## Visualization Types {#visualizations}

### 1. Time Series

Best for displaying metrics over time.

**Query Example:**
```promql
rate(http_requests_total[5m])
```

**Settings:**
- **Legend**: Show as table, to right, to bottom
- **Tooltip**: All series, single
- **Axes**: Left Y-axis, right Y-axis
- **Thresholds**: Add colored threshold lines

### 2. Stat Panel

Display single value with optional sparkline.

**Query Example:**
```promql
sum(up == 1)
```

**Settings:**
- **Value**: Last, first, min, max, mean
- **Graph mode**: None, area
- **Text mode**: Value, name, value and name
- **Color mode**: Value, background

### 3. Gauge

Circular or horizontal gauge for threshold visualization.

**Query Example:**
```promql
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```

**Settings:**
- **Min**: 0
- **Max**: 100
- **Thresholds**:
  - 0-60: Green
  - 60-80: Yellow
  - 80-100: Red

### 4. Bar Chart

Compare values across categories.

**Query Example:**
```promql
topk(10, sum by (endpoint) (rate(http_requests_total[5m])))
```

### 5. Heatmap

Show distribution of values over time.

**Query Example:**
```promql
sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
```

**Settings:**
- **Data format**: Time series buckets
- **Y-Axis**: Logarithmic scale
- **Color scheme**: Spectrum, opacity

### 6. Table

Display data in tabular format.

**Query Example:**
```promql
node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} * 100
```

**Transformations:**
- **Organize fields**: Rename, reorder, hide columns
- **Filter by value**: Show only specific ranges
- **Sort by**: Any column, ascending/descending

### 7. Pie Chart

Show proportional data.

**Query Example:**
```promql
sum by (status) (rate(http_requests_total[5m]))
```

### 8. State Timeline

Show state changes over time.

**Query Example:**
```promql
up{job="api-server"}
```

---

## Variables and Templating {#variables}

### Variable Types

#### 1. Query Variable

Dynamically populated from data source.

**Configuration:**
- **Name**: `instance`
- **Type**: Query
- **Data source**: Prometheus
- **Query**: `label_values(up, instance)`
- **Regex**: `/^(.*):.*/` (extract hostname)
- **Multi-value**: Enabled
- **Include All option**: Enabled

**Usage in Panel:**
```promql
node_cpu_seconds_total{instance=~"$instance"}
```

#### 2. Custom Variable

Manually defined values.

**Configuration:**
- **Name**: `environment`
- **Type**: Custom
- **Values**: `production,staging,development`
- **Multi-value**: Disabled

#### 3. Interval Variable

Time interval selection.

**Configuration:**
- **Name**: `interval`
- **Type**: Interval
- **Values**: `30s,1m,5m,10m,30m,1h`
- **Auto option**: Enabled

**Usage:**
```promql
rate(http_requests_total[$interval])
```

#### 4. Data Source Variable

Switch between data sources.

**Configuration:**
- **Name**: `datasource`
- **Type**: Datasource
- **Type**: Prometheus

### Advanced Variable Examples

#### Chained Variables

```yaml
# Variable 1: Region
Name: region
Query: label_values(up, region)

# Variable 2: Cluster (depends on region)
Name: cluster
Query: label_values(up{region="$region"}, cluster)

# Variable 3: Instance (depends on cluster)
Name: instance
Query: label_values(up{region="$region", cluster="$cluster"}, instance)
```

#### Ad-hoc Filters

Configure in data source settings:
```yaml
jsonData:
  adhocFilters: true
```

Allows users to add filters dynamically without editing dashboard.

---

## Alerting {#alerting}

### Grafana Alerting (Unified Alerting)

#### Creating an Alert Rule

**Example: High CPU Alert**

```yaml
# Alert Rule Configuration
Name: High CPU Usage
Type: Grafana managed alert

# Query
Query A: 
  Data source: Prometheus
  Query: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Conditions
Condition: 
  - WHEN avg() OF query(A, 5m, now) IS ABOVE 80

# Alert evaluation
Evaluate every: 1m
For: 5m

# Labels
Severity: warning
Team: infrastructure

# Annotations
Summary: CPU usage is {{ $value }}% on {{ $labels.instance }}
Description: CPU has been above 80% for more than 5 minutes
Runbook: https://wiki.example.com/runbooks/high-cpu
```

#### Contact Points

Configure notification channels:

##### Slack

```yaml
Name: Slack Alerts
Type: Slack
Webhook URL: https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
Username: Grafana
Recipient: #alerts
Title: {{ .CommonLabels.alertname }}
Text: {{ range .Alerts }}{{ .Annotations.description }}{{ end }}
```

##### Email

```yaml
Name: Email Alerts
Type: Email
Addresses: team@example.com, oncall@example.com
Single email: false (send per alert)
Subject: [{{ .Status }}] {{ .CommonLabels.alertname }}
```

##### PagerDuty

```yaml
Name: PagerDuty
Type: PagerDuty
Integration Key: YOUR_INTEGRATION_KEY
Severity: critical
Client: Grafana
```

##### Webhook

```yaml
Name: Custom Webhook
Type: Webhook
URL: https://api.example.com/webhooks/alerts
HTTP Method: POST
Authorization header: Bearer YOUR_TOKEN
```

#### Notification Policies

```yaml
# Default policy
Root notification policy:
  Group by: [alertname, cluster]
  Group wait: 30s
  Group interval: 5m
  Repeat interval: 4h
  Receiver: default-email

# Specific policies
Routes:
  - Match:
      severity: critical
    Receiver: pagerduty
    Continue: true
    
  - Match:
      team: database
    Receiver: database-team
    Group by: [alertname]
    
  - Match:
      severity: warning
    Receiver: slack-warnings
```

#### Silences

Temporarily mute alerts:

```yaml
# Create silence
Start: 2024-01-15 14:00
End: 2024-01-15 16:00
Matchers:
  - alertname = HighCPUUsage
  - instance =~ server-.*
Comment: Maintenance window for server upgrades
Created by: admin@example.com
```

---

## User Management and Teams {#users}

### User Roles

#### Organization Roles

1. **Viewer**: Can only view dashboards
2. **Editor**: Can create and edit dashboards
3. **Admin**: Full administrative access

#### Folder Permissions

```yaml
# Example folder permissions
Folder: Production Dashboards
Permissions:
  - Team: SRE Team → Editor
  - Team: Dev Team → Viewer
  - User: john@example.com → Admin
```

### Creating Teams

```yaml
# Team Configuration
Name: Backend Team
Email: backend@example.com
Members:
  - alice@example.com (Editor)
  - bob@example.com (Editor)
  - charlie@example.com (Viewer)

Permissions:
  - Folder: Backend Services → Editor
  - Dashboard: API Monitoring → Editor
```

### Authentication

#### LDAP Configuration

Edit `/etc/grafana/grafana.ini`:

```ini
[auth.ldap]
enabled = true
config_file = /etc/grafana/ldap.toml
allow_sign_up = true
```

Create `/etc/grafana/ldap.toml`:

```toml
[[servers]]
host = "ldap.example.com"
port = 389
use_ssl = false
start_tls = true
bind_dn = "cn=admin,dc=example,dc=com"
bind_password = "password"
search_filter = "(cn=%s)"
search_base_dns = ["dc=example,dc=com"]

[servers.attributes]
name = "givenName"
surname = "sn"
username = "cn"
member_of = "memberOf"
email = "mail"

[[servers.group_mappings]]
group_dn = "cn=admins,ou=groups,dc=example,dc=com"
org_role = "Admin"

[[servers.group_mappings]]
group_dn = "cn=developers,ou=groups,dc=example,dc=com"
org_role = "Editor"
```

#### OAuth (Google)

```ini
[auth.google]
enabled = true
client_id = YOUR_CLIENT_ID
client_secret = YOUR_CLIENT_SECRET
scopes = https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email
auth_url = https://accounts.google.com/o/oauth2/auth
token_url = https://accounts.google.com/o/oauth2/token
allowed_domains = example.com
allow_sign_up = true
```

---

## Provisioning and Configuration as Code {#provisioning}

### Dashboard Provisioning

Create `/etc/grafana/provisioning/dashboards/default.yml`:

```yaml
apiVersion: 1

providers:
  - name: 'Default'
    orgId: 1
    folder: 'General'
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
      foldersFromFilesStructure: true
```

### Dashboard JSON Export

Export dashboard as JSON and place in provisioning directory:

```json
{
  "dashboard": {
    "title": "Node Exporter Full",
    "uid": "node-exporter",
    "tags": ["prometheus", "node-exporter"],
    "timezone": "browser",
    "panels": [
      {
        "title": "CPU Usage",
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{ instance }}"
          }
        ]
      }
    ]
  },
  "overwrite": true
}
```

### Terraform Provider

```hcl
# Configure Grafana provider
provider "grafana" {
  url  = "http://grafana.example.com"
  auth = "admin:admin"
}

# Create folder
resource "grafana_folder" "monitoring" {
  title = "Monitoring"
}

# Create dashboard
resource "grafana_dashboard" "metrics" {
  folder      = grafana_folder.monitoring.id
  config_json = file("${path.module}/dashboards/metrics.json")
}

# Create data source
resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "Prometheus"
  url  = "http://prometheus:9090"

  json_data {
    http_method     = "POST"
    query_timeout   = "60"
  }
}

# Create alert rule
resource "grafana_rule_group" "alerts" {
  name             = "instance_alerts"
  folder_uid       = grafana_folder.monitoring.uid
  interval_seconds = 60
  org_id          = 1

  rule {
    name      = "InstanceDown"
    condition = "A"
    
    data {
      ref_id = "A"
      
      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = grafana_data_source.prometheus.uid
      
      model = jsonencode({
        expr = "up == 0"
      })
    }

    for = "5m"

    annotations = {
      summary = "Instance {{ $labels.instance }} is down"
    }

    labels = {
      severity = "critical"
    }
  }
}
```

---

## Best Practices {#best-practices}

### 1. Dashboard Design

#### Keep It Simple
- **One dashboard, one purpose**: Avoid kitchen-sink dashboards
- **Logical grouping**: Use rows to organize related panels
- **Consistent naming**: Follow naming conventions
- **Limit panels**: 10-15 panels per dashboard maximum

#### Visual Hierarchy
```
[Big Number Stats - Most Important KPIs]
[Time Series Graphs - Detailed Trends]
[Tables - Supporting Data]
```

#### Color Usage
- **Green**: Good, normal, success
- **Yellow**: Warning, attention needed
- **Red**: Critical, error, danger
- **Blue/Purple**: Informational

### 2. Query Optimization

#### Use Variables
```promql
# Instead of hardcoding
rate(http_requests_total{instance="server1"}[5m])

# Use variables
rate(http_requests_total{instance="$instance"}[$interval])
```

#### Limit Time Ranges
- Set reasonable default time ranges (last 6h, not last 30d)
- Use relative time ranges
- Implement refresh intervals appropriately

#### Recording Rules
For expensive queries, use Prometheus recording rules:
```yaml
# In Prometheus
- record: job:http_requests:rate5m
  expr: sum(rate(http_requests_total[5m])) by (job)
```

Then in Grafana:
```promql
job:http_requests:rate5m{job="api"}
```

### 3. Documentation

#### Panel Descriptions
Always add descriptions to panels:
```
This panel shows the 95th percentile response time for API endpoints.
A value above 1s indicates degraded performance.
```

#### Dashboard Variables
Document what each variable does:
```
$environment: Production, Staging, or Development environment
$interval: Time range for rate calculations (default: 5m)
```

#### Links to Runbooks
Add links in panel descriptions or dashboard annotations:
```markdown
[Troubleshooting Guide](https://wiki.example.com/runbooks/api-performance)
[Escalation Process](https://wiki.example.com/oncall)
```

### 4. Alerting Best Practices

#### Alert Naming
- Use clear, actionable names
- Include severity in the name
- Example: `Critical: API Response Time High`

#### Alert Descriptions
```
Summary: API response time is {{ $value }}ms (threshold: 1000ms)
Impact: User experience is degraded
Action: Check application logs and database performance
Runbook: https://wiki.example.com/runbooks/high-latency
```

#### Reduce Alert Fatigue
- Set appropriate thresholds
- Use `for` duration to avoid flapping
- Implement proper grouping and silences
- Regular review and tuning

### 5. Organization

#### Folder Structure
```
├── Infrastructure
│   ├── Kubernetes Cluster
│   ├── Linux Systems
│   └── Network
├── Applications
│   ├── API Services
│   ├── Frontend
│   └── Background Jobs
├── Business Metrics
│   ├── Sales Dashboard
│   └── User Analytics
└── SLO Tracking
    └── Service Level Objectives
```

#### Naming Conventions
- **Dashboards**: `[Category] - [Specific Topic]`
  - Example: `Infrastructure - Kubernetes Cluster Overview`
- **Panels**: Clear, concise titles
  - Good: `CPU Usage`
  - Bad: `cpu_usage_graph_1`

---

## Real-World Examples {#examples}

### 1. Complete Node Exporter Dashboard

```json
{
  "title": "Node Exporter Full",
  "tags": ["linux", "node-exporter"],
  "timezone": "browser",
  "templating": {
    "list": [
      {
        "name": "instance",
        "type": "query",
        "datasource": "Prometheus",
        "query": "label_values(node_uname_info, instance)",
        "multi": true,
        "includeAll": true
      }
    ]
  },
  "panels": [
    {
      "title": "CPU Usage",
      "type": "timeseries",
      "datasource": "Prometheus",
      "targets": [
        {
          "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\",instance=~\"$instance\"}[5m])) * 100)",
          "legendFormat": "{{ instance }}"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "min": 0,
          "max": 100,
          "thresholds": {
            "steps": [
              {"value": 0, "color": "green"},
              {"value": 70, "color": "yellow"},
              {"value": 90, "color": "red"}
            ]
          }
        }
      }
    },
    {
      "title": "Memory Usage",
      "type": "timeseries",
      "datasource": "Prometheus",
      "targets": [
        {
          "expr": "100 * (1 - (node_memory_MemAvailable_bytes{instance=~\"$instance\"} / node_memory_MemTotal_bytes{instance=~\"$instance\"}))",
          "legendFormat": "{{ instance }}"
        }
      ]
    },
    {
      "title": "Disk Usage",
      "type": "gauge",
      "datasource": "Prometheus",
      "targets": [
        {
          "expr": "100 - ((node_filesystem_avail_bytes{instance=~\"$instance\",mountpoint=\"/\"} * 100) / node_filesystem_size_bytes{instance=~\"$instance\",mountpoint=\"/\"})",
          "legendFormat": "{{ instance }}"
        }
      ]
    },
    {
      "title": "Network Traffic",
      "type": "timeseries",
      "datasource": "Prometheus",
      "targets": [
        {
          "expr": "rate(node_network_receive_bytes_total{instance=~\"$instance\",device!~\"lo\"}[5m])",
          "legendFormat": "{{ instance }} - {{ device }} IN"
        },
        {
          "expr": "rate(node_network_transmit_bytes_total{instance=~\"$instance\",device!~\"lo\"}[5m])",
          "legendFormat": "{{ instance }} - {{ device }} OUT"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "Bps"
        }
      }
    }
  ]
}
```

### 2. Application Performance Dashboard

```json
{
  "title": "API Performance Monitoring",
  "panels": [
    {
      "title": "Request Rate",
      "type": "stat",
      "targets": [
        {
          "expr": "sum(rate(http_requests_total[5m]))"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "reqps"
        }
      }
    },
    {
      "title": "Error Rate",
      "type": "stat",
      "targets": [
        {
          "expr": "100 * sum(rate(http_requests_total{status=~\"5..\"}[5m])) / sum(rate(http_requests_total[5m]))"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "thresholds": {
            "steps": [
              {"value": 0, "color": "green"},
              {"value": 1, "color": "yellow"},
              {"value": 5, "color": "red"}
            ]
          }
        }
      }
    },
    {
      "title": "P95 Latency",
      "type": "timeseries",
      "targets": [
        {
          "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, endpoint))",
          "legendFormat": "{{ endpoint }}"
        }
      ]
    },
    {
      "title": "Top Endpoints by Request Count",
      "type": "barchart",
      "targets": [
        {
          "expr": "topk(10, sum by (endpoint) (rate(http_requests_total[5m])))"
        }
      ]
    }
  ]
}
```

### 3. Docker Compose Stack

```yaml
version: '3.8'

services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel
      - GF_SERVER_ROOT_URL=http://localhost:3000
    volumes:
      - grafana-storage:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards
    restart: unless-stopped

volumes:
  grafana-storage:
```

---

## Conclusion

Grafana is the industry-standard visualization and dashboarding tool for modern observability stacks. Its flexibility, extensive data source support, and rich visualization library make it indispensable for monitoring.

### Key Takeaways

1. Start with pre-built dashboards from Grafana Labs
2. Use variables for dynamic, reusable dashboards
3. Implement meaningful alerts with proper notifications
4. Organize dashboards logically with folders and tags
5. Leverage provisioning for infrastructure-as-code
6. Follow design best practices for clarity
7. Document dashboards and panels thoroughly

### Further Resources

- Official Documentation: https://grafana.com/docs/
- Grafana Labs: https://grafana.com/grafana/dashboards
- Community Forums: https://community.grafana.com/
- Grafana Tutorials: https://grafana.com/tutorials/

---

**Tags**: #devops #grafana #visualization #monitoring #observability #dashboards #alerting