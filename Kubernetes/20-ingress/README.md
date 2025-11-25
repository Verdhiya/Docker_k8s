# 📚 Kubernetes Ingress

## 🎯 What I Learned

- What Ingress is and why it's needed
- How to install Nginx Ingress Controller
- Troubleshooting ingress controller installation (node label issue)
- Creating Ingress resources with host-based routing
- Accessing applications via domain names through single entry point
- Testing with curl using Host header
- Configuring local hosts file for browser access

## 📚 What I Built

### Two Applications

**App 1: Nginx Official**
- Standard nginx image
- Accessible via: nginx-official.example.com

**App 2: Magical Nginx**
- Custom image (anshuldevops/magicalnginx)
- Shows DevOps course content
- Accessible via: magical-nginx.example.com

### Routing Setup

```
Single Entry Point (172.31.19.217)
         ↓
  Ingress Controller
         ↓
   ┌─────┴─────┐
   ↓           ↓
nginx-official.example.com → nginx-official-service → nginx pod
magical-nginx.example.com → magical-nginx service → magical pod
```

## 🗂️ Files Created

| File | What It Does |
|------|--------------|
| `01-nginx-deployment.yml` | Nginx official deployment (1 replica) |
| `02-nginx-deployment-service.yml` | NodePort service for nginx (port 31303) |
| `03-magical-nginx-deployment.yml` | Magical nginx deployment (1 replica) |
| `04-magical-nginx-deployment-service.yml` | NodePort service for magical nginx (port 31304) |
| `05-ingress-rules.yml` | Ingress resource with host-based routing rules |

## 🚀 What I Did Step-by-Step

### Step 1: Created First Application (Nginx Official)

```bash
# Created deployment
kubectl create -f 01-nginx-deployment.yml

# Verified deployment
kubectl get deployment
kubectl describe deployment nginx-official-deployment

# Created NodePort service
kubectl create -f 02-nginx-deployment-service.yml

# Checked service
kubectl get services

# Tested NodePort access
minikube service nginx-official-service --url
curl http://172.31.19.217:31303
```

**Result:** Nginx welcome page accessible on port 31303

### Step 2: Created Second Application (Magical Nginx)

```bash
# Created deployment
kubectl create -f 03-magical-nginx-deployment.yml

# Verified
kubectl get deployment

# Created NodePort service
kubectl create -f 04-magical-nginx-deployment-service.yml

# Tested access
minikube service magical-nginx --url
curl http://172.31.19.217:31304
```

**Result:** DevOps course page accessible on port 31304

### Step 3: Installed Ingress Controller (Had Issues!)

```bash
# Tried to enable ingress
minikube addons enable ingress

# Pods got stuck in Pending!
kubectl get pods -n ingress-nginx
# STATUS: Pending (for 10+ minutes)

# Checked why
kubectl describe pod -n ingress-nginx <pod-name>
# Error: "node(s) didn't match Pod's node affinity/selector"

# Checked node labels
kubectl get node k8s --show-labels
# Missing: minikube.k8s.io/primary=true

# Fixed by adding label
kubectl label node k8s minikube.k8s.io/primary=true

# Pods started immediately!
kubectl get pods -n ingress-nginx -w
# STATUS: Running ✅
```

**Result:** Ingress controller running after adding required node label

### Step 4: Created Ingress Resource with Routing Rules

```bash
# Created ingress
kubectl create -f 05-ingress-rules.yml

# Checked ingress
kubectl get ingress nginx-rules
# Showed ADDRESS: 172.31.19.217

# Described ingress to see rules
kubectl describe ingress nginx-rules
```

Output showed:
```
Rules:
  Host                        Path  Backends
  ----                        ----  --------
  nginx-official.example.com  /     nginx-official-service:80
  magical-nginx.example.com   /     magical-nginx:80
```

### Step 5: Tested with Curl

```bash
# Tested nginx-official
curl 172.31.19.217 -H 'Host: nginx-official.example.com'
# Got nginx welcome page! ✅

# Tested magical-nginx
curl 172.31.19.217 -H 'Host: magical-nginx.example.com'
# Got DevOps course page! ✅

# Got ingress controller service details
kubectl get svc -n ingress-nginx
# ingress-nginx-controller: 80:32632/TCP, 443:31590/TCP
```

**Result:** Both apps accessible through single IP with different hostnames!

### Step 6: Configured Browser Access

**On my laptop** (not on server):

Edited hosts file:
- **Windows:** `C:\Windows\System32\drivers\etc\hosts`
- **Mac/Linux:** `/etc/hosts`

Added:
```
<EC2-PUBLIC-IP> nginx-official.example.com
<EC2-PUBLIC-IP> magical-nginx.example.com
```

Then opened browser:
- `http://nginx-official.example.com` ✅ Worked!
- `http://magical-nginx.example.com` ✅ Worked!

**Result:** Successfully accessed both apps via browser using domain names!

## 🔍 Problems I Solved

### Problem 1: Ingress Controller Pods Stuck in Pending

**Error:**
```
ingress-nginx-controller  0/1  Pending
```

**Cause:**
```bash
kubectl describe pod -n ingress-nginx <pod-name>
# "node(s) didn't match Pod's node affinity/selector"
```

Pods were looking for label `minikube.k8s.io/primary=true` which my node didn't have.

**Solution:**
```bash
kubectl label node k8s minikube.k8s.io/primary=true
```

Pods started immediately after adding label!

### Problem 2: Browser Couldn't Resolve Hostnames

**Error:** `ERR_NAME_NOT_RESOLVED` in browser

**Cause:** Domain names `nginx-official.example.com` and `magical-nginx.example.com` don't exist in real DNS

**Solution:** Added entries to local hosts file pointing to EC2 public IP

## 📊 What I Discovered

### Before Ingress:
```
nginx-official: http://172.31.19.217:31303
magical-nginx: http://172.31.19.217:31304
```
- Different ports
- Ugly URLs
- Hard to remember

### After Ingress:
```
nginx-official: http://nginx-official.example.com
magical-nginx: http://magical-nginx.example.com
```
- Standard port 80
- Professional URLs
- Easy to remember
- Single entry point

### How Routing Works:

```
Request: http://nginx-official.example.com
              ↓
DNS/hosts file: 172.31.19.217
              ↓
HTTP Request with Host header: nginx-official.example.com
              ↓
Ingress Controller reads Host header
              ↓
Matches rule: nginx-official.example.com → nginx-official-service
              ↓
Routes to nginx-official-service
              ↓
Service routes to nginx pod
              ↓
Returns nginx welcome page
```

## 💡 Key Learnings

1. **Ingress Controller ≠ Ingress Resource**
   - Controller = Software (Nginx pod) that implements routing
   - Resource = YAML rules that define routing

2. **Host Header is Key**
   - Ingress routes based on Host header in HTTP request
   - `curl -H 'Host: example.com'` sends Host header
   - Browser sends Host header automatically

3. **Node Labels Matter**
   - Some workloads need specific node labels
   - Check with `kubectl get node --show-labels`
   - Can add labels with `kubectl label`

4. **Hosts File for Testing**
   - Edit hosts file on local computer (not server!)
   - Maps domain names to IP addresses
   - Only affects your local computer

5. **One Entry Point, Multiple Apps**
   - Both apps through same IP
   - Routing based on hostname
   - No need for multiple LoadBalancers

## 🎓 Commands That Worked

```bash
# Check ingress controller status
kubectl get pods -n ingress-nginx

# View ingress rules
kubectl get ingress
kubectl describe ingress nginx-rules

# Test with curl
curl <IP> -H 'Host: hostname.example.com'

# Get ingress controller service
kubectl get svc -n ingress-nginx

# Add node label
kubectl label node <node-name> minikube.k8s.io/primary=true

# Check node labels
kubectl get node <node-name> --show-labels
```

## 📈 What I Achieved

✅ Installed Nginx Ingress Controller  
✅ Troubleshot and fixed node affinity issue  
✅ Created two separate applications  
✅ Created Ingress resource with host-based routing  
✅ Tested routing with curl  
✅ Configured browser access via hosts file  
✅ Successfully accessed both apps via domain names  

---

**Status:** Completed ✅  
**Result:** Two applications accessible through single entry point with professional URLs!