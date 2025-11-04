# Commands Reference - Deployments

## ReplicationController

```bash
kubectl apply -f 01-replication-controller.yml
kubectl get rc
kubectl scale rc <name> --replicas=<number>
kubectl delete rc <name>
```

## ReplicaSet

```bash
kubectl apply -f 02-replica-set.yml
kubectl get rs
kubectl scale rs <name> --replicas=<number>
kubectl describe rs <name>
kubectl delete rs <name>
```

## Deployment

```bash
# Create
kubectl apply -f 04-deployment.yml

# View
kubectl get deployments
kubectl describe deployment <name>

# Scale
kubectl scale deployment <name> --replicas=<number>
```

## Rolling Updates

```bash
# Update image
kubectl set image deployment/<name> <container>=<image:tag>

# Watch rollout
kubectl rollout status deployment/<name>
kubectl rollout status deployment/<name> -w

# Check history
kubectl rollout history deployment/<name>
```

## Rollback

```bash
# Undo last update
kubectl rollout undo deployment/<name>

# Rollback to specific revision
kubectl rollout undo deployment/<name> --to-revision=<number>

# Check revision details
kubectl rollout history deployment/<name> --revision=<number>
```

## Pause/Resume

```bash
# Pause (queue changes)
kubectl rollout pause deployment/<name>

# Make multiple changes
kubectl set image deployment/<name> container1=image1:tag
kubectl set image deployment/<name> container2=image2:tag
kubectl set resources deployment/<name> -c=container1 --limits=memory=256Mi

# Resume (apply all at once)
kubectl rollout resume deployment/<name>
```

## Edit

```bash
# Edit deployment directly
kubectl edit deployment/<name>
```

## Cleanup

```bash
kubectl delete deployment <name>
```
