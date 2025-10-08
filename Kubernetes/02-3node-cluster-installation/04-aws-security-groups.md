# AWS Security Group Configuration

## Required Inbound Rules (Single Security Group for All Nodes)

| Type | Protocol | Port Range | Source | Description |
|------|----------|-----------|--------|-------------|
| SSH | TCP | 22 | Your IP/32 | SSH access |
| Custom TCP | TCP | 6443 | Your IP/32 | Kubernetes API |
| Custom TCP | TCP | 30000-32767 | Your IP/32 | NodePort services |
| All Traffic | All | All | Same SG ID | Internal cluster communication |

## Configuration Steps

#### 1. EC2 → Security Groups → Select your SG
#### 2. Edit inbound rules
#### 3. Add the 4 rules above
#### 4. Save rules

**Critical:** The "All Traffic from Same SG" rule allows all nodes to communicate internally.
