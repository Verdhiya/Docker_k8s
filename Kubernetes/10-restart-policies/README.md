# Project 10: Container Restart Policies

****Hands-on practice with Kubernetes container restart policies.****

## Files

- 01-always-restart.yml
- 02-onfailure-restart.yml
- 03-onfailure-success.yml
- 04-never-restart.yml
- 05-never-restart-fail.yml

---

## What I Learned

**Restart Policies** control when Kubernetes restarts containers after they exit.

### Three Policies:

- **Always:** Restarts on any exit (success or failure)
- **OnFailure:** Restarts only on errors (Exit Code ≠ 0)
- **Never:** Never restarts regardless of exit code

---

## Exercises

### Exercise 1: Always Restart Policy

**File:** 01-always-restart.yml

**What I did:**
```bash
kubectl apply -f 01-always-restart.yml
kubectl get pods restart-always-pod -w
```

**What I observed:**
- Container: `sleep 20` (exits successfully after 20 seconds)
- Exit Code: 0 (success)
- Behavior: Restarted anyway!
- RESTARTS: 1, 2, 3, 4... (kept increasing)
- STATUS: Running → Completed → Running (loop)
- CrashLoopBackOff appeared (backoff delay between restarts)

****Key Learning: Always means ALWAYS - even on successful completion!****

---

### Exercise 2: OnFailure with Error

**File:** 02-onfailure-restart.yml

**What I did:**
```bash
kubectl apply -f 02-onfailure-restart.yml
kubectl describe pod onfailure-restart-pod
```

**What I observed:**
- Container: `sleep 20; who; pinky`
- Commands: `who` and `pinky` don't exist in alpine
- Exit Code: 127 (command not found)
- Behavior: Kept restarting (error detected!)
- RESTARTS: 1, 2, 3...
- STATUS: Running → Error → CrashLoopBackOff

****Key Learning: OnFailure restarts when Exit Code ≠ 0****

---

### Exercise 3: OnFailure with Success

**File:** 03-onfailure-success.yml

**What I did:**
```bash
kubectl apply -f 03-onfailure-success.yml
kubectl get pods onfailure-success-pod
```

**What I observed:**
- Container: `echo "Task completed!"; sleep 5; exit 0`
- Exit Code: 0 (success)
- Behavior: Did NOT restart ✅
- RESTARTS: 0
- STATUS: Completed (stayed Completed!)

****Key Learning: OnFailure stops on successful completion (perfect for batch jobs!)****

---

### Exercise 4: Never Restart (Success)

**File:** 04-never-restart.yml

**What I did:**
```bash
kubectl apply -f 04-never-restart.yml
kubectl get pods never-restart-pod
```

**What I observed:**
- Container: `echo "Running once"; sleep 10; exit 0`
- Exit Code: 0 (success)
- Behavior: Did NOT restart
- RESTARTS: 0
- STATUS: Completed

---

### Exercise 5: Never Restart (Failure)

**File:** 05-never-restart-fail.yml

**What I did:**
```bash
kubectl apply -f 05-never-restart-fail.yml
kubectl get pods never-restart-fail-pod
```

**What I observed:**
- Container: `echo "This will fail"; exit 1`
- Exit Code: 1 (failure)
- Behavior: Did NOT restart (even though failed!)
- RESTARTS: 0
- STATUS: Error (stayed Error)

******Key Learning:** Never means never - even on failure!****

---

## Summary

**Always:**
- Restarts on Exit 0 ✅
- Restarts on Exit ≠ 0 ✅
- Use for: Long-running services

**OnFailure:**
- Restarts on Exit ≠ 0 ✅
- Stops on Exit 0 ✅
- Use for: Batch jobs, tasks

**Never:**
- Never restarts ❌
- Use for: Debugging, one-time tasks

**CrashLoopBackOff:** Backoff delay when container keeps crashing/exiting

**Exit Codes:**
- 0 = Success
- 1 = General error
- 127 = Command not found
- 137 = Killed by Kubernetes
