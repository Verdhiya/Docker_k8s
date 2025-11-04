#!/bin/bash
# Minikube Installation on Ubuntu 24.04

# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y curl wget apt-transport-https

# Install Docker/containerd
sudo apt-get install -y containerd
sudo systemctl enable containerd
sudo systemctl start containerd

# Install kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Fix permissions
sudo sysctl -w fs.protected_regular=0
echo "fs.protected_regular=0" | sudo tee -a /etc/sysctl.conf

# Start Minikube
sudo minikube start --vm-driver=none

# Verify installation
kubectl get nodes

echo "✅ Minikube installation complete!"
