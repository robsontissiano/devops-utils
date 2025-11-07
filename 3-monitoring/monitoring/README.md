# Monitoring Solutions

A comprehensive collection of open-source monitoring tools, templates, and configurations for infrastructure and application monitoring.

## 📊 Available Monitoring Solutions

### [Prometheus + Grafana](./prometheus-grafana/) ⭐ Recommended
The most popular modern monitoring stack combining metrics collection (Prometheus) with powerful visualization (Grafana).

**Best For:** Modern cloud-native applications, Kubernetes, microservices

**Features:**
- Powerful time-series database
- Pull-based metrics collection
- Rich query language (PromQL)
- Alerting with Alertmanager
- Beautiful dashboards and visualization
- Large ecosystem of exporters
- Native Kubernetes support

[View Prometheus + Grafana Guide →](./prometheus-grafana/README.md)

---

### [Zabbix](./zabbix/)
Enterprise-class open-source monitoring solution with agent-based and agentless monitoring.

**Best For:** Traditional infrastructure, network monitoring, enterprise environments

**Features:**
- Agent-based and agentless monitoring
- SNMP, IPMI, JMX support
- Auto-discovery
- Distributed monitoring
- Built-in notification system
- Database monitoring
- Web-based UI

[View Zabbix Guide →](./zabbix/README.md)

---

### [ELK Stack](./elk-stack/)
Elasticsearch, Logstash, and Kibana for centralized logging and log analysis.

**Best For:** Log aggregation, log analysis, security monitoring

**Features:**
- Centralized log management
- Full-text search
- Log parsing and enrichment
- Powerful visualization
- Real-time analysis
- Security analytics
- APM (Application Performance Monitoring)

[View ELK Stack Guide →](./elk-stack/README.md)

---

### [Netdata](./netdata/)
Real-time performance monitoring with zero configuration and beautiful dashboards.

**Best For:** Quick setup, real-time metrics, troubleshooting

**Features:**
- Zero configuration
- Real-time monitoring (1-second granularity)
- 2000+ metrics collected automatically
- Beautiful web interface
- Low resource usage
- Health alarms
- Distributed architecture

[View Netdata Guide →](./netdata/README.md)

---

## 🆚 Comparison Matrix

| Feature | Prometheus + Grafana | Zabbix | ELK Stack | Netdata |
|---------|---------------------|---------|-----------|---------|
| **License** | Apache 2.0 / AGPL | GPL | Elastic License / SSPL | GPL |
| **Cost** | Free | Free | Free (Basic) / Paid (Advanced) | Free |
| **Difficulty** | Medium | Medium-Hard | Hard | Easy |
| **Setup Time** | 30-60 min | 1-2 hours | 1-3 hours | 5-10 min |
| **Resource Usage** | Medium | Medium-High | High | Low |
| **Scalability** | Excellent | Good | Excellent | Good |
| **Cloud Native** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Kubernetes** | Native | Good | Good | Good |
| **Metrics** | ✅ Excellent | ✅ Excellent | ⚠️ Limited | ✅ Excellent |
| **Logs** | ⚠️ Via Loki | ⚠️ Limited | ✅ Excellent | ⚠️ Limited |
| **Alerting** | ✅ Alertmanager | ✅ Built-in | ✅ Watchers | ✅ Built-in |
| **Dashboards** | ✅ Grafana | ✅ Built-in | ✅ Kibana | ✅ Built-in |
| **Auto-Discovery** | ✅ Service Discovery | ✅ Network/Agent | ⚠️ Manual | ✅ Auto |
| **Best Use Case** | Microservices, K8s | Enterprise, Network | Logs, Security | Quick insights |

## 🎯 Which One Should You Choose?

### Choose **Prometheus + Grafana** if:
- ✅ You're running Kubernetes or containers
- ✅ You have microservices architecture
- ✅ You need powerful time-series metrics
- ✅ You want the most popular modern stack
- ✅ You need extensive community support

### Choose **Zabbix** if:
- ✅ You have traditional infrastructure
- ✅ You need network monitoring (SNMP)
- ✅ You want an all-in-one solution
- ✅ You need agent-based monitoring
- ✅ You're monitoring databases

### Choose **ELK Stack** if:
- ✅ Your primary need is log analysis
- ✅ You need full-text search capabilities
- ✅ You're doing security monitoring
- ✅ You need APM (Application Performance Monitoring)
- ✅ You want centralized logging

### Choose **Netdata** if:
- ✅ You need quick setup with zero config
- ✅ You want real-time (1-second) granularity
- ✅ You're troubleshooting performance issues
- ✅ You have resource constraints
- ✅ You need immediate insights

## 🚀 Quick Start

### Fastest Setup (Netdata)
```bash
# Install on Linux
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Access at http://localhost:19999
```

### Most Popular (Prometheus + Grafana)
```bash
cd monitoring/prometheus-grafana
docker-compose up -d

# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
```

### Enterprise Solution (Zabbix)
```bash
cd monitoring/zabbix
docker-compose up -d

# Zabbix: http://localhost:8080 (Admin/zabbix)
```

### Log Analysis (ELK)
```bash
cd monitoring/elk-stack
docker-compose up -d

# Kibana: http://localhost:5601
```

## 📦 Common Components

### Exporters (Prometheus)
- **Node Exporter** - Hardware and OS metrics
- **cAdvisor** - Container metrics
- **Blackbox Exporter** - HTTP, DNS, TCP, ICMP probes
- **MySQL Exporter** - MySQL metrics
- **PostgreSQL Exporter** - PostgreSQL metrics
- **Nginx Exporter** - Nginx metrics
- **Redis Exporter** - Redis metrics

### Agents (Zabbix)
- **Zabbix Agent 2** - System metrics
- **SNMP** - Network device monitoring
- **JMX** - Java application monitoring
- **IPMI** - Hardware monitoring

### Beats (ELK)
- **Filebeat** - Log file shipping
- **Metricbeat** - System and service metrics
- **Packetbeat** - Network traffic analysis
- **Heartbeat** - Uptime monitoring
- **Auditbeat** - Audit data collection

## 🔔 Alerting Options

### Prometheus Alertmanager
- Grouping and deduplication
- Routing to multiple receivers
- Silence management
- Integration with Slack, PagerDuty, email, etc.

### Zabbix Built-in Alerting
- Trigger-based alerts
- Escalations
- Multiple notification channels
- Problem suppression

### ElastAlert (ELK)
- Query-based alerting
- Multiple rule types
- Rich integration options

### Grafana Alerts
- Dashboard-based alerts
- Multiple notification channels
- Alert rules based on queries

## 🏗️ Architecture Patterns

### Small Environment (1-50 hosts)
```
Single server running:
- Prometheus + Grafana
  OR
- Netdata standalone
```

### Medium Environment (50-500 hosts)
```
Separate servers:
- Prometheus server
- Grafana server
- Alertmanager
- Multiple exporters
```

### Large Environment (500+ hosts)
```
Highly available:
- Prometheus (HA with Thanos/Cortex)
- Grafana (HA with PostgreSQL backend)
- Alertmanager cluster
- Remote storage (S3, GCS)
```

### Enterprise Environment
```
Zabbix distributed:
- Zabbix Server
- Zabbix Proxy servers
- Database (PostgreSQL HA)
- Zabbix Frontend (load balanced)
```

## 🔐 Security Best Practices

1. **Enable Authentication**
   - Use strong passwords
   - Enable HTTPS/TLS
   - Implement SSO where possible

2. **Network Security**
   - Firewall rules
   - VPN or private networks
   - API authentication

3. **Data Security**
   - Encrypt data in transit
   - Secure database credentials
   - Regular backups

4. **Access Control**
   - Role-based access
   - Audit logging
   - Least privilege principle

## 📚 Additional Resources

### Official Documentation
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Zabbix Documentation](https://www.zabbix.com/documentation)
- [Elastic Documentation](https://www.elastic.co/guide/)
- [Netdata Documentation](https://learn.netdata.cloud/)

### Community Resources
- [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [Zabbix Templates](https://www.zabbix.com/integrations)
- [Elastic Community](https://discuss.elastic.co/)

## 🎓 Learning Path

1. **Start Simple**: Install Netdata for immediate insights
2. **Learn Metrics**: Set up Prometheus + Grafana for a few services
3. **Add Logs**: Implement ELK or Loki for log aggregation
4. **Scale Up**: Add more exporters, create custom dashboards
5. **Optimize**: Tune retention, implement remote storage
6. **Alert**: Configure meaningful alerts with Alertmanager

## 💡 Tips and Tricks

### Prometheus
- Use recording rules for frequently used queries
- Set appropriate retention periods
- Use remote write for long-term storage
- Label your metrics consistently

### Grafana
- Use variables in dashboards for flexibility
- Set up alerting rules
- Organize dashboards in folders
- Use dashboard versioning

### Zabbix
- Use templates for similar hosts
- Implement auto-discovery
- Regular housekeeping of old data
- Use macros for flexibility

### ELK
- Use index lifecycle management
- Implement proper log parsing
- Set up index templates
- Monitor cluster health

## 🔧 Troubleshooting

### High Memory Usage
- Adjust retention periods
- Implement downsampling
- Use remote storage
- Increase resources

### Missing Metrics
- Check exporter status
- Verify scrape configs
- Check network connectivity
- Review logs

### Slow Queries
- Optimize PromQL queries
- Add recording rules
- Check data cardinality
- Review dashboard queries

## 🎯 Next Steps

1. Choose your monitoring solution based on your needs
2. Follow the quick start guide in the respective folder
3. Configure agents/exporters for your infrastructure
4. Create meaningful dashboards
5. Set up alerting rules
6. Test and iterate

---

**Need Help?** Check the individual solution guides or open an issue!

