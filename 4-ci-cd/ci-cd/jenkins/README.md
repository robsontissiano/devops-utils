# Jenkins - Automation Server

Self-hosted open-source automation server with extensive plugin ecosystem. Perfect for enterprise CI/CD pipelines.

## Quick Start

### Using Docker Compose

```bash
cd jenkins
docker-compose up -d

# Access Jenkins at http://localhost:8080
```

### Get Initial Admin Password

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Complete Setup

1. Open http://localhost:8080
2. Enter the initial admin password
3. Install suggested plugins
4. Create first admin user
5. Start using Jenkins

## Installation Methods

### Method 1: Docker Compose (Recommended)

See `docker-compose.yml` in this directory. Includes:
- Jenkins with Docker support
- Persistent storage
- Blue Ocean plugin
- Pre-configured plugins

### Method 2: Direct Docker

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

### Method 3: Native Installation

**Ubuntu/Debian:**
```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
```

**CentOS/RHEL:**
```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins
sudo systemctl start jenkins
```

## Essential Plugins

Install these plugins for a complete CI/CD setup:

**Source Control:**
- Git plugin
- GitHub plugin
- GitLab plugin
- Bitbucket plugin

**Build Tools:**
- Maven Integration
- Gradle plugin
- NodeJS plugin
- Python plugin

**Containers:**
- Docker plugin
- Docker Pipeline
- Kubernetes plugin

**Cloud:**
- AWS Steps
- Azure CLI
- Google Cloud SDK

**Pipeline:**
- Pipeline (included)
- Pipeline: Stage View
- Blue Ocean

**Notifications:**
- Slack Notification
- Email Extension
- Mailer

## Pipeline Examples

### Basic Jenkinsfile

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'npm test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### Node.js Application

```groovy
pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-v $HOME/.npm:/.npm'
        }
    }

    environment {
        CI = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'dist/**/*', fingerprint: true
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

### Python Application

```groovy
pipeline {
    agent {
        docker {
            image 'python:3.11-slim'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest pytest-cov flake8
                '''
            }
        }

        stage('Lint') {
            steps {
                sh 'flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics'
            }
        }

        stage('Test') {
            steps {
                sh 'pytest --cov=. --cov-report=xml --cov-report=html'
            }
        }

        stage('Code Coverage') {
            steps {
                publishHTML([
                    reportDir: 'htmlcov',
                    reportFiles: 'index.html',
                    reportName: 'Coverage Report'
                ])
            }
        }
    }
}
```

### Docker Build and Push

```groovy
pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'myuser/myapp'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Test Image') {
            steps {
                sh "docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} npm test"
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
        }
    }
}
```

### Deploy to AWS ECS

```groovy
pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = '123456789.dkr.ecr.us-east-1.amazonaws.com/myapp'
        ECS_CLUSTER = 'my-cluster'
        ECS_SERVICE = 'my-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push to ECR') {
            steps {
                script {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
                        docker build -t ${ECR_REPOSITORY}:${BUILD_NUMBER} .
                        docker push ${ECR_REPOSITORY}:${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster ${ECS_CLUSTER} \
                        --service ${ECS_SERVICE} \
                        --force-new-deployment \
                        --region ${AWS_REGION}
                '''
            }
        }

        stage('Wait for Deployment') {
            steps {
                sh '''
                    aws ecs wait services-stable \
                        --cluster ${ECS_CLUSTER} \
                        --services ${ECS_SERVICE} \
                        --region ${AWS_REGION}
                '''
            }
        }
    }
}
```

### Deploy to Kubernetes

```groovy
pipeline {
    agent any

    environment {
        KUBECONFIG = credentials('kubeconfig-file')
        NAMESPACE = 'production'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:${BUILD_NUMBER} .'
            }
        }

        stage('Push to Registry') {
            steps {
                sh '''
                    docker tag myapp:${BUILD_NUMBER} registry.example.com/myapp:${BUILD_NUMBER}
                    docker push registry.example.com/myapp:${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl set image deployment/myapp \
                        myapp=registry.example.com/myapp:${BUILD_NUMBER} \
                        -n ${NAMESPACE}

                    kubectl rollout status deployment/myapp -n ${NAMESPACE}
                '''
            }
        }
    }
}
```

### Terraform Pipeline

```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action')
        string(name: 'WORKSPACE', defaultValue: 'dev', description: 'Terraform workspace')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Workspace') {
            steps {
                dir('terraform') {
                    sh "terraform workspace select ${params.WORKSPACE} || terraform workspace new ${params.WORKSPACE}"
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'plan' || params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    input message: 'Approve terraform apply?'
                    sh 'terraform apply tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir('terraform') {
                    input message: 'Approve terraform destroy?'
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
```

## Multi-Branch Pipeline

Create `Jenkinsfile` in your repository:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo "Building branch: ${env.BRANCH_NAME}"
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                echo 'Deploying to staging...'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?'
                echo 'Deploying to production...'
            }
        }
    }
}
```

## Credentials Management

### Add Credentials

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click **(global)** domain
3. Click **Add Credentials**

**Types:**
- **Username with password** - Docker Hub, Git
- **Secret text** - API tokens
- **SSH Username with private key** - Git SSH
- **Secret file** - Kubeconfig, service account keys
- **AWS Credentials** - AWS access keys

### Use in Pipeline

```groovy
pipeline {
    agent any

    stages {
        stage('Example') {
            steps {
                // Username/Password
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }

                // Secret text
                withCredentials([string(
                    credentialsId: 'api-token',
                    variable: 'API_TOKEN'
                )]) {
                    sh 'curl -H "Authorization: Bearer $API_TOKEN" api.example.com'
                }

                // Secret file
                withCredentials([file(
                    credentialsId: 'kubeconfig',
                    variable: 'KUBECONFIG'
                )]) {
                    sh 'kubectl get pods'
                }
            }
        }
    }
}
```

## Notifications

### Slack Notification

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
    }

    post {
        success {
            slackSend(
                color: 'good',
                message: "Build Successful: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                channel: '#builds'
            )
        }
        failure {
            slackSend(
                color: 'danger',
                message: "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                channel: '#builds'
            )
        }
    }
}
```

### Email Notification

```groovy
post {
    success {
        emailext(
            subject: "Build Successful: ${env.JOB_NAME}",
            body: "Build ${env.BUILD_NUMBER} completed successfully.",
            to: 'team@example.com'
        )
    }
    failure {
        emailext(
            subject: "Build Failed: ${env.JOB_NAME}",
            body: "Build ${env.BUILD_NUMBER} failed. Check console output.",
            to: 'team@example.com'
        )
    }
}
```

## Shared Libraries

Create reusable pipeline code:

**vars/buildDockerImage.groovy:**
```groovy
def call(String imageName, String tag) {
    sh "docker build -t ${imageName}:${tag} ."
}
```

**vars/deployToK8s.groovy:**
```groovy
def call(String deployment, String namespace, String image) {
    sh """
        kubectl set image deployment/${deployment} \
            ${deployment}=${image} \
            -n ${namespace}
        kubectl rollout status deployment/${deployment} -n ${namespace}
    """
}
```

**Use in Jenkinsfile:**
```groovy
@Library('my-shared-library') _

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                buildDockerImage('myapp', env.BUILD_NUMBER)
            }
        }

        stage('Deploy') {
            steps {
                deployToK8s('myapp', 'production', "myapp:${env.BUILD_NUMBER}")
            }
        }
    }
}
```

## Best Practices

### Pipeline Structure
1. Use declarative pipelines when possible
2. Break complex pipelines into stages
3. Use shared libraries for common tasks
4. Implement proper error handling

### Security
1. Use Jenkins credentials, never hardcode
2. Implement role-based access control
3. Keep Jenkins and plugins updated
4. Use HTTPS for Jenkins URL
5. Scan Docker images for vulnerabilities

### Performance
1. Use agents efficiently
2. Clean up workspace after builds
3. Use pipeline caching
4. Parallelize independent stages
5. Archive only necessary artifacts

### Maintenance
1. Regular backups of Jenkins home
2. Monitor disk space
3. Clean old builds regularly
4. Review and update plugins
5. Monitor build queue and executors

## Backup and Restore

### Backup

```bash
# Backup Jenkins home
tar -czf jenkins-backup-$(date +%Y%m%d).tar.gz /var/jenkins_home

# Backup specific items
tar -czf jenkins-jobs-$(date +%Y%m%d).tar.gz /var/jenkins_home/jobs
tar -czf jenkins-plugins-$(date +%Y%m%d).tar.gz /var/jenkins_home/plugins
```

### Restore

```bash
# Stop Jenkins
docker stop jenkins

# Restore
tar -xzf jenkins-backup.tar.gz -C /

# Start Jenkins
docker start jenkins
```

## Troubleshooting

### Build Fails Immediately

Check:
- Agent availability
- Workspace permissions
- SCM connectivity
- Plugin conflicts

### Slow Builds

Solutions:
- Use distributed builds
- Increase executor count
- Use build caches
- Parallelize stages
- Clean old workspaces

### Plugin Issues

```bash
# Safe restart (waits for running jobs)
curl -X POST http://localhost:8080/safeRestart

# Update plugins
curl -X POST http://localhost:8080/updateCenter/update

# Disable problematic plugin
rm /var/jenkins_home/plugins/plugin-name.jpi
```

## Configuration as Code (JCasC)

Example `jenkins.yaml`:

```yaml
jenkins:
  systemMessage: "Jenkins configured automatically"
  numExecutors: 4

credentials:
  system:
    domainCredentials:
      - credentials:
          - usernamePassword:
              scope: GLOBAL
              id: docker-hub
              username: myuser
              password: ${DOCKER_PASSWORD}

jobs:
  - script: >
      pipelineJob('my-app') {
        definition {
          cpsScm {
            scm {
              git {
                remote { url('https://github.com/user/repo.git') }
                branch('*/main')
              }
            }
            scriptPath('Jenkinsfile')
          }
        }
      }
```

## Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Plugin Index](https://plugins.jenkins.io/)
- [Jenkins Community](https://community.jenkins.io/)

## Next Steps

1. Start Jenkins with Docker Compose
2. Complete initial setup
3. Install recommended plugins
4. Create your first pipeline
5. Add credentials
6. Configure notifications
7. Set up distributed builds
8. Implement backup strategy

