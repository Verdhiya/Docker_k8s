# Kubernetes Hands-On Learning

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

### Technologies Used

- Kubernetes v1.31.13 - v1.34.1
- kubeadm (cluster management)
- Minikube v1.37.0 (single-node)
- containerd (container runtime)
- Calico v3.28.0 (CNI)
- Ubuntu 24.04
- AWS EC2 (t2.medium)

### Skills Acquired

**Cluster Management:**
✅ Cluster installation and configuration  
✅ Multi-version upgrades (3 phases)  
✅ Node operations and maintenance  
✅ Zero-downtime procedures  
✅ Automated cluster startup (systemd)  

**Security & Access Control:**
✅ RBAC security implementation  
✅ Certificate-based authentication  
✅ ServiceAccount permissions  
✅ Secret management  
✅ HTTP basic authentication (htpasswd)  

**Application Management:**
✅ ConfigMaps for configuration  
✅ Secrets for sensitive data  
✅ Environment variables and volume mounts  
✅ Resource requests and limits  
✅ QoS classes (BestEffort, Burstable, Guaranteed)  
✅ Health probes and self-healing  

**Troubleshooting:**
✅ Debugging CrashLoopBackOff  
✅ Fixing OOMKilled containers  
✅ Configuration error resolution  
✅ Pod scheduling issues  
✅ Production-grade best practices  

### Key Achievements

**Cluster Operations:**
- Installed 3-node production-grade cluster from scratch
- Performed 3-phase upgrade across major versions (v1.31 → v1.32 → v1.33 → v1.34)
- Managed node maintenance with zero downtime
- Configured automated cluster startup and data persistence

**Application Deployment:**
- Built nginx web server with htpasswd authentication
- Configured applications using ConfigMaps and Secrets
- Implemented resource management (CPU/Memory)
- Set up self-healing with health probes

**Security Implementation:**
- Implemented enterprise RBAC for users and applications
- Created certificate-based authentication
- Configured ServiceAccounts with proper permissions
- Secured nginx with encrypted passwords

**Debugging & Problem Solving:**
- Fixed nginx CrashLoopBackOff (missing semicolons)
- Debugged OOMKilled containers (memory limit exceeded)
- Resolved volume mounting issues (subPath technique)
- Fixed pod Pending issues (resource constraints)
- Observed and understood Exit Code 137

### Repository Contents

- **59 files** across 11 directories
- **21 YAML configuration files** from hands-on practice
- **9 README documentation files** explaining each project
- **6 command reference files** for quick lookup
- **4 shell scripts** for automation

---

## Project Details

**Projects 1-4:** Infrastructure & Operations  
**Projects 5-6:** Security & Access Control  
**Projects 7-9:** Application & Pod Management  

Each project includes working configurations, documentation, and troubleshooting notes.

---

*All configurations tested and working.*  
*Demonstrates production-ready Kubernetes skills suitable for DevOps/Platform Engineer roles.*

Last Updated: October 14, 2025
