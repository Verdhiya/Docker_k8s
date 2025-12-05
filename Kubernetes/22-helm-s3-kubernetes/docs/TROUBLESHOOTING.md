# Troubleshooting Guide

Solutions to common issues encountered during Helm S3 repository setup and usage.

## 📋 Table of Contents

- [AWS CLI Issues](#aws-cli-issues)
- [helm-s3 Plugin Issues](#helm-s3-plugin-issues)
- [Service and Networking Issues](#service-and-networking-issues)
- [Chart Deployment Issues](#chart-deployment-issues)
- [S3 Repository Issues](#s3-repository-issues)

## ☁️ AWS CLI Issues

### Issue: Command 'aws' not found

**Symptoms:**
```bash
aws --version
Command 'aws' not found
```

**Solution:**
```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
```

### Issue: Unable to locate credentials

**Symptoms:**
```bash
aws sts get-caller-identity
Unable to locate credentials. You can configure credentials by running "aws configure".
```

**Solution:**
```bash
# Set environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Verify
aws sts get-caller-identity
```

### Issue: Access Denied to S3

**Symptoms:**
```bash
aws s3 ls
An error occurred (AccessDenied) when calling the ListBuckets operation
```

**Solution:**

Add required IAM permissions to your user:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:PutBucketVersioning"
            ],
            "Resource": [
                "arn:aws:s3:::helm-*",
                "arn:aws:s3:::helm-*/*"
            ]
        }
    ]
}
```

## 🔌 helm-s3 Plugin Issues

### Issue: Plugin verification fails

**Symptoms:**
```bash
helm plugin install https://github.com/hypnoglow/helm-s3.git
Error: plugin source does not support verification. Use --verify=false to skip verification
```

**Solution:**
```bash
# Install with --verify=false flag
helm plugin install https://github.com/hypnoglow/helm-s3.git \
    --version 0.17.1 \
    --verify=false
```

### Issue: helm s3 command not found

**Symptoms:**
```bash
helm s3 version
Error: unknown command "s3" for "helm"
Run 'helm --help' for usage.

helm plugin list
NAME    VERSION TYPE            APIVERSION      PROVENANCE      SOURCE
s3      0.17.1  getter/v1       legacy          unknown         unknown
```

**Root Cause:** Plugin installed as `getter/v1` instead of command plugin

**Solution:** Create wrapper script

```bash
# Create wrapper
cat > /usr/local/bin/helm-s3 << 'EOF'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
EOF

# Make executable
chmod +x /usr/local/bin/helm-s3

# Verify - should work now
helm-s3 version
```

**Note:** Use `helm-s3` (with hyphen) instead of `helm s3` (with space)

### Issue: Plugin directory not found

**Symptoms:**
```bash
helm plugin list
# Shows plugin but helm-s3 command fails
ls ~/.local/share/helm/plugins/
# Directory exists but named incorrectly
```

**Solution:**
```bash
# Check plugin directory
ls -la ~/.local/share/helm/plugins/

# If directory is helm-s3.git, adjust wrapper path
cat > /usr/local/bin/helm-s3 << 'EOF'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3.git/bin/helm-s3 "$@"
EOF

chmod +x /usr/local/bin/helm-s3
```

## 🌐 Service and Networking Issues

### Issue: Service has no endpoints

**Symptoms:**
```bash
kubectl get endpoints myapp-hello-world
NAME                  ENDPOINTS
myapp-hello-world     <none>

kubectl describe svc myapp-hello-world
Selector:   <none>
```

**Root Cause:** Missing selector in service template

**Solution:** Add selector to `templates/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "hello-world.fullname" . }}
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

**After fix:**
```bash
# Upgrade the release
helm upgrade myapp ./hello-world/

# Verify endpoints exist now
kubectl get endpoints myapp-hello-world
# Should show pod IPs
```

### Issue: curl to NodePort fails

**Symptoms:**
```bash
curl http://localhost:30080
curl: (7) Failed to connect to localhost port 30080
```

**Troubleshooting steps:**

```bash
# 1. Check if service exists
kubectl get svc

# 2. Check if endpoints exist (must not be <none>)
kubectl get endpoints

# 3. Check if pods are running
kubectl get pods

# 4. Verify service selector matches pod labels
kubectl describe svc SERVICE_NAME | grep -A 5 Selector
kubectl get pods --show-labels

# 5. Try pod IP directly
kubectl get pods -o wide
curl http://POD_IP:80

# 6. Check correct NodePort
kubectl get svc
# Use the port shown in PORT(S) column (e.g., 80:30081/TCP)
curl http://localhost:30081
```

### Issue: NodePort not applied from values.yaml

**Symptoms:**
Kubernetes assigns random port instead of specified nodePort (e.g., 32083 instead of 30080)

**Root Cause:** Service template missing nodePort field

**Solution:** Add nodePort to service template with conditional logic

```yaml
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
```

## 📦 Chart Deployment Issues

### Issue: NodePort already allocated

**Symptoms:**
```bash
helm install myapp sv-charts/hello-world
Error: Service "myapp-hello-world" is invalid: spec.ports[0].nodePort: 
Invalid value: 30080: provided port is already allocated
```

**Solution Option 1:** Uninstall existing release

```bash
# List releases
helm ls

# Uninstall conflicting release
helm uninstall RELEASE_NAME

# Install new release
helm install myapp sv-charts/hello-world
```

**Solution Option 2:** Use different NodePort

```bash
helm install myapp sv-charts/hello-world --set service.nodePort=30081
```

### Issue: Release name already in use

**Symptoms:**
```bash
helm install myapp sv-charts/hello-world
Error: cannot reuse a name that is still in use
```

**Solution:**

```bash
# Check existing releases (including failed ones)
helm ls --all

# Uninstall failed/existing release
helm uninstall myapp

# Install again
helm install myapp sv-charts/hello-world
```

### Issue: Pods stuck in Pending state

**Symptoms:**
```bash
kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
myapp-xxx                0/1     Pending   0          2m
```

**Troubleshooting:**

```bash
# 1. Describe pod to see why
kubectl describe pod POD_NAME

# Common reasons:
# - No worker nodes available
# - Node taints (master-only cluster)
# - Insufficient resources

# If master-only cluster, remove taint:
kubectl taint nodes MASTER_NODE node-role.kubernetes.io/control-plane:NoSchedule-
```

### Issue: Pods stuck in ContainerCreating

**Symptoms:**
```bash
kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
myapp-xxx                0/1     ContainerCreating   0          5m
```

**Troubleshooting:**

```bash
# Describe pod to see events
kubectl describe pod POD_NAME

# Common issues:
# - Image pull errors
# - Network/CNI issues
# - Volume mount issues

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 📂 S3 Repository Issues

### Issue: Repository index not found

**Symptoms:**
```bash
helm repo add sv-charts s3://bucket-name/charts
Error: Looks like "s3://bucket-name/charts" is not a valid chart repository
```

**Solution:** Initialize bucket first

```bash
# Initialize S3 bucket as Helm repository
helm-s3 init s3://bucket-name/charts

# Then add repository
helm repo add sv-charts s3://bucket-name/charts
```

### Issue: Index file already exists

**Symptoms:**
```bash
helm-s3 init s3://bucket-name/charts
The index file already exists under the provided URI and cannot be overwritten
```

**Solution Option 1:** Use --ignore-if-exists

```bash
helm-s3 init --ignore-if-exists s3://bucket-name/charts
```

**Solution Option 2:** Force reinitialize

```bash
helm-s3 init --force s3://bucket-name/charts
```

### Issue: Chart not found in repository

**Symptoms:**
```bash
helm search repo sv-charts
No results found

helm install myapp sv-charts/hello-world
Error: chart "hello-world" not found in sv-charts repository
```

**Solution:**

```bash
# 1. Push chart to repository
helm package hello-world/
helm-s3 push hello-world-0.1.0.tgz sv-charts

# 2. Update repository index
helm repo update

# 3. Verify
helm search repo sv-charts
```

### Issue: Stale repository index

**Symptoms:**
New chart pushed but not showing in search

**Solution:**

```bash
# Update repository index
helm repo update

# Or update specific repo
helm repo update sv-charts

# Verify
helm search repo sv-charts
```

## 🔍 Diagnostic Commands

### Check Plugin Status

```bash
# List plugins
helm plugin list

# Check plugin binary location
ls -la ~/.local/share/helm/plugins/

# Test helm-s3 command
helm-s3 version

# Check wrapper script
cat /usr/local/bin/helm-s3
which helm-s3
```

### Check S3 Repository

```bash
# List S3 contents
aws s3 ls s3://BUCKET_NAME/charts/ --recursive

# Download and view index
aws s3 cp s3://BUCKET_NAME/charts/index.yaml - | cat

# Check bucket versioning
aws s3api get-bucket-versioning --bucket BUCKET_NAME
```

### Check Kubernetes Resources

```bash
# Get all resources
kubectl get all

# Check pod details
kubectl describe pod POD_NAME

# Check service details
kubectl describe svc SERVICE_NAME

# Check endpoints
kubectl get endpoints

# View events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check pod logs
kubectl logs POD_NAME
```

### Check Helm Releases

```bash
# List releases
helm ls

# List all (including failed)
helm ls --all

# Get release status
helm status RELEASE_NAME

# Get release history
helm history RELEASE_NAME

# Get release values
helm get values RELEASE_NAME

# Get release manifest
helm get manifest RELEASE_NAME
```

## 💡 Best Practices

1. **Always use `--verify=false`** when installing helm-s3 plugin
2. **Create wrapper script** if `helm s3` command doesn't work
3. **Always include selector** in service templates
4. **Test with `helm template`** before deploying
5. **Use `helm upgrade --install`** for idempotent deployments
6. **Check endpoints after deployment** to ensure service connectivity
7. **Enable S3 versioning** for chart rollback capability
8. **Use `helm repo update`** after pushing new charts