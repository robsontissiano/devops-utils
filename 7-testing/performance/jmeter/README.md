# Apache JMeter - Performance Testing Tool

Industry-standard open-source load testing tool for analyzing and measuring performance of applications.

## Quick Start

### Installation

**Using Package Managers:**

```bash
# macOS (Homebrew)
brew install jmeter

# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install jmeter

# Windows (Chocolatey)
choco install jmeter
```

**Manual Installation:**

```bash
# Download from Apache
wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
tar -xzf apache-jmeter-5.6.3.tgz
cd apache-jmeter-5.6.3/bin

# Run JMeter GUI
./jmeter

# Run JMeter CLI
./jmeter -n -t test-plan.jmx -l results.jtl
```

### Verify Installation

```bash
jmeter --version
# Apache JMeter 5.6.3
```

## Getting Started

### 1. Launch JMeter GUI

```bash
jmeter
```

### 2. Create Test Plan

A basic test plan consists of:
- **Thread Group** - Simulates users
- **Sampler** - Makes requests (HTTP, JDBC, FTP, etc.)
- **Listener** - Collects and displays results
- **Assertion** - Validates responses

### 3. Run Test

**GUI Mode (for test creation):**
```bash
jmeter -t test-plan.jmx
```

**CLI Mode (for actual testing):**
```bash
jmeter -n -t test-plan.jmx -l results.jtl -e -o reports/
```

## Test Plan Templates

See the `test-plans/` directory for ready-to-use templates:

### 1. [Simple HTTP Test](./test-plans/01-simple-http-test.jmx)
Basic HTTP GET request with assertions.

**Configuration:**
- 10 users
- 5 second ramp-up
- Single HTTP request
- Response time assertion

**Run:**
```bash
jmeter -n -t test-plans/01-simple-http-test.jmx -l results/simple-http.jtl -e -o reports/simple-http/
```

### 2. [REST API Load Test](./test-plans/02-rest-api-load-test.jmx)
Comprehensive REST API testing with multiple endpoints.

**Features:**
- POST, GET, PUT, DELETE operations
- JSON assertions
- Response time checks
- Throughput measurement

**Run:**
```bash
jmeter -n -t test-plans/02-rest-api-load-test.jmx -l results/api-load.jtl -e -o reports/api-load/
```

### 3. [Stress Test](./test-plans/03-stress-test.jmx)
Gradually increase load to find breaking point.

**Configuration:**
- Start: 10 users
- Peak: 100 users
- Ramp-up: 5 minutes
- Hold: 10 minutes
- Ramp-down: 2 minutes

**Run:**
```bash
jmeter -n -t test-plans/03-stress-test.jmx -l results/stress.jtl -e -o reports/stress/
```

### 4. [Database Performance Test](./test-plans/04-database-test.jmx)
Test database queries and connections.

**Features:**
- JDBC connection pooling
- Multiple query types (SELECT, INSERT, UPDATE)
- Transaction per second measurement
- Connection timeout handling

**Run:**
```bash
jmeter -n -t test-plans/04-database-test.jmx -l results/db-test.jtl -e -o reports/db-test/
```

### 5. [Distributed Load Test](./test-plans/05-distributed-test.jmx)
Template for distributed testing across multiple servers.

**Run:**
```bash
# Start remote servers first
jmeter-server

# Run from master
jmeter -n -t test-plans/05-distributed-test.jmx -R server1,server2,server3 -l results/distributed.jtl
```

## JMeter Components

### Thread Groups

```xml
<ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Users">
  <stringProp name="ThreadGroup.num_threads">10</stringProp>
  <stringProp name="ThreadGroup.ramp_time">5</stringProp>
  <longProp name="ThreadGroup.duration">60</longProp>
</ThreadGroup>
```

### HTTP Sampler

```xml
<HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="HTTP Request">
  <stringProp name="HTTPSampler.domain">api.example.com</stringProp>
  <stringProp name="HTTPSampler.port">443</stringProp>
  <stringProp name="HTTPSampler.protocol">https</stringProp>
  <stringProp name="HTTPSampler.path">/api/users</stringProp>
  <stringProp name="HTTPSampler.method">GET</stringProp>
</HTTPSamplerProxy>
```

### Assertions

```xml
<ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="Status Code 200">
  <stringProp name="Assertion.test_field">Assertion.response_code</stringProp>
  <stringProp name="Assertion.test_type">8</stringProp>
  <stringProp name="Assertion.test_string">200</stringProp>
</ResponseAssertion>
```

## CLI Commands

### Basic Test Execution

```bash
# Run test plan
jmeter -n -t test-plan.jmx -l results.jtl

# Run with HTML report
jmeter -n -t test-plan.jmx -l results.jtl -e -o reports/

# Run with property override
jmeter -n -t test-plan.jmx -l results.jtl -Jusers=50 -Jduration=300
```

### Distributed Testing

```bash
# Start remote server (on each server)
jmeter-server

# Run from master
jmeter -n -t test-plan.jmx -R server1,server2,server3 -l results.jtl

# Run all configured servers
jmeter -n -t test-plan.jmx -r -l results.jtl
```

### Results Analysis

```bash
# Generate report from existing results
jmeter -g results.jtl -o reports/

# Combine multiple result files
cat results1.jtl results2.jtl > combined.jtl
```

## Properties and Variables

### User Defined Variables

```properties
# In test plan
users=10
rampup=5
duration=60
host=api.example.com
```

### Command Line Properties

```bash
# Override in CLI
jmeter -n -t test.jmx -Jusers=50 -Jhost=api.staging.com
```

### Property File

**user.properties:**
```properties
users=10
threads=10
rampup=5
duration=300
target.host=api.example.com
target.port=443
```

**Usage:**
```bash
jmeter -n -t test.jmx -p user.properties
```

## Plugins

### JMeter Plugins Manager

```bash
# Download Plugins Manager
wget https://jmeter-plugins.org/get/ -O PluginsManager.jar
mv PluginsManager.jar $JMETER_HOME/lib/ext/

# Install via GUI: Options → Plugins Manager
```

### Essential Plugins

1. **PerfMon (Server Monitoring)**
   - Monitor server CPU, Memory, Network
   - Real-time metrics during test

2. **Custom Thread Groups**
   - Ultimate Thread Group (advanced scenarios)
   - Stepping Thread Group (gradual load)
   - Concurrency Thread Group

3. **3 Basic Graphs**
   - Response Times Over Time
   - Transactions per Second
   - Active Threads Over Time

4. **JSON Plugins**
   - JSON Path Extractor
   - JSON Path Assertion
   - JSON Formatter

### Install Plugins via CLI

```bash
# Using Plugin Manager CLI
java -jar cmdrunner-2.3.jar --tool org.jmeterplugins.repository.PluginManagerCMD install jpgc-graphs-basic
```

## Best Practices

### Test Design

1. **Don't use GUI mode for load testing** - Only for test creation
2. **Use CSV Data Config** for parameterization
3. **Add think time** between requests (realistic user behavior)
4. **Use connection pooling** for database tests
5. **Extract and reuse** session tokens and dynamic data

### Performance Optimization

```properties
# jmeter.properties optimizations
jmeter.save.saveservice.output_format=csv
jmeter.save.saveservice.assertion_results=none
jmeter.save.saveservice.bytes=false
summariser.interval=30
```

### Resource Management

```bash
# Increase heap size
export HEAP="-Xms1g -Xmx4g -XX:MaxMetaspaceSize=256m"
jmeter -n -t test.jmx
```

## CI/CD Integration

### Jenkins Integration

**Jenkinsfile:**
```groovy
pipeline {
    agent any

    stages {
        stage('Performance Test') {
            steps {
                sh '''
                    jmeter -n -t test-plan.jmx \
                           -l results.jtl \
                           -e -o reports/
                '''
            }
        }

        stage('Publish Results') {
            steps {
                perfReport sourceDataFiles: 'results.jtl'
                publishHTML([
                    reportDir: 'reports',
                    reportFiles: 'index.html',
                    reportName: 'JMeter Report'
                ])
            }
        }
    }
}
```

### GitHub Actions

**workflow.yml:**
```yaml
name: Performance Test

on: [push]

jobs:
  performance:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Install JMeter
        run: |
          wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
          tar -xzf apache-jmeter-5.6.3.tgz
          echo "$PWD/apache-jmeter-5.6.3/bin" >> $GITHUB_PATH

      - name: Run Tests
        run: |
          jmeter -n -t test-plan.jmx -l results.jtl -e -o reports/

      - name: Upload Results
        uses: actions/upload-artifact@v3
        with:
          name: jmeter-results
          path: reports/
```

### GitLab CI

**.gitlab-ci.yml:**
```yaml
performance:
  image: justb4/jmeter:5.5
  script:
    - jmeter -n -t test-plan.jmx -l results.jtl -e -o reports/
  artifacts:
    paths:
      - reports/
    expire_in: 1 week
```

### Docker

**Dockerfile:**
```dockerfile
FROM alpine:latest

# Install Java and dependencies
RUN apk add --no-cache openjdk11 wget unzip

# Install JMeter
ENV JMETER_VERSION=5.6.3
RUN wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -xzf apache-jmeter-${JMETER_VERSION}.tgz && \
    rm apache-jmeter-${JMETER_VERSION}.tgz && \
    ln -s /apache-jmeter-${JMETER_VERSION}/bin/jmeter /usr/local/bin/jmeter

WORKDIR /tests
COPY test-plans/ /tests/

ENTRYPOINT ["jmeter"]
```

**Usage:**
```bash
# Build
docker build -t my-jmeter .

# Run
docker run -v $(pwd)/results:/results my-jmeter \
  -n -t test-plan.jmx -l /results/results.jtl
```

## Report Analysis

### HTML Dashboard

Generated reports include:
- **APDEX** (Application Performance Index)
- **Response Times Percentiles**
- **Throughput** (requests/sec)
- **Error Rate**
- **Statistics** (min, max, avg, std dev)

### Key Metrics

```
Metric              | Target       | Critical
--------------------|--------------|----------
Response Time (avg) | < 500ms      | < 1000ms
Response Time (95%) | < 1000ms     | < 2000ms
Response Time (99%) | < 2000ms     | < 3000ms
Error Rate          | < 1%         | < 5%
Throughput          | > 100 req/s  | > 50 req/s
```

### JMeter Log Analysis

```bash
# View errors
grep "Error" jmeter.log

# Count response codes
grep "responseCode" results.jtl | sort | uniq -c

# Calculate average response time
awk -F',' '{sum+=$2; count++} END {print sum/count}' results.jtl
```

## Troubleshooting

### Common Issues

**Out of Memory:**
```bash
export HEAP="-Xms2g -Xmx8g"
jmeter -n -t test.jmx
```

**Too Many Open Files:**
```bash
ulimit -n 10000
```

**Connection Timeout:**
```properties
# jmeter.properties
httpclient.timeout=60000
http.connection.timeout=30000
```

**Slow GUI:**
- Use CLI mode for tests
- Disable listeners during test
- Use smaller result file format

## Resources

- [Official Documentation](https://jmeter.apache.org/usermanual/)
- [Best Practices](https://jmeter.apache.org/usermanual/best-practices.html)
- [Plugins Website](https://jmeter-plugins.org/)
- [JMeter Academy](https://www.blazemeter.com/jmeter-tutorial)

## Examples Directory

```
jmeter/
├── README.md (this file)
├── test-plans/
│   ├── 01-simple-http-test.jmx
│   ├── 02-rest-api-load-test.jmx
│   ├── 03-stress-test.jmx
│   ├── 04-database-test.jmx
│   └── 05-distributed-test.jmx
├── plugins/
│   └── recommended-plugins.txt
└── scripts/
    ├── run-test.sh
    ├── generate-report.sh
    └── distributed-setup.sh
```

## Next Steps

1. Install JMeter
2. Explore test plan templates
3. Customize for your application
4. Run in non-GUI mode
5. Analyze results
6. Integrate into CI/CD
7. Set up distributed testing for large loads

## Support

For issues and questions:
- [JMeter User Mailing List](https://jmeter.apache.org/mail2.html)
- [Stack Overflow - JMeter Tag](https://stackoverflow.com/questions/tagged/jmeter)
- [GitHub Issues](https://github.com/apache/jmeter/issues)

