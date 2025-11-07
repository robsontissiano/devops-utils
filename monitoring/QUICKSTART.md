# Monitoring Quick Start Guide

Choose your monitoring solution and get started in minutes!

## 🎯 Which Solution Should I Use?

### Just Want to See Metrics NOW? → **Netdata**
```bash
# One command installation
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Access: http://localhost:19999
```
✅ **5 minutes setup** | Zero configuration | Real-time metrics

---

### Modern Cloud-Native Apps? → **Prometheus + Grafana** ⭐
```bash
cd monitoring/prometheus-grafana
docker-compose up -d

# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
```
✅ **30 minutes setup** | Best for containers & K8s | Most popular

---

### Enterprise Infrastructure? → **Zabbix**
```bash
cd monitoring/zabbix
docker-compose up -d

# Zabbix: http://localhost:8080 (Admin/zabbix)
```
✅ **1 hour setup** | Traditional monitoring | SNMP support

---

### Need Log Analysis? → **ELK Stack**
```bash
cd monitoring/elk-stack
docker-compose up -d

# Kibana: http://localhost:5601
```
✅ **1-2 hours setup** | Log aggregation | Full-text search

---

## 🚀 Quick Commands

### Start All Solutions (for testing)
```bash
# Start Netdata
cd netdata && docker-compose up -d

# Start Prometheus + Grafana
cd ../prometheus-grafana && docker-compose up -d

# Start Zabbix
cd ../zabbix && docker-compose up -d

# Start ELK
cd ../elk-stack && docker-compose up -d
```

### Access All Dashboards
```bash
echo "Netdata:            http://localhost:19999"
echo "Prometheus:         http://localhost:9090"
echo "Grafana:            http://localhost:3000"
echo "Zabbix:             http://localhost:8080"
echo "Kibana:             http://localhost:5601"
echo "Alertmanager:       http://localhost:9093"
```

### Stop Everything
```bash
cd netdata && docker-compose down
cd ../prometheus-grafana && docker-compose down
cd ../zabbix && docker-compose down
cd ../elk-stack && docker-compose down
```

## 💡 Beginner's Path

**Day 1: Explore**
1. Install Netdata (fastest)
2. Explore real-time metrics
3. Understand what needs monitoring

**Day 2-3: Learn**
1. Set up Prometheus + Grafana
2. Add your applications as targets
3. Create your first dashboard

**Week 2: Advanced**
1. Configure alerting
2. Set up notification channels
3. Add recording rules

**Month 1: Production**
1. Implement high availability
2. Set up long-term storage
3. Create runbooks for alerts

## 📊 Comparison at a Glance

| Solution | Setup Time | Difficulty | Best For |
|----------|-----------|------------|----------|
| **Netdata** | 5 min | ⭐ Easy | Quick insights |
| **Prometheus + Grafana** | 30 min | ⭐⭐ Medium | Cloud-native |
| **Zabbix** | 1 hour | ⭐⭐⭐ Medium-Hard | Enterprise |
| **ELK Stack** | 2 hours | ⭐⭐⭐⭐ Hard | Logs |

## 🆘 Common Issues

### Port Already in Use
```bash
# Check what's using the port
sudo lsof -i :9090

# Kill the process or change the port in docker-compose.yml
```

### Docker Out of Memory
```bash
# Increase Docker memory in Docker Desktop settings
# Or reduce Java heap sizes in docker-compose.yml
```

### Can't Access Dashboard
```bash
# Check if containers are running
docker ps

# Check container logs
docker logs <container-name>

# Restart containers
docker-compose restart
```

## 🔐 Security Checklist

Before exposing to the internet:

- [ ] Change default passwords
- [ ] Enable HTTPS/TLS
- [ ] Configure authentication
- [ ] Set up firewall rules
- [ ] Use strong passwords
- [ ] Enable audit logging
- [ ] Regular backups
- [ ] Update regularly

## 📚 Next Steps

1. **Explore** - Try each solution with Docker Compose
2. **Choose** - Pick the one that fits your needs
3. **Deploy** - Follow the detailed README in each folder
4. **Configure** - Set up agents, exporters, or beats
5. **Alert** - Configure meaningful alerts
6. **Optimize** - Tune performance and retention

## 🎓 Learning Resources

- Read the main [Monitoring README](./README.md)
- Check individual solution guides
- Join community forums
- Follow official documentation
- Watch YouTube tutorials

---

**Ready to start? Pick a solution above and dive in!** 🚀

