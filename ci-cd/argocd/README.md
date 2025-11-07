# ArgoCD - GitOps Continuous Delivery for Kubernetes

Declarative GitOps CD tool for Kubernetes. Automatically sync your Kubernetes applications with Git repositories.

## Quick Start

### Install ArgoCD

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Login

```bash
# Open browser
https://localhost:8080

# Username: admin
# Password: (from command above)
```

### Install CLI

```bash
# macOS
brew install argocd

# Linux
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
```

### Login via CLI

```bash
argocd login localhost:8080
```

## Create First Application

### Using CLI

```bash
argocd app create myapp \
  --repo https://github.com/myuser/myrepo \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default
```

### Using YAML

Create `application.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/myuser/myrepo
    targetRevision: HEAD
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Apply:
```bash
kubectl apply -f application.yaml
```

## Application Examples

All examples are in the `applications/` directory:

- `simple-app.yaml` - Basic application
- `helm-app.yaml` - Helm chart deployment
- `kustomize-app.yaml` - Kustomize deployment
- `multi-source-app.yaml` - Multiple sources

## Repository Structure

### Plain Kubernetes Manifests

```
myrepo/
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
```

### Helm Chart

```
myrepo/
├── charts/
│   └── myapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
```

### Kustomize

```
myrepo/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── staging/
    │   └── kustomization.yaml
    └── production/
        └── kustomization.yaml
```

## Sync Policies

### Manual Sync

```yaml
syncPolicy: {}
```

### Automatic Sync

```yaml
syncPolicy:
  automated:
    prune: true      # Delete resources not in Git
    selfHeal: true   # Force sync when cluster state differs
```

### Sync Options

```yaml
syncPolicy:
  automated: {}
  syncOptions:
    - CreateNamespace=true
    - PruneLast=true
    - ApplyOutOfSyncOnly=true
```

### Retry Strategy

```yaml
syncPolicy:
  retry:
    limit: 5
    backoff:
      duration: 5s
      factor: 2
      maxDuration: 3m
```

## Multiple Environments

### Using Overlays (Kustomize)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-staging
spec:
  source:
    repoURL: https://github.com/myuser/myrepo
    path: overlays/staging
    targetRevision: HEAD
  destination:
    namespace: staging
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-production
spec:
  source:
    repoURL: https://github.com/myuser/myrepo
    path: overlays/production
    targetRevision: HEAD
  destination:
    namespace: production
```

### Using Values Files (Helm)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-prod
spec:
  source:
    repoURL: https://github.com/myuser/myrepo
    path: charts/myapp
    helm:
      valueFiles:
        - values-production.yaml
      parameters:
        - name: image.tag
          value: "1.0.0"
        - name: replicaCount
          value: "3"
```

## Projects

Create project for team isolation:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-a
  namespace: argocd
spec:
  description: Team A Applications

  sourceRepos:
    - 'https://github.com/myorg/team-a-*'

  destinations:
    - namespace: 'team-a-*'
      server: https://kubernetes.default.svc

  clusterResourceWhitelist:
    - group: ''
      kind: Namespace

  namespaceResourceWhitelist:
    - group: 'apps'
      kind: Deployment
    - group: ''
      kind: Service
```

## Helm Integration

### Deploy Helm Chart from Git

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  source:
    repoURL: https://github.com/myuser/myrepo
    path: charts/myapp
    targetRevision: HEAD
    helm:
      values: |
        replicaCount: 3
        image:
          repository: myregistry/myapp
          tag: v1.0.0
```

### Deploy from Helm Repository

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
spec:
  source:
    repoURL: https://charts.bitnami.com/bitnami
    chart: nginx
    targetRevision: 13.2.0
    helm:
      parameters:
        - name: service.type
          value: LoadBalancer
```

## Kustomize Integration

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  source:
    repoURL: https://github.com/myuser/myrepo
    path: overlays/production
    targetRevision: HEAD
    kustomize:
      images:
        - myregistry/myapp:v1.0.0
      commonAnnotations:
        deployed-by: argocd
```

## Multi-Source Applications

Deploy from multiple repos:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  sources:
    - repoURL: https://github.com/myuser/helm-charts
      path: myapp
      targetRevision: HEAD
      helm:
        valueFiles:
          - $values/values-production.yaml
    - repoURL: https://github.com/myuser/config-repo
      targetRevision: HEAD
      ref: values
  destination:
    server: https://kubernetes.default.svc
    namespace: production
```

## Notifications

### Configure Notifications

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  service.slack: |
    token: $slack-token

  trigger.on-deployed: |
    - when: app.status.operationState.phase in ['Succeeded']
      send: [app-deployed]

  template.app-deployed: |
    message: |
      Application {{.app.metadata.name}} has been deployed!
    slack:
      attachments: |
        [{
          "title": "{{ .app.metadata.name}}",
          "title_link":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}",
          "color": "good"
        }]
```

### Subscribe to Notifications

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  annotations:
    notifications.argoproj.io/subscribe.on-deployed.slack: my-channel
```

## SSO Integration

### Configure GitHub SSO

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  url: https://argocd.example.com

  dex.config: |
    connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: $github-client-id
          clientSecret: $github-client-secret
          orgs:
            - name: my-org
```

## RBAC

### Configure Role-Based Access

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: role:readonly

  policy.csv: |
    # Admins can do everything
    p, role:admin, *, *, */*, allow

    # Developers can sync apps
    p, role:developer, applications, sync, */*, allow
    p, role:developer, applications, get, */*, allow

    # Assign roles to users
    g, admin@example.com, role:admin
    g, dev@example.com, role:developer
```

## CLI Commands

```bash
# List applications
argocd app list

# Get application details
argocd app get myapp

# Sync application
argocd app sync myapp

# View application logs
argocd app logs myapp

# View application history
argocd app history myapp

# Rollback application
argocd app rollback myapp <revision-id>

# Delete application
argocd app delete myapp

# Create application
argocd app create myapp --repo https://github.com/user/repo --path k8s

# Set application parameter
argocd app set myapp --helm-set image.tag=v2.0.0
```

## Image Updater

Auto-update container images:

```bash
# Install Image Updater
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
```

Configure application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  annotations:
    argocd-image-updater.argoproj.io/image-list: myimage=myregistry/myapp
    argocd-image-updater.argoproj.io/myimage.update-strategy: latest
```

## Best Practices

### Repository Organization
1. One repository per application or service
2. Use branches for environments
3. Tag releases properly
4. Keep manifests simple

### Application Management
1. Use projects for team isolation
2. Enable automated sync carefully
3. Use health checks
4. Implement proper RBAC

### Security
1. Use encrypted secrets (Sealed Secrets, SOPS)
2. Enable SSO
3. Implement RBAC
4. Audit logs regularly

### Performance
1. Limit concurrent syncs
2. Use application sets for many apps
3. Implement webhook notifications
4. Tune refresh intervals

## Troubleshooting

### Application Out of Sync

```bash
# Check diff
argocd app diff myapp

# Force sync
argocd app sync myapp --force

# Check sync status
argocd app get myapp
```

### Sync Fails

Check:
- Kubernetes cluster connectivity
- Git repository access
- RBAC permissions
- Resource quotas

### Application Health Unknown

- Check health checks in manifests
- Verify deployment status
- Review pod logs

## Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Best Practices](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
- [Examples Repository](https://github.com/argoproj/argocd-example-apps)
- [Community](https://argoproj.github.io/community/)

## Next Steps

1. Install ArgoCD in your cluster
2. Create first application
3. Configure auto-sync
4. Set up notifications
5. Implement RBAC
6. Add more applications
7. Configure SSO
8. Set up monitoring

