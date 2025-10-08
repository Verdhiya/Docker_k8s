# Node Draining Commands

## Drain Node
```bash
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
```

## Uncordon Node
```bash
kubectl uncordon <node-name>
```
## Cordon Only (Don't evict pods)
```bash
kubectl cordon <node-name>
```
# Example Workflow

## 1. Create test resources
```bash
kubectl apply -f test-pod.yaml
kubectl apply -f test-deployment.yaml
```
## 2. Drain worker node
```bash
kubectl drain k8s-worker-2 --ignore-daemonsets --delete-emptydir-data
```

## 3. Observe: standalone pod deleted, deployment pods recreated


## 4. Uncordon node
```bash
kubectl uncordon k8s-worker-2
```
