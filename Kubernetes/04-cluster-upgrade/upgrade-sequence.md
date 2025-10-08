# Cluster Upgrade Sequence

## Phase 1: v1.31.13 → v1.32.9

### Add v1.32 repository
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-v1.32-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-v1.32-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes-v1.32.list

```
## Upgrade Order

#### 1. Master node → v1.32.9
#### 2. Worker-1 → v1.32.9
#### 3. Worker-2 → v1.32.9
#### 4. Verify all nodes: kubectl get nodes

## Phase 3: v1.32.9 → v1.33.5
Repeat process with v1.33 repository and version 1.33.5-1.1

## Phase 3: v1.33.5 → v1.34.1
Repeat process with v1.34 repository and version 1.34.1-1.1

## Result
All nodes successfully upgraded from v1.31.13 to v1.34.1 with zero downtime.


