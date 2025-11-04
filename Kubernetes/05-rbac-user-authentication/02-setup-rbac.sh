#!/bin/bash
# Apply RBAC configuration for DevUser

echo "=== Setting up RBAC for DevUser ==="

# Apply Role
kubectl apply -f pod-reader-role.yaml

# Apply RoleBinding
kubectl apply -f pod-reader-rolebinding.yaml

# Verify
kubectl get role -n development
kubectl get rolebinding -n development

# Test permissions
echo ""
echo "Testing DevUser permissions..."
kubectl auth can-i list pods --as=DevUser -n development

echo "✅ RBAC configured!"
echo "Test: kubectl get pods --context=DevUser-context"
