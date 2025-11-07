# GitHub Actions - CI/CD Workflows

Cloud-native CI/CD directly integrated with GitHub. Perfect for automated testing, building, and deployment.

## Quick Start

### 1. Create Workflow File

Create `.github/workflows/ci.yml` in your repository:

```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: echo "Running tests..."
```

### 2. Push to GitHub

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI workflow"
git push
```

### 3. View Results

Go to your repository → **Actions** tab to see the workflow running!

## Workflow Examples

All examples are in the `workflows/` directory:

- **`node-ci.yml`** - Node.js/JavaScript application
- **`python-ci.yml`** - Python application
- **`docker-build.yml`** - Build and push Docker images
- **`aws-deploy.yml`** - Deploy to AWS ECS
- **`terraform.yml`** - Terraform infrastructure
- **`kubernetes-deploy.yml`** - Deploy to Kubernetes
- **`release.yml`** - Create releases and tags

## Common Triggers

### On Push
```yaml
on:
  push:
    branches: [ main, develop ]
```

### On Pull Request
```yaml
on:
  pull_request:
    branches: [ main ]
```

### On Schedule (Cron)
```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
```

### Manual Trigger
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'staging'
```

### Multiple Events
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
```

## Common Workflows

### Node.js CI/CD
```yaml
name: Node.js CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm test
      - run: npm run build
```

### Python CI/CD
```yaml
name: Python CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11']
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov
      - name: Run tests
        run: pytest --cov
```

### Docker Build and Push
```yaml
name: Docker Build

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: user/app:latest
```

### Deploy to AWS ECS
```yaml
name: Deploy to AWS ECS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build and push image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: my-app
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Deploy to ECS
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: task-definition.json
          service: my-service
          cluster: my-cluster
```

## Secrets Management

### Add Secrets

1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add your secrets (AWS keys, API tokens, passwords)

### Use Secrets in Workflow

```yaml
- name: Use secret
  run: echo "Secret: ${{ secrets.MY_SECRET }}"
  env:
    API_KEY: ${{ secrets.API_KEY }}
```

### Environment Secrets

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying to production"
        env:
          TOKEN: ${{ secrets.PROD_TOKEN }}
```

## Advanced Features

### Matrix Builds

Test across multiple versions:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    node: [16, 18, 20]

steps:
  - uses: actions/setup-node@v3
    with:
      node-version: ${{ matrix.node }}
```

### Conditional Steps

```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh
```

### Reusable Workflows

Create reusable workflow in `.github/workflows/reusable.yml`:

```yaml
name: Reusable workflow

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to ${{ inputs.environment }}"
```

Use it:

```yaml
jobs:
  call-reusable:
    uses: ./.github/workflows/reusable.yml
    with:
      environment: 'production'
```

### Artifacts

Save build artifacts:

```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: my-artifact
    path: build/

- name: Download artifact
  uses: actions/download-artifact@v3
  with:
    name: my-artifact
```

### Caching

Speed up workflows with caching:

```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Notifications

### Slack Notification

```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

### Discord Notification

```yaml
- name: Discord Notification
  uses: sarisia/actions-status-discord@v1
  if: always()
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
```

## Testing Integrations

### Code Coverage

```yaml
- name: Run tests with coverage
  run: npm test -- --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    token: ${{ secrets.CODECOV_TOKEN }}
```

### SonarQube

```yaml
- name: SonarQube Scan
  uses: sonarsource/sonarqube-scan-action@master
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```

## Container Workflows

### Multi-platform Builds

```yaml
- name: Set up QEMU
  uses: docker/setup-qemu-action@v2

- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v2

- name: Build multi-platform
  uses: docker/build-push-action@v4
  with:
    platforms: linux/amd64,linux/arm64
    push: true
    tags: user/app:latest
```

## Kubernetes Deployment

```yaml
- name: Set up kubectl
  uses: azure/setup-kubectl@v3

- name: Configure kubeconfig
  run: |
    echo "${{ secrets.KUBE_CONFIG }}" > kubeconfig
    export KUBECONFIG=kubeconfig

- name: Deploy to Kubernetes
  run: |
    kubectl apply -f k8s/
    kubectl rollout status deployment/my-app
```

## Marketplace Actions

Popular actions to use:

```yaml
# Checkout code
- uses: actions/checkout@v3

# Setup languages
- uses: actions/setup-node@v3
- uses: actions/setup-python@v4
- uses: actions/setup-go@v4
- uses: actions/setup-java@v3

# Cloud providers
- uses: aws-actions/configure-aws-credentials@v2
- uses: azure/login@v1
- uses: google-github-actions/auth@v1

# Container registries
- uses: docker/login-action@v2
- uses: aws-actions/amazon-ecr-login@v1

# Deployment
- uses: aws-actions/amazon-ecs-deploy-task-definition@v1
- uses: azure/webapps-deploy@v2

# Security
- uses: aquasecurity/trivy-action@master
- uses: snyk/actions@master
```

## Cost Optimization

### Free Tier Limits

- **Public repositories**: Unlimited minutes
- **Private repositories**:
  - Free: 2,000 minutes/month
  - Team: 3,000 minutes/month
  - Enterprise: 50,000 minutes/month

### Optimization Tips

```yaml
# Use caching
- uses: actions/cache@v3

# Cancel redundant builds
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

# Use self-hosted runners for heavy workloads
runs-on: self-hosted
```

## Self-Hosted Runners

### Setup

```bash
# Download and install
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.310.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.310.2/actions-runner-linux-x64-2.310.2.tar.gz
tar xzf ./actions-runner-linux-x64-2.310.2.tar.gz

# Configure
./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN

# Run
./run.sh
```

### Use in Workflow

```yaml
runs-on: self-hosted
```

## Troubleshooting

### Workflow Not Triggering

```yaml
# Check branch filter
on:
  push:
    branches: [ main ]  # Must push to 'main'

# Check file paths
on:
  push:
    paths:
      - 'src/**'  # Only triggers if src/ files change
```

### Permission Errors

```yaml
permissions:
  contents: read
  packages: write
  pull-requests: write
```

### Debug Mode

Enable debug logging:
- Repository Settings → Secrets → Add `ACTIONS_STEP_DEBUG` = `true`

## Best Practices

1. ✅ Use specific action versions (v3, not @master)
2. ✅ Cache dependencies to speed up builds
3. ✅ Use matrix builds for multi-version testing
4. ✅ Keep secrets in GitHub Secrets
5. ✅ Use environments for production deployments
6. ✅ Enable branch protection rules
7. ✅ Use reusable workflows to avoid duplication
8. ✅ Add status badges to README
9. ✅ Monitor workflow run times
10. ✅ Use conditional steps to optimize

## Status Badges

Add to your README.md:

```markdown
![CI](https://github.com/username/repo/workflows/CI/badge.svg)
```

## Next Steps

1. ✅ Choose a workflow template from `workflows/`
2. ✅ Customize for your project
3. ✅ Add secrets in repository settings
4. ✅ Push and watch it run
5. ✅ Add more stages (test, deploy, notify)
6. ✅ Monitor and optimize

---

**Ready to automate? Check the `workflows/` folder for ready-to-use examples!**

