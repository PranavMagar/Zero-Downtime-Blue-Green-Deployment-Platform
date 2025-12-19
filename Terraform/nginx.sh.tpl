#!/bin/bash
set -e

sudo apt update
sudo apt install -y nginx

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default

# Create our reverse proxy config
cat <<EOF | sudo tee /etc/nginx/sites-available/bluegreen
server {
    listen 80 default_server;
    server_name _;

    location / {
        proxy_pass http://${ACTIVE_IP}:5000;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable config
sudo ln -s /etc/nginx/sites-available/bluegreen /etc/nginx/sites-enabled/bluegreen

# Test and reload
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx
