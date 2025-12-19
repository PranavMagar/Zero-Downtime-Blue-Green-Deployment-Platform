#!/bin/bash
set -e

# Update system
apt-get update -y

# Install Docker
apt-get install -y docker.io

# Start Docker
systemctl start docker
systemctl enable docker

# Pull app image from Docker Hub
docker pull pranavmagar/user-activity-app:latest

# Run BLUE version
docker run -d \
  --name user-activity-blue \
  -p 5000:5000 \
  -e APP_VERSION=v1 \
  pranavmagar/user-activity-app:latest