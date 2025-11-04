# 5: RBAC - User Authentication

Certificate-based user authentication with Kubernetes RBAC.

## Created User

**Username:** DevUser  
**Group:** development  
**Namespace:** development  
**Permissions:** Read pods and logs  

## Authentication Method

Certificate-based (x509) authentication signed by Kubernetes CA.

## Components

- User certificates (DevUser.crt, DevUser.key)
- Role (pod-reader)
- RoleBinding (read-pods-binding)
- Context (DevUser-context)
