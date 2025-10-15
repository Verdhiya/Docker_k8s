# Commands Reference - Health Probes

## Liveness Probe Commands

#### Apply pod with liveness probe
```bash
kubectl apply -f liveness-hc.yml
```
#### Watch for restarts
```bash
kubectl get pods liveness-probe -w
```
#### Check restart count
```bash
kubectl get pods liveness-probe
```
#### View probe configuration
```bash
kubectl describe pod liveness-probe | grep "Liveness:"
```
#### Check events for probe failures
```bash
kubectl describe pod liveness-probe | tail -20
```
#### Check exit code and reason
```bash
kubectl get pod liveness-probe -o yaml | grep -A 10 lastState
```

## Startup Probe Commands

#### Apply pod with startup probe
```bash
kubectl apply -f startup-hc.yml
```
#### Check startup configuration
```bash
kubectl describe pod startup-probe-http | grep "Startup:"
```
#### Monitor pod startup
```bash
kubectl get pods startup-probe-http -w
```

## Readiness Probe Commands

#### Apply pod with readiness probe
```bash
kubectl apply -f readiness-demo.yaml
```
#### Check readiness status (READY column)
```bash
kubectl get pods readiness-demo
```
#### Check why not ready
```bash
kubectl describe pod readiness-demo | tail -10
```
#### Make pod ready
```bash
kubectl exec readiness-demo -- touch /tmp/ready
```
#### Make pod not ready
```bash
kubectl exec readiness-demo -- rm /tmp/ready
```
#### Check Service endpoints
```bash
kubectl get endpoints readiness-svc
```

## Testing Probes

#### Test HTTP endpoint manually
```bash
POD_IP=$(kubectl get pod <name> -o jsonpath='{.status.podIP}')
curl $POD_IP
```
#### Check file inside pod (exec probe)
```bash
kubectl exec <pod> -- cat /tmp/healthcheck
```
#### Watch probe failures in real-time
```bash
kubectl get events --watch | grep -i probe
```

## Debugging Probe Issues

#### Check probe configuration
```bash
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"
```
#### View probe failure events
```bash
kubectl describe pod <name> | grep -i unhealthy
```
#### Check container restarts
```bash
kubectl get pods
# Look at RESTARTS column
```
#### View restart reason
```bash
kubectl get pod <name> -o yaml | grep -A 5 lastState
```
