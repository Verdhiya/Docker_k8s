#!/bin/bash
# Create Kubernetes User with Certificate Authentication

USER_NAME="DevUser"
NAMESPACE="development"

echo "=== Creating user: $USER_NAME ==="

# Create namespace
kubectl create namespace $NAMESPACE

# Generate private key
cd ~/.kube
sudo openssl genrsa -out ${USER_NAME}.key 2048

# Generate CSR
sudo openssl req -new \
  -key ${USER_NAME}.key \
  -out ${USER_NAME}.csr \
  -subj "/CN=${USER_NAME}/O=${NAMESPACE}"

# Sign certificate with Kubernetes CA
sudo openssl x509 -req \
  -in ${USER_NAME}.csr \
  -CA ${HOME}/.minikube/ca.crt \
  -CAkey ${HOME}/.minikube/ca.key \
  -CAcreateserial \
  -out ${USER_NAME}.crt \
  -days 45

# Change ownership
sudo chown $(whoami):$(whoami) ${USER_NAME}.*

# Add user to kubeconfig
kubectl config set-credentials ${USER_NAME} \
  --client-certificate=${HOME}/.kube/${USER_NAME}.crt \
  --client-key=${HOME}/.kube/${USER_NAME}.key

# Create context
kubectl config set-context ${USER_NAME}-context \
  --cluster=minikube \
  --namespace=${NAMESPACE} \
  --user=${USER_NAME}

echo "✅ User created!"
echo "Test: kubectl get pods --context=${USER_NAME}-context"
echo "(Should get Forbidden - no permissions yet)"
