# Project 17: Kubernetes Networking

Hands-on practice with Pod DNS and pod-to-pod communication.

## Files

- 01-pods-dns.yml

**Platform:** Minikube single-node

---

## What I Learned

**Kubernetes Networking:**
- Every pod gets unique IP
- All pods can communicate directly (no NAT)
- DNS for service discovery
- CoreDNS provides name resolution

---

## Exercise: Pod DNS Resolution

**File:** 01-pods-dns.yml

**Pods created:**
- nginx-nodename (nginx web server)
- frontend-app (alpine with curl)

**What I did:**

**Step 1: Get pod IPs**
```bash
kubectl get pods -o wide
# nginx-nodename: IP 10.244.0.171
# frontend-app: IP 10.244.0.170
```

**Step 2: Test from host (master node)**
```bash
curl 10-244-0-171.default.pod.cluster.local
# Error: Could not resolve host ❌
```

**Why failed?**
- Pod DNS only works from INSIDE cluster (from pods)
- Host doesn't use CoreDNS

---

**Step 3: Install curl in alpine pod**
```bash
kubectl exec frontend-app -it -- sh
apk update
apk add curl
```

**Step 4: Test Pod DNS from inside pod**
```bash
curl 10-244-0-171.default.pod.cluster.local
# Success! Got nginx welcome page! ✅
```

**Pod DNS Format:**
```
Original IP: 10.244.0.171
DNS format: 10-244-0-171.default.pod.cluster.local
            └─────────┘ └─────┘ └─────────────────┘
            IP (dashes)  Namespace   Domain

Replace dots with dashes! ✅
```

**Step 5: Test direct IP**
```bash
curl 10.244.0.171
# Also worked! ✅
```

---

## What I Observed

**CoreDNS Service:**
```bash
kubectl get svc -n kube-system
# kube-dns ClusterIP 10.96.0.10

All pods use 10.96.0.10 for DNS resolution! ✅
```

**DNS Resolution Flow:**
```
frontend-app pod:
1. Query: "What is 10-244-0-171.default.pod.cluster.local?"
2. Sent to: 10.96.0.10 (CoreDNS)
3. CoreDNS: "That's 10.244.0.171"
4. Pod: curl 10.244.0.171 ✅
```

**Pod-to-Pod Communication:**
- Method 1: Direct IP (10.244.0.171) ✅
- Method 2: Pod DNS (10-244-0-171.default.pod.cluster.local) ✅
- Both work from inside pods!

---

## Key Discoveries

**Pod DNS:**
- Format: `<ip-with-dashes>.<namespace>.pod.cluster.local`
- Works: From inside pods (containers) ✅
- Doesn't work: From host/nodes ❌
- Requires: CoreDNS service

**Direct IP:**
- Always works (pod-to-pod)
- No DNS needed
- Immediate communication

**CoreDNS:**
- ClusterIP: 10.96.0.10
- Runs as Deployment (2 replicas)
- All pods configured to use it
- Provides pod and service DNS

---

## Summary

**Kubernetes Network Model:**
- Every pod gets unique IP (CNI-assigned)
- Pod-to-pod communication (direct, no NAT)
- DNS for service discovery (CoreDNS)
- Flat network (all pods can reach all pods)

**Pod DNS:**
- Less commonly used than Service DNS
- Good for StatefulSets (predictable names)
- Format uses dashes instead of dots

**Best Practice:**
- Use Service DNS (not Pod DNS)
- Services provide stable endpoints
- Pod IPs change, Service IPs don't!

**Tools:**
- apk (Alpine package manager)
- curl (test HTTP endpoints)
- kubectl exec (run commands in pods)
