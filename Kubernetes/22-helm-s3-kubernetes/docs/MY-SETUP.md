# Production Setup Example

Real-world example of Helm S3 repository setup with sanitized configuration details.

## 📊 Configuration Overview

### AWS Configuration

```
AWS Region:        us-east-1
S3 Bucket:         helm-f6rdqusu (example)
Repository URL:    s3://helm-f6rdqusu/charts
Repository Name:   sv-charts
```

### Kubernetes Cluster

```
Cluster Version:   v1.31.13
Container Runtime: containerd 1.7.28
CNI Plugin:        Calico
Operating System:  Ubuntu 24.04.3 LTS
```

### Helm Configuration

```
Helm Version:      v3.x
Plugin:            helm-s3 v0.17.1
Plugin Location:   ~/.local/share/helm/plugins/helm-s3
Wrapper Script:    /usr/local/bin/helm-s3
```

## 🚀 Setup Steps Performed

### 1. AWS CLI Installation

```bash
# Downloaded and installed AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Verified installation
aws --version
# Output: aws-cli/2.32.9 Python/3.13.9 Linux/6.14.0-1014-aws exe/x86_64.ubuntu.24
```

### 2. AWS Credentials Setup

```bash
# Configured AWS credentials
export AWS_ACCESS_KEY_ID="AKIAXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="your-secret-key-here"
export AWS_DEFAULT_REGION="us-east-1"

# Verified credentials
aws sts get-caller-identity
```

### 3. helm-s3 Plugin Installation

```bash
# Installed plugin with version specification
helm plugin install https://github.com/hypnoglow/helm-s3.git \
    --version 0.17.1 \
    --verify=false

# Verified installation
helm plugin list
```

### 4. Created Wrapper Script

**Issue:** Plugin installed as `getter/v1` instead of command plugin

**Solution:**
```bash
# Created wrapper script
cat > /usr/local/bin/helm-s3 << 'WRAPPER'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
WRAPPER

chmod +x /usr/local/bin/helm-s3

# Verified
helm-s3 version
# Output: 0.17.1
```

### 5. S3 Bucket Setup

```bash
# Bucket was created by setup script
# Bucket name: helm-f6rdqusu

# Enabled versioning
aws s3api put-bucket-versioning \
    --bucket helm-f6rdqusu \
    --versioning-configuration Status=Enabled

# Verified
aws s3 ls s3://helm-f6rdqusu/
```

### 6. Repository Initialization

```bash
# Initialized S3 as Helm repository
helm-s3 init s3://helm-f6rdqusu/charts

# Added to Helm
helm repo add sv-charts s3://helm-f6rdqusu/charts

# Updated repository index
helm repo update

# Verified
helm repo list
# Output:
# NAME        URL
# sv-charts   s3://helm-f6rdqusu/charts
```

### 7. Chart Preparation

**Fixed service template issue:**

```yaml
# File: hello-world/templates/service.yaml
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
      {{- if and (eq .Values.service.type "NodePort") .Values.service.nodePort }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
  selector:
    {{- include "hello-world.selectorLabels" . | nindent 4 }}
```

**Key fix:** Added `selector` section to service template

### 8. Chart Deployment

```bash
# Packaged chart
helm package hello-world/
# Output: Successfully packaged chart and saved it to: /root/hello-world-0.1.0.tgz

# Pushed to S3
helm-s3 push hello-world-0.1.0.tgz sv-charts
# Output: Successfully uploaded the chart to the repository.

# Updated repository
helm repo update

# Searched repository
helm search repo sv-charts
# Output:
# NAME                      CHART VERSION   APP VERSION   DESCRIPTION
# sv-charts/hello-world     0.1.0           1.16.0        A Helm chart for Kubernetes
```

### 9. Application Deployment

```bash
# Installed chart with custom NodePort
helm install myapp sv-charts/hello-world --set service.nodePort=30081

# Verified deployment
kubectl get all
# Output:
# NAME                                 READY   STATUS    RESTARTS   AGE
# pod/myapp-hello-world-xxx-xxx        1/1     Running   0          1m
# pod/myapp-hello-world-xxx-yyy        1/1     Running   0          1m
#
# NAME                        TYPE       CLUSTER-IP    PORT(S)
# service/myapp-hello-world   NodePort   10.x.x.x      80:30081/TCP
#
# NAME                                READY   UP-TO-DATE   AVAILABLE
# deployment.apps/myapp-hello-world   2/2     2            2

# Verified endpoints
kubectl get endpoints myapp-hello-world
# Output:
# NAME                  ENDPOINTS
# myapp-hello-world     192.168.x.x:80,192.168.x.y:80

# Tested service
curl http://localhost:30081
# Output: Welcome to nginx!
```

## 🔧 Issues Encountered and Resolved

### Issue 1: Plugin Verification Failed

**Error:**
```
Error: plugin source does not support verification
```

**Solution:**
```bash
helm plugin install https://github.com/hypnoglow/helm-s3.git \
    --version 0.17.1 \
    --verify=false
```

### Issue 2: helm-s3 Command Not Found

**Error:**
```
helm s3 version
Error: unknown command "s3" for "helm"
```

**Root Cause:** Plugin installed as `getter/v1` instead of command plugin

**Solution:** Created wrapper script at `/usr/local/bin/helm-s3`

### Issue 3: Service Had No Endpoints

**Error:**
```
kubectl describe svc myapp-hello-world
Selector:   <none>
Endpoints:  <none>
```

**Root Cause:** Missing selector in service template

**Solution:** Added selector section to `templates/service.yaml`

### Issue 4: NodePort Not Applied

**Error:** Kubernetes assigned random NodePort instead of specified 30080

**Root Cause:** Service template didn't include nodePort field

**Solution:** Added conditional nodePort in service template

## 📝 Current Working Configuration

### Repository Status

```bash
helm repo list
# NAME        URL
# sv-charts   s3://helm-f6rdqusu/charts

helm search repo sv-charts
# NAME                      CHART VERSION   APP VERSION
# sv-charts/hello-world     0.1.0           1.16.0
```

### S3 Bucket Contents

```bash
aws s3 ls s3://helm-f6rdqusu/charts/ --recursive
# 2025-12-04 15:44:18       4988 charts/hello-world-0.1.0.tgz
# 2025-12-04 15:44:18        420 charts/index.yaml
```

### Deployed Application

```bash
helm ls
# NAME    NAMESPACE   REVISION   STATUS     CHART
# myapp   default     1          deployed   hello-world-0.1.0

kubectl get pods
# NAME                                 READY   STATUS    RESTARTS   AGE
# myapp-hello-world-xxx-xxx            1/1     Running   0          5m
# myapp-hello-world-xxx-yyy            1/1     Running   0          5m

kubectl get svc
# NAME                  TYPE       CLUSTER-IP    PORT(S)
# myapp-hello-world     NodePort   10.x.x.x      80:30081/TCP
```

## 🎯 Key Takeaways

1. **Always use `--verify=false`** when installing helm-s3 plugin
2. **Create wrapper script** if plugin installs as getter/v1
3. **Service template must include selector** for endpoints to work
4. **NodePort requires conditional logic** in service template
5. **S3 bucket versioning is essential** for rollback capability
6. **Repository name is arbitrary** - choose meaningful names like `sv-charts`

## 📚 Quick Commands for Daily Use

```bash
# Push new chart version
helm package hello-world/
helm-s3 push hello-world-0.1.0.tgz sv-charts
helm repo update

# Deploy/Upgrade application
helm upgrade --install myapp sv-charts/hello-world

# Check status
helm ls
kubectl get all

# Rollback if needed
helm rollback myapp 1

# View S3 contents
aws s3 ls s3://helm-f6rdqusu/charts/ --recursive
```