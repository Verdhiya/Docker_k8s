# Essential kubectl Commands

All kubectl commands used throughout the learning journey.

---

## Cluster Info
```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl version
kubectl get componentstatuses
```

---

## Pods

### List pods
```bash
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide
kubectl get pods -n <namespace>
```
### Describe pod
```bash
kubectl describe pod <pod-name>
```
### Logs
```bash
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl logs <pod-name> --previous
```
### Execute commands
```bash
kubectl exec -it <pod-name> -- bash
kubectl exec -it <pod-name> -- sh
kubectl exec <pod-name> -- <command>
kubectl exec <pod-name> -- env
kubectl exec <pod-name> -- printenv
```
### Wait for pod
```bash
kubectl wait --for=condition=ready pod/<pod-name> --timeout=60s
```
### Delete pod
```bash
kubectl delete pod <pod-name>
kubectl delete pod <pod-name> --force --grace-period=0
```

---

## Deployments
```bash
kubectl create deployment <name> --image=<image>
kubectl get deployments
kubectl get deployments -o wide
kubectl describe deployment <name>
kubectl scale deployment <name> --replicas=<number>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl delete deployment <name>
```

---

## Services
```bash
kubectl expose deployment <name> --port=80 --type=NodePort
kubectl get services
kubectl get svc
kubectl describe service <name>
kubectl get endpoints <service-name>
kubectl delete service <name>
```

---

## Namespaces
```bash
kubectl create namespace <name>
kubectl get namespaces
kubectl get ns
kubectl get pods -n <namespace>
kubectl delete namespace <name>
```

---

## ConfigMaps (07)

### Create ConfigMap
```bash
kubectl create configmap <name> --from-literal=key=value
kubectl create configmap <name> --from-file=file.conf
kubectl apply -f configmap.yaml
```
### View ConfigMap
```bash
kubectl get configmaps
kubectl get cm
kubectl describe configmap <name>
kubectl get configmap <name> -o yaml
```
### Update ConfigMap
```bash
kubectl create configmap <name> --from-literal=key=newvalue --dry-run=client -o yaml | kubectl apply -f -
```
### Delete ConfigMap
```bash
kubectl delete configmap <name>
```

---

## Secrets (07)

### Create Secret
```bash
kubectl create secret generic <name> --from-literal=key=value
kubectl create secret generic <name> --from-file=./file.txt
kubectl apply -f secret.yaml
```
### View Secret
```bash
kubectl get secrets
kubectl describe secret <name>
kubectl get secret <name> -o yaml
```
### Decode Secret value
```bash
kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d
```
### Delete Secret
```bash
kubectl delete secret <name>
```

---

## RBAC

### Roles and RoleBindings
```bash
kubectl get roles -A
kubectl get rolebindings -A
kubectl describe role <name> -n <namespace>
kubectl describe rolebinding <name> -n <namespace>
```
### ClusterRoles and ClusterRoleBindings
```bash
kubectl get clusterroles
kubectl get clusterrolebindings
```
### ServiceAccounts
```bash
kubectl get serviceaccounts -A
kubectl get sa -A
kubectl describe serviceaccount <name> -n <namespace>
kubectl create serviceaccount <name> -n <namespace>
```
### Check permissions
```bash
kubectl auth can-i <verb> <resource> -n <namespace>
kubectl auth can-i list pods -n default
kubectl auth can-i --list -n <namespace>
kubectl auth can-i --list --as=system:serviceaccount:<namespace>:<sa-name> -n <namespace>
```

---

## Node Management

### Node operations
```bash
kubectl get nodes
kubectl describe node <node>
kubectl drain <node> --ignore-daemonsets
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
kubectl cordon <node>
kubectl uncordon <node>
```
### Check node resources
```bash
kubectl describe node | grep -A 8 "Allocated resources"
```

---

## Resource Management (08)

### View pod resources
```bash
kubectl describe pod <name> | grep -A 8 "Limits:\|Requests:"
kubectl describe pod <name> | grep "QoS Class"
```
### Check why pod is Pending
```bash
kubectl describe pod <name> | grep -A 10 Events
```
### View node capacity
```bash
kubectl describe node <node-name> | grep -A 8 "Allocated resources"
```
### Monitor resource usage (requires metrics-server)
```bash
kubectl top nodes
kubectl top pods
kubectl top pods -A
```

---

## Health Probes (Project 09)

### View probe configuration
```bash
kubectl describe pod <name> | grep "Liveness:"
kubectl describe pod <name> | grep "Readiness:"
kubectl describe pod <name> | grep "Startup:"
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"
```
### Watch for restarts
```bash
kubectl get pods <name> -w
kubectl get pods -w
```
### Check restart count
```bash
kubectl get pods
# Look at RESTARTS column
```
### Check exit code and last state
```bash
kubectl get pod <name> -o yaml | grep -A 10 lastState
kubectl get pod <name> -o yaml | grep exitCode
```

---

## Troubleshooting

### Describe resources
```bash
kubectl describe <resource> <name>
kubectl describe pod <pod-name>
kubectl describe node <node-name>
```
### Logs
```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl logs -f <pod-name>
```
### Events
```bash
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events -A --sort-by='.lastTimestamp'
kubectl get events --watch
```
### YAML/JSON output
```bash
kubectl get pod <name> -o yaml
kubectl get pod <name> -o json
```
### Explain resources
```bash
kubectl explain pod
kubectl explain deployment
kubectl explain service
```

---

## Watch and Monitor

### Watch resources update
```bash
kubectl get pods -w
kubectl get pods <name> -w
kubectl get nodes -w
```
### Monitor events
```bash
kubectl get events --watch
```
### Follow logs
```bash
kubectl logs -f <pod-name>
```

---

## Cleanup

### Delete by file
```bash
kubectl delete -f <file>.yaml
```
### Delete by type and name
```bash
kubectl delete pod <name>
kubectl delete deployment <name>
kubectl delete service <name>
kubectl delete namespace <name>
```
### Delete all in namespace
```bash
kubectl delete all --all -n <namespace>
```
### Force delete
```bash
kubectl delete pod <name> --force --grace-period=0
```
