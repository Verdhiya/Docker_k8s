
---

### **kubectl Output Formats**

## Common Formats
```bash
kubectl get pods -o wide          # More details
kubectl get pods -o yaml          # Full YAML
kubectl get pods -o json          # JSON format
kubectl get pods -o name          # Just names

---
Custom Columns
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

---
JSONPath
```bash
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pod <name> -o jsonpath='{.status.podIP}'

