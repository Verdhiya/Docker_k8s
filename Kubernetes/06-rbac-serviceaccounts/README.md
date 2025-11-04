# 6: RBAC - ServiceAccounts

ServiceAccount-based authentication for pods and applications.

## ServiceAccounts Created

1. **default** - Auto-created, no permissions
2. **app-reader** - Read pods and logs
3. **my-serviceaccount** - With automountServiceAccountToken disabled

## Key Concepts

- ServiceAccounts are for PODS (not humans)
- Automatic token mounting in pods
- RBAC works same as user accounts
- Best practice: Create dedicated SA per application

## Use Cases

- CI/CD pipelines (Jenkins, GitLab)
- Monitoring systems (Prometheus)
- Logging agents (Fluentd)
- Custom applications needing K8s API access
