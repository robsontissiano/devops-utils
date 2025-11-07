# Google Cloud Platform (GCP) CLI Utilities and Commands

A comprehensive collection of gcloud CLI commands and utilities for managing Google Cloud resources.

## Prerequisites

### Install gcloud CLI
```bash
# macOS
brew install --cask google-cloud-sdk

# Linux
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Windows
# Download from: https://cloud.google.com/sdk/docs/install
```

### Initialize gcloud
```bash
gcloud init
```

### Login to GCP
```bash
gcloud auth login
```

### Login with Service Account
```bash
gcloud auth activate-service-account --key-file=key.json
```

## Configuration Management

### List Configurations
```bash
gcloud config configurations list
```

### Create Configuration
```bash
gcloud config configurations create <config-name>
```

### Activate Configuration
```bash
gcloud config configurations activate <config-name>
```

### Set Project
```bash
gcloud config set project <project-id>
```

### Set Region
```bash
gcloud config set compute/region us-central1
```

### Set Zone
```bash
gcloud config set compute/zone us-central1-a
```

### Show Current Configuration
```bash
gcloud config list
```

### Unset Property
```bash
gcloud config unset <property>
```

## Project Management

### List Projects
```bash
gcloud projects list
```

### Describe Project
```bash
gcloud projects describe <project-id>
```

### Create Project
```bash
gcloud projects create <project-id> --name="My Project"
```

### Delete Project
```bash
gcloud projects delete <project-id>
```

### Set Default Project
```bash
gcloud config set project <project-id>
```

## Compute Engine (GCE)

### List Instances
```bash
gcloud compute instances list
```

### List Instances in Table Format
```bash
gcloud compute instances list --format="table(name,zone,machineType,status,networkInterfaces[0].networkIP:label=INTERNAL_IP,networkInterfaces[0].accessConfigs[0].natIP:label=EXTERNAL_IP)"
```

### Create Instance
```bash
gcloud compute instances create my-instance \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB
```

### Start Instance
```bash
gcloud compute instances start <instance-name> --zone=<zone>
```

### Stop Instance
```bash
gcloud compute instances stop <instance-name> --zone=<zone>
```

### Restart Instance
```bash
gcloud compute instances reset <instance-name> --zone=<zone>
```

### Delete Instance
```bash
gcloud compute instances delete <instance-name> --zone=<zone>
```

### SSH into Instance
```bash
gcloud compute ssh <instance-name> --zone=<zone>
```

### SCP Files to Instance
```bash
gcloud compute scp local-file.txt <instance-name>:~/remote-path --zone=<zone>
```

### List Machine Types
```bash
gcloud compute machine-types list --zones=us-central1-a
```

### List Images
```bash
gcloud compute images list
```

### Create Custom Image
```bash
gcloud compute images create my-image \
  --source-disk=my-disk \
  --source-disk-zone=us-central1-a
```

### Describe Instance
```bash
gcloud compute instances describe <instance-name> --zone=<zone>
```

## Google Kubernetes Engine (GKE)

### List Clusters
```bash
gcloud container clusters list
```

### Create Cluster
```bash
gcloud container clusters create my-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-medium \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=5
```

### Get Cluster Credentials
```bash
gcloud container clusters get-credentials <cluster-name> --zone=<zone>
```

### Resize Cluster
```bash
gcloud container clusters resize <cluster-name> \
  --num-nodes=5 \
  --zone=<zone>
```

### Upgrade Cluster
```bash
gcloud container clusters upgrade <cluster-name> \
  --zone=<zone> \
  --master
```

### Delete Cluster
```bash
gcloud container clusters delete <cluster-name> --zone=<zone>
```

### List Node Pools
```bash
gcloud container node-pools list --cluster=<cluster-name> --zone=<zone>
```

### Create Node Pool
```bash
gcloud container node-pools create <pool-name> \
  --cluster=<cluster-name> \
  --zone=<zone> \
  --num-nodes=3 \
  --machine-type=e2-medium
```

### Delete Node Pool
```bash
gcloud container node-pools delete <pool-name> \
  --cluster=<cluster-name> \
  --zone=<zone>
```

## Cloud Storage (GCS)

### List Buckets
```bash
gcloud storage buckets list
# or using gsutil
gsutil ls
```

### Create Bucket
```bash
gcloud storage buckets create gs://my-bucket --location=us-central1
# or using gsutil
gsutil mb gs://my-bucket
```

### Delete Bucket
```bash
gcloud storage buckets delete gs://my-bucket
# or using gsutil
gsutil rb gs://my-bucket
```

### List Objects in Bucket
```bash
gcloud storage ls gs://my-bucket/
# or using gsutil
gsutil ls gs://my-bucket/
```

### Copy File to Bucket
```bash
gcloud storage cp local-file.txt gs://my-bucket/
# or using gsutil
gsutil cp local-file.txt gs://my-bucket/
```

### Copy File from Bucket
```bash
gcloud storage cp gs://my-bucket/file.txt ./
# or using gsutil
gsutil cp gs://my-bucket/file.txt ./
```

### Sync Directory to Bucket
```bash
gcloud storage rsync ./local-dir gs://my-bucket/remote-dir --recursive
# or using gsutil
gsutil -m rsync -r ./local-dir gs://my-bucket/remote-dir
```

### Delete Object
```bash
gcloud storage rm gs://my-bucket/file.txt
# or using gsutil
gsutil rm gs://my-bucket/file.txt
```

### Delete All Objects in Bucket
```bash
gcloud storage rm gs://my-bucket/** --recursive
# or using gsutil
gsutil -m rm -r gs://my-bucket/*
```

### Make Object Public
```bash
gsutil acl ch -u AllUsers:R gs://my-bucket/file.txt
```

### Set Bucket Lifecycle
```bash
gsutil lifecycle set lifecycle.json gs://my-bucket
```

## Cloud SQL

### List Instances
```bash
gcloud sql instances list
```

### Create Instance
```bash
gcloud sql instances create my-instance \
  --database-version=MYSQL_8_0 \
  --tier=db-f1-micro \
  --region=us-central1
```

### Describe Instance
```bash
gcloud sql instances describe <instance-name>
```

### Delete Instance
```bash
gcloud sql instances delete <instance-name>
```

### Connect to Instance
```bash
gcloud sql connect <instance-name> --user=root
```

### Create Database
```bash
gcloud sql databases create <database-name> --instance=<instance-name>
```

### List Databases
```bash
gcloud sql databases list --instance=<instance-name>
```

### Create User
```bash
gcloud sql users create <username> \
  --instance=<instance-name> \
  --password=<password>
```

### List Users
```bash
gcloud sql users list --instance=<instance-name>
```

### Create Backup
```bash
gcloud sql backups create --instance=<instance-name>
```

### List Backups
```bash
gcloud sql backups list --instance=<instance-name>
```

## Cloud Functions

### List Functions
```bash
gcloud functions list
```

### Deploy Function
```bash
gcloud functions deploy my-function \
  --runtime=nodejs18 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --source=.
```

### Deploy with Environment Variables
```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --set-env-vars KEY1=value1,KEY2=value2
```

### Call Function
```bash
gcloud functions call <function-name>
```

### Get Function Logs
```bash
gcloud functions logs read <function-name>
```

### Delete Function
```bash
gcloud functions delete <function-name>
```

### Describe Function
```bash
gcloud functions describe <function-name>
```

## Cloud Run

### List Services
```bash
gcloud run services list
```

### Deploy Service
```bash
gcloud run deploy my-service \
  --image=gcr.io/my-project/my-image \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated
```

### Deploy from Source
```bash
gcloud run deploy my-service \
  --source=. \
  --region=us-central1
```

### Update Service
```bash
gcloud run services update my-service \
  --region=us-central1 \
  --set-env-vars KEY=value
```

### Delete Service
```bash
gcloud run services delete my-service --region=us-central1
```

### Get Service URL
```bash
gcloud run services describe my-service \
  --region=us-central1 \
  --format='value(status.url)'
```

### View Logs
```bash
gcloud run services logs read my-service --region=us-central1
```

## App Engine

### Deploy Application
```bash
gcloud app deploy
```

### Deploy with Specific Version
```bash
gcloud app deploy --version=v1
```

### Browse Application
```bash
gcloud app browse
```

### View Logs
```bash
gcloud app logs tail -s default
```

### List Versions
```bash
gcloud app versions list
```

### Delete Version
```bash
gcloud app versions delete <version-id>
```

### Set Traffic Split
```bash
gcloud app services set-traffic default --splits v1=0.5,v2=0.5
```

## Cloud Build

### Submit Build
```bash
gcloud builds submit --tag gcr.io/my-project/my-image
```

### Submit with Config
```bash
gcloud builds submit --config=cloudbuild.yaml
```

### List Builds
```bash
gcloud builds list
```

### Describe Build
```bash
gcloud builds describe <build-id>
```

### View Build Logs
```bash
gcloud builds log <build-id>
```

### Cancel Build
```bash
gcloud builds cancel <build-id>
```

## Container Registry / Artifact Registry

### List Images (GCR)
```bash
gcloud container images list
```

### List Tags
```bash
gcloud container images list-tags gcr.io/my-project/my-image
```

### Delete Image
```bash
gcloud container images delete gcr.io/my-project/my-image:tag
```

### Configure Docker
```bash
gcloud auth configure-docker
```

### List Artifact Registry Repositories
```bash
gcloud artifacts repositories list
```

### Create Artifact Registry Repository
```bash
gcloud artifacts repositories create my-repo \
  --repository-format=docker \
  --location=us-central1
```

## IAM (Identity and Access Management)

### List IAM Policies
```bash
gcloud projects get-iam-policy <project-id>
```

### Add IAM Policy Binding
```bash
gcloud projects add-iam-policy-binding <project-id> \
  --member=user:email@example.com \
  --role=roles/editor
```

### Remove IAM Policy Binding
```bash
gcloud projects remove-iam-policy-binding <project-id> \
  --member=user:email@example.com \
  --role=roles/editor
```

### List Service Accounts
```bash
gcloud iam service-accounts list
```

### Create Service Account
```bash
gcloud iam service-accounts create my-sa \
  --display-name="My Service Account"
```

### Create Service Account Key
```bash
gcloud iam service-accounts keys create key.json \
  --iam-account=my-sa@my-project.iam.gserviceaccount.com
```

### List Service Account Keys
```bash
gcloud iam service-accounts keys list \
  --iam-account=my-sa@my-project.iam.gserviceaccount.com
```

### Delete Service Account
```bash
gcloud iam service-accounts delete my-sa@my-project.iam.gserviceaccount.com
```

## VPC and Networking

### List Networks
```bash
gcloud compute networks list
```

### Create Network
```bash
gcloud compute networks create my-network --subnet-mode=custom
```

### Delete Network
```bash
gcloud compute networks delete my-network
```

### List Subnets
```bash
gcloud compute networks subnets list
```

### Create Subnet
```bash
gcloud compute networks subnets create my-subnet \
  --network=my-network \
  --range=10.0.1.0/24 \
  --region=us-central1
```

### List Firewall Rules
```bash
gcloud compute firewall-rules list
```

### Create Firewall Rule
```bash
gcloud compute firewall-rules create allow-http \
  --network=my-network \
  --allow=tcp:80 \
  --source-ranges=0.0.0.0/0
```

### Delete Firewall Rule
```bash
gcloud compute firewall-rules delete allow-http
```

### List IP Addresses
```bash
gcloud compute addresses list
```

### Reserve Static IP
```bash
gcloud compute addresses create my-ip --region=us-central1
```

### Release Static IP
```bash
gcloud compute addresses delete my-ip --region=us-central1
```

## Cloud DNS

### List Managed Zones
```bash
gcloud dns managed-zones list
```

### Create Managed Zone
```bash
gcloud dns managed-zones create my-zone \
  --dns-name="example.com." \
  --description="My DNS Zone"
```

### List Records
```bash
gcloud dns record-sets list --zone=my-zone
```

### Add Record
```bash
gcloud dns record-sets create www.example.com. \
  --zone=my-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=1.2.3.4
```

## Cloud Logging

### Read Logs
```bash
gcloud logging read "resource.type=gce_instance" --limit=50
```

### Read Recent Logs
```bash
gcloud logging read "timestamp>=2023-01-01" --limit=10
```

### Tail Logs
```bash
gcloud logging tail "resource.type=cloud_function"
```

### List Log Entries
```bash
gcloud logging logs list
```

## Cloud Monitoring

### List Metrics
```bash
gcloud monitoring metrics-descriptors list
```

### List Uptime Checks
```bash
gcloud monitoring uptime-checks list
```

## Secret Manager

### List Secrets
```bash
gcloud secrets list
```

### Create Secret
```bash
echo -n "my-secret-value" | gcloud secrets create my-secret --data-file=-
```

### Add Secret Version
```bash
echo -n "new-secret-value" | gcloud secrets versions add my-secret --data-file=-
```

### Access Secret
```bash
gcloud secrets versions access latest --secret=my-secret
```

### Delete Secret
```bash
gcloud secrets delete my-secret
```

## Useful One-Liners

### Stop All Instances in Project
```bash
gcloud compute instances list --format="value(name,zone)" | while read name zone; do gcloud compute instances stop $name --zone=$zone; done
```

### List All External IPs
```bash
gcloud compute instances list --format="table(name,networkInterfaces[0].accessConfigs[0].natIP)"
```

### Delete All Stopped Instances
```bash
gcloud compute instances list --filter="status=TERMINATED" --format="value(name,zone)" | while read name zone; do gcloud compute instances delete $name --zone=$zone --quiet; done
```

### List All Buckets with Size
```bash
gsutil du -sh gs://*
```

### Get Project Number
```bash
gcloud projects describe <project-id> --format="value(projectNumber)"
```

### List All Resources in Project
```bash
gcloud asset search-all-resources --scope=projects/<project-id>
```

### Enable API
```bash
gcloud services enable compute.googleapis.com
```

### List Enabled APIs
```bash
gcloud services list --enabled
```

### Disable API
```bash
gcloud services disable compute.googleapis.com
```

### Get Current Account
```bash
gcloud auth list
```

### Get Access Token
```bash
gcloud auth print-access-token
```

### Describe Resource Quota
```bash
gcloud compute project-info describe --project=<project-id>
```

## Billing

### List Billing Accounts
```bash
gcloud billing accounts list
```

### Link Project to Billing
```bash
gcloud billing projects link <project-id> \
  --billing-account=<billing-account-id>
```

### Get Billing Info
```bash
gcloud billing projects describe <project-id>
```

## Best Practices

1. **Use Service Accounts** for application authentication
2. **Enable VPC Service Controls** for sensitive data
3. **Use Cloud IAM** with least privilege principle
4. **Enable Cloud Audit Logs** for security monitoring
5. **Use Secret Manager** for sensitive data storage
6. **Implement Organization Policies** for governance
7. **Use Labels** for resource organization and cost tracking
8. **Enable Cloud Armor** for DDoS protection
9. **Use Private Google Access** for secure connectivity
10. **Implement Cloud KMS** for encryption key management

## Environment Variables

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
export CLOUDSDK_CORE_PROJECT="my-project"
export CLOUDSDK_COMPUTE_REGION="us-central1"
export CLOUDSDK_COMPUTE_ZONE="us-central1-a"
```

## Output Formats

```bash
# JSON (default)
gcloud compute instances list --format=json

# YAML
gcloud compute instances list --format=yaml

# Table
gcloud compute instances list --format=table

# CSV
gcloud compute instances list --format=csv

# Custom format
gcloud compute instances list --format="table(name,zone,status)"

# Value only (useful in scripts)
gcloud compute instances list --format="value(name)"
```

## Filters

```bash
# Filter by status
gcloud compute instances list --filter="status=RUNNING"

# Filter by zone
gcloud compute instances list --filter="zone:us-central1-a"

# Complex filter
gcloud compute instances list --filter="machineType:e2-medium AND status=RUNNING"
```

## Configuration

### Show All Properties
```bash
gcloud config list --all
```

### Set Properties
```bash
gcloud config set core/project my-project
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```

### Components Management

### List Components
```bash
gcloud components list
```

### Install Component
```bash
gcloud components install kubectl
```

### Update gcloud
```bash
gcloud components update
```

## Troubleshooting

### Debug Mode
```bash
gcloud compute instances list --verbosity=debug
```

### Check Quota
```bash
gcloud compute regions describe us-central1
```

### Test Connectivity
```bash
gcloud compute instances get-serial-port-output <instance-name> --zone=<zone>
```

## Tips

- Use `--quiet` flag to skip confirmation prompts
- Use `--format` to customize output
- Use `--filter` to narrow down results
- Use `--project` to specify project without changing config
- Use `gcloud components list` to see available tools
- Use `gcloud help` or `gcloud <command> --help` for documentation
- Use `gcloud feedback` to report issues

