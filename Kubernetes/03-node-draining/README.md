# 3: Kubernetes Node Draining

Learned safe node maintenance procedures using drain/cordon/uncordon.

## Concepts Covered

- **Drain:** Safely evict all pods from a node
- **Cordon:** Mark node as unschedulable
- **Uncordon:** Allow scheduling on node again
- **DaemonSets:** Must use --ignore-daemonsets flag

## Key Learning

Standalone pods vs Deployment-managed pods behave differently when drained:
- Standalone pods: Deleted permanently
- Deployment pods: Recreated on other nodes (zero downtime)
