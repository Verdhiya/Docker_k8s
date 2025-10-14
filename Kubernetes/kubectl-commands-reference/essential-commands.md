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
Pods
bash
Copy code
# List pods
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide
kubectl get pods -n <namespace>

# Describe pod
kubectl describe pod <pod-name>

# Logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl logs <pod-name> --previous

# Execute commands
kubectl exec -it <pod-name> -- bash
kubectl exec -it <pod-name> -- sh
kubectl exec <pod-name> -- <command>
kubectl exec <pod-name> -- env
kubectl exec <pod-name> -- printenv

# Wait for pod
kubectl wait --for=condition=ready pod/<pod-name> --timeout=60s

# Delete pod
kubectl delete pod <pod-name>
kubectl delete pod <pod-name> --force --grace-period=0
Deployments
bash
Copy code
kubectl create deployment <name> --image=<image>
kubectl get deployments
kubectl get deployments -o wide
kubectl describe deployment <name>
kubectl scale deployment <name> --replicas=<number>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl delete deployment <name>
Services
bash
Copy code
kubectl expose deployment <name> --port=80 --type=NodePort
kubectl get services
kubectl get svc
kubectl describe service <name>
kubectl get endpoints <service-name>
kubectl delete service <name>
Namespaces
bash
Copy code
kubectl create namespace <name>
kubectl get namespaces
kubectl get ns
kubectl get pods -n <namespace>
kubectl delete namespace <name>
ConfigMaps (Project 07)
bash
Copy code
# Create ConfigMap
kubectl create configmap <name> --from-literal=key=value
kubectl create configmap <name> --from-file=file.conf
kubectl apply -f configmap.yaml

# View ConfigMap
kubectl get configmaps
kubectl get cm
kubectl describe configmap <name>
kubectl get configmap <name> -o yaml

# Update ConfigMap
kubectl create configmap <name> --from-literal=key=newvalue --dry-run=client -o yaml | kubectl apply -f -

# Delete ConfigMap
kubectl delete configmap <name>
Secrets (Project 07)
bash
Copy code
# Create Secret
kubectl create secret generic <name> --from-literal=key=value
kubectl create secret generic <name> --from-file=./file.txt
kubectl apply -f secret.yaml

# View Secret
kubectl get secrets
kubectl describe secret <name>
kubectl get secret <name> -o yaml

# Decode Secret value
kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d

# Delete Secret
kubectl delete secret <name>
RBAC
bash
Copy code
# Roles and RoleBindings
kubectl get roles -A
kubectl get rolebindings -A
kubectl describe role <name> -n <namespace>
kubectl describe rolebinding <name> -n <namespace>

# ClusterRoles and ClusterRoleBindings
kubectl get clusterroles
kubectl get clusterrolebindings

# ServiceAccounts
kubectl get serviceaccounts -A
kubectl get sa -A
kubectl describe serviceaccount <name> -n <namespace>
kubectl create serviceaccount <name> -n <namespace>

# Check permissions
kubectl auth can-i <verb> <resource> -n <namespace>
kubectl auth can-i list pods -n default
kubectl auth can-i --list -n <namespace>
kubectl auth can-i --list --as=system:serviceaccount:<namespace>:<sa-name> -n <namespace>
Node Management
bash
Copy code
# Node operations
kubectl get nodes
kubectl describe node <node>
kubectl drain <node> --ignore-daemonsets
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
kubectl cordon <node>
kubectl uncordon <node>

# Check node resources
kubectl describe node | grep -A 8 "Allocated resources"
Resource Management (Project 08)
bash
Copy code
# View pod resources
kubectl describe pod <name> | grep -A 8 "Limits:\|Requests:"
kubectl describe pod <name> | grep "QoS Class"

# Check why pod is Pending
kubectl describe pod <name> | grep -A 10 Events

# View node capacity
kubectl describe node <node-name> | grep -A 8 "Allocated resources"

# Monitor resource usage (requires metrics-server)
kubectl top nodes
kubectl top pods
kubectl top pods -A
Health Probes (Project 09)
bash
Copy code
# View probe configuration
kubectl describe pod <name> | grep "Liveness:"
kubectl describe pod <name> | grep "Readiness:"
kubectl describe pod <name> | grep "Startup:"
kubectl describe pod <name> | grep -A 3 "Liveness:\|Readiness:\|Startup:"

# Watch for restarts
kubectl get pods <name> -w
kubectl get pods -w

# Check restart count
kubectl get pods
# Look at RESTARTS column

# Check exit code and last state
kubectl get pod <name> -o yaml | grep -A 10 lastState
kubectl get pod <name> -o yaml | grep exitCode
Troubleshooting
bash
Copy code
# Describe resources
kubectl describe <resource> <name>
kubectl describe pod <pod-name>
kubectl describe node <node-name>

# Logs
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl logs -f <pod-name>

# Events
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events -A --sort-by='.lastTimestamp'
kubectl get events --watch

# YAML/JSON output
kubectl get pod <name> -o yaml
kubectl get pod <name> -o json

# Explain resources
kubectl explain pod
kubectl explain deployment
kubectl explain service
Watch and Monitor
bash
Copy code
# Watch resources update
kubectl get pods -w
kubectl get pods <name> -w
kubectl get nodes -w

# Monitor events
kubectl get events --watch

# Follow logs
kubectl logs -f <pod-name>
Cleanup
bash
Copy code
# Delete by file
kubectl delete -f <file>.yaml

# Delete by type and name
kubectl delete pod <name>
kubectl delete deployment <name>
kubectl delete service <name>
kubectl delete namespace <name>

# Delete all in namespace
kubectl delete all --all -n <namespace>

# Force delete
kubectl delete pod <name> --force --grace-period=0
