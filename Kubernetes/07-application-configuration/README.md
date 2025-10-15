# Project 07: Application Configuration

***Hands-on practice with ConfigMaps, Secrets, and nginx authentication.***

---

## Exercise 1: ConfigMap with Multiple Data Types

**File:** `example-configmap.yml`

**What I did:**
```bash
kubectl apply -f example-configmap.yml
kubectl get configmaps
kubectl describe configmap player-pro-demo
```
**What I learned:**
- ConfigMaps can store simple values AND configuration files
- Contains 4 keys: player_lives, properties_file_name, base.properties, user-interface.properties

---

## Exercise 2: POSIX-Style ConfigMap

**File:** `example-posix-configmap.yml`

**What I did:**
```bash
kubectl apply -f example-posix-configmap.yml
kubectl describe configmap player-posix-demo
```
**What I learned:**
- Uppercase keys are standard for environment variables

---

## Exercise 3: Created Secret

**File:** `example-secret.yml`

**What I did:**
```bash
echo -n 'admin' | base64
echo -n 'admin321' | base64
kubectl apply -f example-secret.yml
kubectl get secrets
kubectl describe secrets example-secret
```
**What I learned:**
- Secrets store sensitive data
- Values are base64 encoded
- Not visible in kubectl describe

---

## Exercise 4: ConfigMap as Environment Variables

**File:** `configmap-env-demo.yml`

**What I did:**
```bash
kubectl apply -f configmap-env-demo.yml
kubectl exec configmap-env-demo -it -- sh

**# Inside pod:**
echo $PLAYER_LIVES
echo $PROPERTIES_FILE_NAME
printenv
exit
```
**What I learned:**
- ConfigMap keys become environment variables
- Secret keys also available as env vars

---

## Exercise 5: envFrom - Load All Keys

**File:** `configmap-posix-demo.yml`

**What I did:**
```bash
kubectl apply -f configmap-posix-demo.yml
kubectl exec configmap-posix-demo -it -- /bin/bash

**# Inside pod:**
printenv
exit
```
**What I learned:**
- envFrom loads ALL ConfigMap keys automatically
- Easier than specifying each key individually

---

## Exercise 6: Volume Mounting

**File:** `configmap-vol-demo.yml`

**What I did:**
```bash
kubectl apply -f configmap-vol-demo.yml
kubectl exec configmap-vol-demo -it -- sh

**# Inside pod:**
ls -la /etc/config/configMap
ls -la /etc/config/secret
exit
```
**What I learned:**
- Each ConfigMap key becomes a separate file
- Mounted as symlinks (allows dynamic updates)
- Secret files automatically decoded

---

## Exercise 7: nginx with Authentication

**Files:** `nginx.conf, nginx-pod.yml`

### Step 1: Created htpasswd
```bash
sudo apt-get update
apt install apache2-utils
htpasswd -c .htpasswd user

**# Password: 0258**
cat .htpasswd
kubectl create secret generic nginx-htpasswd --from-file .htpasswd
rm -rf .htpasswd
kubectl describe secrets nginx-htpasswd
```
### Step 2: Created nginx ConfigMap
```bash
kubectl create configmap nginx-config-file --from-file=nginx.conf
kubectl describe configmap nginx-config-file
```
### Step 3: Deployed nginx (First Failed)
```bash
kubectl apply -f nginx-pod.yml
kubectl get pods -o wide
# STATUS: CrashLoopBackOff

kubectl logs nginx-pod
# Error: directive "user" is not terminated by ";"
```
### Step 4: Fixed and Redeployed
```bash
kubectl delete pod nginx-pod
vim nginx.conf
# Added semicolons to all directives

kubectl delete configmap nginx-config-file
kubectl create configmap nginx-config-file --from-file=nginx.conf
kubectl apply -f nginx-pod.yml
kubectl get pods nginx-pod
# STATUS: Running ✅
```
### Step 5: Tested Authentication
```bash
curl 10.244.0.41
# Output: 401 Authorization Required ✅

curl -u user:0258 10.244.0.41
# Output: nginx welcome page ✅
```
**What I learned:**
- htpasswd creates encrypted passwords
- nginx.conf needs semicolons on all directives
- subPath mounts single file without replacing directory
- ConfigMap + Secret work together for secure web server

---

## Debugging & Fixes
- **Issue:** nginx CrashLoopBackOff
- **Cause:** Missing semicolons in nginx.conf
- **Fix:** Added semicolons, recreated ConfigMap
- **Issue:** Volume mount replacing entire directory
- **Fix:** Used subPath to mount only nginx.conf file

---

## Summary

✅ ConfigMaps for configuration (8 files total)

✅ Secrets for sensitive data

✅ Environment variables and volume mounts

✅ nginx with htpasswd authentication working

✅ Debugged CrashLoopBackOff successfully

✅ Used subPath for precise file mounting

---

## Nginx with htpasswd Authentication:

**Files:** `nginx.conf, nginx-pod.yml`

### Step 1: Created encrypted password
```bash
sudo apt-get update
apt install apache2-utils
htpasswd -c .htpasswd user
**# Password: 0258**

cat .htpasswd
**# Output: user:$$apr1$$8kxpswu.$X/fiKqvY5XlycNkThRRJW/**

kubectl create secret generic nginx-htpasswd --from-file .htpasswd
rm -rf .htpasswd
```
### Step 2: Created nginx ConfigMap
```bash
kubectl create configmap nginx-config-file --from-file=nginx.conf
kubectl describe configmap nginx-config-file
```
### Step 3: First Attempt (Failed)
```bash
kubectl apply -f nginx-pod.yml
kubectl get pods -o wide
**# STATUS: CrashLoopBackOff**

kubectl logs nginx-pod
**# Error: directive "user" is not terminated by ";"**
```
### Step 4: Debugged and Fixed
```bash
kubectl delete pod nginx-pod
vim nginx.conf
**# Added semicolons to all directives**

kubectl delete configmap nginx-config-file
kubectl create configmap nginx-config-file --from-file=nginx.conf
kubectl apply -f nginx-pod.yml
kubectl get pods nginx-pod
**# STATUS: Running ✅**
```
### Step 5: Tested Authentication
```bash
curl 10.244.0.41
**# Output: 401 Authorization Required ✅**

curl -u user:0258 10.244.0.41
**# Output: nginx welcome page ✅**
```
**What I learned:**
- htpasswd creates encrypted passwords ($apr1$ = MD5 hash)
- nginx requires semicolons after directives
- subPath mounts single file without replacing directory
- ConfigMap (config) + Secret (password) = Secure web server

---

### All Files in Project 07
- example-configmap.yml
- example-posix-configmap.yml
- example-secret.yml
- configmap-env-demo.yml
- configmap-posix-demo.yml
- configmap-vol-demo.yml
- nginx.conf
- nginx-pod.yml
