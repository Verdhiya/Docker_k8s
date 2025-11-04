# Essential Kubectl Commands Reference

## Cluster Information
```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>
kubectl top nodes
```

## Namespace Operations
```bash
kubectl get namespaces
kubectl create namespace <name>
kubectl delete namespace <name>
kubectl config set-context --current --namespace=<namespace>
```

## Pod Operations
```bash
# List pods
kubectl get pods
kubectl get pods -n <namespace>
kubectl get pods --all-namespaces
kubectl get pods -o wide
kubectl get pods --show-labels

# Describe and logs
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>
kubectl logs <pod-name> --previous
kubectl logs -f <pod-name>

# Execute commands
kubectl exec -it <pod-name> -- /bin/bash
kubectl exec <pod-name> -- <command>
kubectl exec <pod-name> -c <container-name> -- <command>

# Create and delete
kubectl run <pod-name> --image=<image>
kubectl delete pod <pod-name>
kubectl delete pod <pod-name> --force --grace-period=0
```

## Deployment Operations
```bash
# Create and manage
kubectl create deployment <name> --image=<image>
kubectl get deployments
kubectl describe deployment <name>
kubectl delete deployment <name>

# Scale
kubectl scale deployment <name> --replicas=<count>

# Update
kubectl set image deployment/<name> <container>=<new-image>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl rollout undo deployment/<name> --to-revision=<n>
```

## Service Operations
```bash
kubectl get services
kubectl get svc
kubectl describe service <name>
kubectl expose deployment <name> --port=<port> --type=<type>
kubectl delete service <name>
```

## ConfigMap Operations
```bash
kubectl create configmap <name> --from-literal=<key>=<value>
kubectl create configmap <name> --from-file=<file>
kubectl get configmaps
kubectl describe configmap <name>
kubectl delete configmap <name>
```

## Secret Operations
```bash
kubectl create secret generic <name> --from-literal=<key>=<value>
kubectl create secret generic <name> --from-file=<file>
kubectl get secrets
kubectl describe secret <name>
kubectl get secret <name> -o jsonpath='{.data}'
kubectl delete secret <name>
```

## Resource Management
```bash
# Apply and create
kubectl apply -f <file.yaml>
kubectl create -f <file.yaml>
kubectl delete -f <file.yaml>

# Edit resources
kubectl edit <resource> <name>
kubectl patch <resource> <name> -p '<patch>'

# Get all resources
kubectl get all
kubectl get all -n <namespace>
```

## Labels and Selectors
```bash
kubectl get pods --selector=<key>=<value>
kubectl get pods -l <key>=<value>
kubectl label pod <pod-name> <key>=<value>
kubectl label pod <pod-name> <key>-
```

## Node Operations
```bash
kubectl cordon <node-name>
kubectl uncordon <node-name>
kubectl drain <node-name>
kubectl drain <node-name> --ignore-daemonsets
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
kubectl taint nodes <node-name> <key>=<value>:<effect>
kubectl taint nodes <node-name> <key>-
```

## Context and Configuration
```bash
kubectl config view
kubectl config get-contexts
kubectl config current-context
kubectl config use-context <context-name>
kubectl config set-context <context-name> --namespace=<namespace>
```

## Debugging Commands
```bash
kubectl get events
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe <resource> <name>
kubectl logs <pod-name> --previous
kubectl top pods
kubectl top nodes
```

## Quick Pod Creation
```bash
# Nginx
kubectl run nginx --image=nginx --restart=Never

# Busybox
kubectl run busybox --image=busybox --restart=Never -- sleep 3600

# With port
kubectl run nginx --image=nginx --port=80

# Dry run
kubectl run nginx --image=nginx --dry-run=client -o yaml

# With labels
kubectl run nginx --image=nginx --labels="app=web,env=prod"
```

## YAML Generation
```bash
# Pod
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Deployment
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deployment.yaml

# Service
kubectl create service clusterip nginx --tcp=80:80 --dry-run=client -o yaml > service.yaml

# Job
kubectl create job test --image=busybox --dry-run=client -o yaml > job.yaml

# CronJob
kubectl create cronjob test --image=busybox --schedule="*/1 * * * *" --dry-run=client -o yaml > cronjob.yaml
```

## Resource Shortnames
```bash
pods = po
services = svc
deployments = deploy
replicasets = rs
namespaces = ns
nodes = no
persistentvolumes = pv
persistentvolumeclaims = pvc
configmaps = cm
serviceaccounts = sa
daemonsets = ds
```

## Useful Aliases
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
```
