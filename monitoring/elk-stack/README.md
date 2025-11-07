# ELK Stack (Elasticsearch, Logstash, Kibana)

Centralized logging and log analysis platform for aggregating, parsing, and visualizing log data.

## 🚀 Quick Start

```bash
# Start ELK stack
docker-compose up -d

# Access Kibana
# URL: http://localhost:5601

# Elasticsearch
# URL: http://localhost:9200
```

## 📦 Stack Components

- **Elasticsearch** - Search and analytics engine
- **Logstash** - Data processing pipeline
- **Kibana** - Visualization and exploration interface
- **Filebeat** - Lightweight log shipper

## ⚙️ Configuration

### Filebeat Configuration

Ship logs from application servers to Logstash:

```yaml
# filebeat.yml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/*.log
      - /var/log/nginx/*.log
    fields:
      log_type: system

output.logstash:
  hosts: ["logstash:5044"]
```

### Logstash Pipeline

```ruby
# logstash.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][log_type] == "nginx" {
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
    }
    date {
      match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

## 📊 Common Use Cases

### Application Logs
- Error tracking
- Performance monitoring
- User behavior analysis

### Security Monitoring
- Failed login attempts
- Suspicious activity
- Compliance auditing

### Infrastructure Monitoring
- System logs
- Access logs
- Performance metrics

## 📚 Resources

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Logstash Documentation](https://www.elastic.co/guide/en/logstash/current/index.html)
- [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Filebeat Documentation](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)

