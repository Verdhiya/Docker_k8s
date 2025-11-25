# Kubernetes Ingress - Commands I Actually Used

## Commands I Ran

### Deploy Applications

```bash
# Create nginx official deployment
kubectl create -f 01-nginx-deployment.yml

# Create nginx service
kubectl create -f 02-nginx-deployment-service.yml

# Create magical nginx deployment
kubectl create -f 03-magical-nginx-deployment.yml

# Create magical nginx service
kubectl create -f 04-magical-nginx-deployment-service.yml

# Check deployments
kubectl get deployment

# Check services
kubectl get services
```

### Test NodePort Services (Before Ingress)

```bash
# Get service URL
minikube service nginx-official-service --url
minikube service magical-nginx --url

# Test access
curl http://172.31.19.217:31303  # nginx-official
curl http://172.31.19.217:31304  # magical-nginx
```

### Install Ingress Controller

```bash
# Enable ingress addon
minikube addons enable ingress

# Check addon status
minikube addons list | grep ingress

# Check if controller pods are running
kubectl get pods -n ingress-nginx

# If pods stuck in Pending, check why
kubectl describe pod -n ingress-nginx <pod-name>

# Check what labels the pods need
kubectl get pod <pod-name> -n ingress-nginx -o yaml | grep -A 10 "nodeSelector\|affinity"

# Check what labels my node has
kubectl get node k8s --show-labels

# Add missing label
kubectl label node k8s minikube.k8s.io/primary=true

# Verify label added
kubectl get node k8s --show-labels | grep primary

# Watch pods start
kubectl get pods -n ingress-nginx -w
```

### Create and Test Ingress

```bash
# Create ingress resource
kubectl create -f 05-ingress-rules.yml

# Check ingress
kubectl get ingress
kubectl get ingress nginx-rules

# Describe ingress (see rules)
kubectl describe ingress nginx-rules

# Check ingress controller service
kubectl get svc -n ingress-nginx

# Get minikube/node IP
minikube ip
```

### Test Routing with Curl

```bash
# Test nginx-official
curl http://172.31.19.217 -H 'Host: nginx-official.example.com'
curl 172.31.19.217 -H 'Host: nginx-official.example.com'

# Test magical-nginx
curl http://172.31.19.217 -H 'Host: magical-nginx.example.com'
curl 172.31.19.217 -H 'Host: magical-nginx.example.com'

# Both worked! Got different HTML content
```

### View Ingress Controller Logs (for debugging)

```bash
# Get controller pod name
kubectl get pods -n ingress-nginx

# View logs
kubectl logs -n ingress-nginx <controller-pod-name>

# Follow logs in real-time
kubectl logs -n ingress-nginx <controller-pod-name> -f
```

## Troubleshooting Commands I Used

### When Pods Were Stuck in Pending

```bash
# Check namespace exists
kubectl get namespace ingress-nginx

# Check pod status
kubectl get pods -n ingress-nginx

# See why pods are pending
kubectl describe pod -n ingress-nginx | grep -A 10 "Events:"

# Output showed:
# "node(s) didn't match Pod's node affinity/selector"

# Check node status
kubectl get nodes

# Check node taints
kubectl describe node k8s | grep -i taint
# Result: Taints: <none>

# Check what labels pods need
kubectl get pod ingress-nginx-controller-xxx -n ingress-nginx -o yaml | grep -A 10 "nodeSelector"

# Showed it needed:
#   kubernetes.io/os: linux
#   minikube.k8s.io/primary: "true"

# Check what labels node has
kubectl get node k8s --show-labels

# My node had kubernetes.io/os=linux but not minikube.k8s.io/primary=true

# Added the missing label
kubectl label node k8s minikube.k8s.io/primary=true

# Pods started immediately!
```

## What Each Command Showed Me

### Getting Ingress Details

```bash
kubectl get ingress nginx-rules
```
Output:
```
NAME          HOSTS                                    ADDRESS         PORTS
nginx-rules   nginx-official.example.com,magical...    172.31.19.217   80
```

### Describing Ingress

```bash
kubectl describe ingress nginx-rules
```
Output showed:
```
Rules:
  Host                        Path  Backends
  ----                        ----  --------
  nginx-official.example.com  /     nginx-official-service:80 (10.244.0.235:80)
  magical-nginx.example.com   /     magical-nginx:80 (10.244.0.236:80)

Events:
  Type    Reason  Message
  ----    ------  -------
  Normal  Sync    Scheduled for sync
```

### Ingress Controller Service

```bash
kubectl get svc -n ingress-nginx
```
Output:
```
NAME                                 TYPE       PORT(S)
ingress-nginx-controller             NodePort   80:32632/TCP,443:31590/TCP
ingress-nginx-controller-admission   ClusterIP  443/TCP
```

## Testing Results

### Before Ingress (NodePort)
```bash
curl http://172.31.19.217:31303  # nginx-official ✅
curl http://172.31.19.217:31304  # magical-nginx ✅
```

### After Ingress (Host-based routing)
```bash
curl 172.31.19.217 -H 'Host: nginx-official.example.com'  # ✅ Nginx welcome page
curl 172.31.19.217 -H 'Host: magical-nginx.example.com'   # ✅ DevOps course page
```

### In Browser (After editing hosts file)
```
http://nginx-official.example.com  # ✅ Worked
http://magical-nginx.example.com   # ✅ Worked
```

## Quick Reference

```bash
# Install ingress controller
minikube addons enable ingress

# Check controller status
kubectl get pods -n ingress-nginx

# View ingress resources
kubectl get ingress

# View routing rules
kubectl describe ingress <name>

# Test with curl
curl <IP> -H 'Host: example.com'

# Add node label (if needed)
kubectl label node <name> minikube.k8s.io/primary=true

# View ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

## Files on Local Computer

### Hosts File Location

**Windows:**
```
C:\Windows\System32\drivers\etc\hosts
```

**Mac/Linux:**
```
/etc/hosts
```

### Entries I Added:
```
<EC2-PUBLIC-IP> nginx-official.example.com
<EC2-PUBLIC-IP> magical-nginx.example.com
```

Note: Use EC2 **public IP**, not private IP (172.31.x.x)!

## What Worked

✅ NodePort services before ingress  
✅ Installing ingress controller (after fixing label)  
✅ Creating ingress resource  
✅ Testing with curl using -H 'Host:...'  
✅ Accessing from browser (after hosts file)  

## What I Learned

- Ingress controller must be installed first
- Ingress resource is just routing rules
- Host header determines which service gets traffic
- Node labels are sometimes required
- Hosts file maps domain names to IPs locally
- One IP can serve multiple applications with ingress

---

These are the actual commands I used to get ingress working!