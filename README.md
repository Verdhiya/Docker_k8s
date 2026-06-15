# Docker & Kubernetes

Complete containerization to orchestration learning path with hands-on projects and real-world applications.

## 🐳 Docker

### Projects Built

#### Single Container Applications:
- **3 Nginx Web Servers** (ports 8080, 8081, 8080) with custom HTML content
- **2 MySQL Databases** with persistent volumes and custom data
- **Python Flask API** for health monitoring (port 5000)

#### Multi-Container Applications:
- **WordPress + MySQL Stack** - Full CMS with database backend
- **Node.js + MongoDB Stack** - Custom API with database integration

### Core Skills Mastered

- **Container Lifecycle:** Created, managed, and troubleshot 10+ containers
- **Volume Management:** Implemented named volumes (`mysql_db`) and bind mounts (`/root/testbind/nginx-bind`)
- **Docker Compose:** Built 2 production-ready multi-service applications
- **Custom Images:** Created Dockerfiles for Node.js and Python applications
- **Networking:** Configured service communication and port mapping
- **Production Deployment:** Deployed on AWS EC2 with proper security configurations

### Essential Commands Used

#### Container Management
```bash
docker run -d -p 8080:80 nginx
docker ps -a
docker logs <container-name>
docker exec -it <container> bash
docker stop/start/restart <container>
```
#### Volume & Bind Mounts
```bash
docker run -d -v mysql_data:/var/lib/mysql mysql:8.4
docker run -d --mount type=bind,source=/host/path,target=/container/path nginx
```
#### Docker Compose
```bash
docker compose up -d
docker compose down
docker compose logs -f
docker compose ps
docker compose exec <service> bash
```
#### Image Building
```bash
docker build -t custom-app .
docker images
```

### Real-World Troubleshooting

- **Resolved MySQL version conflicts** by recreating volumes
- **Managed EC2 resource constraints** on t2.micro (1GB RAM)
- **Debugged container networking** for inter-service communication
- **Fixed JavaScript template literal syntax** in Node.js applications

### Repository Structure

```
├── Docker_Compose/
│   ├── docker-compose.yml            # WordPress + MySQL
│   ├── Dockerfile.python
│   └── Dockerfile.node
├── Docker_compose_custom_app/
│   ├── Custom-Application.yml        # Node.js + MongoDB
│   ├── dockerfile
│   └── app.js
└── testbind/nginx-bind/
    └── index.html                    # Custom web content
```

### Applications Deployed

1. **Static Website** - Nginx with custom HTML via bind mounts
2. **Database Server** - MySQL with persistent data and custom database/tables
3. **WordPress CMS** - Full content management system with MySQL backend
4. **RESTful API** - Node.js application with MongoDB integration
5. **Health Monitor** - Python Flask service for application monitoring

**Learning Stats:** Hands-On | 5 applications | 10+ containers deployed

---

## ☸️ Kubernetes Orchestration

### Infrastructure Foundation

**Cluster Environments:**
- **Development:** Minikube single-node cluster with auto-start
- **Production:** 3-node cluster (1 control plane + 2 workers)
- **Network:** Calico CNI v3.28.0
- **Runtime:** containerd
- **Versions:** v1.31.13 → v1.34.1 (progressive upgrades)

---

## Projects 1-11: Kubernetes Fundamentals

### Project 1: Minikube Setup

**Objective:** Local Kubernetes environment for learning and testing

**Implementation:**
- Installed Minikube v1.37.0 with Docker driver
- Configured 2 CPU and 2GB RAM allocation
- Set up systemd service for automatic cluster startup
- Verified persistence across system reboots

**Skills Gained:**
- Minikube installation and configuration
- Resource allocation strategies
- Linux systemd service creation
- Cluster lifecycle management

---

### Project 2: 3-Node Cluster Installation

**Objective:** Production-grade multi-node cluster from scratch

**Implementation:**
- Deployed 3-node cluster using kubeadm
- Configured containerd as container runtime
- Installed Calico CNI for pod networking
- Configured cloud security groups for cluster communication
- Tested 15+ days uptime with multiple restarts

**Skills Gained:**
- kubeadm cluster bootstrapping
- CNI plugin installation
- Network configuration
- Cluster persistence strategies
- Production cluster architecture

**Challenges Solved:**
- Port configuration in security groups
- CNI installation for pod networking
- Join token expiration handling

---

### Project 3: Node Draining

**Objective:** Safe node maintenance without service disruption

**Implementation:**
- Practiced cordon operations (prevent new pods)
- Executed drain procedures (evict existing pods)
- Tested with standalone pods vs deployments
- Handled DaemonSet pods during drain
- Performed uncordon to restore scheduling

**Skills Gained:**
- Zero-downtime maintenance procedures
- Understanding pod eviction policies
- DaemonSet special handling
- Production maintenance workflows

**Key Learning:** Deployments auto-reschedule evicted pods; standalone pods are lost

---

### Project 4: Cluster Upgrade

**Objective:** Multi-version Kubernetes upgrade safely

**Implementation:**
- Planned 3-phase upgrade: v1.31 → v1.32 → v1.33 → v1.34
- Upgraded control plane first in each phase
- Drained and upgraded worker nodes sequentially
- Verified cluster health after each phase
- Maintained service availability throughout

**Skills Gained:**
- Version compatibility understanding (n+1 rule)
- Component upgrade order (kubeadm → kubelet → kubectl)
- Rolling cluster upgrades
- Backup and verification procedures

---

### Project 5: RBAC User Authentication

**Objective:** Implement certificate-based user access control

**Implementation:**
- Generated X.509 certificates for user authentication
- Signed certificates with cluster Certificate Authority
- Created kubeconfig files for user contexts
- Defined Roles with specific permissions
- Created RoleBindings to assign roles

**Skills Gained:**
- Certificate-based authentication
- RBAC policy creation
- User permission management
- Kubeconfig file structure
- Access control testing

**Result:** Granular user access control with enterprise-grade authentication

---

### Project 6: RBAC ServiceAccounts

**Objective:** Pod-level permission management

**Implementation:**
- Created custom ServiceAccounts for pods
- Defined Roles for ServiceAccount permissions
- Created RoleBindings to ServiceAccounts
- Tested pod-to-API-server authentication
- Configured token auto-mounting
- Implemented security best practices (disable auto-mount)

**Skills Gained:**
- ServiceAccount creation and management
- Pod-level RBAC policies
- Token-based authentication
- Principle of least privilege for applications

**Use Cases Implemented:** Monitoring pods, CI/CD pods, backup pods

---

### Project 7: Application Configuration

**Objective:** Separate configuration from container images

**Implementation:**
- Created ConfigMaps for application settings
- Created Secrets for sensitive data (base64 encoded)
- Injected configuration as environment variables
- Mounted configuration as files
- Set POSIX permissions on mounted files
- Built nginx with htpasswd authentication

**Skills Gained:**
- ConfigMap creation and usage
- Secret management
- Environment variable injection
- Volume-based configuration
- Configuration security practices

**Real Application:** nginx web server with ConfigMap-based nginx.conf and Secret-based htpasswd authentication

---

### Project 8: Container Resources

**Objective:** CPU and memory management with QoS classes

**Implementation:**
- Configured resource requests (minimum guaranteed)
- Configured resource limits (maximum allowed)
- Created pods in all QoS classes (BestEffort, Burstable, Guaranteed)
- Triggered OOMKilled scenario (exit code 137)
- Tested pod eviction during resource pressure

**Skills Gained:**
- Resource request/limit syntax
- QoS class understanding and implications
- Memory vs CPU enforcement differences
- Exit code interpretation
- Resource planning for applications

**Key Learning:** CPU is throttled, memory violations cause OOMKilled

---

### Project 9: Health Probes

**Objective:** Self-healing applications with health monitoring

**Implementation:**
- Configured liveness probes (restart unhealthy containers)
- Configured readiness probes (manage service traffic)
- Configured startup probes (slow-starting applications)
- Implemented HTTP, TCP, and Exec probe types
- Tested automatic pod restart on probe failure
- Verified service endpoint removal on readiness failure

**Skills Gained:**
- Health probe configuration
- Probe timing parameters
- Self-healing application patterns
- Service endpoint management
- Automated recovery procedures

**Result:** Applications automatically recover from failures and manage traffic based on readiness

---

### Project 10: Restart Policies

**Objective:** Understand container restart behavior

**Implementation:**
- Tested Always restart policy (default)
- Tested OnFailure restart policy
- Tested Never restart policy
- Observed CrashLoopBackOff behavior
- Interpreted exit codes (0, 1, 127, 137, 143)
- Understood backoff timing (10s → 300s max)

**Skills Gained:**
- Restart policy selection per workload type
- Exit code interpretation
- CrashLoopBackOff debugging
- Container lifecycle understanding

**Policy Selection:** Always for web servers, OnFailure for batch jobs, Never for one-time tasks

---

### Project 11: Multi-Container Pods

**Objective:** Sidecar pattern and Init containers

**Implementation:**
- Created pods with multiple containers sharing network namespace
- Shared volumes between containers
- Implemented init containers for dependencies
- Tested localhost communication between containers
- Observed init container execution before main containers

**Skills Gained:**
- Multi-container pod patterns
- Shared volume usage
- Init container implementation
- Container execution order
- Sidecar, adapter, ambassador patterns

**Real Scenario:** Data preparation container writing files, nginx serving them in real-time

---

## Projects 12-22: Advanced Kubernetes

### Project 12: Scheduling - nodeSelector & nodeName

**Objective:** Control pod placement on specific nodes

**Implementation:**
- Added labels to worker nodes
- Used nodeSelector for label-based placement
- Used nodeName for direct node assignment
- Created resource constraints affecting scheduling
- Debugged Pending pods due to unmet selectors

**Skills Gained:**
- Node labeling strategies
- Basic pod placement control
- Scheduling constraint understanding
- Resource-aware scheduling

---

### Project 13: DaemonSets

**Objective:** Deploy one pod per node automatically

**Implementation:**
- Created DaemonSets for cluster-wide services
- Observed automatic pod distribution across all nodes
- Applied nodeSelector to DaemonSets for targeted nodes
- Tested automatic pod creation on node join

**Skills Gained:**
- DaemonSet creation and management
- Cluster-wide service deployment
- Automatic pod distribution understanding

**Use Cases:** Log collectors, monitoring agents, network proxies

---

### Project 14: Static Pods

**Objective:** kubelet-managed pods independent of API server

**Implementation:**
- Created static pod manifests in kubelet directory
- Observed automatic pod creation by kubelet
- Tested pod persistence across kubelet restarts
- Deleted static pods by removing manifest files

**Skills Gained:**
- Static pod concept and use cases
- kubelet configuration understanding
- Node-specific pod deployment
- Control plane component architecture

---

### Project 15: Node Affinity

**Objective:** Advanced scheduling with complex rules

**Implementation:**
- Created required affinity rules (hard constraints)
- Created preferred affinity rules (soft constraints)
- Used operators: In, NotIn, Exists, DoesNotExist
- Implemented weight-based preferences
- Combined multiple affinity rules

**Skills Gained:**
- Advanced scheduling expressions
- Required vs Preferred rule differences
- Operator usage and logic
- Complex placement strategies

---

### Project 16: Deployments

**Objective:** Declarative application lifecycle management

**Implementation:**
- Created and managed Deployments
- Executed rolling updates with zero downtime
- Performed rollbacks across 7 revisions
- Used pause/resume for batch updates
- Scaled from 3 to 10 replicas
- Witnessed ReplicaSet label adoption

**Skills Gained:**
- Deployment strategies
- Rolling update procedures
- Rollback mechanisms
- Revision history management
- ReplicaSet behavior
- Production deployment workflows

**Key Discovery:** ReplicaSet automatically adopted bare pods with matching labels

---

### Project 17: Kubernetes Networking

**Objective:** Pod communication and DNS resolution

**Implementation:**
- Tested pod-to-pod communication via IP
- Tested DNS resolution within namespace (short names)
- Tested cross-namespace DNS (FQDN)
- Understood CoreDNS functionality
- Debugged service discovery issues

**Skills Gained:**
- Pod networking fundamentals
- DNS naming conventions (short, namespace-qualified, FQDN)
- Service discovery mechanisms
- Network namespace understanding

---

### Project 18: Network Policies

**Objective:** Pod-level traffic control

**Implementation:**
- Created default deny policies
- Implemented allow rules for specific pods
- Used pod and namespace selectors
- Tested ingress and egress rules
- Verified policy enforcement

**Skills Gained:**
- Network Policy syntax
- Pod-level firewall configuration
- Label-based traffic control
- Zero-trust networking principles

---

### Project 19: Kubernetes Services

**Objective:** Service types and internal/external access

**Implementation:**
- Created ClusterIP services for internal communication
- Created NodePort services for external access
- Tested cross-namespace service access
- Understood service endpoints and selectors
- Debugged DNS resolution issues

**Skills Gained:**
- Service type selection (ClusterIP, NodePort, LoadBalancer)
- Port mapping (port, targetPort, nodePort)
- Service discovery via DNS
- Endpoint management
- Load balancing understanding

**Key Learning:** Cross-namespace requires namespace-qualified names or FQDN

---

### Project 20: Kubernetes Ingress

**Objective:** HTTP routing with domain names

**Implementation:**
- Installed Nginx Ingress Controller v1.13.2
- Created Ingress resources with host-based routing
- Routed 2 applications through single entry point
- Configured domain-based traffic routing
- Tested with curl using Host headers

**Skills Gained:**
- Ingress Controller deployment
- Ingress resource configuration
- Host-based routing rules
- HTTP traffic management

**Challenge Solved:** Fixed Ingress Controller pods stuck in Pending by adding required node label

---

### Project 21: Kubernetes Storage

**Objective:** Persistent storage architecture

**Implementation:**
- Tested hostPath volumes (node filesystem)
- Tested emptyDir volumes (pod lifetime)
- Implemented multi-container volume sharing
- Created StorageClass with WaitForFirstConsumer binding
- Built complete PV/PVC architecture
- Tested reclaim policies (Retain, Delete)

**Skills Gained:**
- Volume type selection and lifecycle
- PersistentVolume/PersistentVolumeClaim workflow
- StorageClass configuration
- Data persistence strategies
- Multi-container data sharing

**Key Experiments:**
- Container restart: emptyDir survives ✅
- Pod deletion: hostPath survives, emptyDir lost ✅
- Real-time file sharing between containers ✅

---

### Project 22: Helm S3 Repository

**Objective:** Private Helm chart repository on AWS S3

**Implementation:**
- Set up AWS S3 bucket as Helm repository
- Installed helm-s3 plugin v0.17.1
- Created and customized Helm charts
- Fixed service template issues (missing selector)
- Packaged and versioned charts
- Performed install, upgrade, and rollback operations
- Automated repository setup with scripts

**Skills Gained:**
- Helm chart creation and templating
- Private repository configuration
- Chart versioning and distribution
- AWS S3 integration
- Plugin installation and troubleshooting

**Issues Resolved:**
- helm-s3 plugin getter/v1 installation → Created wrapper script
- Service template missing selector → Added selector logic
- Plugin verification failure → Used `--verify=false` flag
- NodePort conditional logic → Implemented template conditions

---

## 🎓 Kubernetes Fundamentals Summary (Projects 1-22)

### Learning Modules Completed

```
Foundation (1-4):     Cluster setup, operations, upgrades
Security (5-6):       RBAC, authentication, permissions  
Config & Health (7-9): ConfigMaps, Resources, Probes
Policies (10-12):     Restarts, Multi-container, Scheduling
Advanced (13-15):     DaemonSets, Static Pods, Affinity
Scaling (16):         Deployments, Updates, Rollbacks
Networking (17-18):   Communication, DNS, Policies
Services (19-20):     Service types, Ingress routing
Storage (21):         Volumes, PV/PVC, Persistence
Packages (22):        Helm, Charts, Private repository
```

### Core Statistics

- **Total Projects:** 22 comprehensive modules
- **YAML Files:** 146 configuration files
- **Documentation:** 22 READMEs + 22 command references
- **Clusters Built:** 2 (Minikube + 3-node production)
- **Cluster Uptime:** 15+ days with restart persistence
- **Upgrade Phases:** 3 (v1.31 → v1.34)
- **Services Created:** 6+ (ClusterIP, NodePort)
- **Deployment Revisions:** 7 (with rollbacks tested)
- **Storage Tests:** 3 volume types
- **Helm Charts:** 1 custom chart with fixes

---

## 🏗️ Microservices & Service Mesh

### Food Delivery Platform (Production Microservices)

**Architecture:**
```
4-Service Microservices Platform
├── User Service (Authentication) - 2 replicas
├── Restaurant Service (Catalog) - 2-3 replicas  
├── Order Service (Order management) - 2 replicas
└── Payment Service (Payment processing) - 2 replicas
```

**Infrastructure:**
- API Gateway: NGINX + Istio Gateway
- Total Pods: 9 application pods
- Service Pattern: Independent microservices
- Communication: Kubernetes DNS service discovery
- Routing: Path-based routing (/api/users, /api/restaurants, /api/orders, /api/payments)

**Implementation Details:**
- Each service deployable independently
- Separate scaling per service
- Load balancing across replicas
- Health checks configured
- Resource limits defined

---

### Istio Service Mesh Deployment

**Installation:**
- **Method:** Helm v4.0.1 (3-chart approach)
- **Version:** Istio 1.28.1
- **Charts Deployed:**
  1. istio-base (Custom Resource Definitions)
  2. istiod (Control Plane)
  3. istio-ingress (Gateway)

**Configuration Implemented:**
- Automatic sidecar injection via namespace labeling
- Envoy proxy injection: 11 sidecars across services
- Gateway resource for external traffic entry
- VirtualService for path-based routing rules
- DestinationRule for traffic subsets (v1, v2)
- Telemetry configuration (100% sampling)

**Skills Gained:**
- Helm-based service mesh installation
- Sidecar injection mechanisms
- Gateway and VirtualService configuration
- DestinationRule subset creation
- istioctl CLI usage
- Service mesh verification

**Architecture Transformation:**
```
Before: 9 pods with 1 container each (9 containers)
After:  9 pods with 2 containers each (18 containers)
        Application + Envoy sidecar pattern
```

---

### Observability Stack

**Tools Deployed:**

**Kiali (Service Mesh Visualization):**
- Real-time service topology graph
- Traffic flow animation
- Health status monitoring per service
- Request and error rate visualization
- Service dependency mapping

**Grafana (Metrics Dashboards):**
- Pre-built Istio dashboards
- Service-level metrics visualization
- Resource usage monitoring
- Time-series graph analysis
- Custom dashboard creation

**Prometheus (Metrics Collection):**
- Time-series database deployment
- Metrics scraping from all services
- Custom query capabilities (PromQL)
- All targets monitored and healthy
- Data retention configuration

**Jaeger (Tracing Infrastructure):**
- Distributed tracing infrastructure deployed
- Zipkin provider integration configured
- Request flow tracking capability

**Deployment Method:**
- Installed via Istio sample addons
- Configured dashboard access via port-forwarding
- Integrated with Istio telemetry pipeline

**Skills Gained:**
- Complete observability stack deployment
- Metrics collection and visualization
- Service health monitoring
- Real-time traffic analysis
- Dashboard configuration and management

---

### Auto-Scaling Infrastructure

**Metrics Server:**
- Installed for cluster-wide metrics collection
- Patched for bare-metal compatibility (`--kubelet-insecure-tls`)
- Enabled kubectl top functionality
- Provided data source for HPA

**Horizontal Pod Autoscaler (HPA):**
- Configuration: Min 3, Max 20 pods, 70% CPU target
- Added resource requests to all pods for metric calculation
- Tested auto scale-up under load
- Tested auto scale-down during idle
- Observed scaling behavior in real-time

**Scaling Testing:**
- Manual scaling: 2 → 9 → 3 replicas
- Automatic scaling with CPU-based triggers
- Load generation for testing
- Scale-to-zero testing (via Knative - later removed)

**Skills Gained:**
- Metrics Server installation and troubleshooting
- HPA creation and configuration
- Resource-based auto-scaling
- Load testing strategies
- Scaling behavior observation

---

### Helm Package Management (Advanced Usage)

**Private Chart Repository (Project 22):**
- AWS S3 bucket configured as Helm repository
- helm-s3 plugin installed with workarounds
- Chart packaging and versioning
- Repository automation via scripts

**Chart Development:**
- Created custom Helm charts
- Fixed service templates (missing selector)
- Implemented conditional NodePort logic
- Managed chart versions and releases

**Istio Installation via Helm:**
- Installed Istio using production Helm approach
- Managed 3 separate chart releases
- Configured values for customization
- Achieved clean upgrade/uninstall capability

**Skills Gained:**
- Private repository setup and management
- Plugin troubleshooting and fixes
- Production Helm workflows
- Chart templating and debugging
- Release lifecycle management
- Multi-chart application deployment

---

## 🎯 Complete Technical Skill Set

### Cluster Operations
✅ Cluster installation (kubeadm, Minikube)  
✅ Multi-version upgrades (v1.31 → v1.34)  
✅ Node maintenance (drain, cordon, uncordon)  
✅ Cluster monitoring (Metrics Server)  
✅ Persistence configuration (15+ days tested)  

### Security & Access Control
✅ RBAC for users (certificate-based authentication)  
✅ RBAC for pods (ServiceAccounts)  
✅ Secret management (base64, volume mounting)  
✅ Network Policies (ingress/egress rules)  
✅ Pod security contexts  

### Application Management
✅ Deployments (rolling updates, rollbacks)  
✅ ConfigMaps and Secrets  
✅ Health probes (liveness, readiness, startup)  
✅ Resource management (requests, limits, QoS)  
✅ Multi-container patterns (sidecar, init)  
✅ Restart policies

### Scheduling & Placement
✅ nodeSelector and nodeName  
✅ Node Affinity (required, preferred, operators)  
✅ Taints and Tolerations  
✅ DaemonSets (one pod per node)  
✅ Static Pods (kubelet-managed)  

### Networking
✅ Pod-to-pod communication  
✅ Services (ClusterIP, NodePort, LoadBalancer)  
✅ DNS resolution (short names, FQDN)  
✅ Cross-namespace communication  
✅ Network Policies (pod firewall)  
✅ Ingress routing (host-based)  

### Storage
✅ Volume types (emptyDir, hostPath, PVC)  
✅ PersistentVolume/PersistentVolumeClaim workflow  
✅ StorageClass configuration  
✅ Volume lifecycle understanding  
✅ Data persistence verification  
✅ Multi-container volume sharing  

### Package Management
✅ Helm chart creation and customization  
✅ Private repository (AWS S3)  
✅ Chart versioning and distribution  
✅ Release management (install, upgrade, rollback)  
✅ Template troubleshooting  

### Service Mesh
✅ Istio installation via Helm  
✅ Sidecar injection (automatic)  
✅ Gateway configuration  
✅ VirtualService routing  
✅ DestinationRule subsets  
✅ Service mesh verification  

### Observability
✅ Kiali (service topology)  
✅ Grafana (metrics dashboards)  
✅ Prometheus (metrics collection)  
✅ Jaeger (tracing infrastructure)  
✅ Metrics Server (resource metrics)  

### Auto-Scaling
✅ Manual scaling strategies  
✅ HPA configuration and testing  
✅ CPU-based scaling triggers  
✅ Load testing for scale verification  

---

## 📊 Platform Statistics

### Infrastructure
- **Nodes:** 3-node production cluster
- **Total Pods:** 40+ across all namespaces
- **Namespaces:** 6 active namespaces
- **Deployments:** 9 application deployments

### Microservices Platform
- **Services:** 4 microservices + 1 gateway
- **Replicas:** 9 application pods
- **Containers:** 18 total (9 apps + 9 sidecars)
- **Istio Proxies:** 11 Envoy sidecars

### Observability
- **Monitoring Tools:** 4 (Kiali, Grafana, Prometheus, Jaeger)
- **Metrics Targets:** All healthy
- **Dashboards:** Pre-configured Istio dashboards
- **Telemetry:** 100% request sampling

### Configuration Files
- **Docker:** 20+ files
- **Kubernetes YAML:** 146 files
- **Scripts:** 15+ automation scripts
- **Documentation:** 46 READMEs and guides
- **Total:** 180+ files

---

## 🛠️ Technologies & Tools

### Core Kubernetes
- Kubernetes: v1.31.13 - v1.34.1
- kubeadm, kubectl, Minikube v1.37.0
- containerd (container runtime)
- Calico CNI v3.28.0
- CoreDNS
- Nginx Ingress Controller v1.13.2

### Service Mesh & Monitoring
- Istio: v1.28.1
- Envoy Proxy (11 sidecars)
- Kiali (service graph)
- Grafana (dashboards)
- Prometheus (metrics)
- Jaeger (tracing)
- Metrics Server

### Package Management
- Helm: v4.0.1
- helm-s3 plugin: v0.17.1
- AWS CLI: v2.32.9
- AWS S3 (chart repository)

### Development Environment
- Ubuntu: 24.04
- Cloud Platform: AWS EC2
- Instance Types: t2.medium, t2.large

---

## 🏆 Key Achievements

### Infrastructure
- Built 3-node production Kubernetes cluster from scratch
- Executed 3-phase cluster upgrade (v1.31 → v1.34)
- Achieved 15+ days uptime with restart persistence
- Configured automated cluster startup with systemd

### Applications
- Deployed 5 Docker applications
- Built 4-service microservices platform
- Implemented API Gateway pattern
- Configured independent service scaling

### Service Mesh
- Deployed Istio v1.28.1 via Helm
- Injected 11 Envoy sidecar proxies
- Configured Gateway and VirtualService
- Prepared for canary deployments

### Observability
- Deployed complete monitoring stack (4 tools)
- Configured service mesh visualization
- Implemented metrics collection
- Set up tracing infrastructure

### Auto-Scaling
- Installed and patched Metrics Server
- Created Horizontal Pod Autoscaler
- Tested scaling (3-20 pods range)
- Verified auto scale-up and scale-down

### Package Management
- Set up private Helm repository on AWS S3
- Created and fixed custom Helm charts
- Automated chart distribution
- Managed application lifecycle via Helm

---

## 💡 Production-Ready Features

```
✅ Multi-node high availability (3-node cluster)
✅ Zero-downtime deployments and upgrades
✅ Automatic scaling (HPA with CPU metrics)
✅ Self-healing applications (health probes)
✅ Service mesh (Istio with sidecar pattern)
✅ Complete observability (Kiali, Grafana, Prometheus)
✅ Microservices architecture (independent services)
✅ API Gateway pattern (NGINX + Istio)
✅ Resource management (requests/limits)
✅ Service discovery (Kubernetes DNS)
✅ Load balancing (automatic)
✅ Network segmentation (Network Policies)
✅ Configuration management (ConfigMaps/Secrets)
✅ Persistent storage (PV/PVC)
✅ Private package repository (Helm S3)
✅ RBAC security (Users + ServiceAccounts)
✅ Advanced scheduling (Affinity, DaemonSets)
✅ Ingress routing (host-based)
```

---

## 🎓 Troubleshooting Experience

### Critical Issues Resolved

**Metrics & Monitoring:**
- Metrics Server TLS errors → Patched with `--kubelet-insecure-tls`
- HPA showing `<unknown>` → Added resource requests to pods
- Prometheus targets down → Verified service endpoints

**Scheduling & Resources:**
- Pods stuck in Pending → Resolved resource constraints
- Ingress Controller pending → Added required node label
- Insufficient CPU errors → Scaled down services appropriately

**Helm & Charts:**
- helm-s3 plugin not found → Created wrapper script
- Service no endpoints → Fixed missing selector in template
- Plugin verification failure → Used `--verify=false` flag

**Istio & Service Mesh:**
- Sidecars not injecting → Labeled namespace correctly
- Gateway configuration → Created VirtualService routing
- Resource constraints → Distributed pods across workers

**Storage:**
- Invalid storage units → Fixed formatting (100mi → 100Mi)
- Volume persistence → Verified lifecycle of each type

**Networking:**
- Cross-namespace DNS → Used FQDN syntax
- Network Policy testing → Verified pod isolation
- Service discovery → Debugged DNS resolution

---

## 🚀 Professional Capabilities

### Can Independently Perform

**Infrastructure:**
- Build production Kubernetes clusters from scratch
- Upgrade clusters across major versions
- Perform zero-downtime maintenance
- Configure networking and storage solutions
- Implement security policies

**Application Deployment:**
- Deploy microservices architectures
- Configure auto-scaling (manual and HPA)
- Implement health checks and self-healing
- Manage external configuration
- Execute rolling updates and rollbacks
- Route traffic with Ingress and Istio

**Service Mesh:**
- Install and configure Istio
- Inject Envoy sidecars automatically
- Create Gateway and VirtualService routing
- Configure traffic management
- Monitor service mesh health

**Observability:**
- Deploy complete monitoring stack
- Visualize service topology
- Monitor metrics and trends
- Track resource usage
- Debug application issues

**DevOps Practices:**
- Infrastructure as Code (IaC)
- GitOps-ready configurations
- Automated deployments via scripts
- Release management with Helm
- Rollback procedures
- Capacity planning

---

## 📂 Repository Structure

```
├── Docker/
│   ├── Docker_compose/
│   ├── Docker_compose_custom_app/
│   └── Docker_compose_wordpress_mysql/
│
├── Kubernetes/
│   ├── 01-minikube-setup/
│   ├── 02-3node-cluster-installation/
│   ├── 03-node-draining/
│   ├── 04-cluster-upgrade/
│   ├── 05-rbac-user-authentication/
│   ├── 06-rbac-serviceaccounts/
│   ├── 07-application-configuration/
│   ├── 08-container-resources/
│   ├── 09-health-probes/
│   ├── 10-restart-policies/
│   ├── 11-multicontainer-pods/
│   ├── 12-scheduling-nodeselector-nodename.../
│   ├── 13-daemonsets/
│   ├── 14-static-pods/
│   ├── 15-node-affinity/
│   ├── 16-deployments/
│   ├── 17-kubernetes-networking/
│   ├── 18-network-policy/
│   ├── 19-k8s_services/
│   ├── 20-ingress/
│   ├── 21-k8s-storage/
│   ├── 22-helm-s3-kubernetes/
│   ├── 23-k8s-microservices/
│   ├── kubectl-commands-reference/
│   ├── PROJECT-INFO.md
│   └── README.md
```

---

## 📈 Essential Commands Reference

### Kubernetes Core
```bash
# Cluster Operations
kubectl get nodes | pods | deployments | services
kubectl describe <resource> <name>
kubectl top nodes | pods
kubectl drain/cordon/uncordon <node>

# Application Management
kubectl apply -f <file.yaml>
kubectl create namespace <name>
kubectl scale deployment <name> --replicas=<n>
kubectl rollout status/undo/history deployment/<name>
kubectl rollout restart deployment/<name>

# Debugging
kubectl logs <pod> -c <container> -f
kubectl exec -it <pod> -- bash
kubectl get events --sort-by='.lastTimestamp'
kubectl describe pod <name>

# Networking
kubectl expose deployment <name>
kubectl get svc,endpoints
kubectl get gateway,virtualservice,destinationrule
kubectl get networkpolicy

# Storage
kubectl get pv,pvc,storageclass
kubectl describe pv <name>

# Security
kubectl create serviceaccount <name>
kubectl create role <name> --verb=get,list --resource=pods
kubectl create rolebinding <name> --role=<role>
kubectl auth can-i <verb> <resource>
```

### Istio
```bash
istioctl version
istioctl proxy-status
istioctl proxy-config <type> <pod>
kubectl label namespace <ns> istio-injection=enabled
kubectl get crd | grep istio
```

### Helm
```bash
helm repo add <name> <url>
helm repo update
helm install <release> <chart> -n <namespace>
helm upgrade <release> <chart> -n <namespace>
helm rollback <release> <revision>
helm list -n <namespace>
helm uninstall <release> -n <namespace>
```

---

## 🎯 Learning Outcomes

### Skill Progression

```
Beginner → Intermediate → Advanced → Production-Ready
   ↓            ↓            ↓              ↓
Docker    Multi-node    Service      Complete
Basics    Clusters      Mesh         Platform
```

**Timeline:**
- Docker Fundamentals: Weeks 1-2
- Kubernetes Basics: Weeks 3-4 (Projects 1-12)
- Kubernetes Advanced: Weeks 5-6 (Projects 13-22)
- Service Mesh & Microservices: Week 7

**Result:** Production-ready DevOps platform in 7 weeks

---

## 🚀 Value Proposition

### Professional Applications

**Demonstrates:**
- Comprehensive containerization knowledge
- Production Kubernetes cluster management
- Advanced orchestration capabilities
- Service mesh deployment experience
- Complete observability implementation
- Troubleshooting and problem-solving skills
- Self-learning and documentation abilities

### For Technical Learners

**Provides:**
- Step-by-step learning progression
- Working configurations ready to use
- Real troubleshooting solutions
- Command references for quick lookup
- Production patterns and best practices
- Complete documentation

### Quality Indicators

- ✅ All configurations tested and verified
- ✅ Every project includes detailed documentation
- ✅ Command references for reproducibility
- ✅ Troubleshooting guides for common issues
- ✅ Automation scripts for repeatability
- ✅ Progressive complexity (beginner to advanced)

---

## 📊 Overall Statistics

**Total Projects:** 27 (5 Docker + 22 Kubernetes + Advanced)  
**Clusters Deployed:** 3 environments  
**Applications Built:** 9 (5 Docker + 4 Microservices)  
**Deployments Created:** 15+  
**Services Configured:** 10+  
**YAML Files:** 160+  
**Scripts Written:** 15+  
**Troubleshooting Sessions:** 20+  
**Uptime Proven:** 15+ days  

---

## 💪 Professional Summary

### Competencies Achieved

**Infrastructure Engineering:**
- Production cluster deployment and maintenance
- Multi-version upgrade execution
- High availability configuration
- Disaster recovery understanding

**Application Deployment:**
- Microservices architecture implementation
- Zero-downtime deployment strategies
- Configuration management
- Health monitoring and auto-recovery

**Advanced Orchestration:**
- Service mesh deployment and configuration
- Complete observability stack
- Auto-scaling infrastructure
- Package management with Helm

**DevOps Practices:**
- Infrastructure as Code
- Automated workflows
- Monitoring and alerting
- Release management
- Documentation and knowledge sharing

### Real-World Experience

- Managed 40+ pods across production cluster
- Executed 7 deployment revisions with rollbacks
- Resolved 20+ troubleshooting scenarios
- Created 15+ automation scripts
- Documented 46 guides and references
- Tested 15+ days cluster persistence

---

*All configurations tested and verified working. Suitable for production reference and educational purposes.*

**Last Updated:** December 8, 2024  
**Learning Duration:** 45+ days intensive hands-on practice  
**Skill Level:** Beginner → Advanced Kubernetes & Service Mesh Engineer

---

## 📝 Notes

- Detailed project breakdowns available in individual project folders
- Each project includes README with learnings and observations
- Command references provided for reproducibility
- Troubleshooting guides document actual issues and solutions
- Scripts available for automation and quick setup

For detailed project information, see `docs/project-info.md`
