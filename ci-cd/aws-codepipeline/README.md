# AWS CodePipeline - AWS-Native CI/CD

Fully managed CI/CD service on AWS with native integration for AWS services. Perfect for AWS-centric applications.

## Quick Start

### Prerequisites

- AWS Account
- AWS CLI configured
- Terraform installed (for IaC approach)

### Option 1: Using Terraform (Recommended)

```bash
cd terraform
terraform init
terraform apply
```

### Option 2: Using AWS Console

1. Go to AWS CodePipeline console
2. Click **Create pipeline**
3. Choose source (GitHub, CodeCommit, S3)
4. Add build stage (CodeBuild)
5. Add deploy stage (ECS, Lambda, etc.)
6. Review and create

### Option 3: Using AWS CLI

```bash
aws codepipeline create-pipeline --cli-input-json file://pipeline.json
```

## Terraform Templates

All Terraform configurations are in the `terraform/` directory:

- `main.tf` - Complete pipeline setup
- `codebuild.tf` - CodeBuild project
- `iam.tf` - IAM roles and policies
- `variables.tf` - Configuration variables
- `outputs.tf` - Pipeline outputs

## Pipeline Components

### 1. Source Stage

**GitHub:**
```json
{
  "name": "Source",
  "actions": [{
    "name": "SourceAction",
    "actionTypeId": {
      "category": "Source",
      "owner": "ThirdParty",
      "provider": "GitHub",
      "version": "1"
    },
    "configuration": {
      "Owner": "myuser",
      "Repo": "myrepo",
      "Branch": "main",
      "OAuthToken": "{{resolve:secretsmanager:github-token}}"
    },
    "outputArtifacts": [{"name": "SourceOutput"}]
  }]
}
```

**AWS CodeCommit:**
```json
{
  "name": "Source",
  "actions": [{
    "name": "SourceAction",
    "actionTypeId": {
      "category": "Source",
      "owner": "AWS",
      "provider": "CodeCommit",
      "version": "1"
    },
    "configuration": {
      "RepositoryName": "my-repo",
      "BranchName": "main"
    },
    "outputArtifacts": [{"name": "SourceOutput"}]
  }]
}
```

### 2. Build Stage (CodeBuild)

**buildspec.yml:**
```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $ECR_REPOSITORY:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $ECR_REPOSITORY:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"%s","imageUri":"%s"}]' $CONTAINER_NAME $ECR_REPOSITORY:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
```

### 3. Deploy Stage

**To ECS:**
```json
{
  "name": "Deploy",
  "actions": [{
    "name": "DeployAction",
    "actionTypeId": {
      "category": "Deploy",
      "owner": "AWS",
      "provider": "ECS",
      "version": "1"
    },
    "configuration": {
      "ClusterName": "my-cluster",
      "ServiceName": "my-service",
      "FileName": "imagedefinitions.json"
    },
    "inputArtifacts": [{"name": "BuildOutput"}]
  }]
}
```

**To Lambda:**
```json
{
  "name": "Deploy",
  "actions": [{
    "name": "DeployAction",
    "actionTypeId": {
      "category": "Deploy",
      "owner": "AWS",
      "provider": "Lambda",
      "version": "1"
    },
    "configuration": {
      "FunctionName": "my-function"
    },
    "inputArtifacts": [{"name": "BuildOutput"}]
  }]
}
```

## CodeBuild Projects

### Node.js Build

**buildspec.yml:**
```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
    commands:
      - npm install -g npm@latest

  pre_build:
    commands:
      - echo Installing dependencies...
      - npm ci

  build:
    commands:
      - echo Build started on `date`
      - npm run lint
      - npm test
      - npm run build

  post_build:
    commands:
      - echo Build completed on `date`

artifacts:
  files:
    - '**/*'
  base-directory: dist

cache:
  paths:
    - 'node_modules/**/*'
```

### Python Build

**buildspec.yml:**
```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - pip install --upgrade pip

  pre_build:
    commands:
      - echo Installing dependencies...
      - pip install -r requirements.txt
      - pip install pytest flake8

  build:
    commands:
      - echo Build started on `date`
      - flake8 .
      - pytest

  post_build:
    commands:
      - echo Build completed on `date`

artifacts:
  files:
    - '**/*'

cache:
  paths:
    - '/root/.cache/pip/**/*'
```

### Docker Build and Push to ECR

**buildspec.yml:**
```yaml
version: 0.2

env:
  variables:
    AWS_REGION: us-east-1
    ECR_REPOSITORY: 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp
    IMAGE_TAG: latest

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $ECR_REPOSITORY:latest .
      - docker tag $ECR_REPOSITORY:latest $ECR_REPOSITORY:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $ECR_REPOSITORY:latest
      - docker push $ECR_REPOSITORY:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"my-container","imageUri":"%s"}]' $ECR_REPOSITORY:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files: imagedefinitions.json
```

## Terraform Infrastructure

### Complete Pipeline Example

The `terraform/` directory contains a complete example:

**main.tf** - Creates:
- CodePipeline
- CodeBuild project
- S3 bucket for artifacts
- IAM roles
- CloudWatch log group

**Usage:**
```bash
cd terraform

# Configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

# Apply
terraform init
terraform plan
terraform apply
```

## Manual Approval

Add manual approval step:

```json
{
  "name": "Approval",
  "actions": [{
    "name": "ManualApproval",
    "actionTypeId": {
      "category": "Approval",
      "owner": "AWS",
      "provider": "Manual",
      "version": "1"
    },
    "configuration": {
      "CustomData": "Please review and approve deployment to production",
      "NotificationArn": "arn:aws:sns:region:account:topic"
    }
  }]
}
```

## Notifications

### SNS Integration

```bash
# Create SNS topic
aws sns create-topic --name pipeline-notifications

# Subscribe email
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789:pipeline-notifications \
  --protocol email \
  --notification-endpoint ops@example.com

# Add notification rule
aws codestar-notifications create-notification-rule \
  --name pipeline-notifications \
  --resource arn:aws:codepipeline:us-east-1:123456789:my-pipeline \
  --event-type-ids codepipeline-pipeline-pipeline-execution-failed \
  --targets TargetType=SNS,TargetAddress=arn:aws:sns:us-east-1:123456789:pipeline-notifications
```

## Environment Variables

### In CodeBuild

**buildspec.yml:**
```yaml
env:
  variables:
    NODE_ENV: production
    API_URL: https://api.example.com
  parameter-store:
    DB_PASSWORD: /myapp/db/password
    API_KEY: /myapp/api/key
  secrets-manager:
    GITHUB_TOKEN: github:token
```

### From Systems Manager Parameter Store

```bash
# Store parameter
aws ssm put-parameter \
  --name /myapp/db/password \
  --value "mypassword" \
  --type SecureString

# Use in buildspec.yml
env:
  parameter-store:
    DB_PASSWORD: /myapp/db/password
```

### From Secrets Manager

```bash
# Store secret
aws secretsmanager create-secret \
  --name myapp/api-key \
  --secret-string "my-secret-api-key"

# Use in buildspec.yml
env:
  secrets-manager:
    API_KEY: myapp/api-key:apikey
```

## Cross-Region Deployment

Deploy to multiple regions:

```json
{
  "name": "Deploy",
  "actions": [
    {
      "name": "DeployToUSEast1",
      "actionTypeId": {
        "category": "Deploy",
        "owner": "AWS",
        "provider": "ECS",
        "version": "1"
      },
      "configuration": {
        "ClusterName": "cluster-us-east-1",
        "ServiceName": "my-service"
      },
      "region": "us-east-1"
    },
    {
      "name": "DeployToEUWest1",
      "actionTypeId": {
        "category": "Deploy",
        "owner": "AWS",
        "provider": "ECS",
        "version": "1"
      },
      "configuration": {
        "ClusterName": "cluster-eu-west-1",
        "ServiceName": "my-service"
      },
      "region": "eu-west-1"
    }
  ]
}
```

## Best Practices

### Security
1. Use IAM roles, not access keys
2. Store secrets in Secrets Manager
3. Enable CloudTrail logging
4. Use least privilege IAM policies
5. Encrypt artifacts in S3

### Performance
1. Use caching in CodeBuild
2. Parallelize independent stages
3. Use appropriate instance types
4. Optimize Docker layers
5. Clean up old artifacts

### Cost Optimization
1. Use appropriate build compute types
2. Enable artifact lifecycle policies
3. Use caching to reduce build time
4. Monitor pipeline execution costs
5. Delete unused pipelines

## Monitoring

### CloudWatch Metrics

```bash
# Pipeline execution metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/CodePipeline \
  --metric-name PipelineExecutionTime \
  --dimensions Name=PipelineName,Value=my-pipeline \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-31T23:59:59Z \
  --period 3600 \
  --statistics Average
```

### CloudWatch Alarms

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name pipeline-failures \
  --alarm-description "Alert on pipeline failures" \
  --metric-name PipelineExecutionFailure \
  --namespace AWS/CodePipeline \
  --statistic Sum \
  --period 300 \
  --evaluation-periods 1 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions arn:aws:sns:us-east-1:123456789:alerts
```

## Troubleshooting

### Pipeline Execution Failed

Check:
- CloudWatch Logs for CodeBuild
- IAM permissions
- Source repository access
- Artifact bucket permissions

### CodeBuild Fails

```bash
# View build logs
aws codebuild batch-get-builds --ids <build-id>

# Check CloudWatch Logs
aws logs tail /aws/codebuild/my-project --follow
```

### Deployment Fails

Check:
- ECS task definition
- Container image exists in ECR
- Security group rules
- Target group health

## CLI Commands

```bash
# List pipelines
aws codepipeline list-pipelines

# Get pipeline details
aws codepipeline get-pipeline --name my-pipeline

# Start pipeline execution
aws codepipeline start-pipeline-execution --name my-pipeline

# Get execution status
aws codepipeline get-pipeline-execution \
  --pipeline-name my-pipeline \
  --pipeline-execution-id <execution-id>

# Stop pipeline execution
aws codepipeline stop-pipeline-execution \
  --pipeline-name my-pipeline \
  --pipeline-execution-id <execution-id>
```

## Resources

- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/)
- [AWS CodeBuild Documentation](https://docs.aws.amazon.com/codebuild/)
- [Buildspec Reference](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)
- [Pipeline Structure Reference](https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html)

## Next Steps

1. Choose Terraform or Console approach
2. Review templates in `terraform/` directory
3. Customize for your application
4. Set up source repository connection
5. Configure build specifications
6. Add deployment targets
7. Set up notifications
8. Monitor and optimize

