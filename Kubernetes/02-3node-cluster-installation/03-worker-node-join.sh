#!/bin/bash
# Run on EACH worker node

echo "Paste the join command from master node:"
echo "Example: sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
echo ""
read -p "Paste join command: " JOIN_CMD

# Execute join
eval "sudo $JOIN_CMD"

echo "✅ Worker joined! Verify on master: kubectl get nodes"
