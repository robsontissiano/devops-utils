# Azure CLI Utilities and Commands

A comprehensive collection of Azure CLI commands and utilities for managing cloud resources.

## Prerequisites

### Install Azure CLI
```bash
# macOS
brew install azure-cli

# Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows
winget install -e --id Microsoft.AzureCLI
```

### Login to Azure
```bash
az login
```

### Login with Service Principal
```bash
az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant-id>
```

## Account and Subscription Management

### List Subscriptions
```bash
az account list
```

### Show Current Subscription
```bash
az account show
```

### Set Active Subscription
```bash
az account set --subscription "<subscription-id>"
```

### List Locations
```bash
az account list-locations
```

## Resource Groups

### List Resource Groups
```bash
az group list
```

### Create Resource Group
```bash
az group create --name myResourceGroup --location eastus
```

### Delete Resource Group
```bash
az group delete --name myResourceGroup --yes --no-wait
```

### Show Resource Group
```bash
az group show --name myResourceGroup
```

### List Resources in Group
```bash
az resource list --resource-group myResourceGroup
```

## Virtual Machines

### List VMs
```bash
az vm list
```

### List VMs in Table Format
```bash
az vm list --output table
```

### Create VM
```bash
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image UbuntuLTS \
  --size Standard_B2s \
  --admin-username azureuser \
  --generate-ssh-keys
```

### Start VM
```bash
az vm start --resource-group myResourceGroup --name myVM
```

### Stop VM
```bash
az vm stop --resource-group myResourceGroup --name myVM
```

### Deallocate VM
```bash
az vm deallocate --resource-group myResourceGroup --name myVM
```

### Restart VM
```bash
az vm restart --resource-group myResourceGroup --name myVM
```

### Delete VM
```bash
az vm delete --resource-group myResourceGroup --name myVM --yes
```

### Get VM IP Address
```bash
az vm list-ip-addresses --resource-group myResourceGroup --name myVM
```

### List VM Sizes
```bash
az vm list-sizes --location eastus
```

### Resize VM
```bash
az vm resize --resource-group myResourceGroup --name myVM --size Standard_DS3_v2
```

## Storage Accounts

### List Storage Accounts
```bash
az storage account list
```

### Create Storage Account
```bash
az storage account create \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Standard_LRS
```

### Delete Storage Account
```bash
az storage account delete --name mystorageaccount --resource-group myResourceGroup --yes
```

### Get Storage Account Keys
```bash
az storage account keys list --account-name mystorageaccount --resource-group myResourceGroup
```

### Create Blob Container
```bash
az storage container create \
  --name mycontainer \
  --account-name mystorageaccount \
  --auth-mode login
```

### List Blob Containers
```bash
az storage container list --account-name mystorageaccount --auth-mode login
```

### Upload Blob
```bash
az storage blob upload \
  --container-name mycontainer \
  --name myblob \
  --file ./myfile.txt \
  --account-name mystorageaccount
```

### Download Blob
```bash
az storage blob download \
  --container-name mycontainer \
  --name myblob \
  --file ./downloaded-file.txt \
  --account-name mystorageaccount
```

### List Blobs
```bash
az storage blob list --container-name mycontainer --account-name mystorageaccount --output table
```

### Delete Blob
```bash
az storage blob delete \
  --container-name mycontainer \
  --name myblob \
  --account-name mystorageaccount
```

## App Services

### List App Service Plans
```bash
az appservice plan list
```

### Create App Service Plan
```bash
az appservice plan create \
  --name myAppServicePlan \
  --resource-group myResourceGroup \
  --sku B1
```

### List Web Apps
```bash
az webapp list
```

### Create Web App
```bash
az webapp create \
  --name myWebApp \
  --resource-group myResourceGroup \
  --plan myAppServicePlan
```

### Deploy Code
```bash
az webapp deployment source config-zip \
  --resource-group myResourceGroup \
  --name myWebApp \
  --src ./app.zip
```

### Restart Web App
```bash
az webapp restart --name myWebApp --resource-group myResourceGroup
```

### Show Web App Logs
```bash
az webapp log tail --name myWebApp --resource-group myResourceGroup
```

### List Web App Configuration
```bash
az webapp config appsettings list --name myWebApp --resource-group myResourceGroup
```

### Set Web App Configuration
```bash
az webapp config appsettings set \
  --name myWebApp \
  --resource-group myResourceGroup \
  --settings KEY=VALUE
```

## Azure Kubernetes Service (AKS)

### List AKS Clusters
```bash
az aks list
```

### Create AKS Cluster
```bash
az aks create \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

### Get AKS Credentials
```bash
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

### Scale AKS Cluster
```bash
az aks scale \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --node-count 3
```

### Upgrade AKS Cluster
```bash
az aks upgrade \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --kubernetes-version 1.27.0
```

### Delete AKS Cluster
```bash
az aks delete --resource-group myResourceGroup --name myAKSCluster --yes
```

### Show AKS Versions
```bash
az aks get-versions --location eastus
```

## Azure Container Registry (ACR)

### List Container Registries
```bash
az acr list
```

### Create Container Registry
```bash
az acr create \
  --name myContainerRegistry \
  --resource-group myResourceGroup \
  --sku Basic
```

### Login to ACR
```bash
az acr login --name myContainerRegistry
```

### List Images
```bash
az acr repository list --name myContainerRegistry
```

### Show Image Tags
```bash
az acr repository show-tags --name myContainerRegistry --repository myimage
```

### Delete Image
```bash
az acr repository delete \
  --name myContainerRegistry \
  --image myimage:tag \
  --yes
```

### Build Image in ACR
```bash
az acr build \
  --registry myContainerRegistry \
  --image myimage:v1 \
  .
```

## Azure SQL Database

### List SQL Servers
```bash
az sql server list
```

### Create SQL Server
```bash
az sql server create \
  --name myserver \
  --resource-group myResourceGroup \
  --location eastus \
  --admin-user myadmin \
  --admin-password MyP@ssw0rd!
```

### List Databases
```bash
az sql db list --resource-group myResourceGroup --server myserver
```

### Create Database
```bash
az sql db create \
  --resource-group myResourceGroup \
  --server myserver \
  --name mydatabase \
  --service-objective S0
```

### Delete Database
```bash
az sql db delete --resource-group myResourceGroup --server myserver --name mydatabase --yes
```

### Configure Firewall Rule
```bash
az sql server firewall-rule create \
  --resource-group myResourceGroup \
  --server myserver \
  --name AllowMyIP \
  --start-ip-address 1.2.3.4 \
  --end-ip-address 1.2.3.4
```

## Azure Functions

### List Function Apps
```bash
az functionapp list
```

### Create Function App
```bash
az functionapp create \
  --resource-group myResourceGroup \
  --consumption-plan-location eastus \
  --runtime node \
  --functions-version 4 \
  --name myFunctionApp \
  --storage-account mystorageaccount
```

### Deploy Function App
```bash
az functionapp deployment source config-zip \
  --resource-group myResourceGroup \
  --name myFunctionApp \
  --src ./function.zip
```

### List Function App Settings
```bash
az functionapp config appsettings list --name myFunctionApp --resource-group myResourceGroup
```

### Delete Function App
```bash
az functionapp delete --name myFunctionApp --resource-group myResourceGroup
```

## Virtual Networks

### List Virtual Networks
```bash
az network vnet list
```

### Create Virtual Network
```bash
az network vnet create \
  --name myVNet \
  --resource-group myResourceGroup \
  --address-prefix 10.0.0.0/16 \
  --subnet-name mySubnet \
  --subnet-prefix 10.0.1.0/24
```

### List Subnets
```bash
az network vnet subnet list --resource-group myResourceGroup --vnet-name myVNet
```

### Create Subnet
```bash
az network vnet subnet create \
  --resource-group myResourceGroup \
  --vnet-name myVNet \
  --name mySubnet2 \
  --address-prefix 10.0.2.0/24
```

### List Network Security Groups
```bash
az network nsg list
```

### Create Network Security Group
```bash
az network nsg create \
  --resource-group myResourceGroup \
  --name myNSG
```

### Add NSG Rule
```bash
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --name allow-http \
  --priority 100 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp
```

## Key Vault

### List Key Vaults
```bash
az keyvault list
```

### Create Key Vault
```bash
az keyvault create \
  --name myKeyVault \
  --resource-group myResourceGroup \
  --location eastus
```

### Set Secret
```bash
az keyvault secret set \
  --vault-name myKeyVault \
  --name mySecret \
  --value "MySecretValue"
```

### Get Secret
```bash
az keyvault secret show \
  --vault-name myKeyVault \
  --name mySecret
```

### List Secrets
```bash
az keyvault secret list --vault-name myKeyVault
```

### Delete Secret
```bash
az keyvault secret delete \
  --vault-name myKeyVault \
  --name mySecret
```

## Azure AD / Entra ID

### List Users
```bash
az ad user list
```

### Create User
```bash
az ad user create \
  --display-name "John Doe" \
  --password MyP@ssw0rd! \
  --user-principal-name john@contoso.com
```

### List Service Principals
```bash
az ad sp list
```

### Create Service Principal
```bash
az ad sp create-for-rbac --name myServicePrincipal
```

### List Groups
```bash
az ad group list
```

### Create Group
```bash
az ad group create \
  --display-name myGroup \
  --mail-nickname myGroup
```

## Role-Based Access Control (RBAC)

### List Role Assignments
```bash
az role assignment list
```

### Assign Role
```bash
az role assignment create \
  --assignee user@domain.com \
  --role Contributor \
  --scope /subscriptions/{subscription-id}/resourceGroups/myResourceGroup
```

### Remove Role Assignment
```bash
az role assignment delete \
  --assignee user@domain.com \
  --role Contributor
```

### List Role Definitions
```bash
az role definition list
```

## Monitoring and Logs

### List Log Analytics Workspaces
```bash
az monitor log-analytics workspace list
```

### Query Logs
```bash
az monitor log-analytics query \
  --workspace myWorkspace \
  --analytics-query "AzureActivity | limit 10"
```

### List Metrics
```bash
az monitor metrics list \
  --resource /subscriptions/{sub-id}/resourceGroups/myRG/providers/Microsoft.Compute/virtualMachines/myVM
```

## Useful One-Liners

### Stop All VMs in Resource Group
```bash
az vm list --resource-group myResourceGroup --query "[].name" -o tsv | xargs -I {} az vm stop --resource-group myResourceGroup --name {}
```

### List All Public IPs
```bash
az network public-ip list --query "[].{Name:name, IP:ipAddress, RG:resourceGroup}" --output table
```

### Delete All Resources in Resource Group
```bash
az resource list --resource-group myResourceGroup --query "[].id" -o tsv | xargs -I {} az resource delete --ids {}
```

### Get All VM Sizes and Costs
```bash
az vm list-sizes --location eastus --output table
```

### List All Storage Accounts with URLs
```bash
az storage account list --query "[].{Name:name, URL:primaryEndpoints.blob}" --output table
```

### Export Resource Group as Template
```bash
az group export --name myResourceGroup > template.json
```

### List All Resources with Tags
```bash
az resource list --tag Environment=Production
```

### Find Unattached Disks
```bash
az disk list --query "[?managedBy==null].{Name:name, ResourceGroup:resourceGroup, Size:diskSizeGb}" --output table
```

## Azure DevOps

### List Organizations
```bash
az devops project list
```

### Create Project
```bash
az devops project create --name myProject
```

### List Pipelines
```bash
az pipelines list
```

### Run Pipeline
```bash
az pipelines run --name myPipeline
```

## Cost Management

### Show Current Costs
```bash
az consumption usage list
```

### Show Budget
```bash
az consumption budget list
```

### Create Budget
```bash
az consumption budget create \
  --budget-name myBudget \
  --amount 1000 \
  --time-grain Monthly \
  --start-date 2023-01-01 \
  --end-date 2023-12-31
```

## Best Practices

1. **Use Managed Identities** instead of service principals when possible
2. **Enable Azure AD authentication** for all services
3. **Use Azure Key Vault** for secrets management
4. **Implement RBAC** with least privilege principle
5. **Tag all resources** for cost tracking and organization
6. **Use Azure Policy** for governance
7. **Enable Azure Monitor** for logging and monitoring
8. **Use Azure Backup** for disaster recovery
9. **Implement Network Security Groups** for network isolation
10. **Use Azure DevOps or GitHub Actions** for CI/CD

## Environment Variables

```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
```

## Output Formats

```bash
# JSON (default)
az vm list

# Table
az vm list --output table

# TSV
az vm list --output tsv

# YAML
az vm list --output yaml

# JSON with JMESPath query
az vm list --query "[].{Name:name, RG:resourceGroup}" --output table
```

## Interactive Mode

```bash
# Start interactive mode
az interactive

# Configure interactive mode
az interactive --style classic
```

## Configuration

### Show Configuration
```bash
az configure --list-defaults
```

### Set Default Location
```bash
az configure --defaults location=eastus
```

### Set Default Resource Group
```bash
az configure --defaults group=myResourceGroup
```

### Show Version
```bash
az version
```

### Update CLI
```bash
az upgrade
```

## Extensions

### List Extensions
```bash
az extension list
```

### Install Extension
```bash
az extension add --name azure-devops
```

### Update Extension
```bash
az extension update --name azure-devops
```

