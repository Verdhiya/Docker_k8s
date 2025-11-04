# Project 12: Kubernetes Scheduling

Hands-on practice with nodeSelector, nodeName, and scheduler behavior.

## Files

- 01-nodeselector.yml
- 02-nodename.yml
- 03-resource-req-1.yml
- 04-resource-req-2.yml

**Platform:** AWS 3-node cluster (master + 2 workers)

---

## What I Learned

**Scheduling:** Process of deciding which node runs a pod

**Scheduler:** Filters nodes → Scores nodes → Picks best node

**Manual Control:**
- nodeSelector: Schedule by node labels
- nodeName: Direct node assignment

---

## Exercise 1: nodeSelector (Label-Based Scheduling)

**File:** 01-nodeselector.yml

**What I did:**
```bash
kubectl apply -f 01-nodeselector.yml
kubectl get pods nginx-nodeselector
```

**Initial state:**
- STATUS: Pending ❌
- No nodes had label `disktype=ssd`

**Fixed by labeling:**
```bash
kubectl label nodes k8s-worker-2 disktype=ssd
sleep 5
kubectl get pods nginx-nodeselector -o wide
```

**Result:**
- Pod scheduled to k8s-worker-2 ✅
- Only node with disktype=ssd label

**Key Learning:**
- nodeSelector filters nodes by labels
- Pod stays Pending if no node matches
- Label added → Pod schedules immediately!

---

## Exercise 2: nodeName (Direct Assignment)

**File:** 02-nodename.yml

**What I did:**
```bash
kubectl apply -f 02-nodename.yml
kubectl get pods nginx-nodename -o wide
```

**Result:**
- Scheduled directly to k8s-worker-1 ✅
- Bypassed scheduler (no filtering/scoring)
- Immediate assignment

**Key Learning:**
- nodeName = Direct node specification
- No scheduler involvement
- Fast but inflexible (no alternatives if node fails)

---

## Exercise 3: Resources + nodeSelector (Pod Pending)

**File:** 03-resource-req-1.yml

**What I did:**
```bash
kubectl apply -f 03-resource-req-1.yml
kubectl get pods -o wide
```

**Pods created:**
- frontend-app: requests 1000m CPU, nodeSelector disktype=ssd
- frontend-app-1: requests 1000m CPU, nodeSelector disktype=ssd

**What I observed:**
```
frontend-app: Running on k8s-worker-2 ✅
frontend-app-1: Pending ❌

Why frontend-app-1 stayed Pending:
- Only k8s-worker-2 has disktype=ssd
- k8s-worker-2 already running frontend-app (1000m CPU)
- k8s-worker-2 total: ~2000m CPU
- Available: ~1000m remaining
- frontend-app-1 needs: 1000m
- Scheduler: "Not enough CPU!" → Pending

Error message:
"0/3 nodes available:
 1 Insufficient cpu (worker-2 full)
 1 node didn't match selector (worker-1 no label)
 1 had untolerated taint (master)"
```

**Key Learning:**
- Scheduler respects resource requests!
- Won't overcommit node resources
- Pod stays Pending if no suitable node

---

## Exercise 4: Resources Without nodeSelector

**File:** 04-resource-req-2.yml

**What I did:**
```bash
kubectl apply -f 04-resource-req-2.yml
kubectl get pods frontend-app-2 -o wide
```

**Result:**
- Scheduled to k8s-worker-1 ✅
- No nodeSelector (can go anywhere)
- worker-1 had available CPU

**Key Learning:**
- Without nodeSelector, scheduler picks best available
- Resource requests still respected
- Scheduler balances load across nodes

---

## Taints and Tolerations Discovered

**What I observed:**
```
Master node has taint: node-role.kubernetes.io/control-plane:NoSchedule
Regular pods cannot schedule there

Error seen:
"1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }"
```

**Key Learning:**
- Master tainted to prevent workload pods
- Protects control plane
- Only system pods (with tolerations) run on master

---

## Summary

**nodeSelector:**
- Label-based filtering
- Simple and common
- Pod stays Pending if no match

**nodeName:**
- Direct node assignment
- Bypasses scheduler
- Use for testing/debugging

**Scheduler Behavior:**
- Filters: Labels, resources, taints
- Scores: Resource availability, balance
- Picks: Best node

**Resource Requests:**
- Scheduler uses for placement
- Won't overcommit nodes
- Pod Pending if insufficient resources

**Taints:**
- Master has control-plane taint
- Prevents regular workload pods
- Keeps master dedicated to management
