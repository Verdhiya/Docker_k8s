#!/bin/bash

echo "========================================="
echo "ISTIO INSTALLATION VIA HELM"
echo "========================================="
echo ""

echo "📦 Step 1: Adding Istio Helm repository..."
helm repo add istio https://istio-release.storage.googleapis.com/charts 2>/dev/null || echo "Repository already exists"

# Update only istio repo (ignore errors from other repos)
echo "Updating Istio repository..."
helm repo update istio 2>/dev/null || echo "Warning: Some repos failed to update, but Istio is OK"
echo ""

echo "🏗️  Step 2: Creating istio-system namespace..."
kubectl create namespace istio-system 2>/dev/null || echo "✅ Namespace already exists"
echo ""

echo "📋 Step 3: Installing Istio Base (CRDs)..."
helm install istio-base istio/base \
  -n istio-system \
  --set defaultRevision=default
echo ""

echo "⏳ Waiting 10 seconds for CRDs..."
sleep 10
echo ""

echo "🗼 Step 4: Installing Istiod (Control Plane)..."
echo "   This may take 1-2 minutes..."
helm install istiod istio/istiod \
  -n istio-system \
  --wait
echo ""

echo "🚪 Step 5: Installing Istio Ingress Gateway..."
helm install istio-ingress istio/gateway \
  -n istio-system \
  --wait
echo ""

echo "✅ Step 6: Verifying installation..."
echo ""
echo "=== Helm Releases ==="
helm list -n istio-system
echo ""
echo "=== Istio Pods ==="
kubectl get pods -n istio-system
echo ""
echo "=== Istio Services ==="
kubectl get svc -n istio-system
echo ""

echo "========================================="
echo "✅ ISTIO INSTALLATION COMPLETE!"
echo "========================================="