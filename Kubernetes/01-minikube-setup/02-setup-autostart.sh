#!/bin/bash
# Setup Minikube Auto-Start

# Copy service file
sudo cp minikube-autostart.service /etc/systemd/system/minikube.service

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable minikube.service
sudo systemctl start minikube.service

# Verify
sudo systemctl status minikube.service

echo "✅ Auto-start configured!"
