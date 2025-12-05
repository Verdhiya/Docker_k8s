# Command Reference Guide

Quick reference for all commands used in Helm S3 repository setup and management.

## 📋 Table of Contents

- [AWS CLI Commands](#aws-cli-commands)
- [helm-s3 Plugin Commands](#helm-s3-plugin-commands)
- [Helm Repository Commands](#helm-repository-commands)
- [Helm Chart Commands](#helm-chart-commands)
- [Helm Release Commands](#helm-release-commands)
- [Kubernetes Commands](#kubernetes-commands)

## ☁️ AWS CLI Commands

### S3 Bucket Operations

```bash
# Create bucket (us-east-1)
aws s3api create-bucket --bucket BUCKET_NAME --region us-east-1

# Create bucket (other regions)
aws s3api create-bucket \
    --bucket BUCKET_NAME \
    --region REGION \
    --create-bucket-configuration LocationConstraint=REGION

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket BUCKET_NAME \
    --versioning-configuration Status=Enabled

# List buckets
aws s3 ls

# List bucket contents
aws s3 ls s3://BUCKET_NAME/ --recursive

# Download file from S3
aws s3 cp s3://BUCKET_NAME/path/file.yaml ./

# Upload file to S3
aws s3 cp file.yaml s3://BUCKET_NAME/path/

# Delete bucket contents
aws s3 rm s3://BUCKET_NAME --recursive

# Delete bucket
aws s3api delete-bucket --bucket BUCKET_NAME --region REGION
```

### Verify Credentials

```bash
# Verify AWS credentials
aws sts get-caller-identity

# Expected output shows UserId, Account, and Arn
```

## 🔌 helm-s3 Plugin Commands

### Installation

```bash
# Install plugin (with version and skip verification)
helm plugin install https://github.com/hypnoglow/helm-s3.git \
    --version 0.17.1 \
    --verify=false

# List installed plugins
helm plugin list

# Uninstall plugin
helm plugin uninstall s3
```

### Create Wrapper Script

```bash
# Create helm-s3 wrapper (if plugin installs as getter/v1)
cat > /usr/local/bin/helm-s3 << 'WRAPPER'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
WRAPPER

chmod +x /usr/local/bin/helm-s3

# Verify
helm-s3 version
```

### Repository Operations

```bash
# Initialize S3 bucket as Helm repository
helm-s3 init s3://BUCKET_NAME/charts

# Initialize with force (overwrite existing)
helm-s3 init --force s3://BUCKET_NAME/charts

# Initialize with ignore if exists
helm-s3 init --ignore-if-exists s3://BUCKET_NAME/charts

# Check version
helm-s3 version
```

### Chart Management

```bash
# Push chart to repository
helm-s3 push CHART.tgz REPO_NAME

# Push with force (overwrite existing)
helm-s3 push --force CHART.tgz REPO_NAME

# Delete chart from repository
helm-s3 delete CHART_NAME --version VERSION REPO_NAME

# Reindex repository
helm-s3 reindex REPO_NAME
```

## 📦 Helm Repository Commands

### Repository Management

```bash
# Add S3 repository
helm repo add REPO_NAME s3://BUCKET_NAME/charts

# List repositories
helm repo list

# Update repositories (fetch latest index)
helm repo update

# Update specific repository
helm repo update REPO_NAME

# Remove repository
helm repo remove REPO_NAME
```

### Searching Charts

```bash
# Search all repositories
helm search repo KEYWORD

# Search specific repository
helm search repo REPO_NAME/

# Search with all versions
helm search repo CHART_NAME --versions

# Example
helm search repo sv-charts
helm search repo sv-charts/hello-world --versions
```

## 📊 Helm Chart Commands

### Chart Development

```bash
# Create new chart
helm create CHART_NAME

# Lint chart (validate)
helm lint CHART_NAME/

# Package chart
helm package CHART_NAME/

# Package with specific version
helm package CHART_NAME/ --version 1.2.3
```

### Chart Information

```bash
# Show chart details
helm show chart REPO_NAME/CHART_NAME

# Show chart values
helm show values REPO_NAME/CHART_NAME

# Show all chart info
helm show all REPO_NAME/CHART_NAME
```

### Chart Templates

```bash
# Render templates locally (dry-run)
helm template RELEASE_NAME CHART_NAME/

# Render with custom values
helm template RELEASE_NAME CHART_NAME/ --values custom-values.yaml

# Render with set values
helm template RELEASE_NAME CHART_NAME/ --set key=value

# Debug templates
helm template RELEASE_NAME CHART_NAME/ --debug
```

### Pulling Charts

```bash
# Pull chart from repository
helm pull REPO_NAME/CHART_NAME

# Pull specific version
helm pull REPO_NAME/CHART_NAME --version 1.2.3

# Pull and extract
helm pull REPO_NAME/CHART_NAME --untar
```

## 🚀 Helm Release Commands

### Installation

```bash
# Install chart
helm install RELEASE_NAME REPO_NAME/CHART_NAME

# Install with custom values
helm install RELEASE_NAME REPO_NAME/CHART_NAME --values values.yaml

# Install with set values
helm install RELEASE_NAME REPO_NAME/CHART_NAME --set key=value

# Install with specific NodePort
helm install RELEASE_NAME REPO_NAME/CHART_NAME --set service.nodePort=30081

# Install in specific namespace
helm install RELEASE_NAME REPO_NAME/CHART_NAME --namespace NAMESPACE

# Dry run (test without installing)
helm install RELEASE_NAME REPO_NAME/CHART_NAME --dry-run

# Dry run with debug
helm install RELEASE_NAME REPO_NAME/CHART_NAME --dry-run --debug
```

### Upgrade and Rollback

```bash
# Upgrade release
helm upgrade RELEASE_NAME REPO_NAME/CHART_NAME

# Upgrade with values
helm upgrade RELEASE_NAME REPO_NAME/CHART_NAME --values values.yaml

# Upgrade or install if not exists
helm upgrade --install RELEASE_NAME REPO_NAME/CHART_NAME

# Rollback to previous revision
helm rollback RELEASE_NAME

# Rollback to specific revision
helm rollback RELEASE_NAME 2
```

### Release Management

```bash
# List releases
helm ls

# List all releases (including failed)
helm ls --all

# List in all namespaces
helm ls --all-namespaces

# Get release status
helm status RELEASE_NAME

# Get release history
helm history RELEASE_NAME

# Get release values
helm get values RELEASE_NAME

# Get release manifest
helm get manifest RELEASE_NAME

# Uninstall release
helm uninstall RELEASE_NAME
```

## ☸️ Kubernetes Commands

### Pod Management

```bash
# List pods
kubectl get pods

# List pods with details
kubectl get pods -o wide

# Watch pods (live updates)
kubectl get pods -w

# Describe pod
kubectl describe pod POD_NAME

# View pod logs
kubectl logs POD_NAME

# Follow pod logs
kubectl logs -f POD_NAME

# Execute command in pod
kubectl exec -it POD_NAME -- /bin/bash
```

### Service Management

```bash
# List services
kubectl get svc

# Describe service
kubectl describe svc SERVICE_NAME

# Get service endpoints
kubectl get endpoints SERVICE_NAME

# Port forward to service
kubectl port-forward svc/SERVICE_NAME 8080:80
```

### Deployment Management

```bash
# List deployments
kubectl get deployments

# Describe deployment
kubectl describe deployment DEPLOYMENT_NAME

# Scale deployment
kubectl scale deployment DEPLOYMENT_NAME --replicas=3

# Check rollout status
kubectl rollout status deployment/DEPLOYMENT_NAME

# View rollout history
kubectl rollout history deployment/DEPLOYMENT_NAME
```

### General Commands

```bash
# Get all resources
kubectl get all

# Get nodes
kubectl get nodes

# Get nodes with details
kubectl get nodes -o wide

# View events
kubectl get events

# Apply manifest
kubectl apply -f manifest.yaml
```

## 🧪 Testing Commands

### Service Testing

```bash
# Test via localhost (if on master/node)
curl http://localhost:NODE_PORT

# Test via node IP
curl http://NODE_IP:NODE_PORT

# Test via pod IP
curl http://POD_IP:80

# Test with verbose output
curl -v http://localhost:NODE_PORT
```

### Network Debugging

```bash
# Check endpoints (must not be <none>)
kubectl get endpoints SERVICE_NAME

# Describe service to check selector
kubectl describe svc SERVICE_NAME | grep -A 5 Selector

# Verify pods match selector
kubectl get pods --show-labels
```

## 📝 Complete Workflow Examples

### Setup S3 Repository

```bash
# 1. Install helm-s3 plugin
helm plugin install https://github.com/hypnoglow/helm-s3.git --version 0.17.1 --verify=false

# 2. Create wrapper
cat > /usr/local/bin/helm-s3 << 'EOF'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
EOF
chmod +x /usr/local/bin/helm-s3

# 3. Initialize S3 bucket
helm-s3 init s3://BUCKET_NAME/charts

# 4. Add repository
helm repo add sv-charts s3://BUCKET_NAME/charts

# 5. Update
helm repo update
```

### Push New Chart

```bash
# 1. Package chart
helm package hello-world/

# 2. Push to S3
helm-s3 push hello-world-0.1.0.tgz sv-charts

# 3. Update repository
helm repo update

# 4. Verify
helm search repo sv-charts
```

### Deploy Application

```bash
# 1. Install from repository
helm install myapp sv-charts/hello-world

# 2. Verify deployment
kubectl get all

# 3. Check service endpoints
kubectl get endpoints

# 4. Test service
curl http://localhost:30080
```

### Update and Rollback

```bash
# 1. Upgrade release
helm upgrade myapp sv-charts/hello-world

# 2. Check status
helm status myapp

# 3. View history
helm history myapp

# 4. Rollback if needed
helm rollback myapp 1
```