# kubectl Output Formats
***Commands for viewing resources in different formats.***

---

## Common Output Formats

#### Default format (table)
```bash
kubectl get pods
```
#### Wide format (more columns)
```bash
kubectl get pods -o wide
```
#### YAML format (full configuration)
```bash
kubectl get pods -o yaml
kubectl get pod <name> -o yaml
```
#### JSON format
```bash
kubectl get pods -o json
kubectl get pod <name> -o json
```
#### Name only (just resource names)
```bash
kubectl get pods -o name
```

## Custom Columns

#### Define custom columns
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
```
#### Multiple columns
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.spec.nodeName
```
#### With headers
```bash
kubectl get pods -o custom-columns='POD NAME:.metadata.name,STATUS:.status.phase,IP ADDRESS:.status.podIP'
```

## JSONPath (Extract Specific Fields)

#### Get pod names
```bash
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
```
#### Get pod IP
```bash
kubectl get pod <name> -o jsonpath='{.status.podIP}'
```
#### Get pod IPs for all pods
```bash
kubectl get pods -o jsonpath='{.items[*].status.podIP}'
```
#### Get node name
```bash
kubectl get pod <name> -o jsonpath='{.spec.nodeName}'
```
#### Get container image
```bash
kubectl get pod <name> -o jsonpath='{.spec.containers[0].image}'
```
#### Get QoS class
```bash
kubectl get pod <name> -o jsonpath='{.status.qosClass}'
```
#### Decode Secret value
```bash
kubectl get secret <name> -o jsonpath='{.data.password}' | base64 -d
```
#### Get Service NodePort
```bash
kubectl get svc <name> -o jsonpath='{.spec.ports[0].nodePort}'
```

## Filtering and Sorting

#### Filter by label
```bash
kubectl get pods -l app=nginx
kubectl get pods --selector=app=nginx
```
#### Filter by field
```bash
kubectl get pods --field-selector=status.phase=Running
kubectl get pods --field-selector=spec.nodeName=k8s-worker-1
```
#### Sort by creation time
```bash
kubectl get pods --sort-by=.metadata.creationTimestamp
```
#### Sort events by time
```bash
kubectl get events --sort-by='.lastTimestamp'
```

## Combining with grep

#### Filter output
```bash
kubectl get pods -o wide | grep Running
kubectl get pods -A | grep <pod-name>
kubectl describe pod <name> | grep "QoS Class"
kubectl describe pod <name> | grep -A 5 "Limits:"
```
#### Check environment variables
```bash
kubectl exec <pod> -- env | grep MY_VAR
```
#### Check specific state
```bash
kubectl get pod <name> -o yaml | grep exitCode
kubectl get pod <name> -o yaml | grep -A 10 lastState
```

## Useful Combinations Used in Exercises

#### Get pod IP quickly
```bash
kubectl get pod nginx-pod -o jsonpath='{.status.podIP}'
```
#### Check all ConfigMaps
```bash
kubectl get configmaps
```
#### Check QoS class
```bash
kubectl describe pod frontend-limit | grep "QoS Class"
```
#### Watch pod restarts
```bash
kubectl get pods liveness-probe -w
```
#### Check probe configuration
```bash
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"
```
#### Check node resources
```bash
kubectl describe node | grep -A 8 "Allocated resources"
```
#### View events for debugging
```bash
kubectl describe pod <name> | tail -20
```
