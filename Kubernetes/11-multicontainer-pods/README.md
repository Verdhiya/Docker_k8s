# Project 11: Multi-Container Pods

Hands-on practice with multi-container pods and init containers.

## Files

- 01-multi-containers.yml
- 02-init-container.yml
- 03-init-container-dependency.yml

---

## What I Learned

**Multi-Container Pod:** Multiple containers in same pod sharing network and volumes

**Init Container:** Special containers that run BEFORE main containers (for setup/preparation)

---

## Exercise 1: Multi-Container with Shared Volume

**File:** 01-multi-containers.yml

**What I did:**
```bash
kubectl apply -f 01-multi-containers.yml
kubectl get pods two-containers -o wide
```

**Pod structure:**
- Container 1 (debian): Writes to `/pod-data/index.html`
- Container 2 (nginx): Serves from `/usr/share/nginx/html`
- Shared volume: emptyDir (both mount same volume)

**What I observed:**
```
READY: 1/2
- debian-container: Completed (Exit 0, wrote file and exited)
- nginx-container: Running (serving content)

debian wrote: "Hello from the Secondary container"
nginx served: Same content! ✅
```

**Testing:**
```bash
curl <pod-ip>
# Output: "Hello from the Secondary container"
```

**Key Learning:**
- Containers share volumes (same files accessible)
- One container can write, another can read
- Different lifecycles (one completes, one runs)
- Perfect sidecar pattern!

---

## Exercise 2: Init Containers (Wait-for-Dependencies)

**File:** 02-init-container.yml

**What I did:**
```bash
kubectl apply -f 02-init-container.yml
kubectl get pods application-pod
```

**Pod structure:**
- Init Container 1: Waits for `myservice` DNS
- Init Container 2: Waits for `mydb` DNS
- Main Container: Runs only after both init complete

**What I observed:**
```
Initial STATUS: Init:0/2
- init-myservice running
- Checking: nslookup myservice.default.svc.cluster.local
- Services don't exist yet
- Pod stuck waiting...

After ~5 minutes: Still Init:0/2
- Init container keeps checking every 5 seconds
- Main container: Waiting (PodInitializing)
```

**Created services:**
```bash
kubectl apply -f 03-init-container-dependency.yml
```

**What happened:**
```
Services created (myservice, mydb)
→ init-myservice: nslookup succeeds! (Exit 0)
→ STATUS: Init:1/2

→ init-mydb starts
→ nslookup mydb succeeds immediately! (Exit 0)
→ STATUS: Init:2/2 → Running

→ Main container started! ✅
```

**Timeline:**
- Init 1 ran: ~5 minutes (waiting for service)
- Init 2 ran: <1 second (service already existed)
- Both completed: Exit Code 0
- Main container: Started only after both init done

**Key Learning:**
- Init containers run SEQUENTIALLY (one after another)
- Main container WAITS until all init complete
- Perfect for wait-for-dependency pattern
- Production-ready initialization!

---

## Summary

**Multi-Container Pods:**
- Share network namespace (same IP, localhost)
- Share volumes (emptyDir, ConfigMaps, Secrets)
- Different lifecycle states (one completed, one running)
- Perfect for sidecar pattern

**Init Containers:**
- Run BEFORE main containers
- Sequential execution (init-1 → init-2 → main)
- Must complete successfully (Exit 0)
- Used for setup, dependencies, preparation
- Main container blocked until init done (PodInitializing)

**Real-World Use:**
- Helper containers (logging, monitoring)
- Wait for services to be ready
- Download configuration
- Database migrations
- Permission setup
