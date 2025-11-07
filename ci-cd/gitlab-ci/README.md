# GitLab CI/CD

Built-in CI/CD for GitLab repositories with powerful automation features and complete DevOps platform integration.

## Quick Start

### Create .gitlab-ci.yml

Create `.gitlab-ci.yml` in your repository root:

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - echo "Building application..."
    - npm install
    - npm run build

test:
  stage: test
  script:
    - echo "Running tests..."
    - npm test

deploy:
  stage: deploy
  script:
    - echo "Deploying application..."
  only:
    - main
```

### Push to GitLab

```bash
git add .gitlab-ci.yml
git commit -m "Add CI/CD pipeline"
git push
```

### View Pipeline

Go to your GitLab project → **CI/CD** → **Pipelines**

## Pipeline Templates

### Node.js Application

See `templates/nodejs.gitlab-ci.yml`

### Python Application

See `templates/python.gitlab-ci.yml`

### Docker Build and Push

See `templates/docker.gitlab-ci.yml`

### Deploy to AWS ECS

See `templates/aws-ecs.gitlab-ci.yml`

### Deploy to Kubernetes

See `templates/kubernetes.gitlab-ci.yml`

### Terraform

See `templates/terraform.gitlab-ci.yml`

## Pipeline Configuration

### Basic Structure

```yaml
# Define stages
stages:
  - build
  - test
  - deploy

# Global variables
variables:
  NODE_VERSION: "18"

# Before script (runs before each job)
before_script:
  - echo "Starting job..."

# After script (runs after each job)
after_script:
  - echo "Job completed"

# Jobs
build_job:
  stage: build
  script:
    - echo "Building..."

test_job:
  stage: test
  script:
    - echo "Testing..."
```

### Using Docker Images

```yaml
image: node:18-alpine

build:
  stage: build
  script:
    - npm install
    - npm run build
```

### Multiple Images

```yaml
stages:
  - build
  - test

build:
  image: node:18
  stage: build
  script:
    - npm install

test:
  image: python:3.11
  stage: test
  script:
    - pytest
```

### Service Containers

```yaml
test:
  image: node:18
  services:
    - postgres:14
    - redis:7
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
  script:
    - npm test
```

## Variables and Secrets

### Define Variables

**In .gitlab-ci.yml:**
```yaml
variables:
  DATABASE_URL: "postgresql://localhost/db"
  NODE_ENV: "production"
```

**In GitLab UI:**
1. Go to **Settings** → **CI/CD** → **Variables**
2. Add variable
3. Optionally mask or protect it

### Use Variables

```yaml
deploy:
  script:
    - echo "Deploying to $ENVIRONMENT"
    - echo "Using key: $AWS_ACCESS_KEY_ID"
```

### Protected Variables

```yaml
deploy_production:
  script:
    - deploy.sh
  only:
    - main
  variables:
    # Use protected variables only on protected branches
    DEPLOY_KEY: $PRODUCTION_DEPLOY_KEY
```

## Conditional Execution

### Only/Except Rules

```yaml
deploy_staging:
  script:
    - deploy staging
  only:
    - develop

deploy_production:
  script:
    - deploy production
  only:
    - main
  except:
    - schedules
```

### Rules (Advanced)

```yaml
deploy:
  script:
    - deploy.sh
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_COMMIT_TAG'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: manual
```

### When Conditions

```yaml
cleanup:
  script:
    - cleanup.sh
  when: always  # always, on_success, on_failure, manual, delayed
```

## Caching

### Cache Dependencies

```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .npm/

build:
  script:
    - npm ci
    - npm run build
```

### Per-Branch Cache

```yaml
cache:
  key: "$CI_COMMIT_REF_NAME"
  paths:
    - vendor/
```

### Cache Policy

```yaml
build:
  cache:
    key: build-cache
    paths:
      - target/
    policy: pull-push  # pull, push, pull-push

test:
  cache:
    key: build-cache
    paths:
      - target/
    policy: pull  # Only download, don't upload
```

## Artifacts

### Save Build Artifacts

```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
```

### Pass Artifacts Between Jobs

```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/

deploy:
  script:
    - aws s3 sync dist/ s3://mybucket/
  dependencies:
    - build
```

### Artifact Reports

```yaml
test:
  script:
    - pytest --junit-xml=report.xml
  artifacts:
    reports:
      junit: report.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
```

## Docker Integration

### Build Docker Image

```yaml
build_image:
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t myimage:$CI_COMMIT_SHA .
    - docker push myimage:$CI_COMMIT_SHA
```

### Use GitLab Container Registry

```yaml
variables:
  IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

build:
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $IMAGE .
    - docker push $IMAGE
```

## Parallel Jobs

### Parallel Execution

```yaml
test:
  script:
    - npm test
  parallel: 3  # Run 3 instances in parallel
```

### Matrix Jobs

```yaml
test:
  script:
    - npm test
  parallel:
    matrix:
      - NODE_VERSION: ['16', '18', '20']
        OS: ['ubuntu', 'alpine']
```

## Environments

### Define Environments

```yaml
deploy_staging:
  stage: deploy
  script:
    - deploy staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy_production:
  stage: deploy
  script:
    - deploy production
  environment:
    name: production
    url: https://example.com
  only:
    - main
  when: manual
```

### Environment Variables

```yaml
deploy:
  script:
    - echo "Deploying to $CI_ENVIRONMENT_NAME"
    - echo "URL: $CI_ENVIRONMENT_URL"
```

## Include and Extends

### Include External Files

```yaml
include:
  - local: '/templates/docker.yml'
  - remote: 'https://example.com/ci-template.yml'
  - template: Security/SAST.gitlab-ci.yml

stages:
  - test
  - build
```

### Extends (Inheritance)

```yaml
.deploy_template:
  script:
    - deploy.sh
  only:
    - main

deploy_staging:
  extends: .deploy_template
  variables:
    ENVIRONMENT: staging

deploy_production:
  extends: .deploy_template
  variables:
    ENVIRONMENT: production
  when: manual
```

## GitLab Runner

### Install Runner

**Linux:**
```bash
# Download
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"

# Install
sudo dpkg -i gitlab-runner_amd64.deb

# Register
sudo gitlab-runner register
```

**Docker:**
```bash
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```

### Register Runner

```bash
sudo gitlab-runner register \
  --url https://gitlab.com/ \
  --registration-token YOUR_TOKEN \
  --executor docker \
  --docker-image alpine:latest \
  --description "my-runner" \
  --tag-list "docker,aws" \
  --docker-privileged
```

### Runner Tags

```yaml
build:
  tags:
    - docker
    - linux
  script:
    - npm run build
```

## Auto DevOps

Enable Auto DevOps for automatic CI/CD:

1. Go to **Settings** → **CI/CD** → **Auto DevOps**
2. Enable Auto DevOps
3. Push code and GitLab will automatically:
   - Build Docker images
   - Run tests
   - Deploy to Kubernetes
   - Set up monitoring

## Security Scanning

### SAST (Static Application Security Testing)

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
```

### Container Scanning

```yaml
include:
  - template: Security/Container-Scanning.gitlab-ci.yml
```

### Dependency Scanning

```yaml
include:
  - template: Security/Dependency-Scanning.gitlab-ci.yml
```

## Review Apps

Deploy temporary environments for merge requests:

```yaml
review:
  stage: deploy
  script:
    - deploy_review_app.sh
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://$CI_COMMIT_REF_SLUG.example.com
    on_stop: stop_review
  only:
    - merge_requests

stop_review:
  stage: deploy
  script:
    - stop_review_app.sh
  environment:
    name: review/$CI_COMMIT_REF_NAME
    action: stop
  when: manual
  only:
    - merge_requests
```

## Scheduled Pipelines

Create scheduled pipelines in GitLab UI:

1. Go to **CI/CD** → **Schedules**
2. Click **New schedule**
3. Set cron pattern
4. Add variables

Use in pipeline:

```yaml
nightly_build:
  script:
    - run_extensive_tests.sh
  only:
    - schedules
```

## GitLab CI/CD Variables

### Predefined Variables

```yaml
build:
  script:
    - echo "Branch: $CI_COMMIT_BRANCH"
    - echo "Commit: $CI_COMMIT_SHA"
    - echo "Job: $CI_JOB_NAME"
    - echo "Pipeline: $CI_PIPELINE_ID"
    - echo "Runner: $CI_RUNNER_DESCRIPTION"
```

Common variables:
- `$CI_COMMIT_BRANCH` - Branch name
- `$CI_COMMIT_SHA` - Commit SHA
- `$CI_PROJECT_NAME` - Project name
- `$CI_REGISTRY` - GitLab container registry URL
- `$CI_REGISTRY_IMAGE` - Full image path
- `$CI_PIPELINE_SOURCE` - Pipeline source (push, web, etc.)

## Best Practices

### Pipeline Efficiency
1. Use caching for dependencies
2. Parallelize independent jobs
3. Use artifacts for job dependencies
4. Keep Docker images small
5. Use specific image tags

### Security
1. Use protected variables for secrets
2. Enable security scanning
3. Limit runner access with tags
4. Use least privilege for service accounts
5. Scan Docker images

### Maintainability
1. Use extends for DRY pipelines
2. Break complex pipelines into files
3. Document complex logic
4. Use templates for common patterns
5. Version control your CI/CD

## Troubleshooting

### Job Fails on Runner

Check:
- Runner is active and online
- Runner has correct tags
- Docker service is running
- Sufficient disk space

### Cache Not Working

Solutions:
- Verify cache key is consistent
- Check runner cache configuration
- Ensure paths exist
- Use distributed cache for multiple runners

### Variables Not Available

Check:
- Variable is defined in correct scope
- Variable is not masked improperly
- Protected variables on protected branches
- Spelling and syntax

## Resources

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [CI/CD YAML Reference](https://docs.gitlab.com/ee/ci/yaml/)
- [GitLab Runner Documentation](https://docs.gitlab.com/runner/)
- [CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/)

## Next Steps

1. Create `.gitlab-ci.yml` in your repository
2. Choose a template from `templates/` directory
3. Customize for your project
4. Add secrets in GitLab UI
5. Push and watch pipeline run
6. Add more stages as needed
7. Set up environments
8. Enable security scanning

