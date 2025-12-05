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

## AWS CLI Commands (Module 22)
```bash
# Installation verification
aws --version

# Configure credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Verify credentials
aws sts get-caller-identity

# S3 bucket operations
aws s3 ls                                           # List all buckets
aws s3 mb s3://bucket-name                          # Create bucket
aws s3 rb s3://bucket-name                          # Delete bucket
aws s3 ls s3://bucket-name/                         # List bucket contents
aws s3 ls s3://bucket-name/ --recursive             # List recursively

# S3 file operations
aws s3 cp file.txt s3://bucket-name/                # Upload file
aws s3 cp s3://bucket-name/file.txt ./              # Download file
aws s3 cp s3://bucket-name/file.txt - | cat         # View file content
aws s3 rm s3://bucket-name/file.txt                 # Delete file
aws s3 rm s3://bucket-name/ --recursive             # Delete all files

# S3 API operations
aws s3api create-bucket --bucket name --region us-east-1
aws s3api create-bucket --bucket name --region region \
    --create-bucket-configuration LocationConstraint=region

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket bucket-name \
    --versioning-configuration Status=Enabled

# Check versioning status
aws s3api get-bucket-versioning --bucket bucket-name

# Delete bucket and contents
aws s3 rm s3://bucket-name --recursive
aws s3api delete-bucket --bucket bucket-name --region us-east-1
```

## Helm Installation & Setup (Module 22)
```bash
# Check Helm version
helm version

# Initialize Helm (already done in modern versions)
helm repo list

# Get help
helm --help
helm <command> --help
```

## Helm Plugin Management (Module 22)
```bash
# List installed plugins
helm plugin list

# Install helm-s3 plugin
helm plugin install https://github.com/hypnoglow/helm-s3.git
helm plugin install https://github.com/hypnoglow/helm-s3.git --version 0.17.1
helm plugin install https://github.com/hypnoglow/helm-s3.git --verify=false

# Uninstall plugin
helm plugin uninstall s3

# Update plugin
helm plugin update s3

# Check plugin version (if wrapper created)
helm-s3 version
```

## helm-s3 Wrapper Creation (Module 22)
```bash
# Create wrapper script (if plugin installs as getter/v1)
cat > /usr/local/bin/helm-s3 << 'EOF'
#!/bin/bash
~/.local/share/helm/plugins/helm-s3/bin/helm-s3 "$@"
EOF

chmod +x /usr/local/bin/helm-s3

# Test wrapper
helm-s3 version
```

## helm-s3 Repository Operations (Module 22)
```bash
# Initialize S3 bucket as Helm repository
helm-s3 init s3://bucket-name/charts

# Initialize with force (overwrite existing)
helm-s3 init --force s3://bucket-name/charts

# Initialize with ignore if exists
helm-s3 init --ignore-if-exists s3://bucket-name/charts

# Push chart to S3 repository
helm-s3 push chart-0.1.0.tgz repo-name
helm-s3 push chart-0.1.0.tgz s3://bucket-name/charts

# Push with force (overwrite)
helm-s3 push --force chart-0.1.0.tgz repo-name

# Delete chart from repository
helm-s3 delete chart-name --version 0.1.0 repo-name

# Reindex repository
helm-s3 reindex repo-name
```

## Helm Repository Management (Module 22)
```bash
# Add repository
helm repo add repo-name s3://bucket-name/charts
helm repo add repo-name https://charts.example.com

# List repositories
helm repo list

# Update repositories (fetch latest index)
helm repo update
helm repo update repo-name

# Remove repository
helm repo remove repo-name

# Search repositories
helm search repo keyword
helm search repo repo-name/
helm search repo repo-name/chart-name
helm search repo chart-name --versions
```

## Helm Chart Development (Module 22)
```bash
# Create new chart
helm create chart-name

# Lint chart (validate)
helm lint chart-name/
helm lint .

# Package chart
helm package chart-name/
helm package chart-name/ --version 1.0.0

# Generate index.yaml
helm repo index .
helm repo index . --url https://example.com/charts
```

## Helm Chart Information (Module 22)
```bash
# Show chart details
helm show chart repo-name/chart-name
helm show chart ./chart-directory

# Show chart values
helm show values repo-name/chart-name
helm show values ./chart-directory

# Show all chart info
helm show all repo-name/chart-name

# Show README
helm show readme repo-name/chart-name
```

## Helm Template Testing (Module 22)
```bash
# Render templates locally
helm template release-name chart-name/
helm template release-name ./chart-directory

# Render with custom values
helm template release-name chart-name/ --values values.yaml
helm template release-name chart-name/ --set key=value

# Debug templates
helm template release-name chart-name/ --debug

# Validate templates
helm template release-name chart-name/ --validate
```

## Helm Release Management (Module 22)
```bash
# Install chart
helm install release-name repo-name/chart-name
helm install release-name ./chart-directory

# Install with custom values
helm install release-name repo-name/chart-name --values values.yaml
helm install release-name repo-name/chart-name --set key=value
helm install release-name repo-name/chart-name --set service.nodePort=30081

# Install in specific namespace
helm install release-name repo-name/chart-name --namespace namespace-name
helm install release-name repo-name/chart-name -n namespace-name --create-namespace

# Install specific version
helm install release-name repo-name/chart-name --version 1.0.0

# Dry run (test without installing)
helm install release-name repo-name/chart-name --dry-run
helm install release-name repo-name/chart-name --dry-run --debug

# Generate name automatically
helm install --generate-name repo-name/chart-name
```

## Helm Upgrade & Rollback (Module 22)
```bash
# Upgrade release
helm upgrade release-name repo-name/chart-name
helm upgrade release-name repo-name/chart-name --values values.yaml
helm upgrade release-name repo-name/chart-name --set key=value

# Upgrade or install if not exists
helm upgrade --install release-name repo-name/chart-name

# Upgrade with force
helm upgrade release-name repo-name/chart-name --force

# Upgrade with wait
helm upgrade release-name repo-name/chart-name --wait --timeout 5m

# Rollback to previous revision
helm rollback release-name

# Rollback to specific revision
helm rollback release-name 2

# Rollback with wait
helm rollback release-name 2 --wait
```

## Helm Release Information (Module 22)
```bash
# List releases
helm ls
helm list
helm ls --all-namespaces
helm ls -A

# List all releases (including failed)
helm ls --all

# Get release status
helm status release-name

# Get release history
helm history release-name

# Get release values
helm get values release-name
helm get values release-name --revision 2

# Get release manifest
helm get manifest release-name

# Get all release info
helm get all release-name
```

## Helm Uninstall (Module 22)
```bash
# Uninstall release
helm uninstall release-name

# Uninstall and keep history
helm uninstall release-name --keep-history

# Uninstall in specific namespace
helm uninstall release-name -n namespace-name
```

## Helm Testing (Module 22)
```bash
# Test release
helm test release-name

# Test with logs
helm test release-name --logs
```

## Helm Pull/Fetch Charts (Module 22)
```bash
# Pull chart from repository
helm pull repo-name/chart-name

# Pull specific version
helm pull repo-name/chart-name --version 1.0.0

# Pull and extract
helm pull repo-name/chart-name --untar

# Pull to specific directory
helm pull repo-name/chart-name --destination ./charts/
```

## Complete Helm S3 Workflow (Module 22)
```bash
# 1. Setup: Add S3 repository
helm repo add sv-charts s3://bucket-name/charts
helm repo update

# 2. Development: Package chart
helm package hello-world/

# 3. Distribution: Push to S3
helm-s3 push hello-world-0.1.0.tgz sv-charts

# 4. Discovery: Search repository
helm repo update
helm search repo sv-charts

# 5. Deployment: Install from S3
helm install myapp sv-charts/hello-world

# 6. Management: Upgrade release
helm upgrade myapp sv-charts/hello-world

# 7. Verification: Check status
helm status myapp
kubectl get all

# 8. Rollback: If needed
helm rollback myapp 1

# 9. Cleanup: Uninstall
helm uninstall myapp
```

## Troubleshooting Helm Issues (Module 22)
```bash
# Check plugin installation
helm plugin list
which helm-s3
helm-s3 version

# Check repository configuration
helm repo list
cat ~/.config/helm/repositories.yaml

# Check repository cache
ls ~/.cache/helm/repository/
cat ~/.cache/helm/repository/repo-name-index.yaml

# Debug chart installation
helm install release-name chart/ --dry-run --debug

# Check release history
helm history release-name

# View release manifest
helm get manifest release-name

# Check Kubernetes resources
kubectl get all -l app.kubernetes.io/instance=release-name

# Check service endpoints (common issue)
kubectl get endpoints service-name
kubectl describe svc service-name | grep -A 5 Selector
```

## Helm Shortnames & Aliases
```bash
alias h='helm'
alias hls='helm ls'
alias hi='helm install'
alias hu='helm upgrade'
alias hr='helm rollback'
alias hun='helm uninstall'
alias hs='helm status'
alias hh='helm history'
alias hgv='helm get values'
alias hgm='helm get manifest'
alias hsr='helm search repo'
alias hru='helm repo update'
alias h3p='helm-s3 push'
alias h3i='helm-s3 init'
```

## Common Helm + Kubernetes Patterns (Module 22)
```bash
# Install and verify
helm install myapp sv-charts/hello-world
kubectl get pods -w
kubectl get svc

# Check endpoints after install
kubectl get endpoints
kubectl describe svc myapp-hello-world | grep -A 5 Selector

# Test service
curl http://localhost:30080

# Update chart values
helm upgrade myapp sv-charts/hello-world --set replicaCount=3

# View what changed
kubectl get pods
helm history myapp

# Rollback if issues
helm rollback myapp 1
kubectl get pods -w

# Cleanup
helm uninstall myapp
kubectl get all
```
