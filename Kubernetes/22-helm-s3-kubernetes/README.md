# Helm S3 Repository Setup on Kubernetes

Complete guide to setting up a private Helm chart repository on AWS S3 with step-by-step instructions and issue resolutions.

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31+-blue.svg)](https://kubernetes.io/)
[![Helm](https://img.shields.io/badge/Helm-v3.x-green.svg)](https://helm.sh/)
[![AWS S3](https://img.shields.io/badge/AWS-S3-orange.svg)](https://aws.amazon.com/s3/)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Repository Structure](#repository-structure)
- [Key Issue Resolutions](#key-issue-resolutions)
- [Usage Examples](#usage-examples)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)

## 🎯 Overview

This repository demonstrates how to:
- ✅ Set up AWS S3 as a private Helm chart repository
- ✅ Install and configure helm-s3 plugin with issue resolutions
- ✅ Create and deploy Helm charts with proper service configuration
- ✅ Automate repository setup with a single script
- ✅ Handle common issues and errors encountered in real-world scenarios

**Real-World Tested:** All solutions in this repository are based on actual issues encountered and resolved during implementation.

## ✨ Features

- 🚀 **Automated Setup Script** - One command to create and configure everything
- 🔧 **Issue Resolution Included** - Handles common helm-s3 plugin installation problems
- 📦 **Sample Chart** - Production-ready hello-world chart with fixes
- 📚 **Comprehensive Docs** - Step-by-step guides for every component
- 🔐 **Security Best Practices** - IAM policies and access control examples
- 🧪 **Tested on Ubuntu 24.04** - With Kubernetes v1.31

## 🛠️ Prerequisites

### Required Software

- **Operating System**: Ubuntu 24.04 LTS (or compatible)
- **Kubernetes**: v1.31+ cluster with kubectl configured
- **Helm**: v3.x installed
- **AWS Account**: With S3 access permissions
- **Access**: Root or sudo privileges

### Required AWS IAM Permissions

Your AWS user needs these S3 permissions:

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

## ⚡ Quick Start

### 1. Clone This Repository

```bash
git clone https://github.com/Verdhiya/Docker_k8s.git
cd Docker_k8s/Kubernetes/helm-s3-kubernetes
```

### 2. Install AWS CLI

```bash
# Download AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install dependencies
apt install unzip -y

# Extract and install
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
```

### 3. Configure AWS Credentials

```bash
# Set environment variables
export AWS_ACCESS_KEY_ID="YOUR-ACCESS-KEY"
export AWS_SECRET_ACCESS_KEY="YOUR-SECRET-KEY"
export AWS_DEFAULT_REGION="us-east-1"

# Verify credentials
aws sts get-caller-identity
```

### 4. Run Setup Script

```bash
# Make script executable
chmod +x scripts/s3-helm-repo.sh

# Run the setup
./scripts/s3-helm-repo.sh
```

**The script will:**
- ✅ Verify AWS CLI and credentials
- ✅ Create S3 bucket with versioning
- ✅ Install helm-s3 plugin (with workarounds)
- ✅ Create wrapper script if needed
- ✅ Initialize Helm repository
- ✅ Add repository to Helm configuration

### 5. Push Your First Chart

```bash
# Package the sample chart
helm package hello-world/

# Push to S3
helm-s3 push hello-world-0.1.0.tgz sv-charts

# Update repository index
helm repo update

# Search your repository
helm search repo sv-charts
```

### 6. Deploy Chart

```bash
# Install the chart
helm install myapp sv-charts/hello-world

# Verify deployment
kubectl get all
curl http://localhost:30080
```

## 📚 Documentation

Detailed guides for each component:

- **[AWS CLI Setup](docs/AWS-CLI-SETUP.md)** - Complete AWS CLI installation and configuration
- **[Command Reference](docs/COMMAND-REFERENCE.md)** - Quick reference for all commands
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Setup Example](docs/MY-SETUP.md)** - Real-world production setup example

## 📁 Repository Structure

```
helm-s3-kubernetes/
├── README.md                     # This file
├── .gitignore                    # Git ignore rules
├── hello-world/                  # Sample Helm chart
│   ├── Chart.yaml               # Chart metadata
│   ├── values.yaml              # Default values
│   └── templates/               # Kubernetes manifests
│       ├── deployment.yaml
│       ├── service.yaml         # ✅ Fixed: includes selector
│       ├── serviceaccount.yaml
│       └── tests/
│           └── test-connection.yaml
├── scripts/
│   └── s3-helm-repo.sh          # Automated setup script
└── docs/
    ├── AWS-CLI-SETUP.md         # AWS CLI installation guide
    ├── COMMAND-REFERENCE.md     # Command quick reference
    ├── MY-SETUP.md              # Production setup example
    └── TROUBLESHOOTING.md       # Issue resolutions
```

## 🔧 Key Issue Resolutions

This repository includes solutions for common problems:

### 1. helm-s3 Plugin Installation Error

**Problem:**
```
Error: plugin source does not support verification
```

**Solution:**
```bash
helm plugin install https://github.com/hypnoglow/helm-s3.git \
    --version 0.17.1 \
    --verify=false
```

### 2. Plugin Installs as getter/v1

**Problem:**
```
helm s3 version
Error: unknown command "s3" for "helm"
```

**Solution:** Create wrapper script (handled automatically by setup script)
```bash
cat > /usr/local/bin/helm-s3 << 'WRAPPER'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
WRAPPER
chmod +x /usr/local/bin/helm-s3
```

### 3. Service Has No Endpoints

**Problem:**
```
kubectl get endpoints
NAME                  ENDPOINTS
my-service           <none>
```

**Solution:** Add selector to service template
```yaml
spec:
  selector:
    {{- include "hello-world.selectorLabels" . | nindent 4 }}
```

See [Troubleshooting Guide](docs/TROUBLESHOOTING.md) for more issues and solutions.

## 💻 Usage Examples

### Push New Chart Version

```bash
# Update Chart.yaml version
vi hello-world/Chart.yaml

# Package chart
helm package hello-world/

# Push to S3
helm-s3 push hello-world-0.2.0.tgz sv-charts

# Update and verify
helm repo update
helm search repo sv-charts --versions
```

### Install with Custom Values

```bash
# Install with custom NodePort
helm install myapp sv-charts/hello-world \
    --set service.nodePort=30081

# Install with values file
helm install myapp sv-charts/hello-world \
    --values production-values.yaml
```

### Upgrade and Rollback

```bash
# Upgrade to new version
helm upgrade myapp sv-charts/hello-world --version 0.2.0

# Check history
helm history myapp

# Rollback if needed
helm rollback myapp 1
```

## 🔐 Security Best Practices

1. **Never commit AWS credentials** - Use environment variables or IAM roles
2. **Enable S3 bucket versioning** - For chart rollback capability
3. **Use IAM policies** - Restrict access to specific S3 buckets
4. **Separate environments** - Use different S3 buckets for dev/staging/prod
5. **Rotate access keys** - Regularly update AWS credentials

## 🐛 Troubleshooting

Common issues and quick fixes:

| Issue | Quick Fix |
|-------|-----------|
| `helm-s3: command not found` | Create wrapper: `/usr/local/bin/helm-s3` |
| Service has no endpoints | Add selector to service template |
| NodePort not working | Ensure nodePort in service template |
| AWS credentials error | Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` |
| Plugin verification fails | Use `--verify=false` flag |

Full troubleshooting guide: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## 🧹 Cleanup

```bash
# Uninstall Helm release
helm uninstall myapp

# Remove repository
helm repo remove sv-charts

# Delete S3 bucket
BUCKET_NAME="helm-xxxxxxxx"
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3api delete-bucket --bucket ${BUCKET_NAME} --region us-east-1
```
