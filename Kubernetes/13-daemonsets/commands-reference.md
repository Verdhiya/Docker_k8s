# Commands Reference - DaemonSets

## Create and Manage

```bash
# Apply DaemonSet
kubectl apply -f 01-daemonset-basic.yml

# View DaemonSet
kubectl get daemonsets
kubectl get ds

# Describe DaemonSet
kubectl describe daemonset logging

# View DaemonSet pods
kubectl get pods -l app=httpd-logging -o wide
```

## Check Distribution

```bash
# See which nodes have pods
kubectl get pods -o wide -l app=<daemonset-label>

# Check desired vs current
kubectl get daemonset <name>
# DESIRED: How many nodes match
# CURRENT: How many pods created
```

## Test Self-Healing

```bash
# Delete a DaemonSet pod
kubectl delete pod <daemonset-pod-name>

# Watch it recreate
kubectl get pods -l app=<label> -w
```

## DaemonSet with nodeSelector

```bash
# Apply DaemonSet with nodeSelector
kubectl apply -f 03-daemonset-ssd-only.yml

# Check how many pods
kubectl get pods -l app=ssd-logger

# Add label to node (watch pod auto-create!)
kubectl label nodes <node-name> disktype=ssd

# Remove label (pod terminates)
kubectl label nodes <node-name> disktype-
```

## Cleanup

```bash
# Delete DaemonSet (deletes all pods)
kubectl delete daemonset logging
kubectl delete daemonset monitor-all-nodes
kubectl delete daemonset ssd-logger
```
