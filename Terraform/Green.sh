#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io

systemctl start docker
systemctl enable docker

docker pull pranavmagar/user-activity-app:latest

# Run GREEN version
docker run -d \
  --name user-activity-green \
  -p 5000:5000 \
  -e APP_VERSION=v2 \
  pranavmagar/user-activity-app:latest
