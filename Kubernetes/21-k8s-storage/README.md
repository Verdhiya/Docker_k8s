# Kubernetes Storage and Volumes

## 🎯 What I Learned

- Container filesystem is ephemeral (data lost on container deletion)
- Different volume types and their use cases
- hostPath volume persistence (survives pod deletion)
- emptyDir volume lifetime (pod lifetime, not container lifetime)
- Multi-container volume sharing (sidecar pattern)
- PersistentVolume (PV) and PersistentVolumeClaim (PVC) architecture
- StorageClass configuration and volume binding modes
- Reclaim policies and PV lifecycle

## 📚 Concepts Practiced

### Container Filesystem Problem

**Issue:** Container filesystems are ephemeral
```
Container writes data → Container crashes → Data LOST
Pod deleted → All container data LOST
```

**Solution:** Volumes and Persistent Volumes

### Volume Types Tested

#### 1. hostPath
- Mounts directory from host node into pod
- Data stored on node filesystem
- **Survives pod deletion** ✅
- **NOT recommended for production** (single-node only)

#### 2. emptyDir
- Temporary directory created with pod
- Shared between containers in same pod
- **Survives container restart** ✅
- **Lost on pod deletion** ❌

#### 3. PersistentVolumeClaim (PVC)
- Request for persistent storage
- Binds to PersistentVolume (PV)
- **Survives pod deletion** ✅
- **Cluster-wide persistence** ✅

## 🗂️ Files Created

| File | What It Does |
|------|--------------|
| `01-hostpath-volume-mount.yml` | Pod with hostPath volume, demonstrates data persistence across pod deletion |
| `02-emptydir-volume-pod.yml` | Redis pod with emptyDir, tested container restart vs pod deletion |
| `03-common-volume.yml` | Two containers sharing emptyDir (debian writes, nginx serves) |
| `04-storageclass-local-vol.yml` | StorageClass with WaitForFirstConsumer binding mode |
| `05-persistent-vol.yml` | PersistentVolume (1Gi) using hostPath backend |
| `06-persistent-vol-claim.yml` | PersistentVolumeClaim requesting 200Mi storage |
| `07-pvc-pod.yml` | Pod using PVC to write to persistent storage |

## 🚀 What I Did Step-by-Step

### Experiment 1: hostPath Volume Persistence

```bash
# Created pod with hostPath volume
kubectl apply -f 01-hostpath-volume-mount.yml

# Pod entered CrashLoopBackOff (command exits immediately)
# Each restart added entry to /var/tmp/output.txt

# Checked file on host
cat /var/tmp/output.txt
# Multiple entries from each restart!

# Deleted and recreated pod
kubectl delete -f 01-hostpath-volume-mount.yml
kubectl apply -f 01-hostpath-volume-mount.yml

# File still had ALL previous entries!
cat /var/tmp/output.txt
```

**Discovery:** hostPath data persists on node even after pod deletion! ✅

**Important Learning:**
- CrashLoopBackOff intentional for demonstration
- Each restart appended to same file
- Proves hostPath provides true persistence

---

### Experiment 2: emptyDir Lifetime

```bash
# Created Redis pod with emptyDir
kubectl apply -f 02-emptydir-volume-pod.yml

# Created test file inside container
kubectl exec -it redis-emptydir -- /bin/bash
echo "this is for emptydir testing purpose" >> /data/redis/test.txt
exit

# Test 1: Container Restart
# Killed PID 1 (redis-server)
kubectl exec -it redis-emptydir -- /bin/bash
kill 1
# Container restarted (RESTARTS: 0 → 1)

# File still there!
kubectl exec -it redis-emptydir -- cat /data/redis/test.txt
# ✅ test.txt survived container restart

# Test 2: Pod Deletion
kubectl delete -f 02-emptydir-volume-pod.yml
kubectl apply -f 02-emptydir-volume-pod.yml

# File GONE!
kubectl exec -it redis-emptydir -- ls /data/redis/
# ❌ Empty directory
```

**Discovery:**
- emptyDir survives **container restarts** (same pod) ✅
- emptyDir does NOT survive **pod deletion** ❌

**Lesson:** emptyDir lifetime = Pod lifetime, NOT container lifetime

---

### Experiment 3: Multi-Container Volume Sharing

```bash
# Created pod with two containers sharing emptyDir
kubectl apply -f 03-common-volume.yml

# Setup:
# - debian-container: Writes timestamp every 5 seconds
# - nginx-container: Serves HTTP

# Tested from outside
curl <POD-IP>
# Got timestamps! debian wrote, nginx served ✅

# Tested from inside nginx container
kubectl exec -it shared-multi-container -- bash
cd /usr/share/nginx/html
echo "testing writing in index file inside the nginx html" >> index.html
exit

# Curled again
curl <POD-IP>
# Saw:
# - Timestamps from debian (continuing)
# - My custom line
# - New timestamps AFTER my line
```

**Discovery:**
- Both containers see same data in real-time ✅
- Changes from one container visible to other ✅
- Perfect for sidecar patterns (logging, data processing) ✅

---

### Experiment 4: PersistentVolume Architecture

```bash
# Step 1: Created StorageClass
kubectl apply -f 04-storageclass-local-vol.yml
kubectl describe storageclass local-storage

# Key settings:
# - provisioner: kubernetes.io/no-provisioner (manual)
# - volumeBindingMode: WaitForFirstConsumer
# - allowVolumeExpansion: true

# Step 2: Created PersistentVolume
kubectl apply -f 05-persistent-vol.yml
kubectl get pv
# Status: Available (waiting for claim)

# Step 3: Created PersistentVolumeClaim
kubectl apply -f 06-persistent-vol-claim.yml
kubectl get pvc
# Status: Pending!
# Message: "waiting for first consumer to be created before binding"

# This is WaitForFirstConsumer in action!

# Step 4: Created Pod using PVC
kubectl apply -f 07-pvc-pod.yml

# Immediately checked status
kubectl get pvc
# Status: Pending → Bound ✅

kubectl get pv
# Status: Available → Bound ✅
# Claim: default/my-pvc

# Pod completed successfully
kubectl get pods
# STATUS: Completed
```

**Discovery:**
- PVC requested 200Mi
- PV provided 1Gi
- PVC got full 1Gi (PV capacity) ✅
- Binding happened only when Pod created (WaitForFirstConsumer)

---

### Experiment 5: PV/PVC Lifecycle

```bash
# Test 1: Delete Pod
kubectl delete -f 07-pvc-pod.yml

kubectl get pvc
# Still Bound! ✅

kubectl get pv
# Still Bound! ✅
```

**Lesson:** Deleting Pod doesn't affect PVC/PV binding

```bash
# Test 2: Delete PVC
kubectl delete -f 06-persistent-vol-claim.yml

kubectl get pv
# Status: Bound → Available ✅
# Reclaim Policy (Recycle) cleaned data
```

**Lesson:** Deleting PVC triggers Reclaim Policy
- Recycle: Cleans data, returns PV to Available
- PV ready for reuse

---

## 🔍 Key Discoveries

### hostPath vs emptyDir vs PVC

| Event | hostPath | emptyDir | PVC |
|-------|----------|----------|-----|
| Container restart | ✅ Survives | ✅ Survives | ✅ Survives |
| Pod deletion | ✅ Survives | ❌ Lost | ✅ Survives |
| Node restart | ✅ Survives | ❌ Lost | ✅ Survives |
| Shareable across pods | ⚠️ Same node only | ❌ No | ✅ Yes |

### Storage Capacity Matching

```
PVC requests: 200Mi
PV provides: 1Gi

Result: PVC gets 1Gi (full PV capacity)

Rule: PVC requests minimum, gets what PV provides (if PV ≥ request)
```

### Volume Binding Modes

**WaitForFirstConsumer:**
```
PVC created → Status: Pending
Pod created → Binding happens → Status: Bound
```

**Immediate:**
```
PVC created → Binds immediately → Status: Bound
(Even if no pod using it yet)
```

### Reclaim Policies

| Policy | When PVC Deleted | PV Status | Data |
|--------|------------------|-----------|------|
| Retain | PV keeps data | Released | ✅ Kept (manual cleanup needed) |
| Delete | PV deleted | Deleted | ❌ Lost |
| Recycle | Data scrubbed | Available | ❌ Lost (deprecated) |

## 💡 Real-World Learnings

### When to Use What:

**emptyDir:**
- ✅ Temporary cache
- ✅ Sharing between containers in pod
- ✅ Scratch space
- ❌ NOT for persistent data

**hostPath:**
- ✅ Development/testing only
- ✅ Accessing node logs/config
- ❌ NOT for production
- ❌ NOT portable (tied to specific node)

**PersistentVolume:**
- ✅ Databases (MySQL, PostgreSQL, MongoDB)
- ✅ User-uploaded files
- ✅ Any data that must survive pod deletion
- ✅ Production stateful applications

### Multi-Container Patterns Learned:

**Sidecar Pattern:**
```
Main container + Helper container
Both share volume

Examples:
- Web server + Log shipper
- App + Monitoring agent
- Service + Config reloader
```

**What I tested:**
- debian writes timestamps → nginx serves them
- Both containers see changes in real-time
- Perfect for microservices communication

## 🎓 Challenges Solved

**Challenge 1: hostPath CrashLoopBackOff**
- **Issue:** Pod keeps restarting
- **Cause:** Command exits immediately, Kubernetes thinks it crashed
- **Learning:** This demonstrated data persistence across restarts
- **Each restart added new entry** to output.txt
- **Proved:** hostPath survives pod recreation

**Challenge 2: emptyDir File Creation**
- **Issue:** `echo "text >> file.txt"` didn't create file
- **Cause:** `>>` was inside quotes
- **Fix:** `echo "text" >> file.txt` (redirect outside quotes)

**Challenge 3: PVC Storage Unit**
- **Issue:** `storage: 100mi` invalid
- **Cause:** Wrong case (lowercase mi)
- **Fix:** `storage: 100Mi` (Capital M, capital i)

**Challenge 4: PVC Stuck in Pending**
- **Issue:** PVC status stayed Pending
- **Cause:** `volumeBindingMode: WaitForFirstConsumer`
- **Fix:** Created Pod → Binding happened immediately
- **Learning:** This is intentional behavior for delayed binding

## 📖 Storage Architecture Learned

```
StorageClass
    ↓ (defines behavior)
PersistentVolume (admin creates)
    ↓ (binds to)
PersistentVolumeClaim (user requests)
    ↓ (used by)
Pod
```

### Real Flow:

```
1. Admin: Creates StorageClass → Defines storage type
2. Admin: Creates PV → Actual storage (1Gi at /var/tmp)
3. User: Creates PVC → Requests storage (200Mi minimum)
4. Kubernetes: Waits for pod (WaitForFirstConsumer)
5. User: Creates Pod → Uses PVC
6. Kubernetes: Binds PVC to PV → Both Bound
7. Pod: Writes to /output → Actually stored at /var/tmp
8. Pod deleted → PVC still bound, data safe
9. PVC deleted → PV Available (Recycle cleaned data)
```

## 📊 What I Tested

**Persistence Tests:**
- ✅ hostPath survives pod deletion
- ✅ emptyDir survives container restart
- ❌ emptyDir lost on pod deletion
- ✅ PV data survives pod deletion

**Volume Sharing:**
- ✅ Two containers sharing emptyDir
- ✅ Real-time data synchronization
- ✅ Bidirectional read/write

**PV/PVC Lifecycle:**
- ✅ Storage binding process
- ✅ WaitForFirstConsumer behavior
- ✅ Capacity matching (200Mi request got 1Gi)
- ✅ Reclaim policy in action

## 🎯 Practical Skills Gained

- Created various volume types (hostPath, emptyDir, PVC)
- Tested data persistence across pod lifecycles
- Implemented multi-container volume sharing pattern
- Configured StorageClass with custom binding mode
- Created and managed PV/PVC resources
- Understood storage capacity matching
- Experienced reclaim policy behavior

**Module completed!** Understand Kubernetes storage from ephemeral to persistent! 🎉