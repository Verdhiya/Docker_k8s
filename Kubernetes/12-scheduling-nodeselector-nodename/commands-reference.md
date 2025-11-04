# Commands Reference - Scheduling

## Node Labels

```bash
# View node labels
kubectl get nodes --show-labels

# Label a node
kubectl label nodes <node-name> disktype=ssd

# View specific label
kubectl get nodes -L disktype

# Remove label
kubectl label nodes <node-name> disktype-
```

## Test nodeSelector

```bash
# Apply pod with nodeSelector
kubectl apply -f 01-nodeselector.yml

# Check if scheduled
kubectl get pods nginx-nodeselector -o wide

# If Pending, check why
kubectl describe pod nginx-nodeselector | grep Events -A 10
```

## Test nodeName

```bash
# Apply pod with nodeName
kubectl apply -f 02-nodename.yml

# Verify it went to specified node
kubectl get pods nginx-nodename -o wide
```

## Check Node Capacity

```bash
# View node resources
kubectl describe node <node-name> | grep -A 8 "Allocated resources"

# Check why pod is Pending
kubectl describe pod <pod-name> | grep "Insufficient"
```

## Check Taints

```bash
# View node taints
kubectl describe node k8s-master | grep Taints

# View all node taints
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

## Cleanup

```bash
kubectl delete pod nginx-nodeselector
kubectl delete pod nginx-nodename
kubectl delete pod frontend-app
kubectl delete pod frontend-app-1
kubectl delete pod frontend-app-2
```
