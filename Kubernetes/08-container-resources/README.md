# **Project 08: Container Resources**

***Hands-on practice with CPU, Memory requests, limits, and QoS classes.***

---

## Exercise 1: Pods with Different CPU Requests

**File:** `request-limit.yml`

#### What I did:

```bash
kubectl apply -f request-limit.yml
kubectl get pods -o wide
```

#### What I observed:
- **frontend-1 (250m):** Running ✅
- **frontend-2 (250m):** Running ✅
- **frontend-3 (500m):** Running ✅
- **frontend-4 (750m):** Pending ❌

#### What I learned:
- frontend-4 stayed Pending (node doesn't have 750m CPU available)
- Scheduler respects resource requests

---


## Exercise 2: Cannot Update Resources

#### What I did:

```bash
vim request-limit.yml
# Changed frontend-3 and frontend-4 CPU values
kubectl apply -f request-limit.yml
```

**Error:**
`Pod "frontend-3" is invalid: spec: Forbidden`

#### Fix:

```bash
kubectl delete -f request-limit.yml
kubectl apply -f request-limit.yml
```

#### What I learned:
- Must delete and recreate to change resources

---


## Exercise 3: Requests and Limits

**File:** `resource-limit.yml`

#### What I did:

```bash
kubectl apply -f resource-limit.yml
kubectl describe pod frontend-limit
```

#### What I observed:
- **Requests:** cpu=250m, memory=64Mi
- **Limits:** cpu=500m, memory=128Mi
- **QoS Class:** Burstable

---


## Exercise 4: System Resources

#### What I did:

```bash
top
```

#### What I observed:
- 2 CPUs available (~2000m)
- 3912 MiB memory

---


## Exercise 5: Memory Limit Test

**File:** `memory-limit-test.yaml`

#### What I did:

```bash
kubectl apply -f memory-limit-test.yaml
kubectl get pods memory-demo -w
kubectl describe pod memory-demo | grep -A 15 Events
kubectl get pod memory-demo -o yaml | grep -A 10 lastState
kubectl delete pod memory-demo
```


#### What I observed:
- **STATUS:** CrashLoopBackOff
- **RESTARTS:** 1, 2, 3, 4...
- **exitCode:** 1
- **Reason:** OOMKilled


#### What I learned:
- Container exceeded 100Mi limit
- Kubernetes killed it
- Restarted in infinite loop

---


## Exercise 6: QoS Classes

**Files:** `qos-besteffort.yaml, qos-burstable.yaml, qos-guaranteed.yaml`

#### What I did:

```bash
kubectl apply -f qos-besteffort.yaml
kubectl apply -f qos-burstable.yaml
kubectl apply -f qos-guaranteed.yaml

kubectl describe pod qos-besteffort | grep "QoS Class"
kubectl describe pod qos-burstable | grep "QoS Class"
kubectl describe pod qos-guaranteed | grep "QoS Class"

kubectl delete -f qos-*.yaml
```

#### What I observed:
- **BestEffort:** No resources set
- **Burstable:** requests < limits
- **Guaranteed:** requests = limits

---


## Files

- **request-limit.yml**
- **resource-limit.yml**
- **memory-limit-test.yaml**
- **qos-besteffort.yaml**
- **qos-burstable.yaml**
- **qos-guaranteed.yaml**
