# Commands Reference - Kubernetes Networking

## Test Pod-to-Pod Communication

```bash
# Get pod IPs
kubectl get pods -o wide

# Test direct IP
kubectl exec <source-pod> -- curl <destination-ip>

# Test Pod DNS (from inside pod)
kubectl exec <source-pod> -- curl <ip-with-dashes>.<namespace>.pod.cluster.local
```

## Install Tools in Pods

```bash
# Get shell in pod
kubectl exec -it <pod-name> -- sh

# Alpine: Install curl
apk update
apk add curl

# Ubuntu/Debian: Install curl
apt-get update
apt-get install -y curl

# Test from inside pod
curl <destination-ip>
```

## Check DNS

```bash
# View CoreDNS service
kubectl get svc -n kube-system kube-dns

# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Test DNS resolution
kubectl exec <pod> -- nslookup kubernetes.default
```

## Pod DNS Format

```bash
# Convert Pod IP to DNS
# IP: 192.168.1.10
# DNS: 192-168-1-10.default.pod.cluster.local

# Test Pod DNS
kubectl exec <pod> -- curl 192-168-1-10.default.pod.cluster.local
```

## Cleanup

```bash
kubectl delete pod nginx-nodename
kubectl delete pod frontend-app
```
