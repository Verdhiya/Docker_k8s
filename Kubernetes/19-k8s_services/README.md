# 📚 Kubernetes Services

## 🎯 What I Learned

- Different service types: ClusterIP and NodePort
- How services provide stable access to pods
- Service discovery using DNS
- Cross-namespace service access
- Testing services from within the cluster

## 📚 Concepts Practiced

### Service Types

**ClusterIP (Internal Only)**
- Created a service accessible only within cluster
- Used port 8080 for service, forwarding to port 80 on pods
- Tested access from another pod using service name

**NodePort (External Access)**
- Created a service accessible from outside cluster
- Exposed on port 30099 (NodePort)
- Can access via Node IP and NodePort

### DNS Service Discovery

**Same Namespace:**
```bash
# Works with short name
curl nginx-service:8080
```

**Different Namespace:**
```bash
# Short name doesn't work
curl nginx-service:8080  ❌

# Need namespace qualifier
curl nginx-service.default:8080  ✅

# Full FQDN also works
curl nginx-service.default.svc.cluster.local:8080  ✅
```

## 🗂️ Files Created

| File | What It Does |
|------|--------------|
| `01-nginx-deployment.yml` | Nginx deployment with 3 replicas, label `app=frontend` |
| `02-clusterip-service.yml` | ClusterIP service on port 8080, internal only |
| `03-test-pod.yml` | Pod with curl to test services from inside cluster |
| `04-nodeport-service.yml` | NodePort service on port 30099, external access |
| `05-cross-namespace-test-pod.yml` | Pod in different namespace to test DNS |

## 🚀 What I Did

### Step 1: Created Deployment and ClusterIP Service

```bash
# Created nginx deployment
kubectl apply -f 01-nginx-deployment.yml

# Verified pods running
kubectl get pods -l app=frontend

# Created ClusterIP service
kubectl apply -f 02-clusterip-service.yml

# Checked service and endpoints
kubectl get svc nginx-service
kubectl describe svc nginx-service
kubectl get endpoints nginx-service
```

**Result:** Service created with ClusterIP, 3 endpoints (pod IPs)

### Step 2: Tested Service from Inside Cluster

```bash
# Created test pod
kubectl apply -f 03-test-pod.yml

# Accessed service using service name
kubectl exec pod-svc-test -- curl nginx-service:8080

# Tried from outside (didn't work - ClusterIP is internal only)
curl http://172.31.19.217:8080  ❌
```

**Result:** Service accessible from within cluster, not from outside

### Step 3: Created NodePort Service for External Access

```bash
# Created NodePort service
kubectl apply -f 04-nodeport-service.yml

# Got service details
kubectl get svc nginx-service-nodeport

# Accessed from outside cluster
curl http://172.31.19.217:30099  ✅
```

**Result:** Successfully accessed nginx from outside cluster using NodePort

### Step 4: Tested Cross-Namespace DNS

```bash
# Created new namespace
kubectl create namespace service-namespace

# Created pod in new namespace
kubectl apply -f 05-cross-namespace-test-pod.yml

# Tried short name (failed - different namespace)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service:8080
# Error: Could not resolve host

# Used namespace-qualified name (worked!)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default:8080
# Success: Got nginx HTML

# Used full FQDN (also worked)
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default.svc.cluster.local:8080
# Success: Got nginx HTML

# Used nslookup to see DNS resolution
kubectl exec -n service-namespace svc-test-dns -- nslookup nginx-service.default.svc.cluster.local
# Returned: 10.97.214.191 (service ClusterIP)
```

**Result:** Learned that short names only work in same namespace; need to include namespace for cross-namespace access

## 🔍 Key Discoveries

### Port Mapping
```yaml
Service:
  port: 8080          # What I connect to
  targetPort: 80      # Where it forwards to (pod port)

NodePort:
  port: 80            # Internal port
  targetPort: 80      # Pod port
  nodePort: 30099     # External port on node
```

### DNS Resolution
```
Same namespace:
  nginx-service  ✅

Different namespace:
  nginx-service  ❌
  nginx-service.default  ✅
  nginx-service.default.svc.cluster.local  ✅
```

### Endpoints
- Services use labels to find pods
- Endpoints = actual pod IPs that service routes to
- Can view with: `kubectl get endpoints`

## 📊 What I Tested

**ClusterIP Service:**
- ✅ Accessible from pod in same namespace
- ✅ Accessible from pod in different namespace (with full DNS name)
- ❌ Not accessible from outside cluster

**NodePort Service:**
- ✅ Accessible from inside cluster
- ✅ Accessible from outside via Node IP:NodePort
- ✅ Works on all nodes in cluster

## 💡 What I Learned

1. **Services are stable** - Even when pods restart, service IP stays same
2. **DNS is automatic** - Every service gets a DNS name automatically
3. **Labels matter** - Service selector must match pod labels
4. **Namespaces isolate** - Can't use short DNS names across namespaces
5. **NodePort opens on all nodes** - Any node IP works
6. **ClusterIP is internal only** - Need NodePort/LoadBalancer for external access

---

**Status:** Completed ✅  
**Result:** Understand how services work and how to access them!