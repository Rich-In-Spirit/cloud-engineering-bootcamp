# AWS EC2 NGINX Build Notes

## Date

May 6, 2026

## Project

Project 02 - AWS EC2 NGINX Web Server

## What I Built

I deployed an Ubuntu Linux server in AWS using EC2 and installed NGINX to serve a public web page.

The server was reachable from the internet using the EC2 public IPv4 address.

## Plain-English Summary

I created a virtual server in AWS, connected to it using SSH key authentication, installed a web server, opened the correct network access with a Security Group, edited the default web page, and confirmed the page worked from my browser.

## AWS Services and Concepts Used

### EC2

EC2 stands for Elastic Compute Cloud.

It provides virtual servers in AWS.

In this project, EC2 was used to run an Ubuntu Linux instance.

### AMI

AMI stands for Amazon Machine Image.

The AMI is the starting image/template for the EC2 instance.

In this project, I used an Ubuntu Server AMI.

### Instance Type

The instance type defines the virtual hardware assigned to the EC2 instance.

It controls resources like:

```text
CPU
RAM
network performance
```

Example:

```text
t2.micro
t3.micro
```

### Key Pair

The AWS key pair was used for SSH access.

The private key stayed on my local machine.

The public key was associated with the EC2 instance by AWS.

### Security Group

The Security Group acted as a virtual firewall around the EC2 instance.

Inbound rules used:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   Anywhere
```

### Public IP

The public IP is reachable from the internet.

I used the public IP to access the NGINX web page from my browser.

### Private IP

The private IP is used inside the AWS VPC/internal AWS network.

I initially tried the private IP in my browser, then realized that my home browser could not directly reach it.

## Security Decisions

### SSH

SSH was restricted to my own public IP.

This is safer than opening SSH to the entire internet.

```text
Better:
22/tcp from my IP only

Riskier:
22/tcp from 0.0.0.0/0
```

### HTTP

HTTP on port 80 was opened to the internet for this lab so I could test the web page publicly.

### HTTPS

HTTPS on port 443 was not opened because TLS/SSL was not configured.

### Cost Control

The EC2 instance was stopped after the lab to avoid unnecessary usage.

## Commands Used

### SSH Into EC2

```powershell
ssh -i .\sal-aws-ec2-lab-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Verify Identity and Networking

```bash
whoami
hostname
ip a
ip route
```

### Install NGINX

```bash
sudo apt update
sudo apt install nginx -y
```

### Check NGINX

```bash
systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
journalctl -u nginx --no-pager | tail -n 20
```

### Customize Web Page

```bash
echo "<h1>Sal's AWS EC2 NGINX Web Server</h1><p>Deployed as Project 02 of my Cloud Engineering Bootcamp.</p>" | sudo tee /var/www/html/index.nginx-debian.html
```

### Test Locally

```bash
curl localhost
```

### Test Externally

```text
http://<EC2_PUBLIC_IP>
```

## Validation

The project was validated in two ways:

### Local Validation From Inside EC2

```bash
curl localhost
```

This proved NGINX was responding from inside the EC2 instance.

### External Validation From Browser

```text
http://<EC2_PUBLIC_IP>
```

This proved the web server was reachable from the internet through the public IP and Security Group rule for port 80.

## Troubleshooting Lessons

### Private IP vs Public IP

I initially tried to access the private IP from my browser.

That did not work because the private IP is only reachable inside the AWS VPC.

The public IP worked because it is internet-facing.

### If curl localhost works but browser fails

Likely issue is outside the server:

```text
Security Group
public IP
route/internet path
browser/network issue
```

### If curl localhost fails

Likely issue is on the server:

```text
NGINX not running
NGINX not installed
NGINX not listening on port 80
local firewall blocking traffic
```

## Local-to-Cloud Mapping

```text
VirtualBox VM              -> AWS EC2 instance
Local Ubuntu Server        -> Ubuntu Server AMI on EC2
Local SSH key auth         -> AWS key pair login
UFW firewall               -> AWS Security Group concept
Local NGINX server         -> EC2 NGINX server
curl localhost             -> same troubleshooting test inside EC2
Browser public IP test     -> external validation
```

## What I Learned

- EC2 is AWS virtual compute.
- An AMI is the starting image/template for an instance.
- An instance type defines the virtual hardware size.
- A Security Group controls network access to an EC2 instance.
- SSH should be restricted to my IP when possible.
- HTTP port 80 can be opened publicly for a web server lab.
- Private IPs are for internal VPC communication.
- Public IPs are used for internet access.
- `curl localhost` proves the service works from inside the server.
- Browser access proves the service is reachable externally.
- The same Linux troubleshooting commands I practiced locally apply to AWS EC2.

## Interview-Ready Explanation

I launched an Ubuntu EC2 instance in AWS, selected an AMI and instance type, created a key pair for SSH access, and configured a Security Group to allow SSH only from my public IP and HTTP from anywhere for the lab. I SSH'd into the instance as the `ubuntu` user, installed NGINX, verified it locally with `curl localhost`, confirmed it was listening on port 80 with `ss`, edited the default HTML page under `/var/www/html`, and confirmed the custom page was reachable externally through the EC2 public IP in my browser.

## Next Step

Next, I should connect this project to AWS Cloud Practitioner exam topics:

```text
EC2
AMI
Instance type
Region
Availability Zone
Security Group
Key pair
Public IP
Private IP
Shared Responsibility Model
Cost control
```
