# Project 02 - AWS EC2 NGINX Web Server

## Project Summary

This project demonstrates deploying and securing a basic Linux web server on AWS EC2.

The goal is to repeat the local Ubuntu VM NGINX workflow in the cloud using AWS infrastructure, SSH key authentication, EC2, Security Groups, and Linux server administration.

## Skills Demonstrated

- AWS EC2 instance deployment
- AWS key pair usage
- SSH access to a cloud Linux server
- Security Group configuration
- Linux package management with `apt`
- NGINX installation and service management
- HTTP access over port 80
- Service troubleshooting with `systemctl`
- Port verification with `ss`
- Web testing with `curl`
- Cloud security basics using least privilege

## Planned Environment

- Cloud Provider: AWS
- Compute: EC2
- OS: Ubuntu Server
- Access Method: SSH key pair
- Web Server: NGINX
- Firewall Layer 1: AWS Security Group
- Firewall Layer 2: Optional Linux UFW
- Protocols:
  - SSH: port 22
  - HTTP: port 80

## Architecture

```text
My Computer
   |
   | SSH using AWS key pair
   v
AWS EC2 Instance
   |
   | Security Group allows port 22
   | Security Group allows port 80
   v
Ubuntu Linux Server
   |
   | NGINX listens on port 80
   v
Public web page served over HTTP
```

## Project Goals

- Launch an EC2 instance.
- Configure a Security Group for SSH and HTTP.
- Connect to the instance using SSH.
- Install NGINX.
- Confirm NGINX is running.
- Confirm port 80 is listening.
- Test the web page locally from the instance.
- Test the web page externally from a browser.
- Document troubleshooting steps and security decisions.

## Commands Preview

```bash
ssh -i <key-file>.pem ubuntu@<ec2-public-ip>

sudo apt update
sudo apt install nginx -y

systemctl status nginx
curl localhost

sudo ss -tulnp | grep ':80'
journalctl -u nginx --no-pager | tail -n 20
```

## Security Considerations

- SSH should use key-based authentication.
- Security Groups should only allow required inbound traffic.
- Port 22 should ideally be restricted to my IP address.
- Port 80 can be opened to the internet for a public web test.
- Port 443 should not be opened until HTTPS/TLS is configured.
- The EC2 instance should be stopped or terminated when not needed to avoid cost.

## Related Local Project

This project builds on:

```text
projects/project-01-linux-web-server/
```

The local project taught the Linux side. This project applies that same pattern in AWS.

## Status

Planned. AWS build not started yet.
