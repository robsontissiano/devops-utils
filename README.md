# DevOps Utilities, Templates, and Tools 🚀

A centralized repository for DevOps utilities, commands, templates, and best practices. This collection is organized into 8 core categories covering the complete DevOps lifecycle.

## 📚 Table of Contents

- [Quick Start](#quick-start)
- [1. Containerization](#1-containerization)
- [2. Infrastructure](#2-infrastructure)
- [3. Monitoring](#3-monitoring)
- [4. CI/CD](#4-cicd)
- [5. Config Management](#5-config-management)
- [6. Secret Management](#6-secret-management)
- [7. Testing](#7-testing)
- [8. Cloud CLI](#8-cloud-cli)
- [Repository Structure](#-repository-structure)
- [Best Practices](#-best-practices)
- [Contributing](#-contributing)

## 🚀 Quick Start

### Clone the Repository
```bash
git clone https://github.com/yourusername/devops-utils.git
cd devops-utils
```

### Load Shell Aliases
```bash
# For Zsh
echo "source $(pwd)/8-cloud-cli/shell-profiles/devops-aliases.sh" >> ~/.zshrc
source ~/.zshrc

# For Bash
echo "source $(pwd)/8-cloud-cli/shell-profiles/devops-aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

## 📋 Category Overview

This repository is organized into 8 core DevOps categories:

| Category | Status | Tools Included |
|----------|--------|----------------|
| **1. Containerization** | ✅ Complete | Docker, Kubernetes |
| **2. Infrastructure** | ✅ Complete | Terraform, Pulumi |
| **3. Monitoring** | ✅ Complete | Prometheus+Grafana, Zabbix, ELK, Netdata |
| **4. CI/CD** | ✅ Complete | GitHub Actions, Jenkins, GitLab CI, AWS CodePipeline, ArgoCD |
| **5. Config Management** | 🔜 Planned | Ansible, Chef, Puppet, SaltStack |
| **6. Secret Management** | 🔜 Planned | Vault, AWS Secrets Manager, Sealed Secrets |
| **7. Testing** | 🔜 Planned | k6, Trivy, Terratest, Checkov, OWASP ZAP |
| **8. Cloud CLI** | ✅ Complete | AWS, Azure, GCP, Shell Profiles |

---

## 🛠️ DevOps Toolkit by Category

### 1. Containerization

Container technologies for packaging, distributing, and running applications.

#### [Docker](./1-containerization/docker/) - Container Platform
Comprehensive Docker commands, one-liners, and container management utilities.

**Topics Covered:**
- Container lifecycle management
- Image building and management
- Docker Compose workflows
- Networking and volumes
- Cleanup and maintenance scripts

**Essential One-Liners:**
```bash
# Stop and remove all containers
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)

# Complete rebuild workflow
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker-compose build; docker-compose up -d
```

[View Docker Guide →](./1-containerization/docker/README.md)

#### [Kubernetes](./1-containerization/kubernetes/) - Container Orchestration
Complete Kubernetes commands and best practices for container orchestration.

**Topics Covered:**
- kubectl commands and workflows
- Pod, Service, and Deployment management
- ConfigMaps and Secrets
- Monitoring and Scaling (HPA)
- Multi-cluster management

[View Kubernetes Guide →](./1-containerization/kubernetes/README.md)

---

### 2. Infrastructure

Infrastructure as Code (IaC) tools for provisioning and managing cloud resources.

#### [Terraform](./2-infrastructure/terraform/) - HashiCorp IaC
Industry-standard infrastructure as code using HCL (HashiCorp Configuration Language).

**Topics Covered:**
- Terraform workflow (init, plan, apply)
- State management and backends
- Workspace and module management
- Multi-cloud deployments
- Best practices and security

[View Terraform Guide →](./2-infrastructure/terraform/README.md)

#### [Pulumi](./2-infrastructure/pulumi/) - Modern IaC
Infrastructure as code using real programming languages (TypeScript, Python, Go, C#).

**Topics Covered:**
- Project and stack management
- Multi-language support
- AWS, Azure, and Kubernetes deployments
- Policy as Code with CrossGuard
- Infrastructure testing

[View Pulumi Guide →](./2-infrastructure/pulumi/README.md)

---

### 3. Monitoring

Observability solutions for metrics, logs, and application performance monitoring.

#### [Monitoring Solutions](./3-monitoring/monitoring/)
Comprehensive collection of open-source monitoring tools.

**Available Solutions:**
- **Prometheus + Grafana** ⭐ - Modern metrics and dashboards (Recommended)
- **Zabbix** - Enterprise monitoring with agent-based approach
- **ELK Stack** - Centralized logging (Elasticsearch, Logstash, Kibana)
- **Netdata** - Real-time performance monitoring

**Features:**
- Metrics collection and visualization
- Log aggregation and analysis
- Alerting and notifications
- Container and Kubernetes monitoring
- Infrastructure and application monitoring

[View Monitoring Guide →](./3-monitoring/monitoring/README.md)

---

### 4. CI/CD

Continuous Integration and Continuous Deployment pipelines for automated software delivery.

#### [CI/CD Pipelines](./4-ci-cd/ci-cd/)
Complete collection of CI/CD tools and templates for every use case.

**Available Solutions:**
- **GitHub Actions** ⭐ - Cloud-native CI/CD for GitHub (Most Popular)
- **Jenkins** - Self-hosted automation server (1500+ plugins)
- **GitLab CI** - Built-in CI/CD for GitLab
- **AWS CodePipeline** - AWS-native CI/CD service
- **ArgoCD** - GitOps for Kubernetes

**Features:**
- Automated build, test, and deployment
- Docker image creation and registry push
- Multi-cloud deployments (AWS, Azure, GCP)
- Kubernetes deployments
- Infrastructure as Code pipelines
- Security scanning and compliance

**What's Included:**
- Production-ready pipeline templates
- Multi-environment configurations
- Terraform/Pulumi integration
- Secret management integration
- Deployment strategies (blue/green, canary)

[View CI/CD Guide →](./4-ci-cd/ci-cd/README.md)

---

### 5. Config Management

**Coming Soon** - Configuration management and automation tools.

**Planned Tools:**
- Ansible - Agentless automation and configuration management
- Chef - Infrastructure automation
- Puppet - Configuration management at scale
- SaltStack - Event-driven automation

---

### 6. Secret Management

**Coming Soon** - Secure storage and management of sensitive credentials.

**Planned Tools:**
- HashiCorp Vault - Secrets management platform
- AWS Secrets Manager - AWS-native secrets storage
- Azure Key Vault - Azure secrets management
- Google Secret Manager - GCP secrets storage
- SOPS - Encrypted secrets in Git
- Sealed Secrets - Kubernetes-native secrets

---

### 7. Testing

**Coming Soon** - Testing tools for infrastructure, security, and performance.

**Planned Tools:**
- k6 - Load and performance testing
- Trivy - Container security scanning
- Terratest - Infrastructure testing
- Checkov - IaC security scanning
- OWASP ZAP - Security testing
- Selenium - Browser automation

---

### 8. Cloud CLI

Cloud platform command-line interfaces and productivity shortcuts.

#### [AWS (Amazon Web Services)](./8-cloud-cli/aws/)
Comprehensive AWS CLI commands and utilities.

**Topics Covered:**
- EC2, S3, RDS, Lambda management
- ECS/EKS container services
- IAM and security
- VPC networking
- CloudFormation and CloudWatch

[View AWS Guide →](./8-cloud-cli/aws/README.md)

#### [Azure](./8-cloud-cli/azure/)
Complete Azure CLI commands and utilities.

**Topics Covered:**
- Virtual Machines and App Services
- AKS and Azure Container Registry
- Azure SQL and Functions
- Key Vault and Azure AD
- RBAC and networking

[View Azure Guide →](./8-cloud-cli/azure/README.md)

#### [Google Cloud Platform (GCP)](./8-cloud-cli/gcp/)
Complete gcloud CLI commands and utilities.

**Topics Covered:**
- Compute Engine and GKE
- Cloud Storage and Cloud SQL
- Cloud Functions and Cloud Run
- IAM and networking
- Logging and monitoring

[View GCP Guide →](./8-cloud-cli/gcp/README.md)

#### [Shell Profiles and Aliases](./8-cloud-cli/shell-profiles/)
Productivity-boosting shell aliases and functions for all DevOps tools.

**Features:**
- Docker, Kubernetes, Terraform shortcuts
- AWS, Azure, GCP quick commands
- Git workflow helpers
- Custom utility functions

**Quick Examples:**
```bash
# Docker shortcuts
dclean          # Stop and remove all containers
dcrestart       # Full cleanup, rebuild, and restart

# Kubernetes shortcuts
kgp             # Get pods
kex <pod>       # Exec into pod

# Cloud shortcuts
ec2ls           # List AWS EC2 instances
azls            # List Azure VMs
gcls            # List GCP instances
```

[View Shell Profiles Guide →](./8-cloud-cli/shell-profiles/README.md)

## 📂 Repository Structure

Organized by 8 core DevOps categories with numbered folders:

```
devops-utils/
├── README.md                           # This file
│
├── 1-containerization/                 # Category 1: Containerization
│   ├── docker/                         # Docker commands and utilities
│   │   └── README.md
│   └── kubernetes/                     # Kubernetes orchestration
│       └── README.md
│
├── 2-infrastructure/                   # Category 2: Infrastructure
│   ├── terraform/                      # HashiCorp Terraform IaC
│   │   └── README.md
│   └── pulumi/                         # Pulumi modern IaC
│       └── README.md
│
├── 3-monitoring/                       # Category 3: Monitoring
│   └── monitoring/                     # All monitoring solutions
│       ├── README.md
│       ├── prometheus-grafana/         # Metrics and dashboards
│       ├── zabbix/                     # Enterprise monitoring
│       ├── elk-stack/                  # Centralized logging
│       └── netdata/                    # Real-time monitoring
│
├── 4-ci-cd/                           # Category 4: CI/CD
│   └── ci-cd/                         # All CI/CD pipelines
│       ├── README.md
│       ├── github-actions/            # GitHub Actions workflows
│       ├── jenkins/                   # Jenkins pipelines
│       ├── gitlab-ci/                 # GitLab CI templates
│       ├── aws-codepipeline/          # AWS CodePipeline
│       └── argocd/                    # GitOps for Kubernetes
│
├── 5-config-management/               # Category 5: Config Management
│   └── (Coming Soon: Ansible, Chef, Puppet)
│
├── 6-secret-management/               # Category 6: Secret Management
│   └── (Coming Soon: Vault, Secrets Manager)
│
├── 7-testing/                         # Category 7: Testing
│   └── (Coming Soon: k6, Trivy, Terratest)
│
└── 8-cloud-cli/                       # Category 8: Cloud CLI
    ├── aws/                           # AWS CLI utilities
    │   └── README.md
    ├── azure/                         # Azure CLI utilities
    │   └── README.md
    ├── gcp/                           # Google Cloud Platform
    │   └── README.md
    ├── shell-profiles/                # Shell aliases and functions
    │   ├── README.md
    │   └── devops-aliases.sh
    └── scripts/                       # Utility scripts
```

## 🔧 Common Tasks

### Docker Cleanup Workflow

Stop all containers, remove them, rebuild, and start fresh:
```bash
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker-compose build; docker-compose up -d
```

Or use the alias:
```bash
dcrestart
```

### Kubernetes Quick Deploy

Apply a configuration and watch the rollout:
```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/my-app
kubectl get pods -w
```

Or with aliases:
```bash
ka deployment.yaml
k rollout status deployment/my-app
kgp -w
```

### Terraform Workflow

Initialize, validate, plan, and apply:
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Or use aliases:
```bash
tfi && tfv && tfp && tfa
```

### AWS EC2 Management

List, start, and connect to instances:
```bash
# List running instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Start instance
aws ec2 start-instances --instance-ids i-xxxxx

# Connect via SSM (no SSH keys needed)
aws ssm start-session --target i-xxxxx
```

### Azure Resource Management

List and manage resources:
```bash
# List all resource groups
az group list --output table

# List all VMs
az vm list --output table

# Start/stop VM
az vm start --resource-group myRG --name myVM
az vm stop --resource-group myRG --name myVM
```

## 💡 Best Practices

### Security
- ✅ Use IAM roles and managed identities instead of access keys
- ✅ Enable MFA for sensitive operations
- ✅ Store secrets in Key Vault/Secrets Manager
- ✅ Implement least privilege access
- ✅ Regularly rotate credentials
- ✅ Use private networks and security groups

### Infrastructure as Code
- ✅ Version control all IaC configurations
- ✅ Use remote state backends with locking
- ✅ Implement code review processes
- ✅ Test infrastructure changes in staging first
- ✅ Tag all resources for cost tracking
- ✅ Document your infrastructure

### Container Management
- ✅ Use specific image tags, not `latest`
- ✅ Implement health checks
- ✅ Set resource limits
- ✅ Use multi-stage builds
- ✅ Scan images for vulnerabilities
- ✅ Clean up unused resources regularly

### Monitoring and Logging
- ✅ Enable centralized logging
- ✅ Set up alerts for critical metrics
- ✅ Monitor resource utilization
- ✅ Implement distributed tracing
- ✅ Regular log rotation
- ✅ Audit trail for all changes

## 🎯 Quick Reference by Category

### 1. Containerization

| Task | Command | Alias |
|------|---------|-------|
| List Docker containers | `docker ps -a` | `dpsa` |
| Stop all containers | `docker stop $(docker ps -a -q)` | `dstop` |
| Clean rebuild Docker | Full cleanup + rebuild | `dcrestart` |
| List Kubernetes pods | `kubectl get pods` | `kgp` |
| Exec into pod | `kubectl exec -it <pod> -- bash` | `kex <pod>` |
| Follow pod logs | `kubectl logs -f <pod>` | `klogs <pod>` |

### 2. Infrastructure

| Task | Command | Alias |
|------|---------|-------|
| Terraform init | `terraform init` | `tfi` |
| Terraform plan | `terraform plan` | `tfp` |
| Terraform apply | `terraform apply` | `tfa` |
| Terraform destroy | `terraform destroy` | `tfd` |
| Pulumi preview | `pulumi preview` | `pp` |
| Pulumi up | `pulumi up` | `pu` |

### 3. Monitoring

| Task | Tool | Access |
|------|------|--------|
| Metrics & Dashboards | Prometheus + Grafana | http://localhost:3000 |
| Enterprise Monitoring | Zabbix | http://localhost:8080 |
| Log Analysis | ELK Stack | http://localhost:5601 |
| Real-time Monitoring | Netdata | http://localhost:19999 |

### 4. CI/CD

| Tool | Quick Start | Port |
|------|-------------|------|
| GitHub Actions | Push `.github/workflows/*.yml` | N/A (Cloud) |
| Jenkins | `docker-compose up` in `ci-cd/jenkins/` | http://localhost:8080 |
| GitLab CI | Push `.gitlab-ci.yml` | N/A (Cloud) |
| AWS CodePipeline | `terraform apply` in terraform/ | AWS Console |
| ArgoCD | `kubectl apply -f application.yaml` | http://localhost:8080 |

### 8. Cloud CLI

| Task | AWS | Azure | GCP |
|------|-----|-------|-----|
| List VMs | `aws ec2 describe-instances` | `az vm list` | `gcloud compute instances list` |
| List storage | `aws s3 ls` | `az storage account list` | `gsutil ls` |
| List clusters | `aws eks list-clusters` | `az aks list` | `gcloud container clusters list` |
| Alias | `ec2ls` | `azls` | `gcls` |

## 📖 Learning Resources

### Official Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Pulumi Documentation](https://www.pulumi.com/docs/)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Google Cloud Documentation](https://cloud.google.com/docs)

### Tutorials and Guides
- [Kubernetes By Example](https://kubernetesbyexample.com/)
- [Docker Hub](https://hub.docker.com/)
- [Terraform Registry](https://registry.terraform.io/)
- [Pulumi Examples](https://github.com/pulumi/examples)
- [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)
- [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Guidelines
1. Follow the existing structure and format
2. Add examples for new commands
3. Update the main README if adding new sections
4. Test all commands before submitting
5. Add comments for complex operations

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🌟 Support

If you find this repository helpful, please give it a star! ⭐

## 📬 Contact

For questions, suggestions, or issues, please open an issue in this repository.

---

**Happy DevOps-ing! 🚀**
