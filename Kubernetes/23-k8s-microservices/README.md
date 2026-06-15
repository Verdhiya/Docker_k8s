# Kubernetes Microservices - Food Delivery Platform

## 🎯 What I Learned

- Building a multi-service application as independent, separately-scalable deployments
- API Gateway pattern using NGINX as a reverse proxy (config via ConfigMap)
- Service-to-service communication using Kubernetes DNS (ClusterIP services)
- Path-based routing to backend services (`/api/users`, `/api/restaurants`, `/api/orders`, `/api/payments`)
- Exposing a single external entry point with a NodePort service
- Horizontal Pod Autoscaler (HPA) for CPU-based auto-scaling
- Installing Istio service mesh via Helm (3-chart approach)

## 🏗️ Architecture

```
                 External traffic
                       │
                       ▼
              ┌─────────────────┐
              │   API Gateway   │   nginx:alpine (NodePort 30200)
              │  (reverse proxy)│   config from ConfigMap
              └────────┬────────┘
                       │ path-based routing
       ┌───────────────┼───────────────┬───────────────┐
       ▼               ▼               ▼               ▼
 /api/users     /api/restaurants   /api/orders    /api/payments
       │               │               │               │
 ┌──────────┐   ┌──────────────┐  ┌──────────┐   ┌──────────────┐
 │   user   │   │  restaurant  │  │  order   │   │   payment    │
 │ service  │   │   service    │  │ service  │   │   service    │
 │ 2 replica│   │ 3 replica+HPA│  │ 2 replica│   │  3 replicas  │
 └──────────┘   └──────────────┘  └──────────┘   └──────────────┘

 Namespace: food-delivery   |   Backends: hashicorp/http-echo (ClusterIP)
```

- **App pods:** 10 (2 user + 3 restaurant + 2 order + 3 payment)
- **Gateway pods:** 1
- **Service discovery:** internal ClusterIP + Kubernetes DNS (e.g. `http://user-service/`)
- **External access:** API Gateway via NodePort `30200`

## 🗂️ Files Created

| File | What It Does |
|------|--------------|
| `01-user-service-dep-&-svc.yml` | User (auth) service — Deployment (2 replicas) + ClusterIP Service |
| `02-restaurant-service-dep-&-svc.yml` | Restaurant (catalog) service — Deployment (3 replicas) + ClusterIP Service |
| `03-order-service-dep-&-svc.yml` | Order service — Deployment (2 replicas) + ClusterIP Service |
| `04-api-gateway-config-dep-svc.yml` | NGINX API Gateway — ConfigMap (nginx.conf reverse proxy) + Deployment + NodePort Service (30200) |
| `05-payment-service-dep-&-svc.yml` | Payment service — Deployment (3 replicas) + ClusterIP Service |
| `06-restaurant-service-hpa.yml` | HorizontalPodAutoscaler for restaurant-service (min 3, max 20, 70% CPU) |
| `07-install-istio-via-helm.sh` | Bash script: installs Istio via Helm (base CRDs → istiod → ingress gateway) |

## 🚀 What I Did Step-by-Step

### 1. Create the namespace
```bash
kubectl create namespace food-delivery
```

### 2. Deploy the backend microservices
Each service is a `hashicorp/http-echo` container returning a fixed message on port `8080`,
fronted by a ClusterIP Service on port `80`.

```bash
kubectl apply -f 01-user-service-dep-&-svc.yml
kubectl apply -f 02-restaurant-service-dep-&-svc.yml
kubectl apply -f 03-order-service-dep-&-svc.yml
kubectl apply -f 05-payment-service-dep-&-svc.yml
```

### 3. Deploy the API Gateway
NGINX reads its `nginx.conf` from a ConfigMap (mounted via `subPath`) and reverse-proxies
each `/api/*` path to the matching ClusterIP service by DNS name.

```bash
kubectl apply -f 04-api-gateway-config-dep-svc.yml
```

### 4. Add auto-scaling to the restaurant service
Requires Metrics Server installed in the cluster. The Deployment must define CPU
**resource requests** for the HPA to calculate utilization.

```bash
kubectl apply -f 06-restaurant-service-hpa.yml
kubectl get hpa -n food-delivery
```

### 5. (Optional) Install Istio service mesh
```bash
chmod +x 07-install-istio-via-helm.sh
./07-install-istio-via-helm.sh
```

## ✅ Verify

```bash
# All workloads in the namespace
kubectl get all -n food-delivery

# Test routing through the gateway (NodePort 30200)
curl http://<node-ip>:30200/
curl http://<node-ip>:30200/api/users
curl http://<node-ip>:30200/api/restaurants
curl http://<node-ip>:30200/api/orders
curl http://<node-ip>:30200/api/payments

# Watch the HPA react under load
kubectl get hpa -n food-delivery -w
```

## 🔑 Key Takeaways

- **Independent deployments** let each service scale and roll out on its own
- The **API Gateway** gives one external entry point while backends stay internal (ClusterIP)
- **Kubernetes DNS** (`http://user-service/`) removes the need for hardcoded pod IPs
- **HPA** needs both Metrics Server *and* CPU resource requests on the target pods
- **Istio via Helm** is installed in three ordered charts: `base` (CRDs) → `istiod` (control plane) → `gateway`

## ⚠️ Notes (learning environment)

These manifests are intentionally minimal for learning. For production they would need:
- Resource **requests/limits** on every container (required for the HPA to work, and for QoS)
- Liveness/readiness **health probes**
- Non-root `securityContext`, read-only root filesystem, and pinned image **digests** (not floating tags)
- **NetworkPolicies** for east-west traffic control between services
