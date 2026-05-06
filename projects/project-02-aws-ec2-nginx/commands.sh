#!/bin/bash

# Project 02 - AWS EC2 NGINX Web Server
# Command reference for EC2-side setup and troubleshooting

# Update package list
sudo apt update

# Install NGINX
sudo apt install nginx -y

# Check NGINX service status
systemctl status nginx

# Start NGINX
sudo systemctl start nginx

# Enable NGINX at boot
sudo systemctl enable nginx

# Test local web response
curl localhost

# Check whether NGINX is listening on port 80
sudo ss -tulnp | grep ':80'

# View recent NGINX logs
journalctl -u nginx --no-pager | tail -n 20

# Optional: create a simple custom web page
echo "<h1>EC2 NGINX Web Server</h1><p>Deployed by Sal as part of cloud engineering bootcamp.</p>" | sudo tee /var/www/html/index.nginx-debian.html

# Test again
curl localhost
