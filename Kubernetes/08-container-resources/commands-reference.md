# Commands Reference - Health Probes

### Liveness Probe Commands
```bash
# Apply pod with liveness probe
kubectl apply -f liveness-hc.yml

# Watch for restarts
kubectl get pods liveness-probe -w

# Check restart count
kubectl get pods liveness-probe

# View probe configuration
kubectl describe pod liveness-probe | grep "Liveness:"

# Check events for probe failures
kubectl describe pod liveness-probe | tail -20

# Check exit code and reason
kubectl get pod liveness-probe -o yaml | grep -A 10 lastState
```

### Startup Probe Commands
```bash
# Apply pod with startup probe
kubectl apply -f startup-hc.yml

# Check startup configuration
kubectl describe pod startup-probe-http | grep "Startup:"

# Monitor pod startup
kubectl get pods startup-probe-http -w
```

### Readiness Probe Commands
```bash
# Apply pod with readiness probe
kubectl apply -f readiness-demo.yaml

# Check readiness status (READY column)
kubectl get pods readiness-demo

# Check why not ready
kubectl describe pod readiness-demo | tail -10

# Make pod ready
kubectl exec readiness-demo -- touch /tmp/ready

# Make pod not ready
kubectl exec readiness-demo -- rm /tmp/ready

# Check Service endpoints
kubectl get endpoints readiness-svc
```

### Testing Probes
```bash
# Test HTTP endpoint manually
POD_IP=$(kubectl get pod <name> -o jsonpath='{.status.podIP}')
curl $POD_IP

# Check file inside pod (exec probe)
kubectl exec <pod> -- cat /tmp/healthcheck

# Watch probe failures in real-time
kubectl get events --watch | grep -i probe
```

### Debugging Probe Issues
```bash
# Check probe configuration
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"

# View probe failure events
kubectl describe pod <name> | grep -i unhealthy

# Check container restarts
kubectl get pods
# Look at RESTARTS column

# View restart reason
kubectl get pod <name> -o yaml | grep -A 5 lastState
```
