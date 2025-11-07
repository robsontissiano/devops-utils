#!/bin/bash
# DevOps Utilities - Shell Aliases and Functions
# Source this file in your .bashrc or .zshrc

# =============================================================================
# DOCKER ALIASES
# =============================================================================

# Basic Docker
alias d='docker'
alias dc='docker-compose'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'

# Docker Cleanup
alias dstop='docker stop $(docker ps -a -q) 2>/dev/null'
alias drm='docker rm $(docker ps -a -q) 2>/dev/null'
alias dclean='docker stop $(docker ps -a -q) 2>/dev/null; docker rm $(docker ps -a -q) 2>/dev/null'
alias drmi='docker rmi $(docker images -q) 2>/dev/null'
alias drmid='docker rmi $(docker images -f "dangling=true" -q) 2>/dev/null'
alias dprune='docker system prune -a --volumes'

# Docker Compose One-Liners (as requested by user)
alias dcrestart='docker stop $(docker ps -a -q) 2>/dev/null; docker rm $(docker ps -a -q) 2>/dev/null; docker-compose build; docker-compose up -d'

# Docker Compose Shortcuts
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'
alias dcbuild='docker-compose build'
alias dcrebuild='docker-compose down && docker-compose build && docker-compose up -d'

# Docker Inspection
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
alias dstats='docker stats'
alias dinspect='docker inspect'

# =============================================================================
# KUBERNETES ALIASES
# =============================================================================

# Basic Kubectl
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias ka='kubectl apply -f'
alias kex='kubectl exec -it'
alias kl='kubectl logs -f'

# Pods
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kdp='kubectl describe pod'
alias kdelp='kubectl delete pod'

# Deployments
alias kgd='kubectl get deployments'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'

# Services
alias kgs='kubectl get services'
alias kds='kubectl describe service'
alias kdels='kubectl delete service'

# Namespaces
alias kgn='kubectl get namespaces'
alias kns='kubectl config set-context --current --namespace'

# Context
alias kctx='kubectl config current-context'
alias kctxs='kubectl config get-contexts'
alias kuse='kubectl config use-context'

# =============================================================================
# GIT ALIASES
# =============================================================================

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gst='git stash'
alias gstp='git stash pop'

# =============================================================================
# TERRAFORM ALIASES
# =============================================================================

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'
alias tff='terraform fmt'
alias tfv='terraform validate'
alias tfo='terraform output'
alias tfs='terraform show'
alias tfw='terraform workspace'

# =============================================================================
# AWS CLI ALIASES
# =============================================================================

alias awsp='export AWS_PROFILE='
alias awsr='export AWS_REGION='
alias ec2ls='aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,InstanceType,Tags[?Key==\`Name\`].Value|[0]]" --output table'
alias s3ls='aws s3 ls'

# =============================================================================
# AZURE CLI ALIASES
# =============================================================================

alias azl='az login'
alias azs='az account show'
alias azss='az account set --subscription'

# =============================================================================
# GCP (GOOGLE CLOUD PLATFORM) ALIASES
# =============================================================================

alias gcl='gcloud'
alias gcls='gcloud compute instances list'
alias gcstart='gcloud compute instances start'
alias gcstop='gcloud compute instances stop'
alias gcssh='gcloud compute ssh'
alias gke='gcloud container clusters'
alias gsls='gsutil ls'
alias gscp='gsutil cp'
alias gsrm='gsutil rm'

# =============================================================================
# NAVIGATION ALIASES
# =============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# =============================================================================
# SYSTEM ALIASES
# =============================================================================

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias c='clear'

# =============================================================================
# DOCKER FUNCTIONS
# =============================================================================

# Stop and remove all containers, rebuild, and start (as requested by user)
docker-clean-rebuild() {
    echo "Stopping all containers..."
    docker stop $(docker ps -a -q) 2>/dev/null
    echo "Removing all containers..."
    docker rm $(docker ps -a -q) 2>/dev/null
    echo "Building with docker-compose..."
    docker-compose build
    echo "Starting services..."
    docker-compose up -d
    echo "Done!"
}

# Get container IP
dip() {
    if [ -z "$1" ]; then
        echo "Usage: dip <container-name>"
        return 1
    fi
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Docker exec with bash
dbash() {
    if [ -z "$1" ]; then
        echo "Usage: dbash <container-name>"
        return 1
    fi
    docker exec -it "$1" /bin/bash
}

# Docker exec with sh
dsh() {
    if [ -z "$1" ]; then
        echo "Usage: dsh <container-name>"
        return 1
    fi
    docker exec -it "$1" /bin/sh
}

# Remove containers by name pattern
drmbp() {
    if [ -z "$1" ]; then
        echo "Usage: drmbp <pattern>"
        return 1
    fi
    docker ps -a | grep "$1" | awk '{print $1}' | xargs docker rm -f
}

# =============================================================================
# KUBERNETES FUNCTIONS
# =============================================================================

# Get pod by name pattern
kgpod() {
    if [ -z "$1" ]; then
        echo "Usage: kgpod <pattern>"
        return 1
    fi
    kubectl get pods | grep "$1"
}

# Exec into pod
kexec() {
    if [ -z "$1" ]; then
        echo "Usage: kexec <pod-name>"
        return 1
    fi
    kubectl exec -it "$1" -- /bin/bash
}

# Get logs from pod
klg() {
    if [ -z "$1" ]; then
        echo "Usage: klg <pod-name>"
        return 1
    fi
    kubectl logs -f "$1"
}

# Delete pod by pattern
kdelpod() {
    if [ -z "$1" ]; then
        echo "Usage: kdelpod <pattern>"
        return 1
    fi
    kubectl get pods | grep "$1" | awk '{print $1}' | xargs kubectl delete pod
}

# Port forward shortcut
kport() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: kport <pod-name> <port>"
        return 1
    fi
    kubectl port-forward "$1" "$2":"$2"
}

# =============================================================================
# AWS FUNCTIONS
# =============================================================================

# Switch AWS profile
awsprofile() {
    if [ -z "$1" ]; then
        echo "Current AWS Profile: ${AWS_PROFILE:-default}"
        echo "Usage: awsprofile <profile-name>"
        return 1
    fi
    export AWS_PROFILE="$1"
    echo "Switched to AWS profile: $1"
}

# Get EC2 instance by name
ec2name() {
    if [ -z "$1" ]; then
        echo "Usage: ec2name <instance-name>"
        return 1
    fi
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" --query "Reservations[].Instances[].[InstanceId,State.Name,PrivateIpAddress,PublicIpAddress]" --output table
}

# =============================================================================
# GIT FUNCTIONS
# =============================================================================

# Git commit and push
gcp() {
    if [ -z "$1" ]; then
        echo "Usage: gcp <commit-message>"
        return 1
    fi
    git add .
    git commit -m "$1"
    git push
}

# Create branch and switch
gcb() {
    if [ -z "$1" ]; then
        echo "Usage: gcb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
    git push -u origin "$1"
}

# =============================================================================
# TERRAFORM FUNCTIONS
# =============================================================================

# Terraform init and apply
tfia() {
    terraform init && terraform apply
}

# Terraform format and validate
tffv() {
    terraform fmt -recursive && terraform validate
}

# Terraform workspace switch or create
tfws() {
    if [ -z "$1" ]; then
        echo "Usage: tfws <workspace-name>"
        return 1
    fi
    terraform workspace select "$1" 2>/dev/null || terraform workspace new "$1"
}

# =============================================================================
# GCP FUNCTIONS
# =============================================================================

# Switch GCP project
gcpproject() {
    if [ -z "$1" ]; then
        echo "Current GCP Project: $(gcloud config get-value project 2>/dev/null)"
        echo "Usage: gcpproject <project-id>"
        return 1
    fi
    gcloud config set project "$1"
    echo "Switched to GCP project: $1"
}

# Get GCE instance by name
gcpinstance() {
    if [ -z "$1" ]; then
        echo "Usage: gcpinstance <instance-name>"
        return 1
    fi
    gcloud compute instances list --filter="name=$1"
}

# SSH into GCE instance
gcpssh() {
    if [ -z "$1" ]; then
        echo "Usage: gcpssh <instance-name> [zone]"
        return 1
    fi
    if [ -z "$2" ]; then
        gcloud compute ssh "$1"
    else
        gcloud compute ssh "$1" --zone="$2"
    fi
}

# Get GKE credentials
gkecreds() {
    if [ -z "$1" ]; then
        echo "Usage: gkecreds <cluster-name> [zone]"
        return 1
    fi
    if [ -z "$2" ]; then
        gcloud container clusters get-credentials "$1"
    else
        gcloud container clusters get-credentials "$1" --zone="$2"
    fi
}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Load .env file
loadenv() {
    if [ -f .env ]; then
        export $(cat .env | grep -v '^#' | xargs)
        echo ".env file loaded"
    else
        echo ".env file not found"
    fi
}

# Kill process on port
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port-number>"
        return 1
    fi
    lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "Killed process on port $1" || echo "No process found on port $1"
}

# Generate random string
randstr() {
    local length=${1:-32}
    openssl rand -base64 $length | tr -d "=+/" | cut -c1-$length
}

# =============================================================================
# INFORMATION
# =============================================================================

echo "DevOps aliases loaded successfully!"
echo "Type 'alias' to see all available aliases"
echo "Common shortcuts:"
echo "  dclean    - Stop and remove all Docker containers"
echo "  dcrestart - Full Docker cleanup, rebuild, and restart"
echo "  k         - kubectl"
echo "  tf        - terraform"
echo "  gs        - git status"
echo "  gcls      - gcloud compute instances list"

