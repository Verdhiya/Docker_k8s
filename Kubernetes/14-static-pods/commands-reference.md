# Commands Reference - Static Pods

## Create Static Pod

```bash
# SSH to desired node
ssh <node-name>

# Create YAML in manifests directory
sudo vim /etc/kubernetes/manifests/my-static-pod.yml

# Restart kubelet (optional, speeds detection)
sudo systemctl restart kubelet

# Exit to master
exit

# Verify pod appears
kubectl get pods
# Should see: my-static-pod-<node-name>
```

## Identify Static Pods

```bash
# Check if pod is static
kubectl describe pod <pod-name> | grep "Controlled By"
# Static: Controlled By: Node/<node-name>
# Normal: Controlled By: ReplicaSet/...

# Check config source
kubectl get pod <pod-name> -o yaml | grep config.source
# Static: config.source: file
# Normal: config.source: api

# List all static pods (on master)
ls /etc/kubernetes/manifests/
```

## Delete Static Pod

```bash
# kubectl delete doesn't work permanently!
kubectl delete pod <static-pod-name>
# Pod respawns!

# Proper way: Delete file on node
ssh <node-name>
sudo rm /etc/kubernetes/manifests/<pod-file>.yml
sudo systemctl restart kubelet
exit

# Verify removed
kubectl get pods
```

## View Control Plane Static Pods

```bash
# On master node
ls -la /etc/kubernetes/manifests/

# See their mirror pods
kubectl get pods -n kube-system | grep $(hostname)
```
