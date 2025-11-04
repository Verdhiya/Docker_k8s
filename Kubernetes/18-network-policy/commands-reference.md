# Commands Reference - Network Policies

## Create Namespace

```bash
# Create namespace
kubectl create namespace network-policy

# Label namespace
kubectl label namespace network-policy role=test-network-policy

# View namespace labels
kubectl get namespaces --show-labels
```

## Apply Network Policy

```bash
# Create pods
kubectl apply -f 01-network-policy-pods.yml

# Apply network policy
kubectl apply -f 02-network-policy.yml

# View policies
kubectl get networkpolicy -n network-policy
kubectl describe networkpolicy <name> -n network-policy
```

## Test Policy Enforcement

```bash
# Get pod IPs
kubectl get pods -n network-policy -o wide

# Test from busybox to nginx
kubectl exec -n network-policy busybox-pod -- curl <nginx-ip>

# Success = Allowed ✅
# Timeout = Blocked ❌
```

## Debug Policy

```bash
# Check policy details
kubectl describe networkpolicy <name> -n network-policy

# Check pod labels (must match selectors)
kubectl get pods -n network-policy --show-labels

# Check namespace labels
kubectl get namespace network-policy --show-labels
```

## Common Patterns

```bash
# Deny all ingress
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
