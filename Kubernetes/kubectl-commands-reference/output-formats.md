
kubectl Output Formats
Commands for viewing resources in different formats.

Common Output Formats
bash
Copy code
# Default format (table)
kubectl get pods

# Wide format (more columns)
kubectl get pods -o wide

# YAML format (full configuration)
kubectl get pods -o yaml
kubectl get pod <name> -o yaml

# JSON format
kubectl get pods -o json
kubectl get pod <name> -o json

# Name only (just resource names)
kubectl get pods -o name
Custom Columns
bash
Copy code
# Define custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# Multiple columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.spec.nodeName

# With headers
kubectl get pods -o custom-columns='POD NAME:.metadata.name,STATUS:.status.phase,IP ADDRESS:.status.podIP'
JSONPath (Extract Specific Fields)
bash
Copy code
# Get pod names
kubectl get pods -o jsonpath='{.items[*].metadata.name}'

# Get pod IP
kubectl get pod <name> -o jsonpath='{.status.podIP}'

# Get pod IPs for all pods
kubectl get pods -o jsonpath='{.items[*].status.podIP}'

# Get node name
kubectl get pod <name> -o jsonpath='{.spec.nodeName}'

# Get container image
kubectl get pod <name> -o jsonpath='{.spec.containers[0].image}'

# Get QoS class
kubectl get pod <name> -o jsonpath='{.status.qosClass}'

# Decode Secret value
kubectl get secret <name> -o jsonpath='{.data.password}' | base64 -d

# Get Service NodePort
kubectl get svc <name> -o jsonpath='{.spec.ports[0].nodePort}'
Filtering and Sorting
bash
Copy code
# Filter by label
kubectl get pods -l app=nginx
kubectl get pods --selector=app=nginx

# Filter by field
kubectl get pods --field-selector=status.phase=Running
kubectl get pods --field-selector=spec.nodeName=k8s-worker-1

# Sort by creation time
kubectl get pods --sort-by=.metadata.creationTimestamp

# Sort events by time
kubectl get events --sort-by='.lastTimestamp'
Combining with grep
bash
Copy code
# Filter output
kubectl get pods -o wide | grep Running
kubectl get pods -A | grep <pod-name>
kubectl describe pod <name> | grep "QoS Class"
kubectl describe pod <name> | grep -A 5 "Limits:"

# Check environment variables
kubectl exec <pod> -- env | grep MY_VAR

# Check specific state
kubectl get pod <name> -o yaml | grep exitCode
kubectl get pod <name> -o yaml | grep -A 10 lastState
Useful Combinations Used in Exercises
bash
Copy code
# Get pod IP quickly
kubectl get pod nginx-pod -o jsonpath='{.status.podIP}'

# Check all ConfigMaps
kubectl get configmaps

# Check QoS class
kubectl describe pod frontend-limit | grep "QoS Class"

# Watch pod restarts
kubectl get pods liveness-probe -w

# Check probe configuration
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"

# Check node resources
kubectl describe node | grep -A 8 "Allocated resources"

# View events for debugging
kubectl describe pod <name> | tail -20
