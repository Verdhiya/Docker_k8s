# Commands Reference - Node Affinity

## Required Affinity

```bash
# Apply pod with required affinity
kubectl apply -f 01-node-affinity-in.yml

# Check scheduling
kubectl get pods nginx-node-affinity -o wide

# If Pending, check why
kubectl describe pod nginx-node-affinity | grep Events -A 10
```

## Anti-Affinity (NotIn)

```bash
# Apply anti-affinity pod
kubectl apply -f 02-node-anti-affinity-notin.yml

# Verify it avoided ssd nodes
kubectl get pods nginx-node-anti-affinity -o wide
```

## Exists Operator

```bash
# Apply pod requiring label existence
kubectl apply -f 03-affinity-exists.yml

# Check if Pending
kubectl get pods pod-gpu-required

# Add label to trigger scheduling
kubectl label nodes <node-name> gpu=nvidia

# Watch pod schedule
kubectl get pods pod-gpu-required -o wide
```

## Preferred Affinity

```bash
# Apply pod with preference
kubectl apply -f 04-affinity-preferred.yml

# Check where it scheduled (likely ssd node)
kubectl get pods pod-prefer-ssd -o wide
```

## Check Node Labels

```bash
# View all node labels
kubectl get nodes --show-labels

# View specific labels
kubectl get nodes -L disktype,zone,gpu

# Add label
kubectl label nodes <node-name> key=value

# Remove label
kubectl label nodes <node-name> key-
```

## Cleanup

```bash
kubectl delete pod nginx-node-affinity
kubectl delete pod nginx-node-anti-affinity
kubectl delete pod pod-gpu-required
kubectl delete pod pod-prefer-ssd
kubectl delete pod pod-ssd-or-nvme
kubectl delete pod pod-must-and-prefer
```
