# Project 08: Managing Container Resources

***Learn CPU and Memory management, requests, limits, and QoS classes.***

## Overview

- **Challenge:** Prevent resource starvation and ensure fair resource sharing
- **Solution:** Set resource requests and limits for all containers
- **Instance:** Minikube single-node (t2.medium: 2 CPU, 4Gi RAM)  
- **Duration:** 1-2 hours hands-on practice  

---

## What You'll Learn

- ✅ CPU and Memory requests (minimum guaranteed)  
- ✅ CPU and Memory limits (maximum allowed)  
- ✅ QoS Classes (BestEffort, Burstable, Guaranteed)  
- ✅ Scheduler behavior with insufficient resources  
- ✅ OOMKilled when memory limit exceeded  
- ✅ Resource update limitations  

---

## Concepts

### Requests (Minimum Guaranteed)

- **What:** Minimum amount of resource guaranteed to container

- **How Scheduler Uses It:**
  - Pod requests: 250m CPU, 64Mi memory
  - Scheduler checks all nodes:

- Node A: 200m CPU available → ❌ Not enough
- Node B: 300m CPU available → ✅ Fits! Schedule here


**Analogy:** Hotel reservation - guaranteed minimum room size

---

### Limits (Maximum Allowed)

**What:** Maximum resource container can use

**What Happens When Exceeded:**
- **CPU:** Throttled (slowed down, but keeps running)
- **Memory:** OOMKilled (container killed immediately)

**Analogy:** Buffet plate size - can't take more than plate allows

---

### QoS Classes

| Class | Configuration | Priority | Eviction Order |
|-------|--------------|----------|----------------|
| **Guaranteed** | requests = limits | Highest | Killed last |
| **Burstable** | requests < limits | Medium | Killed second |
| **BestEffort** | No requests/limits | Lowest | Killed first |

---

## Files in This Project

| File | Purpose |
|------|---------|
| `request-limit.yml` | 4 pods with different CPU requests |
| `resource-limit.yml` | Pod with both requests and limits |
| `memory-limit-test.yaml` | Memory limit enforcement demo |
| `qos-besteffort.yaml` | BestEffort QoS example |
| `qos-burstable.yaml` | Burstable QoS example |
| `qos-guaranteed.yaml` | Guaranteed QoS example |

---

## Hands-On Exercises

### Exercise 1: Pods with Different CPU Requests

```bash
kubectl apply -f request-limit.yml

# Observe pod scheduling
kubectl get pods -o wide

# Expected results:
# frontend-1 (250m): Running ✅
# frontend-2 (250m): Running ✅
# frontend-3 (500m): Running ✅
# frontend-4 (750m): Pending ❌ (insufficient CPU!)

# Check why frontend-4 is pending
kubectl describe pod frontend-4 | grep Events -A 10
# Message: "Insufficient cpu"
Key Learning: Scheduler respects requests and won't overcommit node resources!
```

### Exercise 2: Requests and Limits (Burstable QoS)
```bash
kubectl apply -f resource-limit.yml
kubectl get pods frontend-limit

# Check QoS class
kubectl describe pod frontend-limit | grep "QoS Class"
# Output: Burstable

# Why Burstable?
# requests: cpu=250m, memory=64Mi
# limits: cpu=500m, memory=128Mi
# requests < limits = Burstable
```

### Exercise 3: Memory Limit Enforcement (OOMKilled)
```bash
kubectl apply -f memory-limit-test.yaml

# Watch it crash
kubectl get pods memory-demo -w

# Observed behavior:
# STATUS: Running → OOMKilled → CrashLoopBackOff
# RESTARTS: Keeps increasing (1, 2, 3...)

# Check what happened
kubectl describe pod memory-demo | grep -A 15 Events

# Events show:
# "Liveness probe failed"
# "Container will be killed and recreated"
# Reason: OOMKilled

# Check exit code
kubectl get pod memory-demo -o yaml | grep -A 5 lastState
# exitCode: 137 (OOMKilled)
# reason: OOMKilled

# Clean up crashing pod
kubectl delete pod memory-demo
```
**What Happened:**
- Container configured:
  - Memory limit: 100Mi
  - Tries to allocate: 150Mi
  - Exceeds limit! 
  - Kubernetes kills it immediately (OOMKilled)
  - Restarts automatically
  - Tries 150Mi again
  - Killed again
  - Infinite restart loop!

### Exercise 4: Compare QoS Classes
```bash
# Create all three QoS types
kubectl apply -f qos-besteffort.yaml
kubectl apply -f qos-burstable.yaml
kubectl apply -f qos-guaranteed.yaml

# Check QoS for each
kubectl describe pod qos-besteffort | grep "QoS Class"
# Output: BestEffort

kubectl describe pod qos-burstable | grep "QoS Class"
# Output: Burstable

kubectl describe pod qos-guaranteed | grep "QoS Class"
# Output: Guaranteed

# Compare configurations
kubectl describe pod qos-besteffort | grep -A 5 "Limits:\|Requests:"
kubectl describe pod qos-burstable | grep -A 5 "Limits:\|Requests:"
kubectl describe pod qos-guaranteed | grep -A 5 "Limits:\|Requests:"
```

#### Differences:
- BestEffort:  No resources set
- Burstable:   requests: 100m/64Mi, limits: 200m/128Mi
- Guaranteed:  requests: 100m/128Mi, limits: 100m/128Mi (same!)

## Debugging & Troubleshooting

### Issue 1: Cannot Update Resources on Running Pod
**Error:** Pod "frontend-3" is invalid: spec: Forbidden: pod updates may not change fields other than...

**Explanation:**
- Resource requests affect scheduling decisions
- Changing requests would require rescheduling
- Kubernetes doesn't support live pod migration

**Solution:**
```bash
# Must delete and recreate
kubectl delete pod frontend-3
kubectl apply -f request-limit.yml
```

### Issue 2: Pod Stuck in Pending
**Symptoms:**
```bash
kubectl get pods frontend-4
# STATUS: Pending (never becomes Running)
```
**Diagnose:**
```bash
kubectl describe pod frontend-4
# Events: "0/1 nodes are available: 1 Insufficient cpu"
```
**Cause:** Requested 750m CPU but node only has ~200m available

**Solutions:**
- Reduce CPU request
- Delete other pods to free resources
- Add more nodes to cluster (not possible on Minikube)

**Check node capacity:**
```bash
kubectl describe node | grep -A 8 "Allocated resources"
# Shows: CPU Requests, CPU Limits, available capacity
```

### Issue 3: OOMKilled Loop
Symptoms:
```bash
kubectl get pods memory-demo
# STATUS: CrashLoopBackOff
# RESTARTS: 5, 6, 7... (keeps increasing)
```
**Diagnose:**
```bash
kubectl logs memory-demo
kubectl describe pod memory-demo | grep -i oom
# Reason: OOMKilled
```
**Cause:** Container consistently exceeds memory limit

**Solutions:**
- Increase memory limit
- Fix memory leak in application
- Reduce memory usage
- Resource Units Reference

#### CPU
```sql
1 CPU core = 1000m (millicores)

Examples:
100m  = 0.1 CPU = 10% of one core
250m  = 0.25 CPU = 25% of one core
500m  = 0.5 CPU = 50% of one core
1000m = 1 CPU = One full core
2000m = 2 CPU = Two full cores

Real-world usage:
50m-100m   = Tiny sidecar containers
100m-250m  = Small web apps, APIs
500m-1000m = Databases, caches
2000m+     = Heavy processing, ML workloads
```
#### Memory
```sql
Ki = Kibibyte (1024 bytes)
Mi = Mebibyte (1024 Ki)
Gi = Gibibyte (1024 Mi)

Examples:
64Mi  = 64 megabytes
128Mi = 128 megabytes
256Mi = 256 megabytes
512Mi = 512 megabytes
1Gi   = 1 gigabyte
2Gi   = 2 gigabytes

Real-world usage:
32Mi-64Mi    = Tiny sidecars
128Mi-256Mi  = Small web apps
512Mi-1Gi    = Medium apps, small DBs
2Gi-4Gi      = Large apps, databases
8Gi+         = Big data, caching layers
```

### Best Practices

**1. Always Set Requests**
```yaml
✅ DO:
resources:
  requests:
    cpu: 100m
    memory: 128Mi

❌ DON'T: Leave requests unset (BestEffort = lowest priority)
```

**2. Set Limits for Unknown Apps**
```yaml
✅ DO: For new apps, third-party software, batch jobs
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

**3: Limits Should Allow Bursting**
```yaml
✅ Good ratio: Limit = 2-4x Request
requests:
  cpu: 100m
limits:
  cpu: 400m    # 4x allows traffic spike handling
```

**4: Critical Apps = Guaranteed QoS**
```yaml
✅ For databases, caches, critical services:
requests:
  cpu: 1000m
  memory: 2Gi
limits:
  cpu: 1000m     # Same as request
  memory: 2Gi    # Guaranteed QoS = highest priority

**Verification Commands**
```bash
# Check pod resources
kubectl describe pod <pod> | grep -A 8 "Limits:\|Requests:"

# Check QoS class
kubectl describe pod <pod> | grep "QoS Class"

# Check node capacity
kubectl describe node | grep -A 8 "Allocated resources"

# Monitor actual usage (requires metrics-server)
minikube addons enable metrics-server
sleep 60
kubectl top nodes
kubectl top pods

# Check why pod is pending
kubectl describe pod <pod> | grep -i "insufficient"
```

## Summary
**Completed:**
- ✅ Created pods with varying resource requests
- ✅ Observed scheduler behavior (pod Pending)
- ✅ Set both requests and limits
- ✅ Tested all 3 QoS classes
- ✅ Observed OOMKilled behavior
- ✅ Learned resource constraints cannot be updated
- ✅ Debugged resource-related issues

***Key Takeaway: Proper resource management prevents node overload, ensures fair sharing, and protects critical workloads.***
