# Commands Reference - Multi-Container Pods

---

## Multi-Container Pods

```bash
# Apply multi-container pod
kubectl apply -f 01-multi-containers.yml

# Check container readiness
kubectl get pods two-containers
# READY: 1/2 (one container completed, one running)

# Test shared volume
POD_IP=$(kubectl get pod two-containers -o jsonpath='{.status.podIP}')
curl $POD_IP

# Check container states
kubectl describe pod two-containers
```

---

## Init Containers

```bash
# Apply pod with init containers
kubectl apply -f 02-init-container.yml

# Watch init container progress
kubectl get pods application-pod
# STATUS: Init:0/2 (0 of 2 init containers done)

# Describe to see init container status
kubectl describe pod application-pod

# Create required services
kubectl apply -f 03-init-container-dependency.yml

# Watch pod become ready
kubectl get pods application-pod -w
# Init:0/2 → Init:1/2 → Init:2/2 → Running
```

---

## Check Init Container Logs

```bash
# View init container logs
kubectl logs <pod-name> -c <init-container-name>

# Example:
kubectl logs application-pod -c init-myservice
kubectl logs application-pod -c init-mydb
```

---

## Cleanup

```bash
kubectl delete pod two-containers
kubectl delete pod application-pod
kubectl delete svc myservice mydb
```
