# AWS CLI Utilities and Commands

A comprehensive collection of AWS CLI commands and utilities for managing cloud resources.

## Prerequisites

### Install AWS CLI
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Windows
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

### Configure AWS CLI
```bash
aws configure
```

## EC2 Commands

### List EC2 Instances
```bash
aws ec2 describe-instances
```

### List Running Instances
```bash
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"
```

### Start Instance
```bash
aws ec2 start-instances --instance-ids <instance-id>
```

### Stop Instance
```bash
aws ec2 stop-instances --instance-ids <instance-id>
```

### Terminate Instance
```bash
aws ec2 terminate-instances --instance-ids <instance-id>
```

### Create EC2 Instance
```bash
aws ec2 run-instances \
  --image-id ami-xxxxx \
  --instance-type t3.micro \
  --key-name my-key \
  --security-group-ids sg-xxxxx \
  --subnet-id subnet-xxxxx
```

### List AMIs
```bash
aws ec2 describe-images --owners self
```

### Create AMI from Instance
```bash
aws ec2 create-image \
  --instance-id <instance-id> \
  --name "My-AMI" \
  --description "My AMI description"
```

## S3 Commands

### List Buckets
```bash
aws s3 ls
```

### List Bucket Contents
```bash
aws s3 ls s3://bucket-name/
```

### Create Bucket
```bash
aws s3 mb s3://bucket-name
```

### Remove Bucket
```bash
aws s3 rb s3://bucket-name
```

### Remove Bucket with Contents
```bash
aws s3 rb s3://bucket-name --force
```

### Copy File to S3
```bash
aws s3 cp file.txt s3://bucket-name/
```

### Copy from S3 to Local
```bash
aws s3 cp s3://bucket-name/file.txt ./
```

### Sync Local to S3
```bash
aws s3 sync ./local-folder s3://bucket-name/folder/
```

### Sync S3 to Local
```bash
aws s3 sync s3://bucket-name/folder/ ./local-folder
```

### Delete File from S3
```bash
aws s3 rm s3://bucket-name/file.txt
```

### Delete Folder from S3
```bash
aws s3 rm s3://bucket-name/folder/ --recursive
```

### Make Bucket Public
```bash
aws s3api put-bucket-acl --bucket bucket-name --acl public-read
```

## IAM Commands

### List Users
```bash
aws iam list-users
```

### Create User
```bash
aws iam create-user --user-name new-user
```

### Delete User
```bash
aws iam delete-user --user-name user-name
```

### List Groups
```bash
aws iam list-groups
```

### Create Group
```bash
aws iam create-group --group-name new-group
```

### Add User to Group
```bash
aws iam add-user-to-group --user-name user-name --group-name group-name
```

### List Roles
```bash
aws iam list-roles
```

### Create Access Key
```bash
aws iam create-access-key --user-name user-name
```

### List Access Keys
```bash
aws iam list-access-keys --user-name user-name
```

### List Policies
```bash
aws iam list-policies
```

### Attach Policy to User
```bash
aws iam attach-user-policy \
  --user-name user-name \
  --policy-arn arn:aws:iam::aws:policy/PolicyName
```

## RDS Commands

### List DB Instances
```bash
aws rds describe-db-instances
```

### Create DB Instance
```bash
aws rds create-db-instance \
  --db-instance-identifier mydbinstance \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password password \
  --allocated-storage 20
```

### Delete DB Instance
```bash
aws rds delete-db-instance \
  --db-instance-identifier mydbinstance \
  --skip-final-snapshot
```

### Create DB Snapshot
```bash
aws rds create-db-snapshot \
  --db-instance-identifier mydbinstance \
  --db-snapshot-identifier mysnapshot
```

### List DB Snapshots
```bash
aws rds describe-db-snapshots
```

### Restore from Snapshot
```bash
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier newdbinstance \
  --db-snapshot-identifier mysnapshot
```

## Lambda Commands

### List Functions
```bash
aws lambda list-functions
```

### Invoke Function
```bash
aws lambda invoke \
  --function-name my-function \
  --payload '{"key":"value"}' \
  response.json
```

### Create Function
```bash
aws lambda create-function \
  --function-name my-function \
  --runtime nodejs18.x \
  --role arn:aws:iam::account-id:role/lambda-role \
  --handler index.handler \
  --zip-file fileb://function.zip
```

### Update Function Code
```bash
aws lambda update-function-code \
  --function-name my-function \
  --zip-file fileb://function.zip
```

### Delete Function
```bash
aws lambda delete-function --function-name my-function
```

### List Layers
```bash
aws lambda list-layers
```

## ECS/EKS Commands

### List ECS Clusters
```bash
aws ecs list-clusters
```

### Describe ECS Service
```bash
aws ecs describe-services \
  --cluster my-cluster \
  --services my-service
```

### Update ECS Service
```bash
aws ecs update-service \
  --cluster my-cluster \
  --service my-service \
  --force-new-deployment
```

### List EKS Clusters
```bash
aws eks list-clusters
```

### Describe EKS Cluster
```bash
aws eks describe-cluster --name my-cluster
```

### Update Kubeconfig for EKS
```bash
aws eks update-kubeconfig --name my-cluster --region us-east-1
```

## CloudFormation Commands

### List Stacks
```bash
aws cloudformation list-stacks
```

### Create Stack
```bash
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --parameters file://parameters.json
```

### Update Stack
```bash
aws cloudformation update-stack \
  --stack-name my-stack \
  --template-body file://template.yaml
```

### Delete Stack
```bash
aws cloudformation delete-stack --stack-name my-stack
```

### Describe Stack
```bash
aws cloudformation describe-stacks --stack-name my-stack
```

### Validate Template
```bash
aws cloudformation validate-template --template-body file://template.yaml
```

## CloudWatch Commands

### List Log Groups
```bash
aws logs describe-log-groups
```

### Get Log Events
```bash
aws logs get-log-events \
  --log-group-name /aws/lambda/my-function \
  --log-stream-name 2023/11/07/[$LATEST]xxxxx
```

### Tail Logs
```bash
aws logs tail /aws/lambda/my-function --follow
```

### Create Log Group
```bash
aws logs create-log-group --log-group-name my-log-group
```

### Delete Log Group
```bash
aws logs delete-log-group --log-group-name my-log-group
```

### List Metrics
```bash
aws cloudwatch list-metrics
```

### Put Metric Data
```bash
aws cloudwatch put-metric-data \
  --namespace MyNamespace \
  --metric-name MyMetric \
  --value 1.0
```

## VPC Commands

### List VPCs
```bash
aws ec2 describe-vpcs
```

### Create VPC
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

### Delete VPC
```bash
aws ec2 delete-vpc --vpc-id vpc-xxxxx
```

### List Subnets
```bash
aws ec2 describe-subnets
```

### Create Subnet
```bash
aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.1.0/24
```

### List Security Groups
```bash
aws ec2 describe-security-groups
```

### Create Security Group
```bash
aws ec2 create-security-group \
  --group-name my-sg \
  --description "My security group" \
  --vpc-id vpc-xxxxx
```

## Route53 Commands

### List Hosted Zones
```bash
aws route53 list-hosted-zones
```

### Create Hosted Zone
```bash
aws route53 create-hosted-zone \
  --name example.com \
  --caller-reference $(date +%s)
```

### List Record Sets
```bash
aws route53 list-resource-record-sets --hosted-zone-id Z123456
```

## Useful One-Liners

### Stop All Running EC2 Instances
```bash
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text | xargs aws ec2 stop-instances --instance-ids
```

### List All S3 Bucket Sizes
```bash
aws s3 ls | awk '{print $3}' | xargs -I {} sh -c 'echo -n "{}: "; aws s3 ls s3://{}/ --recursive --summarize | grep "Total Size" | awk "{print \$3}"'
```

### Delete All Objects in S3 Bucket
```bash
aws s3 rm s3://bucket-name --recursive
```

### List All Public S3 Buckets
```bash
aws s3api list-buckets --query "Buckets[].Name" --output text | \
xargs -I {} aws s3api get-bucket-acl --bucket {} --query "Grants[?Grantee.URI=='http://acs.amazonaws.com/groups/global/AllUsers']" --output text
```

### Get Latest AMI ID
```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query "sort_by(Images, &CreationDate)[-1].ImageId" \
  --output text
```

### List All Lambda Functions with Runtime
```bash
aws lambda list-functions \
  --query "Functions[].{Name:FunctionName,Runtime:Runtime}" \
  --output table
```

### Get Total Cost (Current Month)
```bash
aws ce get-cost-and-usage \
  --time-period Start=$(date -u -d "$(date +%Y-%m-01)" +%Y-%m-%d),End=$(date -u +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost
```

### Find Unused EBS Volumes
```bash
aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query "Volumes[].{ID:VolumeId,Size:Size,Type:VolumeType}" \
  --output table
```

### List All Resources by Tag
```bash
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Environment,Values=production
```

## AWS SSM Commands

### Run Command on EC2
```bash
aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --instance-ids "i-xxxxx" \
  --parameters 'commands=["echo hello"]'
```

### Start Session (SSH alternative)
```bash
aws ssm start-session --target i-xxxxx
```

### List Parameters
```bash
aws ssm describe-parameters
```

### Get Parameter
```bash
aws ssm get-parameter --name /my/parameter --with-decryption
```

### Put Parameter
```bash
aws ssm put-parameter \
  --name /my/parameter \
  --value "myvalue" \
  --type SecureString
```

## Profile and Region Management

### List Profiles
```bash
aws configure list-profiles
```

### Use Specific Profile
```bash
aws s3 ls --profile myprofile
```

### Set Default Region
```bash
aws configure set region us-west-2
```

### Use Specific Region
```bash
aws ec2 describe-instances --region eu-west-1
```

## Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_PROFILE="myprofile"
```

## Output Formats

```bash
# JSON (default)
aws ec2 describe-instances

# Table
aws ec2 describe-instances --output table

# Text
aws ec2 describe-instances --output text

# YAML
aws ec2 describe-instances --output yaml
```

## JQ Query Examples

### Get Instance IDs
```bash
aws ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId'
```

### Get Instance Names and IPs
```bash
aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | "\(.Tags[]|select(.Key=="Name").Value) - \(.PrivateIpAddress)"'
```

## Best Practices

1. **Use IAM roles** instead of access keys when possible
2. **Enable MFA** for sensitive operations
3. **Use AWS SSM Session Manager** instead of SSH
4. **Tag all resources** for better organization and cost tracking
5. **Use AWS CLI profiles** for multiple accounts
6. **Enable CloudTrail** for audit logging
7. **Use AWS Secrets Manager** for sensitive data
8. **Implement least privilege** IAM policies
9. **Regularly rotate access keys**
10. **Use AWS Organizations** for multi-account management

