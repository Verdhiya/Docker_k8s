#!/bin/bash
set -e

echo "=========================================="
echo "Helm S3 Repository Setup Script"
echo "=========================================="
echo ""

# Create random string
RANDOM_STRING=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
echo "My Random String - $RANDOM_STRING"

# Set the AWS_REGION if not set
DEFAULT_REGION="us-east-1"
AWS_REGION="${AWS_REGION:-${DEFAULT_REGION}}"
export AWS_REGION

echo "Using AWS Region: $AWS_REGION"
echo ""

# Verify AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "ERROR: AWS CLI is not installed"
    echo "Please install it first:"
    echo "  curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
    echo "  apt install unzip -y"
    echo "  unzip awscliv2.zip"
    echo "  sudo ./aws/install"
    exit 1
fi

# Verify AWS credentials
echo "Verifying AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "ERROR: AWS credentials not configured"
    echo "Please configure AWS credentials:"
    echo "  export AWS_ACCESS_KEY_ID='your-key'"
    echo "  export AWS_SECRET_ACCESS_KEY='your-secret'"
    echo "  export AWS_DEFAULT_REGION='us-east-1'"
    exit 1
fi

echo "✓ AWS credentials verified"
echo ""

# Create S3 bucket
BUCKET_NAME="helm-${RANDOM_STRING}"
echo "Creating S3 bucket: $BUCKET_NAME"

if [ "$AWS_REGION" == "us-east-1" ]; then
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $AWS_REGION
else
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $AWS_REGION \
        --create-bucket-configuration LocationConstraint=${AWS_REGION}
fi

# Enable versioning (recommended for Helm repos)
echo "Enabling S3 bucket versioning..."
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

echo "✓ S3 bucket created successfully: $BUCKET_NAME"
echo ""

# Install helm-s3 plugin if not already installed
echo "Checking helm-s3 plugin..."
if helm plugin list | grep -q "^s3"; then
    echo "✓ helm-s3 plugin already installed"
    PLUGIN_VERSION=$(helm plugin list | grep "^s3" | awk '{print $2}')
    echo "  Version: $PLUGIN_VERSION"
else
    echo "Installing helm-s3 plugin..."
    # NOTE: Using --verify=false because plugin doesn't support signature verification
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version 0.17.1 --verify=false
    
    # Verify installation
    if helm plugin list | grep -q "^s3"; then
        echo "✓ helm-s3 plugin installed successfully"
    else
        echo "WARNING: Plugin may be installed as getter only"
        echo "Creating wrapper script for helm-s3 command..."
    fi
fi

# Create helm-s3 wrapper if needed (handles getter/v1 installation issue)
if ! command -v helm-s3 &> /dev/null; then
    echo "Creating helm-s3 wrapper script..."
    
    # Find the plugin binary location
    PLUGIN_DIR="$HOME/.local/share/helm/plugins"
    HELM_S3_BIN=""
    
    if [ -f "$PLUGIN_DIR/helm-s3/bin/helm-s3" ]; then
        HELM_S3_BIN="$PLUGIN_DIR/helm-s3/bin/helm-s3"
    elif [ -f "$PLUGIN_DIR/helm-s3.git/bin/helm-s3" ]; then
        HELM_S3_BIN="$PLUGIN_DIR/helm-s3.git/bin/helm-s3"
    else
        echo "ERROR: Could not find helm-s3 binary"
        echo "Plugin directory contents:"
        ls -la "$PLUGIN_DIR"
        exit 1
    fi
    
    # Create wrapper script
    cat > /usr/local/bin/helm-s3 << WRAPPER_EOF
#!/bin/bash
$HELM_S3_BIN "\$@"
WRAPPER_EOF
    
    chmod +x /usr/local/bin/helm-s3
    
    # Test the wrapper
    if helm-s3 version &> /dev/null; then
        echo "✓ helm-s3 wrapper created successfully"
        echo "  Version: $(helm-s3 version)"
    else
        echo "ERROR: helm-s3 wrapper test failed"
        exit 1
    fi
else
    echo "✓ helm-s3 command already available"
fi

echo ""
echo "Helm S3 Plugin installed successfully"
echo ""

# Initialize S3 bucket for Helm
echo "Initializing Helm repository in S3..."
helm-s3 init --ignore-if-exists s3://${BUCKET_NAME}/charts

echo "✓ Repository initialized"
echo ""

# Add repository to Helm
echo "Adding repository to Helm..."
helm repo add sv-charts s3://${BUCKET_NAME}/charts

echo "✓ Repository added"
echo ""

# Update and verify
echo "Updating repository index..."
helm repo update

echo ""
echo "Verifying repository..."
helm repo list

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo "Bucket Name:  $BUCKET_NAME"
echo "Helm Repo:    s3://${BUCKET_NAME}/charts"
echo "Repo Name:    sv-charts"
echo "AWS Region:   $AWS_REGION"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Package your chart:"
echo "   helm package hello-world/"
echo ""
echo "2. Push to S3:"
echo "   helm-s3 push hello-world-0.1.0.tgz sv-charts"
echo ""
echo "3. Search repository:"
echo "   helm search repo sv-charts"
echo ""
echo "4. Install from repository:"
echo "   helm install myapp sv-charts/hello-world"
echo ""
echo "5. View S3 contents:"
echo "   aws s3 ls s3://${BUCKET_NAME}/charts/ --recursive"
echo "=========================================="
echo ""
echo "IMPORTANT NOTES:"
echo "- Use helm-s3 command with hyphen (not space): helm-s3 push"
echo "- Service template must include selector for endpoints to work"
echo "- NodePort must be specified in service template with conditional"
echo "=========================================="
echo ""
# Save bucket name for future reference
echo "$BUCKET_NAME" > ~/.helm-s3-bucket-name
echo ""
echo "Bucket name saved to: ~/.helm-s3-bucket-name"
echo "==========================================="
echo ""
echo ""
echo "==========================================="
echo " make script executable. "
echo " run this - chmod +x scripts/s3-helm-repo.sh"
echo "==========================================="
echo ""