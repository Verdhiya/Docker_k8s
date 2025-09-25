```
# Docker & Kubernetes

Complete Containerization to orchestration learning path with hands-on projects and real-world applications.

## 🐳 Docker Expertise

### Projects Built

#### Single Container Applications:
- **3 Nginx Web Servers** (ports 8080, 8081, 8080) with custom HTML content
- **2 MySQL Databases** with persistent volumes and custom data
- **Python Flask API** for health monitoring (port 5000)

#### Multi-Container Applications:
- **WordPress + MySQL Stack** - Full CMS with database backend
- **Node.js + MongoDB Stack** - Custom API with database integration

### Core Skills Mastered

- **Container Lifecycle:** Created, managed, and troubleshot 10+ containers
- **Volume Management:** Implemented named volumes (`mysql_db`) and bind mounts (`/root/testbind/nginx-bind`)
- **Docker Compose:** Built 2 production-ready multi-service applications
- **Custom Images:** Created Dockerfiles for Node.js and Python applications
- **Networking:** Configured service communication and port mapping
- **Production Deployment:** Deployed on AWS EC2 with proper security configurations

### Essential Commands Used

```bash
# Container Management
docker run -d -p 8080:80 nginx
docker ps -a
docker logs <container-name>
docker exec -it <container> bash
docker stop/start/restart <container>

# Volume & Bind Mounts
docker run -d -v mysql_data:/var/lib/mysql mysql:8.4
docker run -d --mount type=bind,source=/host/path,target=/container/path nginx

# Docker Compose
docker compose up -d
docker compose down
docker compose logs -f
docker compose ps
docker compose exec <service> bash

# Image Building
docker build -t custom-app .
docker images
```

### Real-World Troubleshooting

- **Resolved MySQL version conflicts** by recreating volumes
- **Fixed port mapping issues** (corrected 3306:33060 to 3306:3306)
- **Managed EC2 resource constraints** on t2.micro (1GB RAM)
- **Debugged container networking** for inter-service communication
- **Fixed JavaScript template literal syntax** in Node.js applications

### Repository Structure

```
├── Docker_Compose/
│   ├── docker-compose.yml            # WordPress + MySQL
│   ├── Dockerfile.python
│   └── Dockerfile.node
├── Docker_compose_custom_app/
│   ├── Custom-Application.yml        # Node.js + MongoDB
│   ├── dockerfile
│   └── app.js
└── testbind/nginx-bind/
    └── index.html                    # Custom web content
```

### Applications Deployed

1. **Static Website** - Nginx with custom HTML via bind mounts
2. **Database Server** - MySQL with persistent data and custom database/tables  
3. **WordPress CMS** - Full content management system with MySQL backend
4. **RESTful API** - Node.js application with MongoDB integration
5. **Health Monitor** - Python Flask service for application monitoring

**Hands-On | 5 Applications | 10+ Containers Deployed

---

## ☸️ Kubernetes Orchestration (Coming Soon)

Advanced container orchestration, scaling, and cloud-native application deployment.

