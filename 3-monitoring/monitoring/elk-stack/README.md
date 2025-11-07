# ELK Stack - Elasticsearch + Logstash + Kibana

Centralized logging and log analysis platform for aggregating, parsing, searching, and visualizing log data from multiple sources.

## 🚀 Quick Start

```bash
# Start the ELK stack
docker-compose up -d

# Wait for services to be ready (1-2 minutes)
docker-compose logs -f

# Access the services
# Kibana: http://localhost:5601
# Elasticsearch: http://localhost:9200
```

### Verify Installation

```bash
# Check Elasticsearch
curl -X GET "localhost:9200/_cluster/health?pretty"

# Check indices
curl -X GET "localhost:9200/_cat/indices?v"

# Check Logstash
curl -X GET "localhost:9600/_node/stats?pretty"
```

## 📦 Stack Components

- **Elasticsearch** - Search and analytics engine (port 9200, 9300)
- **Logstash** - Data processing pipeline (port 5044, 9600)
- **Kibana** - Visualization interface (port 5601)
- **Filebeat** - Lightweight log shipper (optional)

## 📁 Directory Structure

```
elk-stack/
├── docker-compose.yml              # Main compose file
├── README.md                       # This file
├── elasticsearch/
│   └── config/
│       └── elasticsearch.yml       # Elasticsearch configuration
├── logstash/
│   ├── pipeline/
│   │   ├── logstash.conf          # Main pipeline
│   │   ├── nginx.conf             # Nginx logs pipeline
│   │   ├── apache.conf            # Apache logs pipeline
│   │   ├── json.conf              # JSON logs pipeline
│   │   └── syslog.conf            # Syslog pipeline
│   ├── patterns/
│   │   └── custom-patterns        # Custom Grok patterns
│   └── config/
│       └── logstash.yml           # Logstash configuration
├── kibana/
│   └── config/
│       └── kibana.yml             # Kibana configuration
└── filebeat/
    └── filebeat.yml               # Filebeat configuration
```

## ⚙️ Configuration Files

### Elasticsearch Configuration

The `elasticsearch/config/elasticsearch.yml` includes:
- Cluster configuration
- Memory settings
- Network settings
- Security settings

### Logstash Pipelines

Multiple pipeline configurations for different log types:

#### 1. **Nginx Access Logs** (`logstash/pipeline/nginx.conf`)
- Parses Nginx combined log format
- Extracts IP, method, URL, status, user agent
- GeoIP enrichment
- User agent parsing

#### 2. **Apache Logs** (`logstash/pipeline/apache.conf`)
- Parses Apache combined/common formats
- Similar enrichment to Nginx

#### 3. **JSON Logs** (`logstash/pipeline/json.conf`)
- Parses JSON formatted logs
- Flexible field mapping
- Auto-indexing

#### 4. **Syslog** (`logstash/pipeline/syslog.conf`)
- Parses standard syslog format
- Facility and severity parsing
- Host and program extraction

#### 5. **Main Pipeline** (`logstash/pipeline/logstash.conf`)
- General purpose pipeline
- Beats input
- Multiple filter options
- Elasticsearch output

### Kibana Configuration

The `kibana/config/kibana.yml` includes:
- Elasticsearch connection
- Server settings
- Logging configuration

## 🔧 Sending Logs to ELK

### Method 1: Using Filebeat (Recommended)

**Install Filebeat on your servers:**

```bash
# Ubuntu/Debian
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt update && sudo apt install filebeat

# Configure filebeat
sudo vi /etc/filebeat/filebeat.yml
```

**Filebeat Configuration:**

```yaml
# filebeat.yml
filebeat.inputs:
  # System logs
  - type: log
    enabled: true
    paths:
      - /var/log/*.log
      - /var/log/messages
      - /var/log/syslog
    fields:
      log_type: system
      environment: production

  # Nginx logs
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
    fields:
      log_type: nginx
      service: web

  # Application logs
  - type: log
    enabled: true
    paths:
      - /var/log/myapp/*.log
    fields:
      log_type: application
      app_name: myapp

output.logstash:
  hosts: ["logstash-server:5044"]

# Start filebeat
sudo systemctl enable filebeat
sudo systemctl start filebeat
```

### Method 2: Docker Container Logs

The included docker-compose already configures Filebeat to collect Docker logs:

```yaml
filebeat:
  volumes:
    - /var/lib/docker/containers:/var/lib/docker/containers:ro
    - /var/run/docker.sock:/var/run/docker.sock:ro
```

### Method 3: Direct Logging from Applications

**Python Example:**

```python
import logging
from logstash_async.handler import AsynchronousLogstashHandler

# Configure logging
logger = logging.getLogger('python-logstash-logger')
logger.setLevel(logging.INFO)

# Add Logstash handler
handler = AsynchronousLogstashHandler(
    host='localhost',
    port=5000,
    database_path='logstash.db'
)
logger.addHandler(handler)

# Log messages
logger.info('Hello from Python!', extra={'custom_field': 'value'})
```

**Node.js Example:**

```javascript
const winston = require('winston');
const LogstashTransport = require('winston-logstash/lib/winston-logstash-latest');

const logger = winston.createLogger({
  transports: [
    new LogstashTransport({
      port: 5000,
      host: 'localhost',
      node_name: 'my-app'
    })
  ]
});

logger.info('Hello from Node.js!', { custom_field: 'value' });
```

### Method 4: Using Netcat or TCP

```bash
# Send a log line
echo '{"message": "Test log", "level": "info"}' | nc localhost 5000

# Continuous logging
tail -f /var/log/app.log | nc localhost 5000
```

## 📊 Kibana - Creating Visualizations

### 1. Create Index Pattern

1. Open Kibana: http://localhost:5601
2. Go to **Management** → **Stack Management** → **Index Patterns**
3. Click **Create index pattern**
4. Enter pattern: `logs-*` or `filebeat-*`
5. Select **@timestamp** as time field
6. Click **Create**

### 2. Discover Logs

1. Go to **Discover**
2. Select your index pattern
3. Use KQL (Kibana Query Language) to search:

```
# Search examples
response:500                          # Find 500 errors
message:"error" AND level:"error"     # Find error messages
source.ip:192.168.1.1                 # Specific IP
NOT status:200                        # Exclude 200s
host.name:web* AND status >= 400      # Multiple conditions
```

### 3. Create Visualizations

#### Top URLs by Count
```
1. Go to Visualize → Create visualization → Vertical Bar
2. Choose index pattern
3. Y-axis: Count
4. X-axis: Terms → url.keyword
5. Size: 10
```

#### Response Codes Over Time
```
1. Create visualization → Area
2. Y-axis: Count
3. X-axis: Date Histogram → @timestamp
4. Split series: Terms → status
```

#### Geographic Map
```
1. Create visualization → Maps
2. Add layer → Choropleth
3. Metrics: Count
4. Join field: geoip.country_code2
```

### 4. Create Dashboard

1. Go to **Dashboard** → **Create dashboard**
2. Click **Add from library** or **Create new**
3. Add your visualizations
4. Arrange and resize panels
5. Save dashboard

## 🔍 Common Logstash Patterns

### Custom Grok Patterns

Create custom patterns in `logstash/patterns/custom-patterns`:

```
# Custom application log pattern
MYAPP_LOG %{TIMESTAMP_ISO8601:timestamp} \[%{LOGLEVEL:level}\] %{GREEDYDATA:message}

# Custom format
CUSTOM_FORMAT %{IP:client_ip} - %{WORD:method} %{URIPATH:path} - %{NUMBER:response_time:float}
```

Use in Logstash:

```ruby
filter {
  grok {
    patterns_dir => ["/usr/share/logstash/patterns"]
    match => { "message" => "%{MYAPP_LOG}" }
  }
}
```

### Common Filter Patterns

#### Parse JSON
```ruby
filter {
  json {
    source => "message"
    target => "parsed"
  }
}
```

#### Add GeoIP
```ruby
filter {
  geoip {
    source => "client_ip"
    target => "geoip"
  }
}
```

#### Parse User Agent
```ruby
filter {
  useragent {
    source => "user_agent"
    target => "ua"
  }
}
```

#### Add Timestamp
```ruby
filter {
  date {
    match => [ "timestamp", "ISO8601", "dd/MMM/yyyy:HH:mm:ss Z" ]
    target => "@timestamp"
  }
}
```

#### Remove Fields
```ruby
filter {
  mutate {
    remove_field => [ "message", "host" ]
  }
}
```

## 📈 Index Management

### Index Lifecycle Management (ILM)

```bash
# Create ILM policy
curl -X PUT "localhost:9200/_ilm/policy/logs_policy?pretty" -H 'Content-Type: application/json' -d'
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_size": "50GB",
            "max_age": "7d"
          }
        }
      },
      "warm": {
        "min_age": "7d",
        "actions": {
          "shrink": {
            "number_of_shards": 1
          }
        }
      },
      "delete": {
        "min_age": "30d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'
```

### Index Templates

```bash
# Create index template
curl -X PUT "localhost:9200/_index_template/logs_template?pretty" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["logs-*"],
  "template": {
    "settings": {
      "number_of_shards": 3,
      "number_of_replicas": 1,
      "index.lifecycle.name": "logs_policy"
    },
    "mappings": {
      "properties": {
        "@timestamp": { "type": "date" },
        "message": { "type": "text" },
        "level": { "type": "keyword" },
        "host": { "type": "keyword" }
      }
    }
  }
}
'
```

### Delete Old Indices

```bash
# Delete indices older than 30 days
curl -X DELETE "localhost:9200/logs-*" -H 'Content-Type: application/json' -d'
{
  "max_age": "30d"
}
'

# Delete specific index
curl -X DELETE "localhost:9200/logs-2024.01.01"
```

## 🔐 Security Configuration

### Enable X-Pack Security

**Update `elasticsearch.yml`:**

```yaml
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
```

**Set passwords:**

```bash
# Generate passwords
docker exec -it elasticsearch bin/elasticsearch-setup-passwords auto

# Or set manually
docker exec -it elasticsearch bin/elasticsearch-setup-passwords interactive
```

**Update `kibana.yml`:**

```yaml
elasticsearch.username: "kibana_system"
elasticsearch.password: "your-password"
```

**Update `logstash.yml`:**

```ruby
output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    user => "logstash_system"
    password => "your-password"
  }
}
```

### Enable HTTPS

```yaml
# kibana.yml
server.ssl.enabled: true
server.ssl.certificate: /path/to/cert.crt
server.ssl.key: /path/to/cert.key
```

## 🎯 Use Cases

### 1. Application Error Tracking

**Logstash Filter:**

```ruby
filter {
  if [level] == "ERROR" or [level] == "FATAL" {
    mutate {
      add_tag => ["error"]
    }
  }
}
```

**Kibana Alert:**
- Create visualization: Errors per minute
- Set alert: Notify if > 10 errors/minute

### 2. Access Log Analysis

**Analyze:**
- Top requested URLs
- Response time percentiles
- Error rate by endpoint
- Geographic distribution
- Peak traffic times

### 3. Security Monitoring

**Track:**
- Failed login attempts
- Unusual access patterns
- SQL injection attempts
- Privilege escalation
- Suspicious user agents

**Alert on:**
- Multiple failed logins from same IP
- Access from blacklisted IPs
- Unusual request patterns

### 4. Performance Monitoring

**Monitor:**
- Response times
- Slow queries
- High memory usage
- CPU spikes
- Database connection issues

## 🔧 Performance Tuning

### Elasticsearch

```yaml
# elasticsearch.yml
# Heap size (50% of RAM, max 32GB)
ES_JAVA_OPTS: "-Xms4g -Xmx4g"

# Disable swapping
bootstrap.memory_lock: true

# Increase thread pool
thread_pool.write.queue_size: 1000

# Increase batch size
bulk.queue_size: 200
```

### Logstash

```yaml
# logstash.yml
# Worker threads (CPU cores)
pipeline.workers: 4

# Batch settings
pipeline.batch.size: 125
pipeline.batch.delay: 50

# Heap size
LS_JAVA_OPTS: "-Xms2g -Xmx2g"
```

### Kibana

```yaml
# kibana.yml
elasticsearch.requestTimeout: 90000
elasticsearch.pingTimeout: 30000
```

## 📊 Monitoring ELK Stack

### Elasticsearch Health

```bash
# Cluster health
curl -X GET "localhost:9200/_cluster/health?pretty"

# Node stats
curl -X GET "localhost:9200/_nodes/stats?pretty"

# Index stats
curl -X GET "localhost:9200/_stats?pretty"
```

### Logstash Monitoring

```bash
# Node info
curl -X GET "localhost:9600/_node?pretty"

# Pipeline stats
curl -X GET "localhost:9600/_node/stats/pipelines?pretty"
```

### Enable Monitoring in Kibana

1. Go to **Stack Monitoring**
2. Enable monitoring
3. View cluster, node, and index metrics

## 🆘 Troubleshooting

### Elasticsearch Won't Start

```bash
# Check logs
docker logs elasticsearch

# Common issues:
# 1. Insufficient memory
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 2. Disk space
df -h

# 3. Port already in use
sudo lsof -i :9200
```

### Logstash Not Processing Logs

```bash
# Check pipeline
curl -X GET "localhost:9600/_node/pipelines?pretty"

# Check for errors in logs
docker logs logstash

# Test configuration
docker exec -it logstash logstash -f /usr/share/logstash/pipeline/logstash.conf --config.test_and_exit
```

### Kibana Can't Connect to Elasticsearch

```bash
# Verify Elasticsearch is running
curl localhost:9200

# Check Kibana logs
docker logs kibana

# Verify kibana.yml configuration
docker exec -it kibana cat /usr/share/kibana/config/kibana.yml
```

### No Data in Kibana

1. Check if logs are reaching Logstash: `docker logs logstash`
2. Check if Elasticsearch has indices: `curl localhost:9200/_cat/indices`
3. Verify index pattern in Kibana matches index names
4. Check time range in Kibana Discover
5. Verify Filebeat is running: `systemctl status filebeat`

## 📚 Resources

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Logstash Documentation](https://www.elastic.co/guide/en/logstash/current/index.html)
- [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Filebeat Documentation](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [Grok Patterns](https://github.com/logstash-plugins/logstash-patterns-core/tree/main/patterns)
- [Elastic Community](https://discuss.elastic.co/)

## 🎓 Next Steps

1. ✅ Start the ELK stack with `docker-compose up -d`
2. ✅ Access Kibana at http://localhost:5601
3. ✅ Create your first index pattern
4. ✅ Configure Filebeat on your servers
5. ✅ Explore logs in Kibana Discover
6. ✅ Create visualizations and dashboards
7. ✅ Set up alerts for critical events
8. ✅ Configure index lifecycle management
9. ✅ Enable security features
10. ✅ Monitor cluster health

---

**Happy Log Hunting! 🔍📊**
