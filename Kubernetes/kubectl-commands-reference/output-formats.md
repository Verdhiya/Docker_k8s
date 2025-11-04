# Kubectl Output Formats Reference

## Standard Output Formats

### Wide Output
Shows additional columns with more information
```bash
kubectl get pods -o wide
kubectl get nodes -o wide
kubectl get services -o wide
```

### YAML Format
Full resource definition in YAML
```bash
kubectl get pod <pod-name> -o yaml
kubectl get deployment <name> -o yaml
kubectl get all -o yaml
```

### JSON Format
Full resource definition in JSON
```bash
kubectl get pod <pod-name> -o json
kubectl get nodes -o json
```

### Name Only
Only resource names
```bash
kubectl get pods -o name
kubectl get all -o name
```

### Custom Columns
Define custom output columns
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase
kubectl get pods -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,IP:.status.podIP
kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEMORY:.status.capacity.memory
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
```

### Formatted JSONPath
```bash
# With newlines
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'

# Multiple fields
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# With headers
kubectl get pods -o jsonpath='{range .items[*]}{"Pod: "}{.metadata.name}{" IP: "}{.status.podIP}{"\n"}{end}'
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
```

## Filtering and Sorting

### Field Selector
```bash
kubectl get pods --field-selector status.phase=Running
kubectl get pods --field-selector status.phase!=Running
kubectl get pods --field-selector metadata.namespace=default
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
```

### Watch with Output Format
```bash
kubectl get pods -o wide --watch
kubectl get events --watch
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
```

### Filter and Format
```bash
# Running pods only
kubectl get pods --field-selector status.phase=Running -o custom-columns=NAME:.metadata.name,IP:.status.podIP

# Pods in specific namespace with labels
kubectl get pods -n production -l app=web -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,STATUS:.status.phase
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
