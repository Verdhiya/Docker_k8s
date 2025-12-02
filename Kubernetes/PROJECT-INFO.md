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
**19:** Kubernetes Services (ClusterIP, NodePort, DNS, Cross-namespace)  
**20:** Kubernetes Ingress (HTTP routing, Host-based routing, Ingress Controller)  
**21:** Kubernetes Storage (Volumes, PersistentVolumes, StorageClass)

### Technologies Used

- **Kubernetes:** v1.31.13 - v1.34.1
- **Tools:** kubeadm, kubectl, Minikube v1.37.0
- **Container Runtime:** containerd
- **CNI Plugin:** Calico v3.28.0
- **Ingress Controller:** Nginx Ingress Controller v1.13.2
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

**Networking & Services:**
✅ Pod-to-pod communication  
✅ Services (ClusterIP, NodePort, LoadBalancer)  
✅ DNS resolution (CoreDNS)  
✅ Service discovery and endpoints  
✅ Cross-namespace communication  
✅ Port mapping (port, targetPort, nodePort)  
✅ Network Policies (ingress/egress)  
✅ CNI plugins (Calico)  

**Ingress & HTTP Routing:**
✅ Nginx Ingress Controller installation  
✅ Host-based routing (multiple domains)  
✅ Ingress resource configuration  
✅ Single entry point for multiple services  
✅ HTTP request routing with Host headers  
✅ Local hosts file configuration  
✅ Node label troubleshooting  

**Storage & Persistence:**
✅ Container filesystem (ephemeral nature)  
✅ Volume types (emptyDir, hostPath, PVC)  
✅ Volume lifetime and persistence  
✅ Multi-container volume sharing  
✅ StorageClass configuration  
✅ PersistentVolume (PV) creation  
✅ PersistentVolumeClaim (PVC) workflow  
✅ Volume binding modes (WaitForFirstConsumer)  
✅ Reclaim policies (Retain, Delete, Recycle)  

**Troubleshooting:**
✅ Debugging CrashLoopBackOff  
✅ Fixing OOMKilled containers  
✅ Configuration error resolution  
✅ Pod scheduling issues  
✅ Node affinity problems  
✅ Force deleting stuck pods  
✅ Network policy testing  
✅ Disk space management  
✅ Ingress controller pod scheduling  
✅ Storage unit formatting errors  

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

**Networking & Service Discovery:**
- Created ClusterIP services for internal communication
- Exposed applications externally with NodePort
- Tested cross-namespace DNS resolution
- Understood service endpoints and label selectors
- Debugged service connectivity issues
- Mastered DNS naming (short, namespace-qualified, FQDN)

**Ingress & HTTP Routing:**
- Installed Nginx Ingress Controller
- Fixed ingress controller pods stuck in Pending (node label issue)
- Routed two applications through single IP address
- Implemented host-based routing with domain names
- Tested with curl using Host headers
- Configured browser access via local hosts file
- Achieved professional URLs without port numbers

**Storage & Persistence:**
- Tested hostPath volume persistence across pod deletion
- Proved emptyDir survives container restart but not pod deletion
- Implemented multi-container volume sharing (debian writes, nginx serves)
- Created complete PV/PVC architecture (StorageClass → PV → PVC → Pod)
- Tested WaitForFirstConsumer binding mode
- Observed Reclaim Policy behavior (PV lifecycle management)
- Understood storage capacity matching (PVC gets PV capacity)

**Debugging & Problem Solving:**
- Fixed nginx CrashLoopBackOff (missing semicolons)
- Debugged OOMKilled containers (memory limit exceeded)
- Resolved volume mounting issues (subPath technique)
- Fixed pod Pending issues (resource constraints)
- Solved ingress controller node affinity mismatch
- Fixed storage unit error (100mi → 100Mi)
- Understood Exit Codes (0, 1, 127, 137, 143)
- Used CrashLoopBackOff intentionally to demonstrate persistence
- Tested Network Policy enforcement
- Cleaned disk from 98% to 57% usage
- Force-deleted terminating pods

### Repository Contents

- **129 files** across 23 directories
- **50 YAML configuration files** from hands-on practice
- **21 README documentation files** explaining each project
- **21 command reference files** for quick lookup
- **6 shell scripts** for automation
- **4 markdown guides** for procedures

---

## Project Details

### Infrastructure & Operations (1-4)
**Projects 1-4:** Cluster setup, maintenance, and upgrades

### Security & Access Control (5-6)
**Projects 5-6:** RBAC, authentication, and permissions

### Configuration & Health (7-9)
**Projects 7-9:** ConfigMaps, Resources, and Health Probes

### Policies & Scheduling (10-12)
**Projects 10-12:** Restart policies and pod placement

### Advanced Placement (13-15)
**Projects 13-15:** DaemonSets, Static pods, and Affinity

### Scaling & Networking (16-18)
**Projects 16-18:** Deployments, Networking basics, and Policies

### Services & Ingress (19-20)
**Project 19:** Kubernetes Services - Service types, DNS, endpoints  
**Project 20:** Kubernetes Ingress - HTTP routing, ingress controller

### Storage & Persistence (21)
**Project 21:** Kubernetes Storage - Volumes, PV, PVC, persistence testing

Each project includes:
- Numbered YAML/script files (practice order)
- README.md (exercises, learnings, observations)
- commands-reference.md (all commands used)

---

## 19. Kubernetes Services 🌐

**Focus:** Service types, DNS resolution, and cross-namespace communication

Master Kubernetes networking fundamentals with services.

**What's Covered:**
- ClusterIP services for internal communication
- NodePort services for external access
- Service discovery using DNS
- Cross-namespace service access
- Port mapping (port, targetPort, nodePort)
- Label selectors and endpoints

**Files:**
```
19-k8s_services/
├── 01-nginx-deployment.yml              # Nginx with 3 replicas
├── 02-clusterip-service.yml             # Internal service
├── 03-test-pod.yml                      # Pod with curl for testing
├── 04-nodeport-service.yml              # External service
├── 05-cross-namespace-test-pod.yml      # Cross-namespace testing
├── README.md                            # What I learned
└── commands-reference.md                # Commands used
```

**Key Learnings:**
- Services provide stable IPs and DNS names for ephemeral pods
- ClusterIP is internal only, NodePort exposes externally
- DNS short names work only in same namespace
- Cross-namespace requires: `service-name.namespace` or full FQDN
- Endpoints show actual pod IPs service routes to

**Practical Skills:**
- Created ClusterIP service and tested from pod
- Created NodePort service and accessed externally
- Tested cross-namespace DNS resolution
- Understood service selector and label matching
- Debugged service connectivity issues

**Challenge:** Learned that short DNS names don't work across namespaces - need namespace-qualified names!

---

## 20. Kubernetes Ingress 🚪

**Focus:** HTTP routing with Ingress Controller and host-based routing

Route multiple applications through single entry point with domain names.

**What's Covered:**
- Installing Nginx Ingress Controller
- Creating Ingress resources with routing rules
- Host-based routing (different domains)
- Troubleshooting node affinity issues
- Testing with curl and browser
- Configuring local hosts file

**Files:**
```
20-ingress/
├── 01-nginx-deployment.yml              # Nginx official (app 1)
├── 02-nginx-deployment-service.yml      # Service for app 1
├── 03-magical-nginx-deployment.yml      # Magical nginx (app 2)
├── 04-magical-nginx-deployment-service.yml  # Service for app 2
├── 05-ingress-rules.yml                 # Host-based routing rules
├── README.md                            # Step-by-step guide
└── commands-reference.md                # Commands that worked
```

**Key Learnings:**
- Ingress Controller = Software (Nginx pod) that implements routing
- Ingress Resource = YAML rules that define routing
- Host header determines which service gets traffic
- One IP can serve multiple apps with different domains
- Node labels sometimes required for pod scheduling

**Practical Skills:**
- Installed Nginx Ingress Controller via minikube addon
- Fixed pods stuck in Pending by adding node label
- Created ingress with host-based routing rules
- Tested routing with curl using Host header
- Configured local hosts file for browser access
- Successfully accessed two apps via domain names

**Challenge Solved:** Ingress controller pods stuck in Pending due to missing node label `minikube.k8s.io/primary=true`. Added label and pods started immediately!

**Real Achievement:**
- **Before:** Two apps on different ports (31303, 31304)
- **After:** Two apps on standard port 80 with professional domain names
- **Result:** Single entry point routing to multiple services! 🎯

---

## 21. Kubernetes Storage & Volumes 💾

**Focus:** Container filesystem, volumes, and persistent storage

Master Kubernetes storage from ephemeral to persistent volumes.

**What's Covered:**
- Container filesystem (ephemeral nature)
- hostPath volumes (node filesystem)
- emptyDir volumes (pod lifetime)
- Multi-container volume sharing
- StorageClass configuration
- PersistentVolume (PV) architecture
- PersistentVolumeClaim (PVC) workflow
- Volume binding modes and reclaim policies

**Files:**
```
21-k8s-storage/
├── 01-hostpath-volume-mount.yml        # hostPath with persistence demo
├── 02-emptydir-volume-pod.yml          # Redis with emptyDir
├── 03-common-volume.yml                # Multi-container volume sharing
├── 04-storageclass-local-vol.yml       # StorageClass with WaitForFirstConsumer
├── 05-persistent-vol.yml               # PersistentVolume (1Gi)
├── 06-persistent-vol-claim.yml         # PersistentVolumeClaim (200Mi)
├── 07-pvc-pod.yml                      # Pod using PVC
├── README.md                           # Experiments and discoveries
└── commands-reference.md               # Storage commands used
```

**Key Learnings:**
- hostPath survives pod deletion, emptyDir doesn't
- emptyDir survives container restart but not pod deletion
- Multi-container pods can share volumes in real-time
- PVC requests minimum storage, gets PV capacity
- WaitForFirstConsumer delays binding until pod created
- Reclaim policies control PV lifecycle after PVC deletion

**Practical Skills:**
- Created and tested hostPath volumes (data persisted across pod deletion)
- Tested emptyDir lifecycle (container restart vs pod deletion)
- Implemented multi-container volume sharing (debian writes, nginx serves)
- Configured StorageClass with custom binding mode
- Created PV/PVC architecture and tested binding process
- Observed reclaim policy behavior (Available → Bound → Available)

**Challenges Solved:**
- **CrashLoopBackOff:** Used intentionally to demonstrate hostPath persistence across restarts
- **Echo redirect error:** Fixed `echo "text >> file"` to `echo "text" >> file`
- **Invalid storage unit:** Fixed `100mi` to `100Mi` (capital M, capital i)
- **PVC Pending:** Understood WaitForFirstConsumer requires pod creation first

**Key Experiments:**
- Killed redis container (PID 1) → emptyDir survived ✅
- Deleted/recreated pod → emptyDir lost, hostPath survived
- Two containers writing to same file → Real-time sharing proven
- PVC deleted → PV returned to Available (Recycle policy worked)

---

## Hands-On Statistics

- **Projects Completed:** 21
- **YAML Files Created:** 129
- **Clusters Deployed:** 2 (1 single-node Minikube + 1 three-node AWS)
- **Cluster Uptime:** 15+ days with multiple restarts
- **Upgrade Phases:** 3 (across 3 major K8s versions)
- **Deployment Revisions:** 7 (with rollbacks tested)
- **Services Created:** 6 (ClusterIP, NodePort)
- **Ingress Rules Configured:** 2 host-based routes
- **Storage Resources:** 1 StorageClass, 1 PV, 1 PVC
- **Volume Types Tested:** 3 (hostPath, emptyDir, PVC)
- **Debugging Sessions:** Multiple (CrashLoopBackOff, OOMKilled, Pending, Node affinity, Network policies, Storage units)
- **Working Demos:** nginx auth, resource limits, rolling updates, Network Policies, Services, Ingress routing, Volume sharing

---

## 📊 Repository Statistics

**Total Modules:** 21  
**Total Directories:** 23  
**Total Files:** 129  

**Coverage:**
- ✅ Cluster Setup (Minikube + Multi-node)
- ✅ Cluster Operations (Drain, Upgrade, Maintenance)
- ✅ Security & RBAC (Users, Service Accounts)
- ✅ Application Management (Config, Resources, Health)
- ✅ Scheduling (Selectors, Affinity, DaemonSets, Static Pods)
- ✅ Workload Controllers (Deployments, ReplicaSets)
- ✅ Networking (DNS, Services, Network Policies, Ingress)
- ✅ Storage (Volumes, PersistentVolumes, StorageClass)

**Skill Level:** Beginner → Advanced Kubernetes Administration

---

## 🎓 Learning Path

```
Start: Minikube local environment
  ↓
Production: 3-node cluster setup
  ↓
Basics: RBAC, ConfigMaps, Resources
  ↓
Advanced: Scheduling, Health Checks, Multi-container
  ↓
Networking: Services, DNS, Network Policies
  ↓
Routing: Ingress Controller, HTTP routing
  ↓
Storage: Volumes, PV/PVC, Persistence
  ↓
Result: Complete K8s administration skills! ✅
```

---

## 🚀 What Makes This Repository Unique

1. **Practical Focus** - Every file has been tested and works
2. **Real Troubleshooting** - Includes actual problems solved
3. **Progressive Learning** - From basics to advanced
4. **Complete Documentation** - READMEs explain what and why
5. **Commands Reference** - Actual commands used, not just theory
6. **Production Ready** - Patterns suitable for real environments

---

## 💡 Skills Demonstrated

**Cluster Management:**
- Installation, configuration, upgrades, maintenance

**Security:**
- RBAC, service accounts, network policies

**Application Lifecycle:**
- Deployments, scaling, health checks, restarts

**Networking:**
- Services (ClusterIP, NodePort)
- DNS and service discovery
- Ingress and HTTP routing
- Network isolation

**Storage:**
- Volume types and persistence
- PV/PVC architecture
- Multi-container data sharing
- Storage lifecycle management

**Troubleshooting:**
- Node affinity issues
- DNS resolution problems
- Service connectivity
- Pod scheduling failures
- Storage configuration errors

---

*All configurations tested and verified working.*  
*Demonstrates production-ready Kubernetes skills*

**Last Updated:** December 2, 2024  
**Total Learning Duration:** 30+ days of hands-on practice
