# DevOps Utilities, Templates, and Tools 🚀

A centralized repository for DevOps utilities, commands, templates, and best practices. This collection includes comprehensive guides for Kubernetes, Docker, Terraform, Pulumi, AWS, Azure, Google Cloud Platform (GCP), and more.

## 📚 Table of Contents

- [Quick Start](#quick-start)
- [Available Tools](#available-tools)
- [Shell Profiles](#shell-profiles)
- [Contributing](#contributing)
- [License](#license)

## 🚀 Quick Start

### Clone the Repository
```bash
git clone https://github.com/yourusername/devops-utils.git
cd devops-utils
```

### Load Shell Aliases
```bash
# For Zsh
echo "source $(pwd)/shell-profiles/devops-aliases.sh" >> ~/.zshrc
source ~/.zshrc

# For Bash
echo "source $(pwd)/shell-profiles/devops-aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

## 🛠️ Available Tools

### Container Orchestration

#### [Kubernetes](./kubernetes/)
Complete Kubernetes commands and best practices for container orchestration.

**Topics Covered:**
- Basic kubectl commands
- Pod, Service, and Deployment management
- ConfigMaps and Secrets
- Monitoring and Scaling
- Horizontal Pod Autoscaler (HPA)
- Context and namespace management

[View Kubernetes Guide →](./kubernetes/README.md)

#### [Docker](./docker/)
Comprehensive Docker commands, one-liners, and container management utilities.

**Topics Covered:**
- Container lifecycle management
- Image building and management
- Docker Compose workflows
- Networking and volumes
- Cleanup and maintenance scripts
- Advanced debugging techniques

**Essential One-Liners:**
```bash
# Stop and remove all containers
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)

# Complete rebuild workflow
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker-compose build; docker-compose up -d
```

[View Docker Guide →](./docker/README.md)

### Infrastructure as Code

#### [Terraform](./terraform/)
Terraform commands, templates, and best practices for infrastructure management.

**Topics Covered:**
- Basic Terraform workflow
- Workspace management
- State management and backends
- Module creation and usage
- AWS, Azure, and multi-cloud examples
- Best practices and security

[View Terraform Guide →](./terraform/README.md)

#### [Pulumi](./pulumi/)
Modern infrastructure as code using real programming languages (TypeScript, Python, Go, C#).

**Topics Covered:**
- Project initialization and management
- Stack and configuration management
- Multi-language examples (TypeScript, Python)
- AWS, Azure, and Kubernetes deployments
- Policy as Code with CrossGuard
- Testing infrastructure code

[View Pulumi Guide →](./pulumi/README.md)

### Cloud Platforms

#### [AWS (Amazon Web Services)](./aws/)
Comprehensive AWS CLI commands and utilities for cloud resource management.

**Topics Covered:**
- EC2 instance management
- S3 storage operations
- IAM user and role management
- RDS database operations
- Lambda functions
- ECS/EKS container services
- CloudFormation stacks
- CloudWatch logs and monitoring
- VPC networking
- Route53 DNS management

[View AWS Guide →](./aws/README.md)

#### [Azure](./azure/)
Complete Azure CLI commands and utilities for Microsoft Azure cloud.

**Topics Covered:**
- Virtual Machine management
- Storage Account operations
- App Services deployment
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure SQL Database
- Azure Functions
- Virtual Networks and NSGs
- Key Vault secrets management
- Azure AD / Entra ID
- RBAC and security

[View Azure Guide →](./azure/README.md)

#### [Google Cloud Platform (GCP)](./gcp/)
Complete gcloud CLI commands and utilities for Google Cloud.

**Topics Covered:**
- Compute Engine VM management
- Google Kubernetes Engine (GKE)
- Cloud Storage (GCS) operations
- Cloud SQL databases
- Cloud Functions serverless
- Cloud Run containers
- App Engine applications
- Cloud Build CI/CD
- Container/Artifact Registry
- IAM and service accounts
- VPC networking and firewall rules
- Cloud DNS management
- Secret Manager
- Logging and monitoring

[View GCP Guide →](./gcp/README.md)

### Shell Utilities

#### [Shell Profiles and Aliases](./shell-profiles/)
Productivity-boosting shell aliases, functions, and shortcuts for DevOps workflows.

**Topics Covered:**
- Docker aliases and functions
- Kubernetes shortcuts
- Git workflow helpers
- Terraform quick commands
- AWS and Azure CLI shortcuts
- System navigation and monitoring
- Custom utility functions

**Quick Examples:**
```bash
# Docker shortcuts
dclean          # Stop and remove all containers
dcrestart       # Full cleanup, rebuild, and restart
dclogs          # Follow compose logs

# Kubernetes shortcuts
kgp             # Get pods
kex <pod>       # Exec into pod
klogs <pod>     # Follow pod logs

# Terraform shortcuts
tfi             # Terraform init
tfa             # Terraform apply
tfv             # Terraform validate
```

[View Shell Profiles Guide →](./shell-profiles/README.md)

## 📂 Repository Structure

```
devops-utils/
├── README.md                       # This file
├── kubernetes/                     # Kubernetes utilities
│   └── README.md
├── docker/                         # Docker utilities
│   └── README.md
├── terraform/                      # Terraform templates
│   └── README.md
├── pulumi/                         # Pulumi templates
│   └── README.md
├── aws/                           # AWS CLI utilities
│   └── README.md
├── azure/                         # Azure CLI utilities
│   └── README.md
├── gcp/                           # Google Cloud Platform utilities
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

## 🎯 Quick Reference

### Most Used Commands

| Task | Command | Alias |
|------|---------|-------|
| List Docker containers | `docker ps -a` | `dpsa` |
| Stop all containers | `docker stop $(docker ps -a -q)` | `dstop` |
| Clean rebuild Docker | Full cleanup + rebuild | `dcrestart` |
| List Kubernetes pods | `kubectl get pods` | `kgp` |
| Exec into pod | `kubectl exec -it <pod> -- bash` | `kex <pod>` |
| Terraform apply | `terraform apply` | `tfa` |
| Terraform plan | `terraform plan` | `tfp` |
| Git status | `git status` | `gs` |
| Git commit & push | `git add . && git commit -m "msg" && git push` | `gcp "msg"` |
| List AWS EC2 | `aws ec2 describe-instances` | `ec2ls` |
| List Azure VMs | `az vm list` | `azvm list` |
| List GCP instances | `gcloud compute instances list` | `gcpls` |

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
