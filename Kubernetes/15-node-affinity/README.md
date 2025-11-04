# Project 15: Node Affinity

Hands-on practice with Node Affinity (advanced scheduling).

## Files

- 01-node-affinity-in.yml
- 02-node-anti-affinity-notin.yml
- 03-affinity-exists.yml
- 04-affinity-preferred.yml
- 05-affinity-or-logic.yml
- 06-affinity-required-and-preferred.yml

**Platform:** AWS 3-node cluster

---

## What I Learned

**Node Affinity:** Advanced version of nodeSelector with more flexibility

**Operators:** In, NotIn, Exists, DoesNotExist, Gt, Lt

**Types:**
- Required: MUST match (hard rule)
- Preferred: Nice to match (soft preference)

---

## Exercise 1: In Operator (Required)

**File:** 01-node-affinity-in.yml

**What I did:**
```bash
kubectl apply -f 01-node-affinity-in.yml
kubectl get pods nginx-node-affinity -o wide
```

**Affinity rule:**
```yaml
operator: In
values: [ssd]
```

**What I observed:**
- k8s-worker-2 has disktype=ssd ✅
- Pod scheduled to worker-2 ✅

**Key Learning:** In operator matches specific values

---

## Exercise 2: NotIn Operator (Anti-Affinity)

**File:** 02-node-anti-affinity-notin.yml

**What I did:**
```bash
kubectl apply -f 02-node-anti-affinity-notin.yml
kubectl get pods nginx-node-anti-affinity -o wide
```

**Affinity rule:**
```yaml
operator: NotIn
values: [ssd]
```

**What I observed:**
- k8s-worker-1 does NOT have disktype=ssd ✅
- Pod scheduled to worker-1 ✅
- Avoided worker-2 (has ssd)!

**Key Learning:** NotIn avoids nodes with specified values (anti-affinity!)

---

## Exercise 3: Exists Operator

**File:** 03-affinity-exists.yml

**What I did:**
```bash
kubectl apply -f 03-affinity-exists.yml
kubectl get pods pod-gpu-required
```

**Affinity rule:**
```yaml
operator: Exists
key: gpu
```

**Initial state:**
- STATUS: Pending ❌
- No nodes had 'gpu' label

**Added label:**
```bash
kubectl label nodes k8s-worker-1 gpu=nvidia
kubectl get pods pod-gpu-required -o wide
```

**Result:**
- Pod scheduled to worker-1 within seconds! ✅
- Exists checks label presence (value doesn't matter!)

**Key Learning:**
- Exists = Label must be present (any value)
- gpu=nvidia ✅ matches
- gpu=amd ✅ would also match
- Dynamic scheduling when label added!

---

## Exercise 4: Preferred Affinity (Soft)

**File:** 04-affinity-preferred.yml

**What I did:**
```bash
kubectl apply -f 04-affinity-preferred.yml
kubectl get pods pod-prefer-ssd -o wide
```

**Affinity rule:**
```yaml
preferredDuringScheduling...
weight: 100
preference: disktype=ssd
```

**What I observed:**
- Pod scheduled to k8s-worker-2 (has ssd) ✅
- Scheduler PREFERRED ssd node
- But would schedule to non-ssd if worker-2 was full

**Key Learning:** Preferred = Try to match, but not required

---

## Exercise 5: OR Logic (Multiple Values)

**File:** 05-affinity-or-logic.yml

**What I did:**
```bash
kubectl apply -f 05-affinity-or-logic.yml
kubectl get pods pod-ssd-or-nvme -o wide
```

**Affinity rule:**
```yaml
operator: In
values: [ssd, nvme]
```

**What I observed:**
- Pod scheduled to worker-2 (has disktype=ssd) ✅
- Would also accept disktype=nvme
- Accepts EITHER value (OR logic!)

**Key Learning:** Multiple values in In operator = OR logic

---

## Exercise 6: Required + Preferred Together

**File:** 06-affinity-required-and-preferred.yml

**What I did:**
```bash
kubectl apply -f 06-affinity-required-and-preferred.yml
kubectl get pods pod-must-and-prefer -o wide
```

**Affinity rules:**
```yaml
required: kubernetes.io/os=linux (MUST match)
preferred: disktype=ssd (nice to match, weight 80)
```

**Scheduler logic:**
1. Filter: Only Linux nodes (all 3 qualify)
2. Score:
   - worker-2: Score 80 (has ssd) 🏆
   - worker-1: Score 0 (no ssd)
   - master: Tainted (excluded)
3. Winner: worker-2

**What I observed:**
- Pod scheduled to worker-2 ✅
- Combined required + preferred working perfectly!

**Key Learning:** Can combine hard requirements with soft preferences

---

## Summary

**Node Affinity Operators:**
- **In:** Value in list (disktype IN [ssd, nvme])
- **NotIn:** Value not in list (avoid specific nodes)
- **Exists:** Label exists (any value)

**Affinity Types:**
- **Required:** Hard rule (MUST match or stay Pending)
- **Preferred:** Soft rule (nice to match, weight-based scoring)

**vs nodeSelector:**
- nodeSelector: Simple, exact match only
- Node Affinity: Complex, OR/NOT logic, preferences

**Real-World Use:**
- GPU nodes (Exists: gpu label)
- Storage tiers (In: [ssd, nvme])
- Zone preferences (Preferred: zone=us-east-1a)
- Avoid spot instances (NotIn: [spot])
