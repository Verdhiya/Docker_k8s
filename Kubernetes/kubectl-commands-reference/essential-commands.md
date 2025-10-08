# Essential kubectl Commands

---
## Cluster Info
```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl version
```


## Pods
```
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl exec -it <pod-name> -- bash
kubectl delete pod <pod-name>
```


## Deployments
```
kubectl create deployment <name> --image=<image>
kubectl get deployments
kubectl scale deployment <name> --replicas=<number>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl delete deployment <name>
```


## Services
```
kubectl expose deployment <name> --port=80 --type=NodePort
kubectl get services
kubectl describe service <name>
kubectl delete service <name>
```


## Namespaces
```
kubectl create namespace <name>
kubectl get namespaces
kubectl get pods -n <namespace>
kubectl delete namespace <name>
```


## RBAC
```
kubectl get roles -A
kubectl get rolebindings -A
kubectl get serviceaccounts -A
kubectl auth can-i <verb> <resource> -n <namespace>
kubectl auth can-i --list -n <namespace>
```


## Node Management
```
kubectl drain <node> --ignore-daemonsets
kubectl cordon <node>
kubectl uncordon <node>
kubectl describe node <node>
```


## Troubleshooting
```
kubectl describe <resource> <name>
kubectl logs <pod-name>
kubectl get events --sort-by='.lastTimestamp'
kubectl get pods -o yaml
kubectl explain <resource>
```
