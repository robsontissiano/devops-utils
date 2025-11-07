# Docker Utilities and Commands

A comprehensive collection of Docker commands, one-liners, and useful utilities for container management.

## Essential One-Liners

### Stop and Remove All Containers
```bash
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)
```
This command stops all running containers and then removes them. Useful for cleaning up your Docker environment.

### Clean, Build, and Start with Docker Compose
```bash
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker-compose build; docker-compose up -d
```
A complete workflow that:
1. Stops all running containers
2. Removes all containers
3. Rebuilds Docker Compose services
4. Starts services in detached mode

### Remove All Images
```bash
docker rmi $(docker images -q)
```
Removes all Docker images from your system.

### Remove All Dangling Images
```bash
docker rmi $(docker images -f "dangling=true" -q)
```
Removes only unused (dangling) images to free up space.

### Complete Docker System Cleanup
```bash
docker system prune -a --volumes
```
Removes all stopped containers, unused networks, dangling images, and optionally volumes.

## Basic Docker Commands

### Container Management

**List Running Containers:**
```bash
docker ps
```

**List All Containers (including stopped):**
```bash
docker ps -a
```

**Start a Container:**
```bash
docker start <container-name>
```

**Stop a Container:**
```bash
docker stop <container-name>
```

**Restart a Container:**
```bash
docker restart <container-name>
```

**Remove a Container:**
```bash
docker rm <container-name>
```

**Remove a Running Container (force):**
```bash
docker rm -f <container-name>
```

### Image Management

**List Images:**
```bash
docker images
```

**Pull an Image:**
```bash
docker pull <image-name>:<tag>
```

**Build an Image:**
```bash
docker build -t <image-name>:<tag> .
```

**Push to Registry:**
```bash
docker push <image-name>:<tag>
```

**Tag an Image:**
```bash
docker tag <source-image>:<tag> <target-image>:<tag>
```

### Logs and Debugging

**View Container Logs:**
```bash
docker logs <container-name>
```

**Follow Container Logs (real-time):**
```bash
docker logs -f <container-name>
```

**Execute Command in Running Container:**
```bash
docker exec -it <container-name> /bin/bash
```

**Inspect Container:**
```bash
docker inspect <container-name>
```

**View Container Resource Usage:**
```bash
docker stats
```

## Docker Compose Commands

**Start Services:**
```bash
docker-compose up
```

**Start Services in Detached Mode:**
```bash
docker-compose up -d
```

**Stop Services:**
```bash
docker-compose down
```

**Stop and Remove Volumes:**
```bash
docker-compose down -v
```

**Build Services:**
```bash
docker-compose build
```

**View Service Logs:**
```bash
docker-compose logs -f
```

**Scale a Service:**
```bash
docker-compose up -d --scale <service-name>=<number>
```

## Network Commands

**List Networks:**
```bash
docker network ls
```

**Create Network:**
```bash
docker network create <network-name>
```

**Connect Container to Network:**
```bash
docker network connect <network-name> <container-name>
```

**Inspect Network:**
```bash
docker network inspect <network-name>
```

## Volume Commands

**List Volumes:**
```bash
docker volume ls
```

**Create Volume:**
```bash
docker volume create <volume-name>
```

**Remove Volume:**
```bash
docker volume rm <volume-name>
```

**Remove All Unused Volumes:**
```bash
docker volume prune
```

## Advanced One-Liners

### Stop All Containers by Name Pattern
```bash
docker ps -a | grep "<pattern>" | awk '{print $1}' | xargs docker stop
```

### Remove All Exited Containers
```bash
docker rm $(docker ps -a -f status=exited -q)
```

### Get Container IP Address
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-name>
```

### Export Container to Tar
```bash
docker export <container-name> > container-backup.tar
```

### Save Image to Tar
```bash
docker save -o image-backup.tar <image-name>:<tag>
```

### Load Image from Tar
```bash
docker load -i image-backup.tar
```

## Tips and Best Practices

- Always use specific tags instead of `latest` in production
- Use `.dockerignore` to exclude unnecessary files from builds
- Multi-stage builds reduce final image size
- Use health checks in your Docker Compose files
- Regularly clean up unused containers, images, and volumes
- Use Docker BuildKit for faster builds: `DOCKER_BUILDKIT=1 docker build .`

