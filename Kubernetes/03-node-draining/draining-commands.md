# Node Draining Commands

## Drain Node
```bash
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

```
## Uncordon Node
kubectl uncordon <node-name>

## Cordon Only (Don't evict pods)
kubectl cordon <node-name>

## Example Workflow

# 1. Create test resources
kubectl apply -f test-pod.yaml
kubectl apply -f test-deployment.yaml

# 2. Drain worker node
kubectl drain k8s-worker-2 --ignore-daemonsets --delete-emptydir-data

# 3. Observe: standalone pod deleted, deployment pods recreated

# 4. Uncordon node
kubectl uncordon k8s-worker-2
