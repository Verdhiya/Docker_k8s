#!/bin/bash
# Template for upgrading master node
# Replace VERSION with target version (e.g., 1.32.9-1.1)

VERSION="1.32.9-1.1"
VERSION_SHORT="1.32.9"

echo "=== Upgrading Master to v$VERSION_SHORT ==="

# Upgrade kubeadm
sudo apt-mark unhold kubeadm
sudo apt-get update
sudo apt-get install -y kubeadm=$VERSION
sudo apt-mark hold kubeadm

# Check upgrade plan
sudo kubeadm upgrade plan

# Apply upgrade
sudo kubeadm upgrade apply v$VERSION_SHORT

# Drain master
kubectl drain k8s-master --ignore-daemonsets

# Upgrade kubelet and kubectl
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$VERSION kubectl=$VERSION
sudo apt-mark hold kubelet kubectl

# Restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Uncordon master
kubectl uncordon k8s-master

# Verify
kubectl get nodes

echo "✅ Master upgraded to v$VERSION_SHORT"
