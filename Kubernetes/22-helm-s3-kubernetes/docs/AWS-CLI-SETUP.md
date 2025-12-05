# AWS CLI Installation and Configuration

Guide to installing and configuring AWS CLI v2 for Helm S3 repository.

## 📋 Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Verification](#verification)
- [Required IAM Permissions](#required-iam-permissions)

## 🚀 Installation

### Install AWS CLI v2

```bash
# Download AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install unzip if not present
apt install unzip -y

# Extract the installer
unzip awscliv2.zip

# Run the installer
sudo ./aws/install

# Verify installation
aws --version
```

**Expected Output:**
```
aws-cli/2.32.9 Python/3.13.9 Linux/6.14.0-1014-aws exe/x86_64.ubuntu.24
```

## ⚙️ Configuration

### Set AWS Credentials via Environment Variables

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="AKIAXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"

# Verify credentials
aws sts get-caller-identity
```

**Expected Output:**
```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-username"
}
```

## ✅ Verification

### Test S3 Access

```bash
# List S3 buckets
aws s3 ls

# Should display your existing buckets
```

## 🔐 Required IAM Permissions

### Attach this policy to your IAM user for Helm S3 repository operations:

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
                "s3:PutBucketVersioning",
                "s3:GetBucketVersioning"
            ],
            "Resource": [
                "arn:aws:s3:::helm-*",
                "arn:aws:s3:::helm-*/*"
            ]
        }
    ]
}
```

### How to Add IAM Policy in AWS Console

1. Go to AWS Console → IAM → Users
2. Select your user
3. Click "Add permissions" → "Attach policies directly"
4. Click "Create policy"
5. Select "JSON" tab
6. Paste the policy above
7. Name it: `HelmS3RepositoryAccess`
8. Attach to your user