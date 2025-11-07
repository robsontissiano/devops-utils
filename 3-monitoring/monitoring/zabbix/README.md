# Zabbix Monitoring Solution

Enterprise-class open-source monitoring solution with comprehensive monitoring capabilities.

## 🚀 Quick Start

### Using Docker Compose

```bash
# Start Zabbix stack
docker-compose up -d

# Access Zabbix Web UI
# URL: http://localhost:8080
# Username: Admin
# Password: zabbix
```

### Stop the Stack
```bash
docker-compose down

# Remove volumes (data will be lost)
docker-compose down -v
```

## 📦 Included Services

- **Zabbix Server** - Main monitoring server
- **Zabbix Web** - Web interface (Nginx + PHP-FPM)
- **Zabbix Agent** - Agent for monitoring the Zabbix server itself
- **PostgreSQL** - Database backend
- **Zabbix Java Gateway** - For monitoring JMX applications (optional)

## 🎯 Key Features

- **Agent-based and agentless monitoring**
- **SNMP, IPMI, JMX monitoring**
- **Auto-discovery of devices and services**
- **Distributed monitoring with proxies**
- **Powerful triggers and alerting**
- **Built-in notification system**
- **Web-based UI**
- **REST API**

## ⚙️ Initial Configuration

### 1. First Login

1. Navigate to http://localhost:8080
2. Login with default credentials:
   - Username: `Admin`
   - Password: `zabbix`
3. **Change the default password immediately!**

### 2. Add Hosts

**Configuration → Hosts → Create host**

- **Host name**: server01
- **Visible name**: Production Server 01
- **Groups**: Linux servers
- **Agent interfaces**: Add IP address or DNS name
- **Templates**: Link to appropriate templates (e.g., Linux by Zabbix agent)

### 3. Install Zabbix Agent on Remote Hosts

#### Linux (Ubuntu/Debian)
```bash
# Install agent
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo apt update
sudo apt install zabbix-agent2

# Configure agent
sudo vi /etc/zabbix/zabbix_agent2.conf
# Set: Server=your-zabbix-server-ip
# Set: ServerActive=your-zabbix-server-ip
# Set: Hostname=server01

# Start agent
sudo systemctl restart zabbix-agent2
sudo systemctl enable zabbix-agent2
```

#### Linux (CentOS/RHEL)
```bash
# Install repository
sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/8/x86_64/zabbix-release-6.4-1.el8.noarch.rpm
sudo dnf clean all
sudo dnf install zabbix-agent2

# Configure and start
sudo systemctl restart zabbix-agent2
sudo systemctl enable zabbix-agent2
```

#### Docker Agent
```bash
docker run -d \
  --name zabbix-agent \
  -e ZBX_HOSTNAME="docker-host" \
  -e ZBX_SERVER_HOST="zabbix-server-ip" \
  --privileged \
  -v /:/rootfs:ro \
  -v /var/run:/var/run \
  zabbix/zabbix-agent2:latest
```

## 📊 Templates

### Built-in Templates

Zabbix comes with many pre-configured templates:

- **Linux by Zabbix agent**
- **Windows by Zabbix agent**
- **MySQL by Zabbix agent**
- **PostgreSQL by Zabbix agent**
- **Nginx by Zabbix agent**
- **Apache by HTTP**
- **Docker by Zabbix agent 2**
- **Kubernetes by HTTP**
- **Network devices** (SNMP)

### Creating Custom Templates

1. Go to **Configuration → Templates**
2. Click **Create template**
3. Add items, triggers, graphs, and discovery rules
4. Export template for sharing

## 🔔 Alerting Configuration

### 1. Create Media Type

**Administration → Media types → Create media type**

#### Email Configuration
```yaml
Name: Email
Type: Email
SMTP server: smtp.gmail.com
SMTP server port: 587
SMTP helo: gmail.com
SMTP email: your-email@gmail.com
Connection security: STARTTLS
Authentication: Username and password
Username: your-email@gmail.com
Password: your-app-password
```

#### Slack Integration
```yaml
Name: Slack
Type: Webhook
Script:
  - Webhook URL: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
  - Use custom script for formatting
```

### 2. Configure User Media

**Administration → Users → Admin → Media**

- Add email/phone number
- Select when to be notified
- Set notification severity

### 3. Create Actions

**Configuration → Actions → Trigger actions → Create action**

Example action for critical alerts:
```
Name: Email on critical problems
Conditions:
  - Trigger severity >= High
Operations:
  - Send message via Email
  - Send to: Admin
Recovery operations:
  - Notify on recovery
```

## 📈 Common Monitoring Items

### System Metrics

```
# CPU usage
system.cpu.util
system.cpu.load[percpu,avg1]

# Memory
vm.memory.size[available]
vm.memory.utilization

# Disk
vfs.fs.size[/,used]
vfs.fs.size[/,free]
vfs.fs.size[/,pfree]  # Percentage free

# Network
net.if.in[eth0]
net.if.out[eth0]
```

### Process Monitoring

```
# Check if process is running
proc.num[nginx]

# Process memory usage
proc.mem[nginx]

# Process CPU usage
proc.cpu.util[nginx]
```

### Log Monitoring

```
# Monitor log file
log[/var/log/messages]
log[/var/log/messages,error]  # Search for pattern
logrt["/var/log/app/.*\.log"]  # Monitor multiple logs with regex
```

### Web Monitoring

```
# HTTP status code
web.page.regexp[example.com,,200]

# Response time
web.page.perf[example.com]

# Certificate expiry
web.cert.expiry[example.com]
```

## 🔍 Auto-Discovery

### Network Discovery

**Configuration → Discovery → Create discovery rule**

```yaml
Name: Local network
IP range: 192.168.1.1-254
Update interval: 1h
Checks:
  - ICMP ping
  - Zabbix agent
  - SNMP
Actions:
  - Add host
  - Link to template
  - Enable host
```

### Low-Level Discovery (LLD)

Automatically discover:
- File systems
- Network interfaces
- Databases
- Docker containers
- Kubernetes pods

Example: Disk discovery
```
Key: vfs.fs.discovery
Filter: {#FSTYPE} matches ext[234]|xfs|btrfs
```

## 🎨 Dashboards

### Creating Custom Dashboard

1. Go to **Monitoring → Dashboard**
2. Click **Create dashboard**
3. Add widgets:
   - Graph
   - Plain text
   - Problems
   - System status
   - Map
   - Graph prototype

### Dashboard Widgets

**System Status Widget**
- Shows overall system health
- Displays triggers by severity

**Problems Widget**
- Recent problems
- Filter by host group, severity
- Show timeline

**Graph Widget**
- CPU usage over time
- Memory utilization
- Network traffic
- Custom metrics

## 🌐 Distributed Monitoring with Proxies

### Why Use Proxies?

- Monitor remote locations
- Reduce load on Zabbix server
- Monitor isolated networks
- Scale horizontally

### Installing Zabbix Proxy

```bash
# Install proxy
apt install zabbix-proxy-sqlite3

# Configure
vi /etc/zabbix/zabbix_proxy.conf
# Set: Server=zabbix-server-ip
# Set: Hostname=proxy-location1

# Start proxy
systemctl restart zabbix-proxy
systemctl enable zabbix-proxy
```

### Configure Proxy in UI

**Administration → Proxies → Create proxy**

- Proxy name: proxy-location1
- Proxy mode: Active
- Encryption: Optional

Then assign hosts to proxy:
**Configuration → Hosts → Select host → Proxy**

## 📡 SNMP Monitoring

### Configure SNMP in Zabbix

1. Install SNMP utils on Zabbix server:
```bash
apt install snmp snmp-mibs-downloader
```

2. Add SNMP interface to host:
   - Interface type: SNMP
   - IP address: device IP
   - Port: 161
   - SNMP version: SNMPv2 or SNMPv3
   - SNMP community: public (or your community string)

3. Link appropriate template:
   - Template Net Cisco IOS SNMP
   - Template Net Juniper SNMP
   - Template Net HP Comware HH3C SNMP

### Custom SNMP Items

```
Key: snmpget[{#SNMPINDEX},1.3.6.1.2.1.2.2.1.2]
Description: Interface name
```

## 🔐 Security Best Practices

### 1. Change Default Passwords

```sql
-- Connect to PostgreSQL
psql -U zabbix -d zabbix

-- Change Admin password
UPDATE users SET passwd=md5('new-strong-password') WHERE alias='Admin';
```

### 2. Enable HTTPS

Configure nginx with SSL certificates:

```nginx
server {
    listen 443 ssl;
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    ...
}
```

### 3. Firewall Rules

```bash
# Allow only from specific IPs
ufw allow from 192.168.1.0/24 to any port 10051
ufw allow from 192.168.1.0/24 to any port 8080
```

### 4. Database Security

- Use strong database password
- Restrict database access to localhost
- Regular backups

### 5. Agent Security

Enable PSK encryption:

```bash
# Generate PSK
openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk

# Configure agent
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=PSK 001
TLSPSKFile=/etc/zabbix/zabbix_agentd.psk
```

## 🔧 Performance Tuning

### Database Tuning (PostgreSQL)

```sql
-- /etc/postgresql/14/main/postgresql.conf
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
```

### Zabbix Server Tuning

```ini
# /etc/zabbix/zabbix_server.conf
StartPollers=50
StartPollersUnreachable=10
StartTrappers=10
StartPingers=10
StartDiscoverers=5
CacheSize=256M
HistoryCacheSize=128M
TrendCacheSize=128M
ValueCacheSize=256M
```

### Housekeeping

Configure automatic data cleanup:
**Administration → General → Housekeeping**

- Enable internal housekeeping
- Override item history period: 90 days
- Override item trend period: 365 days

## 📚 Zabbix API

### Using the API

```bash
# Authentication
curl -X POST http://localhost:8080/api_jsonrpc.php \
  -H "Content-Type: application/json-rpc" \
  -d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
      "user": "Admin",
      "password": "zabbix"
    },
    "id": 1
  }'

# Get hosts
curl -X POST http://localhost:8080/api_jsonrpc.php \
  -H "Content-Type: application/json-rpc" \
  -d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["hostid", "name"]
    },
    "auth": "YOUR_AUTH_TOKEN",
    "id": 2
  }'
```

### Python Example

```python
from pyzabbix import ZabbixAPI

# Connect
zapi = ZabbixAPI('http://localhost:8080')
zapi.login('Admin', 'zabbix')

# Get all hosts
hosts = zapi.host.get(output=['hostid', 'name'])
for host in hosts:
    print(f"{host['hostid']}: {host['name']}")

# Create item
zapi.item.create(
    name='CPU Load',
    key_='system.cpu.load[percpu,avg1]',
    hostid='10084',
    type=0,
    value_type=0,
    interfaceid='1',
    delay='60s'
)
```

## 🆘 Troubleshooting

### Agent Not Connecting

```bash
# Test connection
zabbix_get -s agent-host -k agent.ping

# Check firewall
telnet agent-host 10050

# Check agent logs
tail -f /var/log/zabbix/zabbix_agentd.log

# Test agent configuration
zabbix_agentd -t system.cpu.load[percpu,avg1]
```

### High Database Load

- Enable housekeeping
- Optimize database indexes
- Increase database resources
- Reduce history retention

### No Data Coming In

- Check agent status
- Verify network connectivity
- Review server logs: `/var/log/zabbix/zabbix_server.log`
- Check item configuration

## 📖 Resources

- [Official Documentation](https://www.zabbix.com/documentation)
- [Zabbix Share (Templates)](https://share.zabbix.com/)
- [Zabbix Forums](https://www.zabbix.com/forum/)
- [Zabbix Git Repository](https://git.zabbix.com/)

## 🎓 Next Steps

1. ✅ Start Zabbix with Docker Compose
2. ✅ Change default admin password
3. ✅ Add your first host
4. ✅ Install Zabbix agent on remote servers
5. ✅ Configure notifications
6. ✅ Create custom dashboards
7. ✅ Set up auto-discovery

