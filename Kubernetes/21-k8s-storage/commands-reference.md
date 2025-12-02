# Kubernetes Storage - Commands I Used

## Commands I Actually Ran

### Create Resources

```bash
# Create hostPath pod
kubectl apply -f 01-hostpath-volume-mount.yml

# Create emptyDir pod
kubectl apply -f 02-emptydir-volume-pod.yml

# Create multi-container shared volume pod
kubectl apply -f 03-common-volume.yml

# Create StorageClass
kubectl apply -f 04-storageclass-local-vol.yml

# Create PersistentVolume
kubectl apply -f 05-persistent-vol.yml

# Create PersistentVolumeClaim
kubectl apply -f 06-persistent-vol-claim.yml

# Create pod using PVC
kubectl apply -f 07-pvc-pod.yml
```

### View Resources

```bash
# View pods
kubectl get pods
kubectl get pods -o wide

# Describe pod
kubectl describe pod <pod-name>

# View PersistentVolumes
kubectl get pv
kubectl get pv -o wide
kubectl describe pv <pv-name>

# View PersistentVolumeClaims
kubectl get pvc
kubectl get pvc -o wide
kubectl describe pvc <pvc-name>

# View StorageClass
kubectl get storageclass
kubectl get sc
kubectl describe storageclass <name>
```

### Test and Verify

```bash
# Exec into pod
kubectl exec -it <pod-name> -- /bin/bash
kubectl exec -it <pod-name> -- sh

# Exec into specific container (multi-container pod)
kubectl exec -it shared-multi-container -c nginx-container -- bash
kubectl exec -it shared-multi-container -c debian-container -- bash

# Check files in volume
kubectl exec -it <pod-name> -- ls -la /data
kubectl exec -it <pod-name> -- cat /data/file.txt

# Write to volume from inside container
kubectl exec -it <pod-name> -- /bin/bash
echo "test data" >> /data/test.txt

# Kill process to test restart
kubectl exec -it <pod-name> -- kill 1
# Watch pod restart count increase
```

### Test Persistence

```bash
# hostPath test
kubectl apply -f 01-hostpath-volume-mount.yml
# Let it crash and restart multiple times
cat /var/tmp/output.txt
# Multiple entries from each restart

# Delete and recreate
kubectl delete -f 01-hostpath-volume-mount.yml
kubectl apply -f 01-hostpath-volume-mount.yml
cat /var/tmp/output.txt
# Old data still there!

# emptyDir test
kubectl apply -f 02-emptydir-volume-pod.yml
kubectl exec -it redis-emptydir -- /bin/bash
echo "test" > /data/redis/test.txt
exit

# Kill container (test container restart)
kubectl exec -it redis-emptydir -- kill 1
kubectl exec -it redis-emptydir -- cat /data/redis/test.txt
# File still there! ✅

# Delete pod (test pod deletion)
kubectl delete -f 02-emptydir-volume-pod.yml
kubectl apply -f 02-emptydir-volume-pod.yml
kubectl exec -it redis-emptydir -- ls /data/redis/
# Empty! File lost ❌
```

### Test Multi-Container Sharing

```bash
# Create shared volume pod
kubectl apply -f 03-common-volume.yml

# Get pod IP
kubectl get pods -o wide

# Curl to see nginx serving debian's timestamps
curl <POD-IP>

# Exec into nginx container
kubectl exec -it shared-multi-container -c nginx-container -- bash
cd /usr/share/nginx/html
cat index.html
# Timestamps written by debian container!

# Write from nginx container
echo "custom line" >> index.html

# Curl again
curl <POD-IP>
# Shows timestamps AND custom line!
```

### PV/PVC Workflow

```bash
# Step 1: Create StorageClass
kubectl apply -f 04-storageclass-local-vol.yml
kubectl describe storageclass local-storage

# Step 2: Create PV
kubectl apply -f 05-persistent-vol.yml
kubectl get pv
# Status: Available

# Step 3: Create PVC
kubectl apply -f 06-persistent-vol-claim.yml
kubectl get pvc
# Status: Pending (WaitForFirstConsumer)

kubectl describe pvc my-pvc
# Message: "waiting for first consumer to be created before binding"

# Step 4: Create Pod
kubectl apply -f 07-pvc-pod.yml

# Check binding happened
kubectl get pvc
# Status: Bound ✅

kubectl get pv
# Status: Bound, Claim: default/my-pvc ✅

# Step 5: Verify file created
ls -la /var/tmp/
cat /var/tmp/success.txt
```

### Test PVC Lifecycle

```bash
# Delete pod (PVC still bound)
kubectl delete -f 07-pvc-pod.yml
kubectl get pvc
# Still Bound ✅

kubectl get pv
# Still Bound ✅

# Delete PVC (PV reclaim policy triggered)
kubectl delete -f 06-persistent-vol-claim.yml
kubectl get pv
# Status: Bound → Available ✅
# Recycle policy cleaned data
```

### Edit PVC Storage

```bash
# Tried to expand storage
kubectl edit pvc my-pvc
# Changed storage: 100Mi → 200Mi

kubectl get pvc
# Capacity still shows 1Gi (full PV capacity)

# Lesson: PVC gets full PV capacity when bound
```

## Verification Commands

### Check Volume Mounts

```bash
# See what volumes pod is using
kubectl describe pod <pod-name> | grep -A 5 "Volumes:"

# See container mounts
kubectl describe pod <pod-name> | grep -A 3 "Mounts:"

# Check volume type
kubectl get pod <pod-name> -o jsonpath='{.spec.volumes[*]}'
```

### Check Storage Resources

```bash
# All PVs
kubectl get pv

# All PVCs
kubectl get pvc

# All StorageClasses
kubectl get sc

# PV details
kubectl get pv <name> -o yaml

# PVC details
kubectl get pvc <name> -o yaml
```

### Host Filesystem Checks

```bash
# For hostPath volumes, check on host node
ls -la /var/tmp/
cat /var/tmp/output.txt
cat /var/tmp/success.txt

# For emptyDir, can't check on host (managed by kubelet)
```

## Delete Resources

```bash
# Delete pod
kubectl delete -f <pod-file>.yml
kubectl delete pod <pod-name>

# Delete PVC
kubectl delete pvc <pvc-name>
kubectl delete -f <pvc-file>.yml

# Delete PV
kubectl delete pv <pv-name>
kubectl delete -f <pv-file>.yml

# Delete StorageClass
kubectl delete storageclass <name>
kubectl delete -f <sc-file>.yml
```

## Troubleshooting Commands

### PVC Stuck in Pending

```bash
# Check why PVC is pending
kubectl describe pvc <name>

# Possible reasons:
# 1. WaitForFirstConsumer - need to create pod
# 2. No matching PV available
# 3. Access mode mismatch
# 4. Capacity too small

# Check available PVs
kubectl get pv

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Pod Can't Mount Volume

```bash
# Check pod events
kubectl describe pod <name> | grep -A 10 Events

# Check PVC is bound
kubectl get pvc

# Check volume definition in pod
kubectl get pod <name> -o yaml | grep -A 10 volumes
```

### Check What's Using PVC

```bash
# See which pod is using PVC
kubectl describe pvc <name> | grep "Used By:"

# Or check all pods
kubectl get pods -o json | jq '.items[] | select(.spec.volumes[]?.persistentVolumeClaim.claimName=="my-pvc") | .metadata.name'
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl get pv` | List PersistentVolumes |
| `kubectl get pvc` | List PersistentVolumeClaims |
| `kubectl get sc` | List StorageClasses |
| `kubectl describe pv <name>` | View PV details |
| `kubectl describe pvc <name>` | View PVC details and binding status |
| `kubectl exec -it <pod> -- bash` | Access container to check volume |
| `cat /var/tmp/<file>` | Check hostPath data on node |

## Volume Types Quick Comparison

| Type | Persistence | Sharing | Use Case |
|------|-------------|---------|----------|
| emptyDir | Pod lifetime | Same pod only | Temp data, cache |
| hostPath | Node lifetime | Same node | Dev/test only |
| PVC | Independent | Cross-pod | Production data |
| configMap | Independent | Read-only | Configuration |
| secret | Independent | Read-only | Credentials |

## Storage Units

```yaml
storage: 100Mi   # 100 Mebibytes (binary)
storage: 1Gi     # 1 Gibibyte (binary)
storage: 500M    # 500 Megabytes (decimal)
storage: 2G      # 2 Gigabytes (decimal)
```

**Common:** Use `Mi` and `Gi` (binary units)

## Access Modes

```yaml
- ReadWriteOnce (RWO)   # Single node, read-write (most common)
- ReadOnlyMany (ROX)    # Multiple nodes, read-only
- ReadWriteMany (RWX)   # Multiple nodes, read-write (requires NFS/etc)
```

---

These are the actual commands I used to learn Kubernetes storage!