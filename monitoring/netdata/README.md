# Netdata Real-Time Monitoring

Zero-configuration real-time performance monitoring with beautiful dashboards.

## 🚀 Quick Start

### Install on Linux (Easiest)

```bash
# One-line installation
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Access dashboard
# URL: http://localhost:19999
```

### Using Docker

```bash
# Run Netdata container
docker run -d \
  --name=netdata \
  -p 19999:19999 \
  -v netdataconfig:/etc/netdata \
  -v netdatalib:/var/lib/netdata \
  -v netdatacache:/var/cache/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

# Access dashboard
# URL: http://localhost:19999
```

### Using Docker Compose

```bash
# Start Netdata
docker-compose up -d

# Access dashboard
# URL: http://localhost:19999
```

## ✨ Key Features

- **Zero Configuration** - Works out of the box
- **Real-Time Monitoring** - 1-second granularity
- **2000+ Metrics** - Automatically collected
- **Beautiful Dashboards** - Interactive and responsive
- **Low Resource Usage** - Minimal CPU and memory
- **Health Alarms** - Built-in alerting
- **Distributed Architecture** - Can stream to parent nodes

## 📊 Monitored Metrics

### System
- CPU usage per core
- RAM usage
- Swap usage
- Disk I/O
- Network traffic
- System load
- Processes

### Applications
- Web servers (Apache, Nginx)
- Databases (MySQL, PostgreSQL, MongoDB)
- Message queues (RabbitMQ, Redis)
- Docker containers
- Kubernetes pods

### Network
- Bandwidth usage
- Packet statistics
- Connection states
- Firewall statistics

## 🔔 Alerting

### Configure Email Alerts

```bash
# Edit health_alarm_notify.conf
sudo vi /etc/netdata/health_alarm_notify.conf

# Configure email
SEND_EMAIL="YES"
DEFAULT_RECIPIENT_EMAIL="ops@example.com"
EMAIL_SENDER="netdata@example.com"
SSMTP_SERVER="smtp.gmail.com"
SSMTP_PORT="587"
SSMTP_USER="your-email@gmail.com"
SSMTP_PASS="your-app-password"
```

### Configure Slack Alerts

```bash
# Edit health_alarm_notify.conf
SEND_SLACK="YES"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
DEFAULT_RECIPIENT_SLACK="#alerts"
```

### Custom Alarms

```bash
# Create custom alarm
sudo vi /etc/netdata/health.d/cpu_usage.conf

alarm: cpu_usage
on: system.cpu
lookup: average -3m unaligned of user,system,nice
units: %
every: 10s
warn: $this > 80
crit: $this > 95
info: average CPU usage over the last 3 minutes
```

## 🌐 Netdata Cloud

Free service for managing multiple Netdata agents:

1. Sign up at https://app.netdata.cloud
2. Claim your node:
```bash
sudo netdata-claim.sh -token=YOUR_CLAIM_TOKEN -rooms=YOUR_ROOM_ID -url=https://app.netdata.cloud
```

## 🔐 Security

### Enable Basic Auth (Nginx)

```nginx
server {
    listen 80;
    server_name netdata.example.com;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;

    location / {
        proxy_pass http://localhost:19999;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
    }
}
```

### Enable HTTPS

```bash
# Install certbot
apt install certbot python3-certbot-nginx

# Get certificate
certbot --nginx -d netdata.example.com
```

## 🎯 Best Practices

1. **Keep it updated**: `sudo netdata-updater.sh`
2. **Monitor multiple servers**: Use Netdata Cloud
3. **Set meaningful alerts**: Avoid alert fatigue
4. **Use persistent storage**: Configure database mode
5. **Secure access**: Use authentication and HTTPS

## 📚 Resources

- [Official Documentation](https://learn.netdata.cloud/)
- [GitHub Repository](https://github.com/netdata/netdata)
- [Community Forums](https://community.netdata.cloud/)
- [Awesome Netdata](https://github.com/netdata/netdata/blob/master/docs/awesome-netdata.md)

## 🎓 Next Steps

1. ✅ Install Netdata
2. ✅ Access the dashboard
3. ✅ Explore real-time metrics
4. ✅ Configure alerts
5. ✅ Connect to Netdata Cloud (optional)
6. ✅ Install on multiple servers

