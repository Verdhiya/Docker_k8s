# Project 18: Network Policies

Hands-on practice with Kubernetes Network Policies (pod firewall).

## Files

- 01-network-policy-pods.yml
- 02-network-policy.yml

**Platform:** AWS 3-node cluster with Calico CNI

**Note:** Network Policies require CNI support (Calico ✅, Flannel ❌)

---

## What I Learned

**Network Policy:** Firewall rules for pods (control who can talk to whom)

**Default Kubernetes:** All pods can talk to all pods (open!)

**With Policies:** Restrict communication (zero-trust security)

---

## Setup

**Created namespace:**
```bash
kubectl create namespace network-policy
kubectl label namespace network-policy role=test-network-policy
```

**Why label namespace?**
- For namespaceSelector in Network Policy
- Test namespace-level filtering

---

## Exercise 1: Default Behavior (Before Policy)

**File:** 01-network-policy-pods.yml

**Pods created:**
- nginx-pod (label: app=frontend) on worker-1
- busybox-pod (label: app=client) on worker-2

**What I did:**
```bash
kubectl apply -f 01-network-policy-pods.yml
kubectl get pods -n network-policy -o wide
```

**Testing communication:**
```bash
kubectl exec -n network-policy busybox-pod -- curl 192.168.230.22
```

**Result:** Success! Got nginx welcome page! ✅

**Key Learning:** Without Network Policy, all pods can communicate freely

---

## Exercise 2: Network Policy with Empty Rules (Default Deny)

**File:** 02-network-policy.yml (first version)

**Policy created:**
```yaml
spec:
  podSelector:
    matchLabels:
      app: frontend    # Applies to nginx-pod
  policyTypes:
  - Ingress
  - Egress
  # NO ingress rules!
  # NO egress rules!
```

**What I did:**
```bash
kubectl apply -f 02-network-policy.yml
kubectl exec -n network-policy busybox-pod -- curl 192.168.230.22
```

**Result:** TIMEOUT! ❌
```
Request hung for 16+ seconds
No response from nginx
^C (had to cancel)
```

**Why blocked?**
- Policy applied to nginx-pod (app=frontend)
- policyTypes: [Ingress, Egress] declared
- But NO rules specified
- Empty rules = DENY ALL! 🚫

**nginx-pod:**
- Cannot receive traffic from anyone ❌
- Cannot send traffic to anyone ❌
- Completely isolated!

**Key Learning:** Empty Network Policy = Default deny (lockdown!)

---

## Exercise 3: Allow Traffic with namespaceSelector

**Updated 02-network-policy.yml:**
```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        role: test-network-policy
  ports:
  - protocol: TCP
    port: 80
```

**What this means:**
```
Allow incoming traffic TO nginx-pod
FROM pods in namespaces with label role=test-network-policy
ON port 80 only
```

**What I did:**
```bash
kubectl apply -f 02-network-policy.yml
kubectl exec -n network-policy busybox-pod -- curl 192.168.230.22
```

**Result:** Success! Got nginx page! ✅

**Why allowed?**
- busybox-pod is in network-policy namespace ✅
- network-policy namespace has label role=test-network-policy ✅
- Namespace label matches! ✅
- Traffic allowed on port 80! ✅

**Key Learning:**
- namespaceSelector filters by namespace labels
- Both source pod and namespace must match
- Port restriction enforced (only 80 allowed)

---

## What I Proved

**Default Kubernetes:**
```
No Network Policy:
busybox → nginx ✅ (allowed)
All traffic flows freely
```

**With Empty Policy:**
```
Policy with no rules:
busybox → nginx ❌ (blocked!)
Default deny behavior
```

**With namespaceSelector:**
```
Policy with namespace filtering:
busybox → nginx:80 ✅ (allowed, same namespace)
Pod from other namespace → nginx ❌ (blocked!)
```

---

## Network Policy Components

**podSelector (top-level):**
- WHO the policy applies TO (target pods)
- Example: app=frontend (nginx-pod)

**from (in ingress):**
- WHO can send traffic TO target
- Example: Pods in namespace with role=test-network-policy

**ports:**
- WHICH ports allowed
- Example: port 80 (HTTP)

**Together:** Very granular control! 🎯

---

## Summary

**Network Policies:**
- Firewall for pods
- Control ingress (incoming) and egress (outgoing)
- Default: Allow all (no policies)
- Empty rules: Deny all (lockdown)
- Selective rules: Allow specific traffic

**Selectors:**
- podSelector: Filter by pod labels
- namespaceSelector: Filter by namespace labels
- Can combine both

**Ingress vs Egress:**
- Ingress: Who can call me (incoming)
- Egress: Who can I call (outgoing)

**Best Practice:**
- Start with deny-all
- Add specific allow rules
- Zero-trust security

**Requires:** CNI with Network Policy support (Calico ✅)

**Real-World:**
- Multi-tier app isolation
- Database protection
- Namespace isolation
- Compliance (PCI-DSS, HIPAA)
