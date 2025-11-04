# 4: Kubernetes Cluster Upgrade

**Challenge:** Upgrade 3-node cluster from v1.31.13 to v1.34.1

**Constraint:** Cannot skip minor versions - must upgrade incrementally

**Path:** v1.31.13 → v1.32.9 → v1.33.5 → v1.34.1

**Duration:** ~2.5 hours  
**Downtime:** 0 seconds (rolling upgrade)  
**Result:** ✅ All nodes successfully upgraded

## Key Learnings

- Must upgrade one minor version at a time
- Always upgrade master before workers
- Use `kubeadm upgrade apply` on master
- Use `kubeadm upgrade node` on workers
- Drain nodes before upgrading kubelet
- Verify health after each phase
