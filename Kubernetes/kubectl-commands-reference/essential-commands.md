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
# Basic service commands
kubectl get services
kubectl get svc
kubectl get svc -o wide
kubectl describe service <name>
kubectl expose deployment <name> --port=<port> --type=<type>
kubectl delete service <name>

# Create specific service types
kubectl expose deployment <name> --port=80 --target-port=80                    # ClusterIP
kubectl expose deployment <name> --type=NodePort --port=80                      # NodePort
kubectl expose deployment <name> --type=LoadBalancer --port=80                  # LoadBalancer

# View service endpoints (pod IPs behind service)
kubectl get endpoints
kubectl get ep
kubectl get endpoints <service-name>

# Describe endpoints
kubectl describe endpoints <service-name>

# Generate service YAML
kubectl expose deployment <name> --port=80 --dry-run=client -o yaml > service.yml
```

## Service Discovery & DNS (Module 19)
```bash
# Test service from within cluster (same namespace)
kubectl exec <pod> -- curl http://service-name:port

# Test from different namespace
kubectl exec -n <namespace> <pod> -- curl http://service-name.target-namespace:port

# Test with full FQDN
kubectl exec <pod> -- curl http://service-name.namespace.svc.cluster.local:port

# DNS lookup
kubectl exec <pod> -- nslookup service-name
kubectl exec <pod> -- nslookup service-name.namespace.svc.cluster.local

# Check DNS config in pod
kubectl exec <pod> -- cat /etc/resolv.conf

# Port forward for local testing
kubectl port-forward svc/<service-name> 8080:80
```

## Ingress Operations (Module 20)
```bash
# Install Ingress Controller (Minikube)
minikube addons enable ingress
minikube addons disable ingress
minikube addons list | grep ingress

# Check ingress controller pods
kubectl get pods -n ingress-nginx
kubectl get pods -n ingress-nginx -o wide

# Check ingress controller service
kubectl get svc -n ingress-nginx

# Create and manage ingress
kubectl apply -f ingress.yml
kubectl create -f ingress.yml
kubectl get ingress
kubectl get ing
kubectl get ingress -A

# Describe ingress (see rules and backends)
kubectl describe ingress <ingress-name>

# Edit ingress
kubectl edit ingress <ingress-name>

# Delete ingress
kubectl delete ingress <ingress-name>

# View ingress details
kubectl get ingress <name> -o yaml
kubectl get ingress <name> -o jsonpath='{.spec.rules[*].host}'
kubectl get ingress <name> -o jsonpath='{.status.loadBalancer.ingress[*].ip}'
```

## Test Ingress Routing
```bash
# Get ingress IP
kubectl get ingress <name>

# Test with curl using Host header
curl http://<INGRESS-IP> -H 'Host: example.com'
curl -v http://<INGRESS-IP> -H 'Host: example.com'

# Test different hosts
curl http://<IP> -H 'Host: app1.example.com'
curl http://<IP> -H 'Host: app2.example.com'

# View ingress controller logs
kubectl logs -n ingress-nginx <controller-pod-name>
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx -f
```

## Storage Operations (Module 21)
```bash
# View PersistentVolumes
kubectl get pv
kubectl get persistentvolumes
kubectl get pv -o wide
kubectl describe pv <pv-name>

# View PersistentVolumeClaims
kubectl get pvc
kubectl get persistentvolumeclaims
kubectl get pvc -o wide
kubectl describe pvc <pvc-name>

# View StorageClass
kubectl get storageclass
kubectl get sc
kubectl describe storageclass <name>

# Create storage resources
kubectl apply -f storageclass.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml

# Delete storage resources
kubectl delete pvc <pvc-name>
kubectl delete pv <pv-name>
kubectl delete storageclass <name>

# Edit PVC (expand storage if allowed)
kubectl edit pvc <pvc-name>

# Check which pod is using PVC
kubectl describe pvc <pvc-name> | grep "Used By:"

# Check volume mounts in pod
kubectl describe pod <pod-name> | grep -A 5 "Volumes:"
kubectl describe pod <pod-name> | grep -A 3 "Mounts:"
```

## Test Volume Persistence
```bash
# For hostPath volumes - check on node
ls -la /var/tmp/
cat /var/tmp/<filename>

# Exec into pod to check volume
kubectl exec -it <pod-name> -- /bin/bash
cd /data
ls -la
cat <file>

# Exec into specific container (multi-container pod)
kubectl exec -it <pod-name> -c <container-name> -- /bin/bash

# Kill container to test emptyDir persistence
kubectl exec -it <pod-name> -- kill 1
# Check if data survives (watch RESTARTS count increase)
kubectl get pods -w
```

## Node Label Management (Module 20)
```bash
# View node labels
kubectl get nodes --show-labels
kubectl get node <node-name> --show-labels

# Add label to node
kubectl label node <node-name> <key>=<value>

# Example: Add minikube primary label (Module 20)
kubectl label node k8s minikube.k8s.io/primary=true

# Remove label
kubectl label node <node-name> <key>-

# View specific labels
kubectl get nodes -L <label-key>
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

# Check node taints
kubectl describe node <node-name> | grep Taint

# View node details
kubectl describe node <node-name>
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

# Check pod events
kubectl describe pod <pod-name> | grep -A 10 "Events:"

# Check why pod is pending
kubectl describe pod <pod-name> | grep -A 5 "Conditions:"

# View all resources in namespace
kubectl get all -n <namespace>
```

## DNS and Networking
```bash
# Test DNS resolution
kubectl exec <pod> -- nslookup <service-name>
kubectl exec <pod> -- nslookup kubernetes.default

# Check DNS config
kubectl exec <pod> -- cat /etc/resolv.conf

# Check CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns

# Test service connectivity
kubectl run test --image=curlimages/curl -it --rm -- curl http://service-name
kubectl run test --image=busybox -it --rm -- wget -qO- http://service-name
```

## Quick Testing Pods
```bash
# Create temporary test pod with curl
kubectl run test --image=curlimages/curl -it --rm -- sh

# Create temporary test pod with busybox
kubectl run test --image=busybox -it --rm -- sh

# Test service from temporary pod
kubectl run test --image=curlimages/curl -it --rm -- curl http://service-name

# Create pod for long-term testing
kubectl run test-pod --image=curlimages/curl -- sleep 3600
kubectl exec test-pod -- curl http://service-name
kubectl delete pod test-pod
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

# Ingress (basic)
kubectl create ingress my-ingress --rule="example.com/*=my-service:80" --dry-run=client -o yaml > ingress.yaml

# Job
kubectl create job test --image=busybox --dry-run=client -o yaml > job.yaml

# CronJob
kubectl create cronjob test --image=busybox --schedule="*/1 * * * *" --dry-run=client -o yaml > cronjob.yaml
```

## Troubleshooting Service Issues
```bash
# Check if service exists
kubectl get svc <service-name>

# Check service endpoints (should show pod IPs)
kubectl get endpoints <service-name>

# If no endpoints, check pod labels match service selector
kubectl get svc <service-name> -o yaml | grep -A 3 selector
kubectl get pods --show-labels

# Check pods are running
kubectl get pods -l <service-selector>

# Test direct to pod (bypass service)
kubectl get pods -o wide
kubectl exec test-pod -- curl http://<pod-ip>:80
```

## Troubleshooting Ingress Issues
```bash
# Check ingress exists
kubectl get ingress

# Check ingress has address
kubectl get ingress <name>

# Check ingress controller is running
kubectl get pods -n ingress-nginx

# View ingress controller logs
kubectl logs -n ingress-nginx <controller-pod>

# Check backend services exist
kubectl get svc

# Check service endpoints
kubectl get endpoints <service-name>

# Test service directly (bypass ingress)
kubectl run test --image=curlimages/curl -it --rm -- curl http://service-name
```

## Troubleshooting Storage Issues
```bash
# Check PVC status
kubectl get pvc
kubectl describe pvc <pvc-name>

# If PVC stuck in Pending:
# 1. Check if matching PV exists
kubectl get pv

# 2. Check volumeBindingMode (might be WaitForFirstConsumer)
kubectl describe storageclass <name> | grep VolumeBindingMode

# 3. Create pod using PVC (triggers binding)

# Check PV status
kubectl get pv
kubectl describe pv <pv-name>

# Check whats using PVC
kubectl describe pvc <pvc-name> | grep "Used By:"

# Check pod volume mounts
kubectl describe pod <pod-name> | grep -A 10 "Volumes:"
kubectl describe pod <pod-name> | grep -A 5 "Mounts:"
```

## Minikube Commands
```bash
# Get minikube IP
minikube ip

# Get service URL
minikube service <service-name> --url

# Enable/disable addons
minikube addons enable ingress
minikube addons disable ingress
minikube addons list

# Check minikube status
minikube status
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
ingress = ing
endpoints = ep
storageclasses = sc
```

## Useful Aliases
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kgi='kubectl get ingress'
alias kgpv='kubectl get pv'
alias kgpvc='kubectl get pvc'
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kge='kubectl get endpoints'
```

## DNS Naming Patterns (Module 19)
```bash
# Same namespace
service-name
service-name:port

# Different namespace
service-name.namespace
service-name.namespace:port

# Full FQDN (works from anywhere)
service-name.namespace.svc.cluster.local
service-name.namespace.svc.cluster.local:port

# Examples
curl http://nginx-service                                    # Same namespace
curl http://nginx-service.default                            # Different namespace
curl http://nginx-service.default.svc.cluster.local          # Full FQDN
```

## Common Command Patterns from Modules 19-21
```bash
# Module 19: Test ClusterIP service
kubectl exec pod-svc-test -- curl nginx-service:8080

# Module 19: Test cross-namespace DNS
kubectl exec -n service-namespace svc-test-dns -- curl nginx-service.default:8080

# Module 20: Test ingress routing
curl http://172.31.19.217 -H 'Host: nginx-official.example.com'

# Module 20: Fix ingress controller (add node label)
kubectl label node k8s minikube.k8s.io/primary=true

# Module 20: View ingress logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx -f

# Module 21: Check hostPath data on node
cat /var/tmp/output.txt
cat /var/tmp/success.txt

# Module 21: Test emptyDir persistence
kubectl exec -it redis-emptydir -- kill 1    # Kill container
kubectl get pods -w                          # Watch restart
kubectl exec -it redis-emptydir -- ls /data/redis/  # Data still there!

# Module 21: Test multi-container sharing
kubectl exec -it shared-multi-container -c nginx-container -- cat /usr/share/nginx/html/index.html
kubectl exec -it shared-multi-container -c debian-container -- cat /html/index.html
# Both see same data!

# Module 21: Watch PVC binding
kubectl get pvc -w  # Status: Pending → Bound (when pod created)
```

## Storage Lifecycle Commands
```bash
# Create storage resources in order
kubectl apply -f storageclass.yml      # 1. StorageClass
kubectl apply -f pv.yml                # 2. PersistentVolume
kubectl apply -f pvc.yml               # 3. PersistentVolumeClaim
kubectl apply -f pod-using-pvc.yml     # 4. Pod using PVC

# Check binding status
kubectl get pv                          # Check PV status
kubectl get pvc                         # Check PVC status

# Delete in reverse order
kubectl delete -f pod-using-pvc.yml    # 1. Delete pod first
kubectl delete -f pvc.yml              # 2. Delete PVC (triggers reclaim policy)
kubectl get pv                         # 3. Check PV status (depends on reclaim policy)
kubectl delete -f pv.yml               # 4. Delete PV
kubectl delete -f storageclass.yml     # 5. Delete StorageClass
```
