# Terraform Utilities and Commands

A comprehensive guide to Terraform commands, best practices, and useful templates for infrastructure as code.

## Essential Commands

### Initialize Terraform
```bash
terraform init
```
Initializes a Terraform working directory, downloads providers and modules.

### Plan Changes
```bash
terraform plan
```
Creates an execution plan showing what Terraform will do.

### Apply Changes
```bash
terraform apply
```
Applies the changes required to reach the desired state.

### Apply with Auto-Approve
```bash
terraform apply -auto-approve
```
Applies changes without interactive approval prompt.

### Destroy Infrastructure
```bash
terraform destroy
```
Destroys all resources managed by Terraform.

### Destroy with Auto-Approve
```bash
terraform destroy -auto-approve
```
Destroys infrastructure without confirmation prompt.

## Workspace Management

### List Workspaces
```bash
terraform workspace list
```

### Create New Workspace
```bash
terraform workspace new <workspace-name>
```

### Select Workspace
```bash
terraform workspace select <workspace-name>
```

### Delete Workspace
```bash
terraform workspace delete <workspace-name>
```

## State Management

### Show State
```bash
terraform show
```

### List Resources in State
```bash
terraform state list
```

### Show Specific Resource
```bash
terraform state show <resource-address>
```

### Move Resource in State
```bash
terraform state mv <source> <destination>
```

### Remove Resource from State
```bash
terraform state rm <resource-address>
```

### Pull Remote State
```bash
terraform state pull
```

### Push State to Remote
```bash
terraform state push
```

## Validation and Formatting

### Validate Configuration
```bash
terraform validate
```

### Format Configuration Files
```bash
terraform fmt
```

### Format Recursively
```bash
terraform fmt -recursive
```

### Check Format (without modifying)
```bash
terraform fmt -check
```

## Output and Variables

### Show Outputs
```bash
terraform output
```

### Show Specific Output
```bash
terraform output <output-name>
```

### Show Outputs in JSON
```bash
terraform output -json
```

### Set Variables
```bash
terraform apply -var="variable_name=value"
```

### Use Variable File
```bash
terraform apply -var-file="variables.tfvars"
```

## Import and Refresh

### Import Existing Resource
```bash
terraform import <resource-address> <resource-id>
```

### Refresh State
```bash
terraform refresh
```

## Useful One-Liners

### Initialize and Apply in One Go
```bash
terraform init && terraform apply -auto-approve
```

### Plan with Detailed Log
```bash
TF_LOG=DEBUG terraform plan
```

### Save Plan to File
```bash
terraform plan -out=tfplan
```

### Apply from Saved Plan
```bash
terraform apply tfplan
```

### Destroy Specific Resource
```bash
terraform destroy -target=<resource-address>
```

### Apply Specific Resource
```bash
terraform apply -target=<resource-address>
```

### Format and Validate
```bash
terraform fmt -recursive && terraform validate
```

## Advanced Commands

### Graph Dependencies
```bash
terraform graph | dot -Tpng > graph.png
```

### Taint Resource (mark for recreation)
```bash
terraform taint <resource-address>
```

### Untaint Resource
```bash
terraform untaint <resource-address>
```

### Console (interactive)
```bash
terraform console
```

### Test Configuration
```bash
terraform test
```

## Backend Configuration

### Initialize with Backend Config
```bash
terraform init -backend-config="bucket=my-bucket"
```

### Reconfigure Backend
```bash
terraform init -reconfigure
```

### Migrate State
```bash
terraform init -migrate-state
```

## Example: Basic AWS Infrastructure

```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}
```

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

```hcl
# outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
```

## Example: Remote State Backend (S3)

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

## Example: Module Usage

```hcl
# main.tf
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  environment = "production"
}
```

## Best Practices

1. **Always use version constraints** for providers and modules
2. **Use remote state backend** for team collaboration
3. **Enable state locking** to prevent concurrent modifications
4. **Use workspaces** for environment separation
5. **Store sensitive data in variables** marked as sensitive
6. **Use terraform fmt** before committing code
7. **Run terraform validate** in CI/CD pipeline
8. **Use modules** for reusable components
9. **Document your code** with descriptions
10. **Use .gitignore** to exclude state files and secrets

## Common .gitignore for Terraform

```
# .gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfplan
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
```

## Environment Variables

### AWS Credentials
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Terraform Logging
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log
```

### Terraform Variables
```bash
export TF_VAR_variable_name="value"
```

## Troubleshooting

### Lock Issues
```bash
terraform force-unlock <lock-id>
```

### Upgrade Providers
```bash
terraform init -upgrade
```

### Clean Cache
```bash
rm -rf .terraform/
terraform init
```

### Check Provider Versions
```bash
terraform version
terraform providers
```

