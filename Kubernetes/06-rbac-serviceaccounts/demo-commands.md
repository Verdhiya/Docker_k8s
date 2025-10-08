# ServiceAccount Demo Commands

## Setup
```bash
kubectl create namespace sa-demo
kubectl create serviceaccount app-reader -n sa-demo
kubectl apply -f serviceaccount-role.yaml
kubectl apply -f serviceaccount-rolebinding.yaml
kubectl apply -f pod-with-serviceaccount.yaml
kubectl apply -f pod-default-sa.yaml

```
## Test Default SA (No Permissions)

```bash
kubectl exec -n sa-demo default-sa-pod -- kubectl get pods -n sa-demo
```
**Error: Forbidden ✅**

## Test Custom SA (Has Permissions)
```bash
kubectl exec -n sa-demo app-reader-pod -- kubectl get pods -n sa-demo
```
**Success: Lists pods ✅**

## Verification
```bash
kubectl get serviceaccounts -n sa-demo
kubectl get roles -n sa-demo
kubectl get rolebindings -n sa-demo
kubectl auth can-i list pods --as=system:serviceaccount:sa-demo:app-reader -n sa-demo
```

