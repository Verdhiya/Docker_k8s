
Project 08: Container Resources
Hands-on practice with CPU, Memory requests, limits, and QoS classes.

Exercise 1: Pods with Different CPU Requests
File: request-limit.yml (4 pods: frontend-1, frontend-2, frontend-3, frontend-4)

What I did:

bash
Copy code
kubectl apply -f request-limit.yml
kubectl get pods -o wide
What I observed:

sql
Copy code
frontend-1 (250m CPU): Running ✅
frontend-2 (250m CPU): Running ✅
frontend-3 (500m CPU): Running ✅
frontend-4 (750m CPU): Pending ❌
Why frontend-4 stayed Pending:

Requested 750m CPU
Node only had ~200m available
Scheduler won't overcommit
What I learned:

Scheduler respects resource requests
Pod stays Pending if insufficient resources
Exercise 2: Tried to Update Resources (Failed)
What I did:

bash
Copy code
vim request-limit.yml
# Changed frontend-3 from 250m to 500m
# Changed frontend-4 from 250m to 750m
kubectl apply -f request-limit.yml
Error I got:

python
Run Code
Copy code
Pod "frontend-3" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`
What I learned:

Cannot update CPU/Memory requests on running pods
Must delete and recreate
What I did:

bash
Copy code
kubectl delete -f request-limit.yml
kubectl apply -f request-limit.yml
Exercise 3: Pod with Requests and Limits
File: resource-limit.yml

What I did:

bash
Copy code
kubectl apply -f resource-limit.yml
kubectl get pods -o wide
kubectl describe pod frontend-limit
What I observed:

yaml
Copy code
Limits:
  cpu:     500m
  memory:  128Mi
Requests:
  cpu:        250m
  memory:     64Mi

QoS Class: Burstable
What I learned:

requests < limits = Burstable QoS
Pod can burst from 250m to 500m CPU
Exercise 4: Checked System Resources
What I did:

bash
Copy code
top
What I observed:

2 CPUs available
3912 MiB total memory
My t2.medium has ~2000m CPU capacity
Exercise 5: Memory Limit Test (OOMKilled)
File: memory-limit-test.yaml

What I did:

bash
Copy code
kubectl apply -f memory-limit-test.yaml
kubectl get pods memory-demo -w
kubectl describe pod memory-demo | grep -A 15 Events
kubectl get pod memory-demo -o yaml | grep -A 10 lastState
What I observed:

makefile
Copy code
STATUS: CrashLoopBackOff
RESTARTS: 1, 2, 3, 4...

Events:
"Liveness probe failed"
"Back-off restarting failed container"

lastState:
  exitCode: 1
  reason: OOMKilled
What happened:

Container tried to use 150Mi
Limit was 100Mi
Kubernetes killed it
Restarted automatically
Killed again (loop!)
What I did:

bash
Copy code
kubectl delete pod memory-demo
What I learned:

Exceeding memory limit = OOMKilled
Exit Code 137 or 1 with reason OOMKilled
Creates infinite restart loop if not fixed
Exercise 6: QoS Classes
Files: qos-besteffort.yaml, qos-burstable.yaml, qos-guaranteed.yaml

What I did:

bash
Copy code
kubectl apply -f qos-besteffort.yaml
kubectl apply -f qos-burstable.yaml
kubectl apply -f qos-guaranteed.yaml

kubectl describe pod qos-besteffort | grep "QoS Class"
kubectl describe pod qos-burstable | grep "QoS Class"
kubectl describe pod qos-guaranteed | grep "QoS Class"

kubectl delete -f qos-guaranteed.yaml
kubectl delete -f qos-burstable.yaml
kubectl delete -f qos-besteffort.yaml
What I observed:

makefile
Copy code
qos-besteffort: QoS Class: BestEffort
qos-burstable: QoS Class: Burstable
qos-guaranteed: QoS Class: Guaranteed
What I learned:

No resources = BestEffort (lowest priority)
requests < limits = Burstable (medium priority)
requests = limits = Guaranteed (highest priority)
Summary
✅ Created pods with CPU requests

✅ Observed pod Pending (insufficient resources)

✅ Cannot update resources on running pods

✅ Set both requests and limits

✅ Tested memory limit (OOMKilled)

✅ Verified all 3 QoS classes

Key Skill: Resource management prevents overload and ensures fair sharing.

All Files in Project 08
request-limit.yml (4 pods with different CPU requests)
resource-limit.yml (requests + limits)
memory-limit-test.yaml (OOMKilled demo)
qos-besteffort.yaml (no resources)
qos-burstable.yaml (requests < limits)
qos-guaranteed.yaml (requests = limits)
