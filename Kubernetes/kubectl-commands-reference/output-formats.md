# Kubectl Output Formats Reference

## Standard Output Formats

### Wide Output
Shows additional columns with more information
```bash
kubectl get pods -o wide
kubectl get nodes -o wide
kubectl get services -o wide
kubectl get pv -o wide
kubectl get pvc -o wide
```

### YAML Format
Full resource definition in YAML
```bash
kubectl get pod <pod-name> -o yaml
kubectl get deployment <name> -o yaml
kubectl get pv <pv-name> -o yaml
kubectl get pvc <pvc-name> -o yaml
kubectl get all -o yaml
```

### JSON Format
Full resource definition in JSON
```bash
kubectl get pod <pod-name> -o json
kubectl get nodes -o json
kubectl get pv -o json
```

### Name Only
Only resource names
```bash
kubectl get pods -o name
kubectl get pv -o name
kubectl get pvc -o name
kubectl get all -o name
```

### Custom Columns
Define custom output columns
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
kubectl get pods -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,IP:.status.podIP
kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEMORY:.status.capacity.memory
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage,STATUS:.status.phase
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage
```

## JSONPath Queries

### Basic JSONPath
```bash
# Get pod names
kubectl get pods -o jsonpath='{.items[*].metadata.name}'

# Get pod IPs
kubectl get pods -o jsonpath='{.items[*].status.podIP}'

# Get node names
kubectl get nodes -o jsonpath='{.items[*].metadata.name}'

# Get PV names
kubectl get pv -o jsonpath='{.items[*].metadata.name}'

# Get PVC status
kubectl get pvc -o jsonpath='{.items[*].status.phase}'
```

### Formatted JSONPath
```bash
# With newlines
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'

# Multiple fields
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# With headers
kubectl get pods -o jsonpath='{range .items[*]}{"Pod: "}{.metadata.name}{" IP: "}{.status.podIP}{"\n"}{end}'

# PV capacity and status
kubectl get pv -o jsonpath='{range .items[*]}{"PV: "}{.metadata.name}{" Capacity: "}{.spec.capacity.storage}{" Status: "}{.status.phase}{"\n"}{end}'
```

### Complex JSONPath Examples
```bash
# Get container images
kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}'

# Get container names and images
kubectl get pods -o jsonpath='{range .items[*]}{"\n"}Pod: {.metadata.name}{"\n"}{range .spec.containers[*]}  Container: {.name} Image: {.image}{"\n"}{end}{end}'

# Get node capacity
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.capacity.cpu}{"\t"}{.status.capacity.memory}{"\n"}{end}'

# Get persistent volume sizes
kubectl get pv -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.capacity.storage}{"\n"}{end}'

# Get service endpoints
kubectl get svc -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.clusterIP}{"\t"}{.spec.ports[*].port}{"\n"}{end}'

# Get PVC and their bound PV
kubectl get pvc -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.volumeName}{"\t"}{.status.phase}{"\n"}{end}'
```

## Filtering and Sorting

### Field Selector
```bash
kubectl get pods --field-selector status.phase=Running
kubectl get pods --field-selector status.phase!=Running
kubectl get pods --field-selector metadata.namespace=default
kubectl get pv --field-selector status.phase=Available
kubectl get pvc --field-selector status.phase=Bound
```

### Label Selector
```bash
kubectl get pods -l app=nginx
kubectl get pods -l 'app in (nginx,apache)'
kubectl get pods -l app=nginx,tier=frontend
kubectl get pods -l 'env!=production'
```

### Sorting
```bash
kubectl get pods --sort-by=.metadata.name
kubectl get pods --sort-by=.metadata.creationTimestamp
kubectl get nodes --sort-by=.status.capacity.cpu
kubectl get pv --sort-by=.spec.capacity.storage
kubectl get pvc --sort-by=.status.capacity.storage
```

## Practical Examples

### Find Pods Using Most CPU
```bash
kubectl top pods --sort-by=cpu
```

### Find Pods Using Most Memory
```bash
kubectl top pods --sort-by=memory
```

### List All Container Images in Use
```bash
kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}' | tr -s '[[:space:]]' '\n' | sort | uniq
```

### Get Pod Names and Their Nodes
```bash
kubectl get pods -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName
```

### Get Services with Their Type and Port
```bash
kubectl get svc -o custom-columns=NAME:.metadata.name,TYPE:.spec.type,PORT:.spec.ports[*].port
```

### Find Not Running Pods
```bash
kubectl get pods --field-selector status.phase!=Running
```

### Get All Images from Deployments
```bash
kubectl get deployments -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}'
```

### Export Resource Definition
```bash
kubectl get pod <pod-name> -o yaml --export > pod-backup.yaml
# Note: --export is deprecated, use this instead:
kubectl get pod <pod-name> -o yaml | kubectl neat > pod-backup.yaml
```

## Watching Resources

### Watch for Changes
```bash
kubectl get pods --watch
kubectl get pods -w
kubectl get pods --watch-only
kubectl get pvc -w
kubectl get pv -w
```

### Watch with Output Format
```bash
kubectl get pods -o wide --watch
kubectl get events --watch
kubectl get pvc -o wide --watch
```

## Combining Commands

### Get Specific Fields
```bash
# Pod IP addresses
kubectl get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP --no-headers

# Node allocatable resources
kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.allocatable.cpu,MEMORY:.status.allocatable.memory

# Container resource requests
kubectl get pods -o custom-columns=NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory
```

### Count Resources
```bash
kubectl get pods --no-headers | wc -l
kubectl get nodes --no-headers | wc -l
kubectl get pv --no-headers | wc -l
kubectl get pvc --no-headers | wc -l
```

### Filter and Format
```bash
# Running pods only
kubectl get pods --field-selector status.phase=Running -o custom-columns=NAME:.metadata.name,IP:.status.podIP

# Pods in specific namespace with labels
kubectl get pods -n production -l app=web -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,STATUS:.status.phase

# Available PVs only
kubectl get pv --field-selector status.phase=Available -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage
```

## Output Comparison

| Format | Use Case | Example |
|--------|----------|---------|
| default | Quick view | `kubectl get pods` |
| wide | More details | `kubectl get pods -o wide` |
| yaml | Full definition, backup | `kubectl get pod nginx -o yaml` |
| json | Scripting, automation | `kubectl get pod nginx -o json` |
| name | Simple listing | `kubectl get pods -o name` |
| custom-columns | Specific fields | `kubectl get pods -o custom-columns=...` |
| jsonpath | Extract specific data | `kubectl get pods -o jsonpath='{...}'` |

## Tips and Tricks

1. **Use aliases** to speed up common commands
2. **Combine with grep** for simple filtering: `kubectl get pods | grep Running`
3. **Use jq** for advanced JSON processing: `kubectl get pods -o json | jq '.items[].metadata.name'`
4. **Save templates** for frequently used custom-columns
5. **Use --dry-run=client** with `-o yaml` to generate resource templates
6. **Combine with watch** to monitor changes in real-time
7. **Use --show-labels** to see all labels at a glance

## Common Pitfalls

- JSONPath in kubectl uses `{...}` not `$.`
- Array indexing starts at 0: `.items[0]`
- Wildcards use `*`: `.items[*]`
- String literals in JSONPath need quotes: `{"\n"}`
- Field selectors are limited compared to label selectors
- Storage units are case-sensitive: `100Mi` not `100mi`

---

## Practical Examples from Modules 19-21

### Module 19: Services and Endpoints

```bash
# Get service ClusterIP
kubectl get svc nginx-service -o jsonpath='{.spec.clusterIP}'
# Output: 10.97.214.191

# Get service selector
kubectl get svc nginx-service -o jsonpath='{.spec.selector}'
# Output: {"app":"frontend"}

# Get service port mapping
kubectl get svc nginx-service -o jsonpath='{.spec.ports[0].port}'
kubectl get svc nginx-service -o jsonpath='{.spec.ports[0].targetPort}'

# Get all service names and their ClusterIPs
kubectl get svc -o custom-columns=NAME:.metadata.name,CLUSTER-IP:.spec.clusterIP,TYPE:.spec.type

# Get service endpoints (pod IPs)
kubectl get endpoints nginx-service -o jsonpath='{.subsets[*].addresses[*].ip}'

# Compare service endpoints with pod IPs
kubectl get pods -l app=frontend -o custom-columns=NAME:.metadata.name,IP:.status.podIP
kubectl get endpoints nginx-service

# Get services with their ports
kubectl get svc -o custom-columns=NAME:.metadata.name,PORT:.spec.ports[*].port,TARGET:.spec.ports[*].targetPort,NODEPORT:.spec.ports[*].nodePort
```

### Module 20: Ingress

```bash
# Get ingress hosts
kubectl get ingress nginx-rules -o jsonpath='{.spec.rules[*].host}'
# Output: nginx-official.example.com magical-nginx.example.com

# Get ingress address
kubectl get ingress nginx-rules -o jsonpath='{.status.loadBalancer.ingress[*].ip}'
# Output: 172.31.19.217

# Get backend service names from ingress
kubectl get ingress nginx-rules -o jsonpath='{.spec.rules[*].http.paths[*].backend.service.name}'

# Get all ingress with hosts and addresses
kubectl get ingress -o custom-columns=NAME:.metadata.name,HOSTS:.spec.rules[*].host,ADDRESS:.status.loadBalancer.ingress[*].ip

# Check ingress controller pods status
kubectl get pods -n ingress-nginx -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName

# Get node labels (used to fix ingress controller)
kubectl get nodes -o custom-columns=NAME:.metadata.name,LABELS:.metadata.labels
```

### Module 21: Storage and Volumes

```bash
# Get PV details
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage,STATUS:.status.phase,CLAIM:.spec.claimRef.name

# Output example:
# NAME               CAPACITY   STATUS      CLAIM
# my-persistnt-vol   1Gi        Available   <none>
# my-persistnt-vol   1Gi        Bound       my-pvc

# Get PVC with bound volume
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage

# Output example:
# NAME     STATUS    VOLUME             CAPACITY
# my-pvc   Bound     my-persistnt-vol   1Gi

# Get StorageClass details
kubectl get sc -o custom-columns=NAME:.metadata.name,PROVISIONER:.provisioner,RECLAIM:.reclaimPolicy,BINDING:.volumeBindingMode

# Get volume mounts from pod
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].volumeMounts[*].mountPath}'

# Get volume types in pod
kubectl get pod shared-multi-container -o jsonpath='{range .spec.volumes[*]}{"Volume: "}{.name}{" Type: "}{.emptyDir}{.hostPath}{.persistentVolumeClaim}{"\n"}{end}'

# Check PV reclaim policy
kubectl get pv -o jsonpath='{.items[*].spec.persistentVolumeReclaimPolicy}'

# Get PV access modes
kubectl get pv -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.accessModes[*]}{"\n"}{end}'

# Get storage class of PVC
kubectl get pvc -o jsonpath='{.items[*].spec.storageClassName}'
```

### Cross-Namespace DNS Testing (Module 19)

```bash
# List pods in different namespace
kubectl get pods -n service-namespace -o custom-columns=NAME:.metadata.name,IP:.status.podIP,NAMESPACE:.metadata.namespace

# Get all services across namespaces
kubectl get svc -A -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP

# Check DNS server (CoreDNS)
kubectl get pods -n kube-system -l k8s-app=kube-dns -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP
```

### Troubleshooting Ingress Controller (Module 20)

```bash
# Check why pod is pending - node affinity issue
kubectl get pod ingress-nginx-controller-xxx -n ingress-nginx -o jsonpath='{.spec.nodeSelector}'
# Output: {"kubernetes.io/os":"linux","minikube.k8s.io/primary":"true"}

# Get node labels to compare
kubectl get node k8s -o jsonpath='{.metadata.labels}' | jq '.'

# Get pod events showing scheduling failure
kubectl get pod ingress-nginx-controller-xxx -n ingress-nginx -o jsonpath='{.status.conditions[?(@.type=="PodScheduled")].message}'

# Check all pods pending in namespace
kubectl get pods -n ingress-nginx --field-selector status.phase=Pending -o custom-columns=NAME:.metadata.name,REASON:.status.conditions[*].reason
```

### Service Discovery Verification

```bash
# Get full service DNS information
kubectl get svc nginx-service -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,CLUSTER-IP:.spec.clusterIP

# List all endpoints with their IPs
kubectl get endpoints -o custom-columns=NAME:.metadata.name,ENDPOINTS:.subsets[*].addresses[*].ip

# Get pods and their corresponding service
kubectl get pods -o custom-columns=NAME:.metadata.name,LABELS:.metadata.labels,IP:.status.podIP
```

### Quick Status Checks

```bash
# One-liner: Check if all ingress backends are healthy
kubectl get ingress nginx-rules -o jsonpath='{range .spec.rules[*].http.paths[*]}{.backend.service.name}{"\n"}{end}' | while read svc; do echo -n "$svc: "; kubectl get endpoints $svc -o jsonpath='{.subsets[*].addresses[*].ip}' && echo; done

# One-liner: Get all services and their endpoint count
kubectl get svc -o json | jq -r '.items[] | "\(.metadata.name): \(.spec.clusterIP) - Endpoints: \(if .spec.selector then "dynamic" else "manual" end)"'

# Check all namespaces for services
kubectl get svc -A -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.spec.type,PORTS:.spec.ports[*].port --sort-by=.metadata.namespace

# One-liner: Get all PVs and their claim status
kubectl get pv -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\t"}{.spec.claimRef.name}{"\n"}{end}'
```

---

## Real Output Examples from Practice

### Service Description Output
```bash
$ kubectl get svc nginx-service -o wide
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
nginx-service   ClusterIP   10.97.214.191   <none>        8080/TCP   4d

$ kubectl get endpoints nginx-service
NAME            ENDPOINTS
nginx-service   10.244.0.212:80,10.244.0.211:80,10.244.0.213:80
```

### Ingress Output
```bash
$ kubectl get ingress nginx-rules
NAME          CLASS    HOSTS                                                  ADDRESS         PORTS   AGE
nginx-rules   <none>   nginx-official.example.com,magical-nginx.example.com   172.31.19.217   80      24m

$ kubectl describe ingress nginx-rules
Name:             nginx-rules
Namespace:        default
Address:          172.31.19.217
Rules:
  Host                        Path  Backends
  ----                        ----  --------
  nginx-official.example.com  /     nginx-official-service:80 (10.244.0.235:80)
  magical-nginx.example.com   /     magical-nginx:80 (10.244.0.236:80)
```

### Storage Output (Module 21)

```bash
$ kubectl get pv -o wide
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    AGE   VOLUMEMODE
my-persistnt-vol   1Gi        RWO            Recycle          Available           local-storage   21m   Filesystem

$ kubectl get pvc -o wide
NAME     STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS    AGE   VOLUMEMODE
my-pvc   Pending                                      local-storage   11m   Filesystem

# After pod created (binding happened):
$ kubectl get pvc -o wide
NAME     STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS    AGE   VOLUMEMODE
my-pvc   Bound    my-persistnt-vol   1Gi        RWO            local-storage   16m   Filesystem

$ kubectl get pv -o wide
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS    AGE   VOLUMEMODE
my-persistnt-vol   1Gi        RWO            Recycle          Bound    default/my-pvc   local-storage   26m   Filesystem

$ kubectl describe storageclass local-storage
Name:            local-storage
IsDefaultClass:  No
Provisioner:           kubernetes.io/no-provisioner
Parameters:            <none>
AllowVolumeExpansion:  True
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     WaitForFirstConsumer

$ kubectl describe pod shared-multi-container | grep -A 5 "Volumes:"
Volumes:
  html:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
```

### Node Labels Output
```bash
$ kubectl get node k8s --show-labels
NAME   STATUS   ROLES           AGE   VERSION   LABELS
k8s    Ready    control-plane   55d   v1.34.0   beta.kubernetes.io/arch=amd64,kubernetes.io/os=linux,minikube.k8s.io/primary=true,...
```

### Storage Lifecycle Outputs

```bash
# PVC pending (WaitForFirstConsumer)
$ kubectl describe pvc my-pvc
Events:
  Type    Reason                Age   Message
  ----    ------                ----  -------
  Normal  WaitForFirstConsumer  12s   waiting for first consumer to be created before binding

# After pod created (bound)
$ kubectl get pvc
NAME     STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS
my-pvc   Bound    my-persistnt-vol   1Gi        RWO            local-storage

# PV lifecycle states
$ kubectl get pv
NAME               CAPACITY   STATUS      # Can be: Available, Bound, Released, Failed
my-persistnt-vol   1Gi        Available   # No claim
my-persistnt-vol   1Gi        Bound       # Claimed by PVC
```

---

## AWS CLI Output Examples (Module 22)

### AWS Credentials Verification
```bash
$ aws --version
aws-cli/2.32.9 Python/3.13.9 Linux/6.14.0-1014-aws exe/x86_64.ubuntu.24

$ aws sts get-caller-identity
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/username"
}
```

### S3 Bucket Operations
```bash
$ aws s3 ls
2025-04-30 15:32:44 existing-bucket-1
2025-12-04 15:14:25 helm-f6rdqusu

$ aws s3 ls s3://helm-f6rdqusu/charts/
                           PRE charts/
2025-12-04 15:14:25         70 index.yaml

$ aws s3 ls s3://helm-f6rdqusu/charts/ --recursive
2025-12-04 15:44:18       4988 charts/hello-world-0.1.0.tgz
2025-12-04 15:44:18        420 charts/index.yaml

$ aws s3api get-bucket-versioning --bucket helm-f6rdqusu
{
    "Status": "Enabled"
}
```

### S3 File Content
```bash
$ aws s3 cp s3://helm-f6rdqusu/charts/index.yaml - | cat
apiVersion: v1
entries:
  hello-world:
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2025-12-04T15:44:18.123456789Z"
    description: A Helm chart for Kubernetes
    digest: sha256:abc123...
    name: hello-world
    urls:
    - charts/hello-world-0.1.0.tgz
    version: 0.1.0
generated: "2025-12-04T15:44:18.987654321Z"
```

---

## Helm Output Examples (Module 22)

### Helm Version
```bash
$ helm version
version.BuildInfo{Version:"v3.16.3", GitCommit:"cfd07493f46efc9debd9cc1b02a0961186df7fdf", GitTreeState:"clean", GoVersion:"go1.22.7"}
```

### Helm Plugin List
```bash
$ helm plugin list
NAME    VERSION TYPE            APIVERSION      PROVENANCE      SOURCE
s3      0.17.1  getter/v1       legacy          unknown         unknown

# After wrapper created:
$ helm-s3 version
0.17.1
```

### Helm Repository Operations
```bash
$ helm repo list
NAME            URL
bitnami         https://charts.bitnami.com/bitnami
sv-charts       s3://helm-f6rdqusu/charts

$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "sv-charts" chart repository
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈

$ helm search repo sv-charts
NAME                      CHART VERSION   APP VERSION     DESCRIPTION
sv-charts/hello-world     0.1.0           1.16.0          A Helm chart for Kubernetes

$ helm search repo sv-charts/hello-world --versions
NAME                      CHART VERSION   APP VERSION     DESCRIPTION
sv-charts/hello-world     0.1.0           1.16.0          A Helm chart for Kubernetes
```

### helm-s3 Operations
```bash
$ helm-s3 init s3://helm-f6rdqusu/charts
Initialized empty repository at s3://helm-f6rdqusu/charts

$ helm-s3 push hello-world-0.1.0.tgz sv-charts
Successfully uploaded the chart to the repository.

$ helm-s3 push --force hello-world-0.1.0.tgz sv-charts
Successfully uploaded the chart to the repository.
```

### Helm Chart Information
```bash
$ helm show chart sv-charts/hello-world
apiVersion: v2
appVersion: 1.16.0
description: A Helm chart for Kubernetes
name: hello-world
type: application
version: 0.1.0

$ helm show values sv-charts/hello-world
# Default values for hello-world.
replicaCount: 2
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.25"
service:
  type: NodePort
  port: 80
  nodePort: 30080
...

$ helm show all sv-charts/hello-world
# Shows both chart info and values
```

### Helm Release Management
```bash
$ helm install myapp sv-charts/hello-world
NAME: myapp
LAST DEPLOYED: Thu Dec  5 15:45:07 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services myapp-hello-world)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT

$ helm ls
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
myapp   default         1               2025-12-05 15:45:07.123456789 +0000 UTC deployed        hello-world-0.1.0       1.16.0

$ helm ls --all-namespaces
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
myapp   default         1               2025-12-05 15:45:07.123456789 +0000 UTC deployed        hello-world-0.1.0       1.16.0

$ helm status myapp
NAME: myapp
LAST DEPLOYED: Thu Dec  5 15:45:07 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
...

$ helm history myapp
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION
1               Thu Dec  5 15:45:07 2025        deployed        hello-world-0.1.0       1.16.0          Install complete
2               Thu Dec  5 16:10:23 2025        deployed        hello-world-0.1.0       1.16.0          Upgrade complete
3               Thu Dec  5 16:15:44 2025        deployed        hello-world-0.1.0       1.16.0          Rollback to 1

$ helm get values myapp
USER-SUPPLIED VALUES:
service:
  nodePort: 30081

$ helm get manifest myapp
---
# Source: hello-world/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp-hello-world
...
```

### Helm Upgrade and Rollback
```bash
$ helm upgrade myapp sv-charts/hello-world --set replicaCount=3
Release "myapp" has been upgraded. Happy Helming!
NAME: myapp
LAST DEPLOYED: Thu Dec  5 16:10:23 2025
NAMESPACE: default
STATUS: deployed
REVISION: 2
DESCRIPTION: Upgrade complete

$ helm rollback myapp 1
Rollback was a success! Happy Helming!

$ helm history myapp
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION
1               Thu Dec  5 15:45:07 2025        superseded      hello-world-0.1.0       1.16.0          Install complete
2               Thu Dec  5 16:10:23 2025        superseded      hello-world-0.1.0       1.16.0          Upgrade complete
3               Thu Dec  5 16:15:44 2025        deployed        hello-world-0.1.0       1.16.0          Rollback to 1
```

### Helm Package
```bash
$ helm package hello-world/
Successfully packaged chart and saved it to: /root/hello-world-0.1.0.tgz

$ ls -lh hello-world-*.tgz
-rw-r--r-- 1 root root 4.9K Dec  5 15:18 hello-world-0.1.0.tgz
```

### Helm Template Rendering
```bash
$ helm template myapp hello-world/ --dry-run
---
# Source: hello-world/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp-hello-world
...

$ helm install myapp sv-charts/hello-world --dry-run --debug
install.go:214: [debug] Original chart version: ""
install.go:231: [debug] CHART PATH: /root/.cache/helm/repository/hello-world-0.1.0.tgz
...
```

### Helm Errors and Warnings
```bash
$ helm install myapp sv-charts/hello-world
Error: INSTALLATION FAILED: Service "myapp-hello-world" is invalid: spec.ports[0].nodePort: Invalid value: 30080: provided port is already allocated

$ helm install myapp sv-charts/hello-world
level=WARN msg="unable to find exact version; falling back to closest available version" chart=hello-world requested="" selected=0.1.0
NAME: myapp
...

$ helm uninstall myapp
release "myapp" uninstalled
```

### Helm with Kubernetes Integration
```bash
# After helm install
$ kubectl get all -l app.kubernetes.io/instance=myapp
NAME                                    READY   STATUS    RESTARTS   AGE
pod/myapp-hello-world-64c86b877d-5x2fc   1/1     Running   0          55s
pod/myapp-hello-world-64c86b877d-xsh8t   1/1     Running   0          55s

NAME                      TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
service/myapp-hello-world NodePort   10.103.87.1   <none>        80:30081/TCP   55s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/myapp-hello-world   2/2     2            2           9m14s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/myapp-hello-world-64c86b877d   2         2         2       55s

$ kubectl get endpoints myapp-hello-world
NAME                  ENDPOINTS
myapp-hello-world     192.168.230.39:80,192.168.230.40:80

$ kubectl describe svc myapp-hello-world | grep -A 5 Selector
Selector:                 app.kubernetes.io/instance=myapp,app.kubernetes.io/name=hello-world
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.103.87.1
IPs:                      10.103.87.1
```

### Combined Helm and Kubectl Verification
```bash
# Complete workflow verification
$ helm ls
NAME    NAMESPACE       REVISION        STATUS          CHART
myapp   default         1               deployed        hello-world-0.1.0

$ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/myapp-hello-world-xxx               1/1     Running   0          2m

NAME                        TYPE       CLUSTER-IP    PORT(S)
service/myapp-hello-world   NodePort   10.103.87.1   80:30081/TCP

NAME                                READY   UP-TO-DATE   AVAILABLE
deployment.apps/myapp-hello-world   2/2     2            2

NAME                                          DESIRED   CURRENT   READY
replicaset.apps/myapp-hello-world-xxx         2         2         2

$ curl http://localhost:30081
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
</html>
```

---

## Summary of Output Formats

| Tool | Default Format | Alternative Formats |
|------|----------------|-------------------|
| kubectl | Table | `-o wide`, `-o yaml`, `-o json`, `-o jsonpath`, `-o custom-columns` |
| helm | Human-readable | `--output yaml`, `--output json`, `--output table` |
| aws | JSON (default) | `--output text`, `--output table`, `--output yaml` |
| helm-s3 | Human-readable | N/A (uses helm's output) |

---

## Quick Reference: Getting Specific Information

```bash
# Kubernetes Resources
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get svc -o custom-columns=NAME:.metadata.name,IP:.spec.clusterIP
kubectl get pv -o jsonpath='{.items[*].status.phase}'

# Helm Releases
helm ls -o json | jq '.[] | {name: .name, status: .status, chart: .chart}'
helm get values release-name -o json
helm history release-name -o json

# AWS S3
aws s3 ls --output text
aws s3api list-buckets --query 'Buckets[*].Name' --output text
aws s3api get-bucket-versioning --bucket name --output yaml

# helm-s3 (uses standard output)
helm-s3 version
```
