# Kubernetes Services - Commands I Used

## Commands I Actually Ran

### Create Resources

```bash
# Create deployment
kubectl apply -f 01-nginx-deployment.yml

# Create ClusterIP service
kubectl apply -f 02-clusterip-service.yml

# Create test pod
kubectl apply -f 03-test-pod.yml

# Create NodePort service
kubectl apply -f 04-nodeport-service.yml

# Create namespace
kubectl create namespace service-namespace

# Create pod in different namespace
kubectl apply -f 05-cross-namespace-test-pod.yml
```

### View Resources

```bash
# View pods
kubectl get pods
kubectl get pods -l app=frontend
kubectl get pods -o wide
kubectl get pods --show-labels

# View services
kubectl get svc
kubectl get services
kubectl get svc -o wide

# View in specific namespace
kubectl get pods -n service-namespace
kubectl get pods -n service-namespace -o wide --show-labels

# View endpoints
kubectl get endpoints
kubectl get endpoints nginx-service

# View namespaces
kubectl get namespaces
kubectl get namespaces --show-labels
```

### Describe Resources

```bash
# Describe deployment
kubectl describe deployment nginx-server

# Describe service
kubectl describe service nginx-service
kubectl describe service nginx-service-nodeport

# Describe pod
kubectl describe pod pod-svc-test
```

### Test Services

```bash
# Test ClusterIP service from pod (same namespace)
kubectl exec pod-svc-test -- curl nginx-service:8080

# Test from pod in different namespace - short name (failed)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service:8080

# Test with namespace qualifier (worked)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default:8080

# Test with full FQDN (worked)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default.svc.cluster.local:8080

# Test NodePort from outside cluster
curl http://172.31.19.217:30099
```

### DNS Resolution Testing

```bash
# nslookup from pod in different namespace
kubectl exec -n service-namespace svc-test-dns -- nslookup nginx-service.default.svc.cluster.local

# Result showed:
# Server: 10.96.0.10
# Address: 10.96.0.10:53
# Name: nginx-service.default.svc.cluster.local
# Address: 10.97.214.191
```

## What Each Command Showed Me

### Endpoints Show Pod IPs

```bash
kubectl get endpoints nginx-service
```
Output:
```
NAME            ENDPOINTS
nginx-service   10.244.0.212:80,10.244.0.211:80,10.244.0.213:80
```

These matched my pod IPs!

### Service Details

```bash
kubectl describe service nginx-service
```
Showed:
- Type: ClusterIP
- IP: 10.97.214.191 (stable IP)
- Port: 8080/TCP
- TargetPort: 80/TCP
- Endpoints: (3 pod IPs)
- Selector: app=frontend

### NodePort Service Details

```bash
kubectl describe service nginx-service-nodeport
```
Showed:
- Type: NodePort
- IP: 10.110.180.105
- Port: 80/TCP
- TargetPort: 80/TCP
- NodePort: 30099/TCP
- Endpoints: (same 3 pod IPs)

## DNS Discovery Results

| From | To | Command | Result |
|------|-----|---------|--------|
| default | default | `curl nginx-service:8080` | ✅ Worked |
| service-namespace | default | `curl nginx-service:8080` | ❌ Failed (DNS error) |
| service-namespace | default | `curl nginx-service.default:8080` | ✅ Worked |
| service-namespace | default | `curl nginx-service.default.svc.cluster.local:8080` | ✅ Worked |

## Quick Reference

```bash
# View services
kubectl get svc

# View endpoints (pod IPs)
kubectl get endpoints <service-name>

# Test from pod
kubectl exec <pod-name> -- curl <service-name>:<port>

# Test cross-namespace
kubectl exec -n <namespace> <pod> -- curl <service>.<target-namespace>:<port>

# Test NodePort from outside
curl http://<node-ip>:<nodeport>

# DNS lookup
kubectl exec <pod> -- nslookup <service-name>
```

## What Worked vs What Didn't

**✅ Worked:**
- Accessing ClusterIP service from same namespace using short name
- Accessing ClusterIP service from different namespace using namespace-qualified name
- Accessing NodePort service from outside cluster
- DNS resolution with full FQDN

**❌ Didn't Work:**
- Accessing ClusterIP service from outside cluster
- Using short service name from different namespace
- Trying to curl NodePort on port 80 from outside (needed port 30099)

---

These are the actual commands I used and what I learned from them!