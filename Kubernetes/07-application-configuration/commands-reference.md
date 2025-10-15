# Commands Reference - Application Configuration

---

#### ConfigMap Commands
```bash
# Apply ConfigMap from YAML
kubectl apply -f example-configmap.yml
```
#### View all ConfigMaps
```bash
kubectl get configmaps
```
#### Describe specific ConfigMap
```bash
kubectl describe configmap player-pro-demo
```
#### View ConfigMap in YAML
```bash
kubectl get configmap player-pro-demo -o yaml
```
#### Create ConfigMap from file
```bash
kubectl create configmap nginx-config-file --from-file=nginx.conf
```
#### Delete ConfigMap
```bash
kubectl delete configmap player-pro-demo
```
#### Secret Commands
```bash
# Encode values to base64
echo -n 'admin' | base64
echo -n 'admin321' | base64
```
#### Apply Secret from YAML
```bash
kubectl apply -f example-secret.yml
```
#### View all Secrets
```bash
kubectl get secrets
```
#### Describe Secret (values hidden)
```bash
kubectl describe secrets example-secret
```
#### View Secret in YAML (base64 encoded)
```bash
kubectl get secret example-secret -o yaml
```
#### Decode Secret value
```bash
kubectl get secret example-secret -o jsonpath='{.data.password}' | base64 -d
```
#### Create Secret from file
```bash
kubectl create secret generic nginx-htpasswd --from-file .htpasswd
```
#### Delete Secret
```bash
kubectl delete secret example-secret
```
#### htpasswd Commands
```bash
# Install htpasswd
sudo apt-get update
apt install apache2-utils
```
#### Create password file
```bash
htpasswd -c .htpasswd user
```
#### View encrypted password
```bash
cat .htpasswd
```
#### Create Secret from htpasswd file
```bash
kubectl create secret generic nginx-htpasswd --from-file .htpasswd
```
#### Pod Environment Variable Commands
```bash
# Check environment variables
kubectl exec configmap-env-demo -- env
```
#### Filter specific variables
```bash
kubectl exec configmap-env-demo -- env | grep PLAYER

# Print specific variable
kubectl exec configmap-env-demo -- sh -c 'echo $PLAYER_LIVES'
```
#### Interactive shell
```bash
kubectl exec -it configmap-env-demo -- sh

# Inside: printenv
echo $VAR_NAME
exit
```
#### Volume Mount Commands
```bash
# List mounted files
kubectl exec configmap-vol-demo -- ls -la /etc/config/configMap

# View file content
kubectl exec configmap-vol-demo -- cat /etc/config/configMap/player_lives
```
#### Interactive exploration
```bash
kubectl exec -it configmap-vol-demo -- sh

# Inside: cd /etc/config
ls -la
cat filename
exit
```
#### nginx Testing Commands
```bash
# Get pod IP
kubectl get pods nginx-pod -o wide
```
#### Test without credentials
```bash
curl <pod-ip>
```
#### Test with credentials
```bash
curl -u user:password <pod-ip>
```
