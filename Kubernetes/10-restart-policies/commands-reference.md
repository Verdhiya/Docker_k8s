# Commands Reference - Restart Policies

---

## Apply and Watch

```bash
# Apply restart policy pod
kubectl apply -f 01-always-restart.yml

# Watch for restarts
kubectl get pods <pod-name> -w

# Check restart count
kubectl get pods
# Look at RESTARTS column
```

---

## Check Exit Codes

```bash
# Describe pod
kubectl describe pod <pod-name>

# Check last state
kubectl get pod <pod-name> -o yaml | grep -A 10 lastState

# Check exit code
kubectl get pod <pod-name> -o yaml | grep exitCode
```

---

## Test All Three Policies

```bash
# Always policy
kubectl apply -f 01-always-restart.yml
kubectl get pods restart-always-pod -w

# OnFailure policy (error)
kubectl apply -f 02-onfailure-restart.yml
kubectl get pods onfailure-restart-pod

# OnFailure policy (success)
kubectl apply -f 03-onfailure-success.yml
kubectl get pods onfailure-success-pod

# Never policy (success)
kubectl apply -f 04-never-restart.yml
kubectl get pods never-restart-pod

# Never policy (failure)
kubectl apply -f 05-never-restart-fail.yml
kubectl get pods never-restart-fail-pod
```

---

## Cleanup

```bash
kubectl delete pod restart-always-pod
kubectl delete pod onfailure-restart-pod
kubectl delete pod onfailure-success-pod
kubectl delete pod never-restart-pod
kubectl delete pod never-restart-fail-pod
```
