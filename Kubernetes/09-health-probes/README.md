
Project 09: Health Probes
Hands-on practice with Liveness, Readiness, and Startup probes.

Exercise 1: Liveness Probe (Exec and HTTP)
File: liveness-hc.yml (contains 2 pods: liveness-probe and liveness-probe-http)

What I did:

bash
Copy code
kubectl apply -f liveness-hc.yml
kubectl get pods -o wide
kubectl get pods liveness-probe -w
kubectl describe pods liveness-probe
kubectl get pod liveness-probe -o yaml | grep -A 10 lastState
kubectl describe pods liveness-probe-http
For liveness-probe (exec method):

What I observed:

yaml
Copy code
Timeline:
0-60s: Probe passes ✅ (file exists)
60s: Container deletes /tmp/healthcheck
65-75s: Probe fails 3 times ❌
75s: Container RESTARTED

RESTARTS: 1 → 2 → 3... (kept increasing)

Events:
"Liveness probe failed: cat: can't open '/tmp/healthcheck': No such file or directory"
"Container liveness failed liveness probe, will be restarted"

Last State:
  Reason: Error
  Exit Code: 137
For liveness-probe-http:

What I did:

bash
Copy code
curl 10.244.0.63
# Output: nginx welcome page
What I observed:

sql
Copy code
Liveness: http-get http://:80/ delay=3s period=3s
RESTARTS: 0 (stayed healthy)
Pod checks HTTP endpoint every 3 seconds
What I learned:

Liveness probe detects frozen containers
Exec method: checks if file exists
HTTP method: checks endpoint response
Failure → Container restarted automatically
Exit Code 137 = Killed by Kubernetes
Exercise 2: Startup Probe
File: startup-hc.yml

What I did:

bash
Copy code
kubectl apply -f startup-hc.yml
kubectl describe pods startup-probe-http
kubectl get pods -o wide
What I observed:

vbnet
Copy code
Startup: http-get http://:80/ delay=0s period=10s #failure=30

Calculation: 30 × 10s = 300 seconds (5 minutes allowed)

STATUS: Running
RESTARTS: 0
What I learned:

Startup probe gives slow apps time to initialize
failureThreshold: 30 = 30 checks before giving up
nginx started quickly, first check passed
Exercise 3: Readiness Probe
Files: readiness-demo.yaml, readiness-demo-labeled.yaml, readiness-service.yaml

What I did:

bash
Copy code
kubectl apply -f readiness-demo.yaml
kubectl get pods readiness-demo
kubectl describe pod readiness-demo | tail -10
kubectl exec readiness-demo -- touch /tmp/ready
sleep 10
kubectl get pods readiness-demo
kubectl exec readiness-demo -- rm /tmp/ready
sleep 15
kubectl get pods readiness-demo
What I observed:

yaml
Copy code
Without /tmp/ready file:
READY: 0/1 (pod running but NOT ready)
Warning: Readiness probe failed

After creating /tmp/ready:
READY: 1/1 (NOW ready!)

After deleting /tmp/ready:
READY: 0/1 (not ready again)
RESTARTS: 0 (never restarted!)
What I learned:

Readiness controls traffic, doesn't restart pod
0/1 = Running but not ready
1/1 = Running and ready for traffic
Exercise 4: Complete Probes Demo
File: complete-probes.yaml

What I did:

bash
Copy code
kubectl apply -f complete-probes.yaml
kubectl describe pod complete-probes-demo | grep -A 2 "Startup:\|Liveness:\|Readiness:"
What I observed:

Pod had all three probe types configured
Startup, Liveness, and Readiness all working together
Summary
✅ Liveness probe detects frozen containers → Restarts automatically

✅ Observed RESTARTS counter increasing (1, 2, 3...)

✅ Exit Code 137 = Container killed by Kubernetes

✅ Startup probe allows 300 seconds for slow apps

✅ Readiness probe controls traffic (0/1 vs 1/1)

✅ exec and HTTP probe methods tested

Key Skill: Self-healing - Kubernetes automatically recovers from failures.

All Files in Project 09
liveness-hc.yml (exec and HTTP liveness)
startup-hc.yml (startup probe)
readiness-demo.yaml (basic readiness)
readiness-demo-labeled.yaml (with labels)
readiness-service.yaml (Service for testing)
complete-probes.yaml (all three probes)
