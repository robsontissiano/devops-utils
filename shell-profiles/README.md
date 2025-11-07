# Shell Profiles and Aliases

A collection of useful shell profiles, aliases, and shortcuts for DevOps workflows.

## Installation

### For Bash
```bash
# Add to ~/.bashrc or ~/.bash_profile
source /path/to/devops-utils/shell-profiles/devops-aliases.sh
```

### For Zsh
```bash
# Add to ~/.zshrc
source /path/to/devops-utils/shell-profiles/devops-aliases.sh
```

## Quick Setup

```bash
echo "source $(pwd)/shell-profiles/devops-aliases.sh" >> ~/.zshrc
source ~/.zshrc
```

## Docker Aliases

### Basic Docker Commands
```bash
alias d='docker'
alias dc='docker-compose'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dsp='docker system prune -a'
```

### Docker Container Management
```bash
# Stop all containers
alias dstop='docker stop $(docker ps -a -q)'

# Remove all containers
alias drm='docker rm $(docker ps -a -q)'

# Stop and remove all containers
alias dclean='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)'

# Remove all images
alias drmi='docker rmi $(docker images -q)'

# Remove dangling images
alias drmid='docker rmi $(docker images -f "dangling=true" -q)'

# Complete cleanup
alias dprune='docker system prune -a --volumes'
```

### Docker Compose Shortcuts
```bash
# Stop, remove, rebuild, and start
alias dcrestart='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker-compose build; docker-compose up -d'

# Docker compose up
alias dcup='docker-compose up -d'

# Docker compose down
alias dcdown='docker-compose down'

# Docker compose logs
alias dclogs='docker-compose logs -f'

# Docker compose build
alias dcbuild='docker-compose build'

# Rebuild and restart
alias dcrebuild='docker-compose down && docker-compose build && docker-compose up -d'
```

### Docker Inspection
```bash
# Show container logs
alias dlogs='docker logs -f'

# Execute bash in container
alias dexec='docker exec -it'

# Show container stats
alias dstats='docker stats'

# Inspect container
alias dinspect='docker inspect'
```

## Kubernetes Aliases

### Basic Kubectl
```bash
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias ka='kubectl apply -f'
alias kex='kubectl exec -it'
alias kl='kubectl logs -f'
```

### Pods
```bash
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kdp='kubectl describe pod'
alias kdelp='kubectl delete pod'
```

### Deployments
```bash
alias kgd='kubectl get deployments'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
```

### Services
```bash
alias kgs='kubectl get services'
alias kds='kubectl describe service'
alias kdels='kubectl delete service'
```

### Namespaces
```bash
alias kgn='kubectl get namespaces'
alias kns='kubectl config set-context --current --namespace'
```

### Context and Config
```bash
alias kctx='kubectl config current-context'
alias kctxs='kubectl config get-contexts'
alias kuse='kubectl config use-context'
```

### Logs and Debugging
```bash
alias klogs='kubectl logs -f'
alias kpf='kubectl port-forward'
aliasktop='kubectl top'
```

## Git Aliases

```bash
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
```

## Terraform Aliases

```bash
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
```

## AWS CLI Aliases

```bash
alias awsp='export AWS_PROFILE='
alias awsr='export AWS_REGION='
alias ec2ls='aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,InstanceType,Tags[?Key==\`Name\`].Value|[0]]" --output table'
alias s3ls='aws s3 ls'
alias s3mb='aws s3 mb'
alias s3rb='aws s3 rb'
```

## Azure CLI Aliases

```bash
alias az='azure'
alias azl='az login'
alias azs='az account show'
alias azss='az account set --subscription'
alias azg='az group'
alias azvm='az vm'
alias azaks='az aks'
```

## GCP (Google Cloud Platform) Aliases

```bash
alias gcl='gcloud'
alias gcls='gcloud compute instances list'
alias gcstart='gcloud compute instances start'
alias gcstop='gcloud compute instances stop'
alias gcssh='gcloud compute ssh'
alias gke='gcloud container clusters'
alias gsls='gsutil ls'
alias gscp='gsutil cp'
alias gsrm='gsutil rm'
```

## Navigation Aliases

```bash
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
```

## System Aliases

```bash
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias h='history'
alias c='clear'
```

## Network Aliases

```bash
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me'
alias ping='ping -c 5'
```

## Functions

### Docker Functions

```bash
# Remove containers by name pattern
drmbp() {
    docker ps -a | grep "$1" | awk '{print $1}' | xargs docker rm -f
}

# Get container IP
dip() {
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Docker exec with bash
dbash() {
    docker exec -it "$1" /bin/bash
}

# Docker exec with sh
dsh() {
    docker exec -it "$1" /bin/sh
}
```

### Kubernetes Functions

```bash
# Get pod by name pattern
kgpod() {
    kubectl get pods | grep "$1"
}

# Exec into pod
kexec() {
    kubectl exec -it "$1" -- /bin/bash
}

# Get logs from pod
klg() {
    kubectl logs -f "$1"
}

# Delete pod by pattern
kdelpod() {
    kubectl get pods | grep "$1" | awk '{print $1}' | xargs kubectl delete pod
}

# Port forward shortcut
kport() {
    kubectl port-forward "$1" "$2":"$2"
}
```

### AWS Functions

```bash
# Switch AWS profile
awsprofile() {
    export AWS_PROFILE="$1"
    echo "Switched to AWS profile: $1"
}

# Get EC2 instance by name
ec2name() {
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" --query "Reservations[].Instances[].[InstanceId,State.Name,PrivateIpAddress,PublicIpAddress]" --output table
}

# SSH to EC2 by instance ID
ec2ssh() {
    IP=$(aws ec2 describe-instances --instance-ids "$1" --query "Reservations[].Instances[].PublicIpAddress" --output text)
    ssh ec2-user@"$IP"
}
```

### GCP Functions

```bash
# Switch GCP project
gcpproject() {
    gcloud config set project "$1"
    echo "Switched to GCP project: $1"
}

# Get GCE instance by name
gcpinstance() {
    gcloud compute instances list --filter="name=$1"
}

# SSH into GCE instance
gcpssh() {
    gcloud compute ssh "$1" --zone="$2"
}

# Get GKE credentials
gkecreds() {
    gcloud container clusters get-credentials "$1" --zone="$2"
}
```

### Git Functions

```bash
# Git commit and push
gcp() {
    git add .
    git commit -m "$1"
    git push
}

# Create branch and switch
gcb() {
    git checkout -b "$1"
    git push -u origin "$1"
}

# Git pull all branches
gpall() {
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
}
```

### Terraform Functions

```bash
# Terraform init and apply
tfia() {
    terraform init && terraform apply
}

# Terraform format and validate
tffv() {
    terraform fmt -recursive && terraform validate
}

# Terraform workspace switch or create
tfw() {
    terraform workspace select "$1" || terraform workspace new "$1"
}
```

## Environment Setup Functions

```bash
# Load .env file
loadenv() {
    if [ -f .env ]; then
        export $(cat .env | grep -v '^#' | xargs)
        echo ".env file loaded"
    else
        echo ".env file not found"
    fi
}

# Show all loaded environment variables
showenv() {
    env | sort
}
```

## Development Shortcuts

```bash
# Start development environment
alias devup='docker-compose -f docker-compose.dev.yml up -d'
alias devdown='docker-compose -f docker-compose.dev.yml down'
alias devlogs='docker-compose -f docker-compose.dev.yml logs -f'

# Start production environment
alias produp='docker-compose -f docker-compose.prod.yml up -d'
alias proddown='docker-compose -f docker-compose.prod.yml down'
alias prodlogs='docker-compose -f docker-compose.prod.yml logs -f'
```

## Monitoring Aliases

```bash
# System monitoring
alias cpu='top -o cpu'
alias mem='top -o mem'
alias disk='df -h'
alias proc='ps aux | grep'
```

## Productivity Aliases

```bash
# Quick edit configs
alias editbash='vim ~/.bashrc'
alias editzsh='vim ~/.zshrc'
alias sourcebash='source ~/.bashrc'
alias sourcezsh='source ~/.zshrc'

# Quick directory access
alias projects='cd ~/projects'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
```

## Safety Aliases

```bash
# Confirm before overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Create parent directories as needed
alias mkdir='mkdir -p'
```

## JSON/YAML Tools

```bash
# Pretty print JSON
alias json='python -m json.tool'

# YAML to JSON
alias yaml2json='python -c "import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout, indent=2)"'

# JSON to YAML
alias json2yaml='python -c "import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout)"'
```

## Advanced One-Liners

### Find and Kill Process
```bash
killport() {
    lsof -ti:$1 | xargs kill -9
}
```

### Generate Random String
```bash
randstr() {
    openssl rand -base64 ${1:-32}
}
```

### Watch Command
```bash
alias watch='watch -n 1'
```

### Tail Multiple Logs
```bash
tailall() {
    tail -f "$@"
}
```

## Custom Prompt (Optional)

```bash
# Add to your shell profile for a colorful prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# With git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
```

## Tips

1. Add only the aliases you actually use to avoid clutter
2. Test aliases before adding them permanently
3. Use `alias` command to see all current aliases
4. Use `unalias <alias-name>` to remove an alias
5. Create custom functions for complex operations
6. Document your custom aliases for future reference

