#!/bin/bash
# Run ONLY on MASTER node

echo "=== Initializing Kubernetes Master Node ==="

# Initialize cluster
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Setup kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# Wait for nodes to be ready
echo "Waiting for node to be Ready..."
sleep 30

# Verify
kubectl get nodes
kubectl get pods -A

# Generate join command
echo ""
echo "=== Worker Join Command ==="
kubeadm token create --print-join-command

echo ""
echo "✅ Master node initialized!"
echo "Copy the join command above and run on worker nodes"
