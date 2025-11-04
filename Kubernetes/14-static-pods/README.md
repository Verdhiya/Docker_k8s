# Project 14: Static Pods

Hands-on practice with static pods (kubelet-managed).

## Files

- 01-static-pod.yml

**Platform:** AWS 3-node cluster

**IMPORTANT:** Static pod file created on k8s-worker-2 (not master!)

---

## What I Learned

**Static Pod:** Pod managed directly by kubelet (not by API server)

**Location:** `/etc/kubernetes/manifests/` on the node

**Use Case:** Control plane components, critical node-level services

---

## Exercise: Create Static Pod on Worker Node

**File:** 01-static-pod.yml

**What I did:**

**Step 1: SSH to worker-2**
```bash
ssh k8s-worker-2
```

**Step 2: Create static pod file**
```bash
sudo vim /etc/kubernetes/manifests/static-pod.yml

# Content:
apiVersion: v1
kind: Pod
metadata:
  name: nginx-static-pod
spec:
  containers:
  - name: nginx
    image: nginx
```

**Step 3: Restart kubelet (optional, speeds detection)**
```bash
sudo systemctl restart kubelet
```

**Step 4: Check from master**
```bash
# On k8s-master:
kubectl get pods -o wide
```

**What I observed:**
```
Pod appeared:
NAME: nginx-static-pod-k8s-worker-2
                     └─────────────┘
                     Node name suffix!

Key identifiers:
- Name ends with node name (-k8s-worker-2)
- Controlled By: Node/k8s-worker-2
- Config Source: file
- Config Mirror: (mirror pod)

This is a static pod! ✅
```

---

## Testing Static Pod Behavior

**Tried to delete via kubectl:**
```bash
kubectl delete pod nginx-static-pod-k8s-worker-2
```

**What happened:**
```
1. Mirror pod deleted from API
2. STATUS: Pending (briefly)
3. STATUS: Running (came back!)
4. Pod respawned in ~10 seconds

Why?
- File still exists in /etc/kubernetes/manifests/
- kubelet: "My file is still there, recreate pod!"
- kubectl delete doesn't work for static pods!
```

**Proper deletion:**
```bash
# SSH to worker-2
ssh k8s-worker-2

# Delete the file
sudo rm /etc/kubernetes/manifests/static-pod.yml

# Exit to master
exit

# Check pods
kubectl get pods
# nginx-static-pod-k8s-worker-2 disappeared! ✅
```

**Key Learning:**
- kubectl delete doesn't permanently remove static pods
- Must delete source file on the node
- Only way to truly remove static pod

---

## Static Pod Identification

**How to identify static pods:**

1. **Name ends with node name:**
   - nginx-static-pod-k8s-worker-2 ← Static
   - nginx-deployment-xyz-abc ← Not static

2. **Controlled By: Node/**
   ```bash
   kubectl describe pod nginx-static-pod-k8s-worker-2 | grep "Controlled By"
   # Output: Controlled By: Node/k8s-worker-2
   ```

3. **Config Source: file**
   ```bash
   kubectl get pod nginx-static-pod-k8s-worker-2 -o yaml | grep config.source
   # Output: kubernetes.io/config.source: file
   ```

---

## Control Plane Static Pods

**On k8s-master, these are static pods:**
```bash
kubectl get pods -n kube-system | grep k8s-master

etcd-k8s-master
kube-apiserver-k8s-master
kube-controller-manager-k8s-master
kube-scheduler-k8s-master
```

**All created from:**
```bash
ls /etc/kubernetes/manifests/
# etcd.yaml
# kube-apiserver.yaml
# kube-controller-manager.yaml
# kube-scheduler.yaml
```

**These bootstrap the control plane!** ✅

---

## Summary

**Static Pods:**
- Managed by kubelet directly (not API server)
- Created from files in `/etc/kubernetes/manifests/`
- Show as mirror pods in kubectl (read-only reflection)
- Can't delete via kubectl (must delete file)
- Work even if API server is down
- Used for control plane components

**Key Point:**
- Static pod location = Which node runs it
- File on worker-2 → Pod on worker-2
- File on master → Pod on master

**Identification:**
- Name: ends with `-<node-name>`
- Controlled By: Node/<node-name>
- Config Source: file

**Delete:** Remove file from `/etc/kubernetes/manifests/` on the node
