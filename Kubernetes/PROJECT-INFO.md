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
**22:** Helm S3 Repository (Private chart repo, AWS S3, helm-s3 plugin)  
**23:** Microservices Platform (Food delivery app, API Gateway, HPA, Istio via Helm)

### Technologies Used

- **Kubernetes:** v1.31.13 - v1.34.1
- **Tools:** kubeadm, kubectl, Minikube v1.37.0
- **Container Runtime:** containerd
- **CNI Plugin:** Calico v3.28.0
- **Ingress Controller:** Nginx Ingress Controller v1.13.2
- **Package Manager:** Helm v3.x
- **Helm Plugin:** helm-s3 v0.17.1
- **Cloud Storage:** AWS S3
- **AWS CLI:** v2.32.9
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

**Package Management & Helm:**
✅ Helm installation and configuration  
✅ Helm chart creation and customization  
✅ helm-s3 plugin installation (with issue resolution)  
✅ AWS S3 as private Helm repository  
✅ Chart packaging and versioning  
✅ Repository management (add, update, search)  
✅ Release lifecycle (install, upgrade, rollback)  
✅ Automated repository setup scripts  
✅ Wrapper script creation for plugin issues  
✅ Service template fixes (selector, NodePort)  
✅ Chart debugging and testing  

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

**Helm & Package Management:**
- Set up private Helm chart repository on AWS S3
- Installed and configured helm-s3 plugin with issue resolutions
- Created wrapper script to fix getter/v1 installation problem
- Fixed critical service template issues (missing selector)
- Packaged and pushed charts to S3 repository
- Performed chart installations, upgrades, and rollbacks
- Automated entire repository setup process
- Documented real-world troubleshooting solutions
- Achieved complete Helm workflow from packaging to deployment

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

- **146 files** across 29 directories
- **61 YAML configuration files** from hands-on practice
- **22 README documentation files** explaining each project
- **22 command reference files** for quick lookup
- **7 shell scripts** for automation
- **8 markdown guides** for procedures and troubleshooting

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

### Package Management (22)
**Project 22:** Helm S3 Repository - Private chart repo, AWS S3, automation

### Microservices (23)
**Project 23:** Microservices Platform - Food delivery app, API Gateway, HPA, Istio via Helm

Each project includes:
- Numbered YAML/script files (practice order)
- README.md (exercises, learnings, observations)
- commands-reference.md (all commands used)

---

## 1. Minikube Setup 🎯

**Focus:** Single-node Kubernetes cluster for local development and learning

Set up lightweight Kubernetes environment for testing and learning.

**What's Covered:**
- Minikube installation on Ubuntu 24.04
- Docker driver configuration
- Automated cluster startup with systemd
- Persistent configuration across reboots
- Resource allocation (CPU, Memory)

**Files:**
```
01-minikube-setup/
├── 01-install-minikube.sh              # Installation script
├── 02-setup-autostart.sh               # Systemd setup script
├── 03-minikube-autostart.service       # Systemd service file
└── README.md                           # Setup guide
```

**Key Learnings:**
- Minikube provides single-node K8s cluster for learning
- Docker driver runs K8s inside container
- Systemd enables automatic cluster startup on boot
- Minikube survives system reboots with proper configuration
- Resource limits prevent system overload

**Practical Skills:**
- Installed Minikube with Docker driver
- Configured 2 CPU and 2GB RAM allocation
- Created systemd service for autostart
- Tested cluster persistence across reboots
- Verified kubectl connectivity

**Real Achievement:**
- **Goal:** Local K8s environment that starts automatically
- **Result:** Fully functional Minikube with auto-start! ✅

---

## 2. 3-Node Cluster Installation 🏗️

**Focus:** Production-grade multi-node Kubernetes cluster setup

Build production-like 3-node cluster from scratch on AWS EC2.

**What's Covered:**
- Complete cluster installation with kubeadm
- Container runtime (containerd) setup
- Calico CNI plugin installation
- Master and worker node configuration
- AWS security group requirements
- Network connectivity setup

**Files:**
```
02-3node-cluster-installation/
├── 01-all-nodes-setup.sh               # Common setup (all nodes)
├── 02-master-node-init.sh              # Master initialization
├── 03-worker-node-join.sh              # Worker join script
├── 04-aws-security-groups.md           # Required ports and rules
└── README.md                           # Installation guide
```

**Key Learnings:**
- kubeadm simplifies cluster bootstrapping
- containerd is lightweight and production-ready
- Calico provides pod networking (CNI)
- Security groups must allow specific ports
- Join token expires in 24 hours
- Cluster survives stop/start with proper setup

**Practical Skills:**
- Configured 3 EC2 instances (t2.medium)
- Installed container runtime on all nodes
- Initialized control plane with kubeadm
- Installed Calico CNI for pod networking
- Joined 2 worker nodes to cluster
- Configured AWS security groups
- Tested cluster persistence (15+ days)

**Challenges Solved:**
- **Port conflicts:** Opened required ports in security groups
- **CNI missing:** Installed Calico for pod networking
- **Join token expired:** Regenerated with kubeadm token create

**Real Achievement:**
- **Before:** No cluster infrastructure
- **After:** Production-grade 3-node cluster on AWS
- **Result:** Fully functional cluster that survives reboots! 🎯

---

## 3. Node Draining 🔧

**Focus:** Safe node maintenance procedures with zero downtime

Master node draining for maintenance without service disruption.

**What's Covered:**
- Cordon vs Drain operations
- Pod eviction and rescheduling
- DaemonSet handling during drain
- Graceful pod termination
- Node maintenance procedures
- Uncordon to return to service

**Files:**
```
03-node-draining/
├── 01-test-pod.yaml                    # Single pod for testing
├── 02-test-deployment.yaml             # Deployment for HA testing
├── README.md                           # Procedures and observations
└── draining-commands.md                # Command reference
```

**Key Learnings:**
- Cordon prevents new pods, doesn't evict existing
- Drain safely evicts pods and cordons node
- ReplicaSets automatically reschedule evicted pods
- Standalone pods are not rescheduled (lost!)
- DaemonSets require --ignore-daemonsets flag
- Uncordon makes node schedulable again

**Practical Skills:**
- Cordoned node to prevent scheduling
- Drained node with pod eviction
- Observed pod rescheduling to other nodes
- Tested with standalone pod vs deployment
- Handled DaemonSet pods during drain
- Uncordoned node after maintenance
- Verified zero-downtime for deployments

**Key Experiments:**
- Standalone pod → Not rescheduled (lost)
- Deployment pod → Automatically rescheduled ✅
- DaemonSet pod → Requires --ignore-daemonsets flag

**Real Achievement:**
- **Scenario:** Node needs maintenance
- **Execution:** Drain → Maintenance → Uncordon
- **Result:** Zero-downtime maintenance! ✅

---

## 4. Cluster Upgrade 🚀

**Focus:** Multi-version Kubernetes cluster upgrade procedures

Upgrade production cluster across 3 major versions safely.

**What's Covered:**
- Version compatibility rules (n+1 only)
- Control plane upgrade first
- Worker node upgrades after master
- Component-by-component upgrade process
- Backup and rollback procedures
- Multi-phase upgrade strategy

**Files:**
```
04-cluster-upgrade/
├── 01-upgrade-master-template.sh       # Master upgrade steps
├── 02-upgrade-worker-template.sh       # Worker upgrade steps
├── 03-upgrade-sequence.md              # Phase-by-phase plan
└── README.md                           # Upgrade guide
```

**Key Learnings:**
- Can only upgrade one minor version at a time
- Master must be upgraded before workers
- Drain workers before upgrading
- Components upgrade in order: kubeadm → kubelet → kubectl
- Cluster remains functional during rolling upgrades
- Version skew policy: master can be n+1 of workers

**Practical Skills:**
- Planned 3-phase upgrade (v1.31 → v1.32 → v1.33 → v1.34)
- Upgraded master node first (each phase)
- Drained and upgraded worker nodes
- Verified cluster health after each phase
- Tested pod scheduling after each upgrade
- Documented entire upgrade process

**Upgrade Path Executed:**
```
Phase 1: v1.31.13 → v1.32.1
Phase 2: v1.32.1  → v1.33.0
Phase 3: v1.33.0  → v1.34.1
```

**Real Achievement:**
- **Starting Version:** v1.31.13
- **Final Version:** v1.34.1
- **Result:** 3 successful major version upgrades! 🎯

---

## 5. RBAC User Authentication 🔐

**Focus:** Certificate-based user authentication and authorization

Implement enterprise-grade user access control with certificates and RBAC.

**What's Covered:**
- X.509 certificate creation for users
- Certificate signing with cluster CA
- Kubeconfig file generation
- Role and RoleBinding creation
- User permission testing
- kubectl context configuration

**Files:**
```
05-rbac-user-authentication/
├── 01-create-user.sh                   # User certificate creation
├── 02-setup-rbac.sh                    # RBAC configuration
├── 03-pod-reader-role.yaml             # Role definition
├── 04-pod-reader-rolebinding.yaml      # RoleBinding
└── README.md                           # Step-by-step guide
```

**Key Learnings:**
- Kubernetes has no user objects (external auth)
- Certificates provide user identity
- Roles define what can be done
- RoleBindings assign roles to users
- Namespaced permissions with Roles
- Cluster-wide permissions with ClusterRoles

**Practical Skills:**
- Generated private key for user
- Created certificate signing request (CSR)
- Signed certificate with cluster CA
- Created kubeconfig for user
- Defined Role with specific permissions
- Created RoleBinding to assign role
- Tested user permissions (allowed/denied)

**User Created:**
- **Name:** john
- **Permissions:** Read pods in default namespace
- **Authentication:** X.509 certificate

**Real Achievement:**
- **Before:** Root access only
- **After:** Granular user permissions with certificates
- **Result:** Enterprise-grade access control! 🔒

---

## 6. RBAC ServiceAccounts 🤖

**Focus:** Pod-level permissions and ServiceAccount management

Control what pods can do using ServiceAccounts and RBAC.

**What's Covered:**
- ServiceAccount creation and usage
- Default ServiceAccount behavior
- Role creation for ServiceAccounts
- RoleBinding to ServiceAccounts
- Pod-to-API-server communication
- Token-based authentication
- Disabling auto-mounting credentials

**Files:**
```
06-rbac-serviceaccounts/
├── 01-serviceaccount-basic.yaml        # Simple ServiceAccount
├── 02-serviceaccount-role.yaml         # Role definition
├── 03-serviceaccount-rolebinding.yaml  # RoleBinding
├── 04-pod-with-serviceaccount.yaml     # Pod using custom SA
├── 05-pod-default-sa.yaml              # Pod with default SA
├── 06-advanced-no-automount.yaml       # Disable auto-mount
├── 07-demo-commands.md                 # Testing commands
└── README.md                           # Complete guide
```

**Key Learnings:**
- Every namespace has "default" ServiceAccount
- Pods use default SA unless specified
- ServiceAccounts get auto-mounted tokens
- Tokens enable pod-to-API-server auth
- Can disable auto-mount for security
- ServiceAccounts are namespaced

**Practical Skills:**
- Created custom ServiceAccount
- Defined Role for pod permissions
- Created RoleBinding to ServiceAccount
- Deployed pod with custom ServiceAccount
- Tested API access from inside pod
- Verified token mounting in pod
- Disabled auto-mount for security

**Use Cases Demonstrated:**
- **Monitoring pods:** Need permission to list pods
- **CI/CD pods:** Need deployment permissions
- **Backup pods:** Need read-only access

**Real Achievement:**
- **Before:** Pods had default permissions (limited)
- **After:** Granular pod permissions per use case
- **Result:** Principle of least privilege for pods! 🔒

---

## 7. Application Configuration 📝

**Focus:** ConfigMaps and Secrets for application configuration

Separate configuration from container images using ConfigMaps and Secrets.

**What's Covered:**
- ConfigMap creation and usage
- Environment variables from ConfigMaps
- Volume mounts for config files
- Secret creation and encoding
- Using Secrets in pods
- nginx.conf configuration example
- POSIX permissions for mounted files

**Files:**
```
07-application-configuration/
├── 01-example-configmap.yml            # Basic ConfigMap
├── 02-example-posix-configmap.yml      # ConfigMap with permissions
├── 03-example-secret.yml               # Basic Secret
├── 04-configmap-env-demo.yml           # Environment variables
├── 05-configmap-posix-demo.yml         # POSIX permissions demo
├── 06-configmap-vol-demo.yml           # Volume mount demo
├── 07-nginx.conf                       # nginx configuration
├── 08-nginx-pod.yml                    # nginx with htpasswd
├── README.md                           # Configuration guide
└── commands-reference.md               # Commands used
```

**Key Learnings:**
- ConfigMaps store non-sensitive configuration
- Secrets store sensitive data (base64 encoded)
- Can inject as environment variables or volumes
- Volume mounts allow file-based configuration
- POSIX permissions can be set on mounted files
- Configuration changes can trigger pod restarts

**Practical Skills:**
- Created ConfigMaps from literals and files
- Created Secrets for passwords
- Injected ConfigMaps as environment variables
- Mounted ConfigMaps as volumes
- Configured nginx with custom nginx.conf
- Set up htpasswd authentication
- Applied POSIX permissions (0644, 0400)

**Real Application Built:**
- **nginx web server** with:
  - Custom nginx.conf from ConfigMap
  - htpasswd authentication from Secret
  - Environment variables from ConfigMap
  - Successful authentication testing

**Real Achievement:**
- **Before:** Configuration baked into images
- **After:** External configuration management
- **Result:** Portable and secure configuration! ✅

---

## 8. Container Resources 💻

**Focus:** CPU and memory management with QoS classes

Control resource allocation and understand Quality of Service classes.

**What's Covered:**
- Resource requests (minimum guaranteed)
- Resource limits (maximum allowed)
- QoS classes (BestEffort, Burstable, Guaranteed)
- OOMKilled scenarios
- Resource quota and limit ranges
- CPU throttling vs memory limits

**Files:**
```
08-container-resources/
├── 01-request-limit.yml                # Requests and limits
├── 02-resource-limit.yml               # Limits only
├── 03-memory-limit-test.yml            # OOMKilled demo
├── 04-qos-besteffort.yml               # BestEffort QoS
├── 05-qos-burstable.yml                # Burstable QoS
├── 06-qos-guaranteed.yml               # Guaranteed QoS
├── README.md                           # Resource guide
└── commands-reference.md               # Resource commands
```

**Key Learnings:**
- Requests = minimum resources guaranteed
- Limits = maximum resources allowed
- CPU is compressible (throttled), memory is not (OOMKilled)
- QoS determines eviction order during resource pressure
- Guaranteed = requests = limits (highest priority)
- Burstable = requests < limits (medium priority)
- BestEffort = no requests/limits (lowest priority)

**Practical Skills:**
- Set CPU and memory requests
- Set CPU and memory limits
- Created all 3 QoS classes
- Triggered OOMKilled scenario
- Observed pod eviction behavior
- Calculated QoS class from resources

**QoS Classes Tested:**
1. **BestEffort:** No resources specified → Evicted first
2. **Burstable:** Requests < Limits → Evicted second
3. **Guaranteed:** Requests = Limits → Evicted last

**Real Experiment:**
- **Scenario:** Pod exceeding memory limit
- **Result:** OOMKilled with exit code 137
- **Learning:** Memory limits are hard limits! 💥

**Real Achievement:**
- **Before:** No resource control (unpredictable)
- **After:** Guaranteed resources with proper QoS
- **Result:** Predictable and fair resource allocation! ✅

---

## 9. Health Probes 🏥

**Focus:** Application health monitoring and self-healing

Implement liveness, readiness, and startup probes for reliability.

**What's Covered:**
- Liveness probes (restart if unhealthy)
- Readiness probes (remove from service if not ready)
- Startup probes (slow-starting apps)
- HTTP, TCP, and command probes
- Probe timing configuration
- Service endpoint management

**Files:**
```
09-health-probes/
├── 01-liveness-hc.yml                  # Liveness probe demo
├── 02-startup-hc.yml                   # Startup probe demo
├── 03-readiness-demo.yml               # Readiness probe setup
├── 04-readiness-demo-labeled.yml       # With labels
├── 05-readiness-service.yml            # Service for readiness
├── 06-readiness-hc.yml                 # Readiness probe config
├── 07-complete-probes.yml              # All probes together
└── README.md                           # Health probe guide
```

**Key Learnings:**
- Liveness = "Is app alive?" → Restart if fails
- Readiness = "Is app ready to serve?" → Remove from endpoints
- Startup = "Has app started?" → Longer delay for slow apps
- Failed liveness → Pod restart (CrashLoopBackOff)
- Failed readiness → Removed from service endpoints
- Probes run throughout pod lifetime

**Practical Skills:**
- Created HTTP liveness probe
- Created readiness probe with file check
- Configured startup probe for slow app
- Set appropriate timing (delay, period, timeout)
- Tested probe failure scenarios
- Observed automatic pod restart
- Verified service endpoint removal

**Probe Types Used:**
- **HTTP GET:** Check HTTP endpoint (status 200-399 = success)
- **TCP Socket:** Check TCP port (connection = success)
- **Exec Command:** Run command (exit 0 = success)

**Real Scenarios Tested:**
- Liveness failure → Pod automatically restarted ✅
- Readiness failure → Pod removed from service ✅
- Readiness pass → Pod added back to service ✅

**Real Achievement:**
- **Before:** Manual health monitoring
- **After:** Automated self-healing applications
- **Result:** High availability with auto-recovery! 🚑

---

## 10. Restart Policies ♻️

**Focus:** Container restart behavior and pod lifecycle

Understand how Kubernetes handles container and pod restarts.

**What's Covered:**
- Always restart policy (default)
- OnFailure restart policy
- Never restart policy
- Exit code interpretation
- CrashLoopBackOff state
- Restart backoff timing

**Files:**
```
10-restart-policies/
├── 01-always-restart.yml               # Always policy demo
├── 02-onfailure-restart.yml            # OnFailure with failure
├── 03-onfailure-success.yml            # OnFailure with success
├── 04-never-restart.yml                # Never policy demo
├── 05-never-restart-fail.yml           # Never policy with failure
├── README.md                           # Restart policy guide
└── commands-reference.md               # Commands used
```

**Key Learnings:**
- Always = Restart on any termination (success or failure)
- OnFailure = Restart only on failure (exit code > 0)
- Never = Never restart, even on failure
- Exit code 0 = Success, >0 = Failure
- CrashLoopBackOff = Repeated restart failures
- Backoff timing: 10s → 20s → 40s → 80s → 160s → 300s (max)

**Practical Skills:**
- Created pods with each restart policy
- Tested container exit scenarios
- Observed CrashLoopBackOff behavior
- Interpreted exit codes
- Understood backoff timing
- Chose appropriate policy for use cases

**Use Cases:**
- **Always:** Web servers, long-running services
- **OnFailure:** Batch jobs, data processing
- **Never:** One-time tasks, debugging

**Exit Codes Tested:**
- **0:** Success (completed normally)
- **1:** General error
- **127:** Command not found
- **137:** SIGKILL (OOMKilled)
- **143:** SIGTERM (graceful termination)

**Real Achievement:**
- **Before:** Unclear restart behavior
- **After:** Predictable container lifecycle
- **Result:** Appropriate restart policies per workload! ✅

---

## 11. Multi-Container Pods 🔗

**Focus:** Sidecar pattern and Init containers

Run multiple containers in single pod for shared resources.

**What's Covered:**
- Multi-container pod patterns
- Shared network namespace (localhost)
- Shared volume mounts
- Init containers for dependencies
- Container execution order
- Sidecar, adapter, and ambassador patterns

**Files:**
```
11-multicontainer-pods/
├── 01-multi-containers.yml             # Multiple containers
├── 02-init-container.yml               # Init container demo
├── 03-init-container-dependency.yml    # Dependency waiting
├── README.md                           # Multi-container guide
└── commands-reference.md               # Commands used
```

**Key Learnings:**
- Containers in same pod share network namespace
- Can communicate via localhost
- Share volumes for data exchange
- Init containers run before main containers
- Init containers must complete successfully
- All containers see same pod IP

**Practical Skills:**
- Created pod with multiple containers
- Shared volume between containers
- Configured init container
- Tested localhost communication
- Observed init container execution order
- Debugged multi-container scenarios

**Patterns Implemented:**
- **Sidecar:** Helper container alongside main app
- **Init Container:** Setup tasks before main app starts

**Real Scenarios:**
- nginx + log collector (sidecar pattern)
- Init container prepares data before app starts
- Containers communicate via shared volume

**Real Achievement:**
- **Before:** Single container per pod
- **After:** Complex multi-container architectures
- **Result:** Advanced pod patterns for real use cases! ✅

---

## 12. Scheduling: nodeSelector & nodeName 🎯

**Focus:** Basic pod placement and node selection

Control which nodes run your pods using labels and node names.

**What's Covered:**
- nodeSelector (label-based placement)
- nodeName (direct node assignment)
- Node labeling
- Resource-based scheduling
- Pod pending due to scheduling constraints
- Node selection best practices

**Files:**
```
12-scheduling-nodeselector-nodename/
├── 01-nodeselector.yml                 # nodeSelector demo
├── 02-nodename.yml                     # nodeName demo
├── 03-resource-req-1.yml               # Resource constraints
├── 04-resource-req-2.yml               # Different resources
├── README.md                           # Scheduling guide
└── commands-reference.md               # Scheduling commands
```

**Key Learnings:**
- nodeSelector uses node labels for placement
- nodeName assigns pod to specific node (bypasses scheduler)
- Labels are key-value pairs on nodes
- Pod stays Pending if no node matches selector
- Resource requests affect scheduling decisions
- nodeSelector is simpler than node affinity

**Practical Skills:**
- Added labels to nodes
- Used nodeSelector to place pods
- Used nodeName for direct assignment
- Created resource constraints
- Debugged Pending pods
- Understood scheduling failures

**Scheduling Methods:**
1. **nodeSelector:** `disktype=ssd` (label matching)
2. **nodeName:** `k8s-worker-1` (specific node)
3. **Resources:** Scheduler finds nodes with capacity

**Real Experiments:**
- Pod with nodeSelector → Only scheduled on matching nodes ✅
- Pod with nodeName → Directly placed on that node ✅
- Insufficient resources → Pod stays Pending

**Real Achievement:**
- **Before:** Random pod placement
- **After:** Controlled pod placement by requirements
- **Result:** Pods run on appropriate nodes! 🎯

---

## 13. DaemonSets 🔄

**Focus:** Run one pod per node automatically

Deploy cluster-wide services using DaemonSets.

**What's Covered:**
- DaemonSet concept and use cases
- Automatic pod distribution
- Node selector with DaemonSets
- Updating DaemonSets
- Removing DaemonSet pods
- Common use cases (logging, monitoring)

**Files:**
```
13-daemonsets/
├── 01-daemonset-basic.yml              # Basic DaemonSet
├── 02-daemonset-all-nodes.yml          # All nodes including master
├── 03-daemonset-ssd-only.yml           # Only SSD nodes
├── README.md                           # DaemonSet guide
└── commands-reference.md               # DaemonSet commands
```

**Key Learnings:**
- DaemonSet ensures one pod per node
- Automatically adds pod to new nodes
- Automatically removes pod from deleted nodes
- Can use nodeSelector to target specific nodes
- Survives node restarts and rejoins
- Common for system-level services

**Practical Skills:**
- Created basic DaemonSet
- Observed automatic distribution to all nodes
- Added node selector to DaemonSet
- Tested pod creation on new nodes
- Verified pod removal from cordoned nodes
- Updated DaemonSet configuration

**Use Cases Implemented:**
- **Logging agent:** Collect logs from all nodes
- **Monitoring agent:** Metrics from every node
- **Network proxy:** Node-level networking

**Real Experiments:**
- 3-node cluster → 3 pods automatically created ✅
- Cordoned node → Pod removed from that node ✅
- nodeSelector added → Only matching nodes got pods ✅

**Real Achievement:**
- **Before:** Manual pod placement on each node
- **After:** Automatic cluster-wide distribution
- **Result:** Effortless node-level services! 🔄

---

## 14. Static Pods 📌

**Focus:** kubelet-managed pods without API server

Create pods managed directly by kubelet on worker nodes.

**What's Covered:**
- Static pod concept
- kubelet manifest directory
- Static pod creation
- Mirror pods in API server
- Use cases for static pods
- Difference from regular pods

**Files:**
```
14-static-pods/
├── 01-static-pod.yml                   # Static pod definition
├── README.md                           # Static pod guide
└── commands-reference.md               # Commands used
```

**Key Learnings:**
- Static pods managed by kubelet, not API server
- Placed in /etc/kubernetes/manifests/ directory
- kubelet watches directory and creates pods
- Mirror pod appears in kubectl output
- Can't delete via kubectl (delete file instead)
- Survives kubelet restarts

**Practical Skills:**
- Created static pod manifest
- Placed in kubelet manifest directory
- Verified pod creation by kubelet
- Observed mirror pod in API server
- Tested pod persistence
- Deleted static pod by removing file

**Static Pod Locations:**
- **Master:** Control plane components (etcd, scheduler, etc.)
- **Worker:** Custom worker-specific pods

**Real Experiments:**
- File added → Pod created automatically ✅
- File removed → Pod deleted automatically ✅
- kubelet restarted → Pod recreated ✅

**Real Achievement:**
- **Before:** All pods through API server
- **After:** Node-specific pods without API dependency
- **Result:** Kubelet-managed pods for special cases! 📌

---

## 15. Node Affinity 🧲

**Focus:** Advanced pod placement with complex rules

Use sophisticated rules for pod placement beyond nodeSelector.

**What's Covered:**
- requiredDuringScheduling rules
- preferredDuringScheduling rules
- In, NotIn, Exists, DoesNotExist operators
- Multiple affinity rules (AND logic)
- Weight-based preferences
- Combining required and preferred

**Files:**
```
15-node-affinity/
├── 01-node-affinity-in.yml             # In operator
├── 02-node-anti-affinity-notin.yml     # NotIn operator
├── 03-affinity-exists.yml              # Exists operator
├── 04-affinity-preferred.yml           # Soft preferences
├── 05-affinity-or-logic.yml            # OR logic with matchExpressions
├── 06-affinity-required-and-preferred.yml  # Combined rules
├── README.md                           # Node affinity guide
└── commands-reference.md               # Affinity commands
```

**Key Learnings:**
- Node affinity is more expressive than nodeSelector
- Required = hard rule (pod won't schedule if not met)
- Preferred = soft rule (try to match, but not mandatory)
- Operators: In, NotIn, Exists, DoesNotExist, Gt, Lt
- Multiple terms = OR logic
- Multiple expressions in term = AND logic

**Practical Skills:**
- Created required affinity rules
- Created preferred affinity rules
- Used In operator for multiple values
- Used NotIn for anti-affinity
- Used Exists for label presence check
- Combined required and preferred rules
- Set weights for preferences

**Affinity Rules Created:**
```
Required: Must have disktype=ssd
Preferred: Prefer zone=us-east-1a (weight 50)
Preferred: Prefer instancetype=t2.large (weight 30)
```

**Real Experiments:**
- Required rule not met → Pod stays Pending ✅
- Preferred rule not met → Pod still schedules ✅
- Multiple preferred rules → Higher weight wins ✅

**Real Achievement:**
- **Before:** Simple nodeSelector only
- **After:** Complex placement logic with priorities
- **Result:** Flexible pod placement strategies! 🧲

---

## 16. Deployments 🚢

**Focus:** Declarative application deployment and scaling

Manage application lifecycle with Deployments.

**What's Covered:**
- ReplicationController (legacy)
- ReplicaSet (modern controller)
- Deployment (production standard)
- Rolling updates
- Rollback procedures
- Pause and resume
- Deployment strategies

**Files:**
```
16-deployments/
├── 01-replication-controller.yml       # Legacy RC
├── 02-replica-set.yml                  # ReplicaSet
├── 03-bare-pods.yml                    # Pods without controller
├── 04-deployment.yml                   # Deployment
├── README.md                           # Deployment guide
└── commands-reference.md               # Deployment commands
```

**Key Learnings:**
- ReplicationController is legacy (don't use)
- ReplicaSet manages pod replicas
- Deployment manages ReplicaSets
- Deployments enable rolling updates
- Can rollback to previous versions
- Pause/resume for batch updates
- ReplicaSet can adopt existing pods (label matching!)

**Practical Skills:**
- Created ReplicaSet and Deployment
- Scaled replicas up and down
- Performed rolling update
- Rolled back to previous version
- Paused and resumed deployment
- Managed deployment history (7 revisions)
- Witnessed label adoption by ReplicaSet

**Deployment Operations:**
```
Create → Scale → Update → Rollback → Delete
  3       10       5        3         0
```

**Real Experiments:**
- Bare pods with matching labels → Adopted by ReplicaSet! ✅
- Rolling update → Zero downtime ✅
- Rollback → Instant revert to previous version ✅
- Pause → Updated 2 pods → Resume → All updated ✅

**Real Achievement:**
- **Before:** Manual pod management
- **After:** Declarative deployments with history
- **Result:** Production-ready deployment workflow! 🚢

---

## 17. Kubernetes Networking 🌐

**Focus:** Pod-to-pod communication and DNS resolution

Understand Kubernetes networking fundamentals and DNS.

**What's Covered:**
- Pod networking basics
- Pod-to-pod communication
- DNS resolution in cluster
- Service discovery
- Network namespaces
- CoreDNS functionality

**Files:**
```
17-kubernetes-networking/
├── 01-pods-dns.yml                     # DNS testing pods
├── README.md                           # Networking guide
└── commands-reference.md               # Networking commands
```

**Key Learnings:**
- Every pod gets unique IP address
- Pods can communicate directly via IP
- DNS enables service discovery
- CoreDNS provides cluster DNS
- Pods in same namespace use short names
- Cross-namespace needs FQDN
- Network policies don't exist by default (all allowed)

**Practical Skills:**
- Created pods for network testing
- Tested pod-to-pod communication via IP
- Tested DNS resolution (short names)
- Tested cross-namespace DNS (FQDN)
- Used nslookup and curl from pods
- Understood DNS naming conventions

**DNS Formats:**
```
Short name:     service-name
Namespace:      service-name.namespace
FQDN:          service-name.namespace.svc.cluster.local
```

**Real Experiments:**
- Pod A → Pod B via IP → Success ✅
- Pod A → Service via DNS → Success ✅
- Same namespace → Short name works ✅
- Different namespace → Need FQDN ✅

**Real Achievement:**
- **Before:** Unknown how pods communicate
- **After:** Complete networking and DNS understanding
- **Result:** Foundation for service discovery! 🌐

---

## 18. Network Policies 🔒

**Focus:** Pod-level firewall rules for traffic control

Implement network segmentation using Network Policies.

**What's Covered:**
- Network Policy concepts
- Ingress rules (incoming traffic)
- Egress rules (outgoing traffic)
- Pod selectors for targeting
- Namespace selectors
- Default deny policies
- Allow specific traffic

**Files:**
```
18-network-policy/
├── 01-network-policy-pods.yml          # Test pods
├── 02-network-policy.yml               # Policy rules
├── README.md                           # Network policy guide
└── commands-reference.md               # Policy commands
```

**Key Learnings:**
- Network policies are pod-level firewalls
- By default, all traffic is allowed
- Policies are additive (OR logic)
- Ingress = incoming to pod
- Egress = outgoing from pod
- Requires CNI plugin support (Calico works!)
- Empty podSelector = applies to all pods in namespace

**Practical Skills:**
- Created test pods for policy testing
- Implemented default deny policy
- Allowed specific pod-to-pod traffic
- Used label selectors for targeting
- Tested policy enforcement
- Debugged connectivity issues
- Verified policy application

**Policy Rules Created:**
```
Default: Deny all ingress
Allow:   Traffic from pods with label "access=allowed"
Allow:   Traffic to specific ports
```

**Real Experiments:**
- No policy → All pods communicate ✅
- Default deny → All traffic blocked ✅
- Specific allow → Only allowed pods communicate ✅
- Label change → Access revoked immediately ✅

**Real Achievement:**
- **Before:** No network segmentation
- **After:** Granular traffic control per pod
- **Result:** Zero-trust networking! 🔒

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

**Real Achievement:**
- **Before:** Direct pod IP communication
- **After:** Stable service endpoints with DNS
- **Result:** Production-ready service discovery! 🌐

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
- **Invalid storage unit:** Fixed `100mi` to `100Mi` (capital M)
- **PVC Pending:** Understood WaitForFirstConsumer requires pod creation first

**Key Experiments:**
- Killed redis container (PID 1) → emptyDir survived ✅
- Deleted/recreated pod → emptyDir lost, hostPath survived
- Two containers writing to same file → Real-time sharing proven
- PVC deleted → PV returned to Available (Recycle policy worked)

**Real Achievement:**
- **Before:** No data persistence understanding
- **After:** Complete storage lifecycle mastery
- **Result:** Production-ready persistent storage! 💾

---

## 22. Helm S3 Repository Setup 📦

**Focus:** Private Helm chart repository on AWS S3 with issue resolutions

Set up production-ready private Helm repository with automated deployment.

**What's Covered:**
- AWS CLI installation and configuration
- helm-s3 plugin installation (with workarounds)
- S3 bucket configuration for Helm repository
- Helm chart creation and customization
- Service template fixes (selector, NodePort)
- Chart packaging and versioning
- Repository operations (push, search, install)
- Release management (upgrade, rollback)
- Automated setup scripts

**Files:**
```
22-helm-s3-kubernetes/
├── README.md                            # Complete setup guide
├── hello-world/                         # Sample Helm chart (fixed)
│   ├── Chart.yaml                      # Chart metadata
│   ├── values.yaml                     # Default values
│   └── templates/                      # Kubernetes manifests
│       ├── deployment.yaml
│       ├── service.yaml                # ✅ Fixed: includes selector
│       ├── serviceaccount.yaml
│       └── tests/
├── script/
│   └── s3-helm-repo.sh                 # Automated setup script
└── docs/
    ├── AWS-CLI-SETUP.md                # AWS CLI installation
    ├── command-reference.md            # Helm commands
    ├── MY-SETUP.md                     # Production example
    └── TROUBLESHOOTING.md              # Issue resolutions
```

**Key Learnings:**
- helm-s3 plugin requires `--verify=false` flag
- Plugin can install as getter/v1 instead of command
- Service templates must include selector for endpoints
- NodePort needs conditional logic in service template
- S3 versioning essential for rollback capability
- Repository name is arbitrary local alias
- helm-s3 command uses hyphen (not space)

**Practical Skills:**
- Installed AWS CLI v2 and configured credentials
- Created S3 bucket with versioning enabled
- Installed helm-s3 plugin with workarounds
- Created wrapper script to fix getter/v1 issue
- Fixed service template (missing selector)
- Packaged Helm chart with proper versioning
- Pushed chart to private S3 repository
- Installed applications from custom repository
- Performed upgrades and rollbacks
- Automated entire setup process

**Issues Solved:**
- ✅ Plugin verification failure → Used --verify=false
- ✅ helm-s3 command not found → Created wrapper script
- ✅ Service has no endpoints → Added selector to template
- ✅ NodePort not applied → Added conditional in template
- ✅ Port conflicts → Used different NodePort values

**Challenge Solved:** 
helm-s3 plugin installed as `getter/v1` instead of command plugin. Created wrapper script at `/usr/local/bin/helm-s3` pointing to plugin binary. This is a known issue documented in troubleshooting guide!

**Real Achievement:**
- **Before:** Manual chart management, no private repository
- **After:** Automated S3 repository with complete workflow
- **Result:** Production-ready private Helm chart repository! 🎯

**Complete Workflow:**
1. AWS CLI installed and configured
2. S3 bucket created with versioning
3. helm-s3 plugin installed (with fixes)
4. Chart packaged and pushed to S3
5. Repository added to Helm
6. Application deployed from private repo
7. Successful upgrade and rollback tested

**Documentation Highlights:**
- Complete AWS CLI setup guide
- 534 lines of troubleshooting solutions
- 480 lines of command reference
- Real production setup example
- All sensitive data sanitized

---

## 23. Microservices Platform 🍔

**Focus:** Multi-service application with API Gateway, auto-scaling, and service mesh

Build a food-delivery platform as independent, separately-scalable microservices.

**What's Covered:**
- Independent microservice Deployments (one identity per service)
- API Gateway pattern (NGINX reverse proxy, config from ConfigMap)
- Service-to-service communication via Kubernetes DNS (ClusterIP)
- Path-based routing (`/api/users`, `/api/restaurants`, `/api/orders`, `/api/payments`)
- Single external entry point via NodePort
- Horizontal Pod Autoscaler (CPU-based)
- Installing Istio service mesh via Helm (3-chart approach)

**Files:**
```
23-k8s-microservices/
├── 01-user-service-dep-&-svc.yml         # User service (2 replicas) + ClusterIP
├── 02-restaurant-service-dep-&-svc.yml   # Restaurant service (3 replicas) + ClusterIP
├── 03-order-service-dep-&-svc.yml        # Order service (2 replicas) + ClusterIP
├── 04-api-gateway-config-dep-svc.yml     # NGINX gateway: ConfigMap + Deployment + NodePort (30200)
├── 05-payment-service-dep-&-svc.yml      # Payment service (3 replicas) + ClusterIP
├── 06-restaurant-service-hpa.yml         # HPA: min 3, max 20, 70% CPU
├── 07-install-istio-via-helm.sh          # Istio install: base → istiod → gateway
└── README.md                             # Architecture and step-by-step guide
```

**Architecture:**
```
4 microservices + 1 API Gateway   (namespace: food-delivery)
├── User Service        - 2 replicas (ClusterIP)
├── Restaurant Service  - 3 replicas + HPA (ClusterIP)
├── Order Service       - 2 replicas (ClusterIP)
├── Payment Service     - 3 replicas (ClusterIP)
└── API Gateway         - 1 replica  (NGINX, NodePort 30200)

App pods: 10  |  Gateway pods: 1  |  Backends: hashicorp/http-echo
```

**Key Learnings:**
- Each service is an independent Deployment — scaled and rolled out separately
- API Gateway is the only externally exposed component; backends stay internal (ClusterIP)
- Kubernetes DNS (`http://user-service/`) removes the need for hardcoded pod IPs
- NGINX reads `nginx.conf` from a ConfigMap mounted via `subPath`
- HPA needs both Metrics Server *and* CPU resource requests on target pods
- Istio installs as 3 ordered Helm charts: base (CRDs) → istiod → gateway

**Practical Skills:**
- Deployed 4 backend microservices with ClusterIP services
- Configured an NGINX API Gateway with path-based reverse-proxy routing
- Exposed the platform externally via NodePort
- Created an HPA for CPU-based auto-scaling (3–20 pods)
- Scripted Istio service mesh installation via Helm

**Real Achievement:**
- **Before:** Monolithic, single-deployment thinking
- **After:** Independent microservices behind a single gateway with auto-scaling
- **Result:** Production-pattern microservices platform! 🍔

---

## Hands-On Statistics

- **Projects Completed:** 23
- **YAML Files Created:** 146
- **Clusters Deployed:** 2 (1 single-node Minikube + 1 three-node AWS)
- **Cluster Uptime:** 15+ days with multiple restarts
- **Upgrade Phases:** 3 (across 3 major K8s versions)
- **Deployment Revisions:** 7 (with rollbacks tested)
- **Services Created:** 6 (ClusterIP, NodePort)
- **Ingress Rules Configured:** 2 host-based routes
- **Storage Resources:** 1 StorageClass, 1 PV, 1 PVC
- **Volume Types Tested:** 3 (hostPath, emptyDir, PVC)
- **Helm Charts Created:** 1 (with fixes)
- **Helm Repositories:** 1 private S3 repository
- **Chart Releases:** 3+ (install, upgrade, rollback tested)
- **Debugging Sessions:** Multiple (CrashLoopBackOff, OOMKilled, Pending, Node affinity, Network policies, Storage units, Helm plugin issues)
- **Working Demos:** nginx auth, resource limits, rolling updates, Network Policies, Services, Ingress routing, Volume sharing, Helm S3 repository

---

## 📊 Repository Statistics

**Total Modules:** 23  
**Total Directories:** 29  
**Total Files:** 146  

**Coverage:**
- ✅ Cluster Setup (Minikube + Multi-node)
- ✅ Cluster Operations (Drain, Upgrade, Maintenance)
- ✅ Security & RBAC (Users, Service Accounts)
- ✅ Application Management (Config, Resources, Health)
- ✅ Scheduling (Selectors, Affinity, DaemonSets, Static Pods)
- ✅ Workload Controllers (Deployments, ReplicaSets)
- ✅ Networking (DNS, Services, Network Policies, Ingress)
- ✅ Storage (Volumes, PersistentVolumes, StorageClass)
- ✅ Package Management (Helm, Charts, Private Repositories)

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
Package Management: Helm, Charts, Private Repository
  ↓
Result: Complete K8s administration + DevOps skills! ✅
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

**Package Management:**
- Helm chart creation and customization
- Private repository setup (AWS S3)
- Chart versioning and distribution
- Release management and rollbacks

**Troubleshooting:**
- Node affinity issues
- DNS resolution problems
- Service connectivity
- Pod scheduling failures
- Storage configuration errors
- Helm plugin installation issues

---

*All configurations tested and verified working.*  
*Demonstrates production-ready Kubernetes skills*

**Last Updated:** June 15, 2026  
**Total Learning Duration:** 30+ days of hands-on practice
