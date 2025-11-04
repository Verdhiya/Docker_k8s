# Project 16: Kubernetes Deployments

Hands-on practice with ReplicationController, ReplicaSet, and Deployments.

## Files

- 01-replication-controller.yml
- 02-replica-set.yml
- 03-bare-pods.yml
- 04-deployment.yml

**Platform:** Minikube single-node

---

## What I Learned

**Evolution:** ReplicationController → ReplicaSet → Deployment (modern)

**Deployment:** Production-standard for stateless applications with rolling updates and rollback

---

## Exercise 1: ReplicationController (Legacy)

**File:** 01-replication-controller.yml

**What I did:**
```bash
kubectl apply -f 01-replication-controller.yml
kubectl get rc alipne-box-replication-controller
```

**What I observed:**
```
DESIRED: 3
CURRENT: 3
READY: 3

Pods created with random suffixes:
- alipne-box-replication-controller-7k8wl
- alipne-box-replication-controller-gsjc5
- alipne-box-replication-controller-xn48r
```

**Self-healing test:**
```bash
kubectl delete pod alipne-box-replication-controller-xn48r
kubectl get pods
# New pod created: alipne-box-replication-controller-zpg2q ✅
```

**Scaling:**
```bash
kubectl scale rc alipne-box-replication-controller --replicas=6
# DESIRED: 6, 3 new pods created instantly!

kubectl scale rc alipne-box-replication-controller --replicas=2
# 4 pods terminated, 2 remained
```

**Key Learning:** ReplicationController maintains desired count but lacks advanced features

---

## Exercise 2: ReplicaSet (Modern Replacement)

**File:** 02-replica-set.yml

**What I did:**
```bash
kubectl apply -f 02-replica-set.yml
kubectl get rs myapp-replicas
```

**Advanced selector:**
```yaml
selector:
  matchExpressions:
    - {key: tier, operator: In, values: [frontend]}
```

**What I observed:**
```
DESIRED: 3
CURRENT: 3

More flexible selector than ReplicationController! ✅
```

**Scaling:**
```bash
kubectl scale rs myapp-replicas --replicas=10
# Scaled to 10 instantly!

kubectl scale rs myapp-replicas --replicas=2
# Scaled down to 2
```

---

## Exercise 3: Bare Pods + Label Adoption

**File:** 03-bare-pods.yml

**What I created:**
- mypod1 (label: tier=frontend)
- mypod2 (label: tier=frontend)

**Then applied ReplicaSet:**
```bash
kubectl apply -f 02-replica-set.yml
```

**AMAZING Discovery:**
```
ReplicaSet selector: tier in (frontend)
Bare pods: mypod1, mypod2 (tier=frontend)

ReplicaSet: "I need 3 pods with tier=frontend"
ReplicaSet: "Found 2 existing (mypod1, mypod2)!"
ReplicaSet: "Creating only 1 more!" (myapp-replicas-2ltqm)

DESIRED: 3
CURRENT: 3 (2 adopted + 1 created!)

mypod1 and mypod2 ADOPTED by ReplicaSet! ✅
Controlled By: Changed from <none> to ReplicaSet/myapp-replicas
```

**Deleted mypod2:**
```bash
kubectl delete pod mypod2
# ReplicaSet recreated it with new name: myapp-replicas-fr4g8 ✅
```

**Key Learning:**
- ReplicaSets adopt existing pods with matching labels!
- Label-based management
- Zero-downtime migration from bare pods
- Production-ready pattern!

---

## Exercise 4: Deployment (Complete Application Management)

**File:** 04-deployment.yml

**Multi-container deployment:**
- chef-server container
- ubuntu container
- 2 containers per pod!

**What I did:**
```bash
kubectl apply -f 04-deployment.yml
kubectl get deployment chef-server
kubectl rollout status deployment chef-server
```

**What I observed:**
```
READY: 3/3
UP-TO-DATE: 3
AVAILABLE: 3

Deployment created ReplicaSet: chef-server-5ffff644c
ReplicaSet created 3 pods (6 containers total!)

StrategyType: RollingUpdate
RollingUpdateStrategy: 25% max unavailable, 25% max surge
```

---

## Rolling Updates (Live!)

**Updated image:**
```bash
kubectl set image deployment chef-server chef-server=chef/chefworkstation:25.8.1091
kubectl rollout status deployment chef-server -w
```

**What I watched in real-time:**
```
Old RS (5ffff644c): 3 pods
New RS (6654cfdffc): 0 pods

Rolling update:
1. Create 1 new pod (v2)
2. Wait for Running (2/2)
3. Delete 1 old pod (v1)
4. Create another new pod
5. Repeat until all v2

Old: 3 → 2 → 1 → 0
New: 0 → 1 → 2 → 3 ✅

Zero downtime! Always had running pods!
```

**Second update:**
```bash
kubectl set image deployment chef-server chef-server=chef/chefworkstation:25.9.1093
```

**Result:**
- New ReplicaSet: chef-server-7d69c94b8d
- Another rolling update
- Graceful replacement

**THIRD update failed (bad image):**
- Image didn't exist
- Update stuck (ImagePullBackOff)
- Old version KEPT RUNNING! ✅
- Service protected by Deployment!

---

## Rollback

**Checked history:**
```bash
kubectl rollout history deployment chef-server

REVISION 1: 25.7.1089 (original)
REVISION 2: 25.8.1091 (first update)
REVISION 3: 25.9.1093 (second update)
```

**Rolled back:**
```bash
kubectl rollout undo deployment chef-server
# Instant rollback to revision 2! ✅
```

**Rollback to specific revision:**
```bash
kubectl rollout undo deployment chef-server --to-revision=1
# Back to original version! ✅

New REVISION 5 created (rollback creates new revision)
```

---

## Advanced: Pause/Resume (Batched Updates)

**Paused deployment:**
```bash
kubectl rollout pause deployment chef-server
```

**Made multiple changes while paused:**
```bash
kubectl set image deployment chef-server chef-server=latest
kubectl set image deployment chef-server ubuntu=ubuntu:latest
kubectl set resources deployment chef-server -c=chef-server --limits=memory=250Mi
```

**Status:** All changes queued, NOT applied yet! 🛑

**Resumed:**
```bash
kubectl rollout resume deployment chef-server
```

**Result:**
- ALL 3 changes applied in ONE rolling update! ✅
- More efficient than 3 separate updates
- Production best practice!

---

## Manual Edit

**Edited directly:**
```bash
kubectl edit deployment chef-server
```

**Changed:**
- Images to different versions
- Container configurations

**Result:**
- New ReplicaSet created
- Rolling update triggered
- New revision in history

---

## Summary

**ReplicationController:**
- Self-healing, scaling
- Old (deprecated)
- No rolling updates

**ReplicaSet:**
- Modern RC replacement
- Advanced selectors (matchExpressions)
- Label adoption behavior!
- Still no rolling updates (use Deployment)

**Deployment:**
- Manages ReplicaSets
- Rolling updates (zero-downtime)
- Rollback capability
- Revision history
- Pause/Resume (batch changes)
- kubectl edit support
- Production-standard

**Scaling:**
- Horizontal: Add more replicas (what we practiced)
- Easy: kubectl scale

**Key Skill:** Deployment = Complete application lifecycle management
