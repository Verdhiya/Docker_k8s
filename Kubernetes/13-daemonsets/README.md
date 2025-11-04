# Project 13: DaemonSets

Hands-on practice with DaemonSets (one pod per node).

## Files

- 01-daemonset-basic.yml
- 02-daemonset-all-nodes.yml
- 03-daemonset-ssd-only.yml

**Platform:** AWS 3-node cluster

---

## What I Learned

**DaemonSet:** Ensures one copy of a pod runs on every node (or selected nodes)

**Use Cases:** Node-level services (monitoring, logging, networking)

---

## Exercise 1: Basic DaemonSet

**File:** 01-daemonset-basic.yml

**What I did:**
```bash
kubectl apply -f 01-daemonset-basic.yml
kubectl get daemonsets logging
kubectl get pods -l app=httpd-logging -o wide
```

**What I observed:**
```
DESIRED: 2
CURRENT: 2
READY: 2

Pods created:
- logging-twv5z → k8s-worker-1 ✅
- logging-vmjw6 → k8s-worker-2 ✅
- (no pod on k8s-master)

Why only 2 pods (not 3)?
Master has taint: control-plane:NoSchedule
DaemonSet has no toleration for this taint
Result: No pod on master ✅
```

**Self-healing test:**
```bash
kubectl delete pod logging-twv5z
kubectl get pods -l app=httpd-logging
# New pod created: logging-7vhg5 ✅
# DaemonSet recreated it within seconds!
```

**Key Learning:**
- DaemonSet auto-creates 1 pod per node
- Respects taints (no master pod by default)
- Self-healing (delete pod → recreates)

---

## Exercise 2: DaemonSet on ALL Nodes (Including Master)

**File:** 02-daemonset-all-nodes.yml

**What I did:**
```bash
kubectl apply -f 02-daemonset-all-nodes.yml
kubectl get pods -l app=monitor -o wide
```

**What I observed:**
```
DESIRED: 3
CURRENT: 3

Pods created:
- monitor-all-nodes-skkzq → k8s-master ✅
- monitor-all-nodes-fhxmt → k8s-worker-1 ✅
- monitor-all-nodes-29k98 → k8s-worker-2 ✅

All 3 nodes! Including master!

Why master included?
Toleration added:
  - key: node-role.kubernetes.io/control-plane
    operator: Exists
    effect: NoSchedule

This allows scheduling on master! ✅
```

**Key Learning:**
- Tolerations allow DaemonSet to run on tainted nodes
- Perfect for cluster-wide monitoring
- One pod per node guaranteed

---

## Exercise 3: DaemonSet with nodeSelector

**File:** 03-daemonset-ssd-only.yml

**What I did:**
```bash
# worker-2 already had disktype=ssd label
kubectl apply -f 03-daemonset-ssd-only.yml
kubectl get pods -l app=ssd-logger -o wide
```

**What I observed:**
```
DESIRED: 1
CURRENT: 1

Pods created:
- ssd-logger-4lnkj → k8s-worker-2 ✅

Only on worker-2 (has disktype=ssd label)
Not on master or worker-1 (no label)
```

**Tested adding label:**
```bash
kubectl label nodes k8s-worker-1 disktype=ssd
kubectl get pods -l app=ssd-logger -o wide
# DaemonSet automatically created pod on worker-1! ✅
# DESIRED: 2, CURRENT: 2
```

**Key Learning:**
- DaemonSet respects nodeSelector
- Only runs on matching nodes
- Automatically creates pod when node matches

---

## Summary

**DaemonSet Characteristics:**
- One pod per node automatically
- No manual replica management
- Scales with cluster (node added → pod created)
- Self-healing (pod deleted → recreated)
- Respects nodeSelector and taints

**Use Cases:**
- Monitoring agents (Prometheus Node Exporter)
- Log collectors (Fluentd, Filebeat)
- Network plugins (Calico-node, kube-proxy)
- Storage daemons
- Security agents

**vs Deployment:**
- Deployment: N replicas (scheduler distributes)
- DaemonSet: 1 per node (automatic distribution)

**Tolerations:**
- Allow scheduling on tainted nodes
- Required for running on master
- Kubernetes auto-adds standard tolerations

**Real-World:** Calico-node and kube-proxy are DaemonSets!
