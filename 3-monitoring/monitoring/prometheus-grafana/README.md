# Prometheus + Grafana Monitoring Stack

The most popular modern monitoring solution combining Prometheus (metrics collection) with Grafana (visualization).

## 🚀 Quick Start

### Using Docker Compose

```bash
# Start the stack
docker-compose up -d

# Access the services
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
# Alertmanager: http://localhost:9093
# Node Exporter metrics: http://localhost:9100/metrics
```

### Stop the Stack
```bash
docker-compose down

# Remove volumes (data will be lost)
docker-compose down -v
```

## 📦 Included Services

- **Prometheus** - Time-series database and metrics collector
- **Grafana** - Visualization and dashboarding
- **Alertmanager** - Alert handling and routing
- **Node Exporter** - System metrics exporter
- **cAdvisor** - Container metrics exporter
- **Blackbox Exporter** - HTTP/DNS/TCP/ICMP probes

## 📁 Files Structure

```
prometheus-grafana/
├── docker-compose.yml          # Main compose file
├── prometheus/
│   ├── prometheus.yml          # Prometheus configuration
│   ├── alerts.yml              # Alert rules
│   └── recording-rules.yml     # Recording rules
├── alertmanager/
│   └── alertmanager.yml        # Alertmanager configuration
├── grafana/
│   ├── provisioning/
│   │   ├── dashboards/         # Dashboard configs
│   │   └── datasources/        # Datasource configs
│   └── dashboards/             # JSON dashboard files
└── README.md
```

## ⚙️ Configuration

### Prometheus Configuration

The `prometheus.yml` file defines:
- Scrape intervals
- Scrape targets
- Alert rules
- Remote storage (optional)

### Alert Rules

Edit `prometheus/alerts.yml` to add custom alerts:

```yaml
groups:
  - name: custom_alerts
    interval: 30s
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for 5 minutes"
```

### Grafana Dashboards

Grafana includes pre-configured dashboards for:
- Node Exporter Full (ID: 1860)
- Docker and System Monitoring (ID: 893)
- Prometheus Stats (ID: 2)

Import more dashboards from: https://grafana.com/grafana/dashboards/

### Alertmanager Configuration

Configure notification channels in `alertmanager/alertmanager.yml`:

#### Slack Integration
```yaml
receivers:
  - name: 'slack'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'
        channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

#### Email Integration
```yaml
receivers:
  - name: 'email'
    email_configs:
      - to: 'ops@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'your-email@gmail.com'
        auth_password: 'your-app-password'
```

## 📊 Adding Exporters

### Add Node Exporter to Other Hosts

```bash
# Linux
docker run -d \
  --name=node-exporter \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  prom/node-exporter:latest \
  --path.rootfs=/host
```

Then add to `prometheus.yml`:
```yaml
scrape_configs:
  - job_name: 'remote-node'
    static_configs:
      - targets: ['remote-host:9100']
```

### MySQL Exporter

```yaml
# Add to docker-compose.yml
  mysql-exporter:
    image: prom/mysqld-exporter
    environment:
      - DATA_SOURCE_NAME=exporter:password@(mysql:3306)/
    ports:
      - "9104:9104"
```

### PostgreSQL Exporter

```yaml
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter
    environment:
      - DATA_SOURCE_NAME=postgresql://postgres:password@postgres:5432/dbname?sslmode=disable
    ports:
      - "9187:9187"
```

### Redis Exporter

```yaml
  redis-exporter:
    image: oliver006/redis_exporter
    environment:
      - REDIS_ADDR=redis:6379
    ports:
      - "9121:9121"
```

### Nginx Exporter

```yaml
  nginx-exporter:
    image: nginx/nginx-prometheus-exporter
    command:
      - -nginx.scrape-uri=http://nginx:8080/stub_status
    ports:
      - "9113:9113"
```

## 🎯 Monitoring Kubernetes

### Using Prometheus Operator

```bash
# Install with Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

### Service Monitors

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
  - port: metrics
    interval: 30s
```

## 📈 Useful PromQL Queries

### CPU Usage
```promql
# CPU usage per instance
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Top 5 processes by CPU
topk(5, rate(process_cpu_seconds_total[5m]))
```

### Memory Usage
```promql
# Memory usage percentage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Memory available
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

### Disk Usage
```promql
# Disk usage percentage
100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"}) * 100)

# Disk I/O
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])
```

### Network
```promql
# Network traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])

# Network errors
rate(node_network_receive_errs_total[5m])
```

### HTTP Monitoring
```promql
# Request rate
rate(http_requests_total[5m])

# Request duration 95th percentile
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Error rate
rate(http_requests_total{status=~"5.."}[5m])
```

## 🔔 Common Alert Rules

### System Alerts

```yaml
groups:
  - name: system_alerts
    rules:
      # High CPU
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage"
          description: "CPU usage is above 80%"

      # High Memory
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage is above 90%"

      # Low Disk Space
      - alert: LowDiskSpace
        expr: (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100 < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Low disk space"
          description: "Disk space is below 10%"

      # Instance Down
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Instance down"
          description: "{{ $labels.instance }} is down"
```

### Application Alerts

```yaml
groups:
  - name: application_alerts
    rules:
      # High Response Time
      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time"
          description: "95th percentile response time is above 1s"

      # High Error Rate
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate"
          description: "Error rate is above 5%"

      # SSL Certificate Expiry
      - alert: SSLCertificateExpiry
        expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 30
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "SSL certificate expiring soon"
          description: "SSL certificate expires in less than 30 days"
```

## 🎨 Creating Custom Dashboards

### Dashboard JSON Template

```json
{
  "dashboard": {
    "title": "My Custom Dashboard",
    "panels": [
      {
        "title": "CPU Usage",
        "targets": [
          {
            "expr": "100 - (avg(rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)"
          }
        ],
        "type": "graph"
      }
    ]
  }
}
```

### Best Practices

1. **Use Variables** - Make dashboards reusable
2. **Organize Panels** - Group related metrics
3. **Add Descriptions** - Document what metrics mean
4. **Set Thresholds** - Visual indicators for problems
5. **Use Templates** - Start with community dashboards

## 🔧 Performance Tuning

### Prometheus

```yaml
# prometheus.yml
global:
  scrape_interval: 15s      # Default 1m
  evaluation_interval: 15s   # Default 1m

  # Keep 30 days of data
  storage:
    tsdb:
      retention.time: 30d
      retention.size: 50GB
```

### Recording Rules

Pre-calculate expensive queries:

```yaml
groups:
  - name: recording_rules
    interval: 30s
    rules:
      - record: instance:node_cpu:avg_rate5m
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

      - record: instance:node_memory_usage:percentage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

## 📊 Remote Storage

### Thanos (Long-term Storage)

```yaml
  thanos-sidecar:
    image: thanosio/thanos:latest
    volumes:
      - ./prometheus:/prometheus
    command:
      - 'sidecar'
      - '--tsdb.path=/prometheus'
      - '--prometheus.url=http://prometheus:9090'
      - '--objstore.config-file=/bucket.yml'
```

### Cortex (Horizontally Scalable)

```yaml
  cortex:
    image: cortexproject/cortex
    command:
      - '-config.file=/etc/cortex/config.yaml'
    ports:
      - "9009:9009"
```

## 🔐 Security

### Enable Basic Auth

```yaml
# prometheus.yml
basic_auth_users:
  admin: $2y$10$...hashed_password...
```

### TLS Configuration

```yaml
# prometheus.yml
tls_config:
  cert_file: /path/to/cert.pem
  key_file: /path/to/key.pem
```

### Grafana Auth

```ini
# grafana.ini
[auth]
disable_login_form = false

[auth.basic]
enabled = true

[auth.anonymous]
enabled = false
```

## 📚 Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
- [Grafana Dashboard Library](https://grafana.com/grafana/dashboards/)

## 🆘 Troubleshooting

### Prometheus Not Scraping Targets

1. Check target status: http://localhost:9090/targets
2. Verify network connectivity
3. Check firewall rules
4. Review Prometheus logs: `docker logs prometheus`

### High Memory Usage

1. Reduce scrape frequency
2. Implement retention policies
3. Use recording rules
4. Enable remote storage

### Grafana Dashboard Not Loading

1. Check Grafana logs: `docker logs grafana`
2. Verify datasource configuration
3. Test Prometheus queries
4. Check browser console for errors

## 🎓 Next Steps

1. ✅ Start the stack with Docker Compose
2. ✅ Access Grafana and explore default dashboards
3. ✅ Add your applications as targets
4. ✅ Create custom alerts
5. ✅ Set up notification channels
6. ✅ Import community dashboards
7. ✅ Configure long-term storage

