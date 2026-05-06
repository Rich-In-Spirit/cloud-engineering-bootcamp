# AWS EC2 NGINX Architecture

## Planned Architecture

```text
User Browser
   |
   | HTTP request on port 80
   v
AWS Security Group
   |
   | Allows inbound 80/tcp
   v
EC2 Ubuntu Instance
   |
   | NGINX service listening on port 80
   v
Default or custom web page
```

## Admin Access Flow

```text
My Computer
   |
   | SSH using private key
   | Destination: EC2 public IP
   | Port: 22
   v
AWS Security Group
   |
   | Allows inbound 22/tcp from my IP
   v
EC2 Ubuntu Instance
```

## Components

### EC2

EC2 provides the virtual machine running Ubuntu Server.

### Key Pair

The AWS key pair allows SSH access to the EC2 instance.

### Security Group

The Security Group controls inbound and outbound traffic at the AWS network layer.

Planned inbound rules:

```text
SSH   22/tcp   My IP only
HTTP  80/tcp   Anywhere for testing
```

### Ubuntu Server

The operating system running on the EC2 instance.

### NGINX

The web server installed on Ubuntu to serve HTTP traffic.

## Local-to-Cloud Mapping

```text
VirtualBox VM        -> AWS EC2 instance
VirtualBox NAT rule  -> AWS Security Group inbound rule
Local SSH key        -> AWS EC2 key pair
UFW                  -> Host firewall
NGINX local page     -> Public EC2 web page
curl localhost       -> Local service test from inside EC2
Browser test         -> External web access test
```

## Key Troubleshooting Questions

```text
Does the EC2 instance have a public IP?
Is the Security Group allowing SSH?
Is the Security Group allowing HTTP?
Can I SSH into the instance?
Is NGINX installed?
Is NGINX running?
Is NGINX listening on port 80?
Can the instance curl localhost?
Can my browser reach the public IP?
```
