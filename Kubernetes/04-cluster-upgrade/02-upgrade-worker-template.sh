#!/bin/bash
# Template for upgrading worker node
# Run from MASTER for drain/uncordon, SSH to worker for upgrade

VERSION="1.32.9-1.1"
WORKER_NAME="k8s-worker-1"

echo "=== Upgrading $WORKER_NAME to v$VERSION ==="

# Drain worker (run on MASTER)
kubectl drain $WORKER_NAME --ignore-daemonsets --delete-emptydir-data

# SSH to worker and run these:
# sudo apt-mark unhold kubeadm
# sudo apt-get update
# sudo apt-get install -y kubeadm=$VERSION
# sudo apt-mark hold kubeadm
# sudo kubeadm upgrade node
# sudo apt-mark unhold kubelet kubectl
# sudo apt-get install -y kubelet=$VERSION kubectl=$VERSION
# sudo apt-mark hold kubelet kubectl
# sudo systemctl daemon-reload
# sudo systemctl restart kubelet
# exit

# Uncordon worker (run on MASTER)
kubectl uncordon $WORKER_NAME

echo "✅ Worker upgraded!"
