# Kubernetes Hands-On Learning

#### ***Complete Kubernetes learning journey with practical implementations.***
---

## Learning Journey Overview

### Project Sequence

**1:** Minikube Setup (Single-node learning environment)  
**2:** 3-Node Cluster Installation (Production-like setup)  
**3:** Node Draining (Maintenance procedures)  
**4:** Cluster Upgrade (v1.31.13 → v1.34.1)  
**5:** RBAC User Authentication (Certificate-based auth)  
**6:** RBAC ServiceAccounts (Pod-level permissions)  
**7:** Application Configuration (ConfigMaps and Secrets)  
**8:** Container Resources (CPU, Memory, QoS classes)  
**9:** Health Probes (Liveness, Readiness, Startup)  
**10:** Restart Policies (Always, OnFailure, Never)  
**11:** Multi-Container Pods (Shared volumes, Init containers)  
**12:** Scheduling (nodeSelector, nodeName, Taints)  
**13:** DaemonSets (One pod per node)  
**14:** Static Pods (kubelet-managed pods)  
**15:** Node Affinity (Advanced scheduling rules)  
**16:** Deployments (Scaling, Rolling updates, Rollback)  
**17:** Kubernetes Networking (Pod DNS, Communication)  
**18:** Network Policies (Pod-level firewall rules)  

### Technologies Used

- **Kubernetes:** v1.31.13 - v1.34.1
- **Tools:** kubeadm, kubectl, Minikube v1.37.0
- **Container Runtime:** containerd
- **CNI Plugin:** Calico v3.28.0
- **Platform:** AWS EC2 (t2.medium), Minikube (t2.medium)
- **OS:** Ubuntu 24.04

### Skills Acquired

**Cluster Management:**
✅ Single-node and multi-node cluster setup  
✅ Multi-version upgrades (3 phases)  
✅ Node operations and maintenance  
✅ Zero-downtime procedures  
✅ Automated cluster startup (systemd)  
✅ Stop/start persistence (15+ days tested)  

**Security & Access Control:**
✅ RBAC security implementation  
✅ Certificate-based authentication  
✅ ServiceAccount permissions  
✅ Secret management  
✅ HTTP basic authentication (htpasswd)  
✅ Network Policies (pod-level firewall)  
✅ Namespace isolation  

**Application Management:**
✅ ConfigMaps for configuration  
✅ Secrets for sensitive data  
✅ Environment variables and volume mounts  
✅ Resource requests and limits  
✅ QoS classes (BestEffort, Burstable, Guaranteed)  
✅ Health probes and self-healing  
✅ Multi-container pod patterns  
✅ Init containers for dependencies  

**Scheduling & Placement:**
✅ nodeSelector (label-based)  
✅ nodeName (direct assignment)  
✅ Node Affinity (In, NotIn, Exists operators)  
✅ Required vs Preferred affinity  
✅ Taints and tolerations  
✅ DaemonSets (automatic distribution)  
✅ Static Pods (kubelet-managed)  

**Application Scaling:**
✅ ReplicationController (legacy)  
✅ ReplicaSet (modern, label adoption!)  
✅ Deployments (production-standard)  
✅ Rolling updates (zero-downtime)  
✅ Rollback capability  
✅ Pause/Resume (batched updates)  
✅ Manual and declarative scaling  

**Networking:**
✅ Pod-to-pod communication  
✅ Services (ClusterIP, NodePort, LoadBalancer)  
✅ DNS resolution (CoreDNS)  
✅ Pod DNS format  
✅ Network Policies (ingress/egress)  
✅ CNI plugins (Calico)  

**Troubleshooting:**
✅ Debugging CrashLoopBackOff  
✅ Fixing OOMKilled containers  
✅ Configuration error resolution  
✅ Pod scheduling issues  
✅ Force deleting stuck pods  
✅ Network policy testing  
✅ Disk space management  

### Key Achievements

**Cluster Operations:**
- Installed 3-node production-grade cluster from scratch
- Performed 3-phase upgrade across major versions (v1.31 → v1.32 → v1.33 → v1.34)
- Managed node maintenance with zero downtime
- Configured automated cluster startup and data persistence
- Proved stop/start persistence (15+ days, multiple restarts)

**Application Deployment:**
- Built nginx web server with htpasswd authentication
- Configured applications using ConfigMaps and Secrets
- Implemented resource management (CPU/Memory)
- Set up self-healing with health probes
- Deployed multi-container applications
- Executed zero-downtime rolling updates
- Managed 7 deployment revisions with rollback

**Security Implementation:**
- Implemented enterprise RBAC for users and applications
- Created certificate-based authentication
- Configured ServiceAccounts with proper permissions
- Secured nginx with encrypted passwords
- Applied Network Policies for pod isolation
- Namespace-level security controls

**Advanced Scheduling:**
- Mastered nodeSelector and nodeName
- Implemented Node Affinity (6 operator types)
- Created DaemonSets for cluster-wide services
- Deployed static pods on worker nodes
- Managed taints and tolerations
- Achieved precise pod placement across 3-node cluster

**Scaling & Updates:**
- Witnessed ReplicaSet label adoption (bare pods became managed!)
- Performed rolling updates with zero downtime
- Rolled back failed deployments instantly
- Used pause/resume for efficient batched updates
- Scaled applications from 3 to 10 replicas and back
- Managed multiple ReplicaSets per Deployment

**Debugging & Problem Solving:**
- Fixed nginx CrashLoopBackOff (missing semicolons)
- Debugged OOMKilled containers (memory limit exceeded)
- Resolved volume mounting issues (subPath technique)
- Fixed pod Pending issues (resource constraints)
- Understood Exit Codes (0, 1, 127, 137, 143)
- Tested Network Policy enforcement
- Cleaned disk from 98% to 57% usage
- Force-deleted terminating pods

### Repository Contents

- **92 files** across 20 directories
- **31 YAML configuration files** from hands-on practice
- **18 README documentation files** explaining each project
- **18 command reference files** for quick lookup
- **6 shell scripts** for automation
- **3 markdown guides** for procedures

---

## Project Details

**Projects 1-4:** Infrastructure & Operations (Cluster setup and management)  
**Projects 5-6:** Security & Access Control (RBAC and authentication)  
**Projects 7-9:** Configuration & Health (ConfigMaps, Resources, Probes)  
**Projects 10-12:** Policies & Scheduling (Restart policies, Scheduling rules)  
**Projects 13-15:** Advanced Placement (DaemonSets, Static pods, Affinity)  
**Projects 16-18:** Scaling & Networking (Deployments, Networking, Policies)  

Each project includes:
- Numbered YAML/script files (practice order)
- README.md (exercises, learnings, observations)
- commands-reference.md (all commands used)

---

## Hands-On Statistics

- **Projects Completed:** 18
- **YAML Files Created:** 92
- **Clusters Deployed:** 2 (1 single-node Minikube + 1 three-node AWS)
- **Cluster Uptime:** 15+ days with multiple restarts
- **Upgrade Phases:** 3 (across 3 major K8s versions)
- **Deployment Revisions:** 7 (with rollbacks tested)
- **Debugging Sessions:** Multiple (CrashLoopBackOff, OOMKilled, Pending, Network policies)
- **Working Demos:** nginx auth, resource limits, rolling updates, Network Policies

---

*All configurations tested and verified working.*  
*Demonstrates production-ready Kubernetes skills*

**Last Updated:** November 4, 2025  
**Total Learning Duration:** 21+ days of hands-on practice
