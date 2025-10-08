# Project 2: Production-Grade 3-Node Kubernetes Cluster

**Architecture:** 1 Master + 2 Workers  
**Instance Type:** AWS EC2 t2.medium  
**OS:** Ubuntu 24.04  
**Initial Version:** v1.31.13  
**Container Runtime:** containerd  
**CNI Plugin:** Calico v3.28.0  

## Setup Overview

1. Configure all 3 nodes (master + workers)
2. Initialize master node
3. Join worker nodes to cluster
4. Verify cluster health

## Result

✅ 3-node cluster operational  
✅ All nodes in Ready state  
✅ Calico networking functional  
✅ Production-ready configuration  
