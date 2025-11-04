
Commands Reference - Application Configuration
ConfigMap Commands
bash
Copy code
# Apply ConfigMap from YAML
kubectl apply -f example-configmap.yml

# View all ConfigMaps
kubectl get configmaps

# Describe specific ConfigMap
kubectl describe configmap player-pro-demo

# View ConfigMap in YAML
kubectl get configmap player-pro-demo -o yaml

# Create ConfigMap from file
kubectl create configmap nginx-config-file --from-file=nginx.conf

# Delete ConfigMap
kubectl delete configmap player-pro-demo
Secret Commands
bash
Copy code
# Encode values to base64
echo -n 'admin' | base64
echo -n 'admin321' | base64

# Apply Secret from YAML
kubectl apply -f example-secret.yml

# View all Secrets
kubectl get secrets

# Describe Secret (values hidden)
kubectl describe secrets example-secret

# View Secret in YAML (base64 encoded)
kubectl get secret example-secret -o yaml

# Decode Secret value
kubectl get secret example-secret -o jsonpath='{.data.password}' | base64 -d

# Create Secret from file
kubectl create secret generic nginx-htpasswd --from-file .htpasswd

# Delete Secret
kubectl delete secret example-secret
htpasswd Commands
bash
Copy code
# Install htpasswd
sudo apt-get update
apt install apache2-utils

# Create password file
htpasswd -c .htpasswd user

# View encrypted password
cat .htpasswd

# Create Secret from htpasswd file
kubectl create secret generic nginx-htpasswd --from-file .htpasswd
Pod Environment Variable Commands
bash
Copy code
# Check environment variables
kubectl exec configmap-env-demo -- env

# Filter specific variables
kubectl exec configmap-env-demo -- env | grep PLAYER

# Print specific variable
kubectl exec configmap-env-demo -- sh -c 'echo $PLAYER_LIVES'

# Interactive shell
kubectl exec -it configmap-env-demo -- sh
# Inside: printenv, echo $VAR_NAME, exit
Volume Mount Commands
bash
Copy code
# List mounted files
kubectl exec configmap-vol-demo -- ls -la /etc/config/configMap

# View file content
kubectl exec configmap-vol-demo -- cat /etc/config/configMap/player_lives

# Interactive exploration
kubectl exec -it configmap-vol-demo -- sh
# Inside: cd /etc/config, ls -la, cat filename, exit
nginx Testing Commands
bash
Copy code
# Get pod IP
kubectl get pods nginx-pod -o wide

# Test without credentials
curl <pod-ip>

# Test with credentials
curl -u user:password <pod-ip>
