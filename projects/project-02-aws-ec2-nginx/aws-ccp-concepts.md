# AWS Cloud Practitioner Concepts from Project 02

## Project

Project 02 - AWS EC2 NGINX Web Server

## Purpose

This file maps the EC2 NGINX web server project to AWS Cloud Practitioner concepts.

## EC2

EC2 stands for Elastic Compute Cloud.

EC2 provides virtual servers in AWS.

In this project, EC2 was used to launch an Ubuntu Linux server that hosted an NGINX web page.

## AMI

AMI stands for Amazon Machine Image.

An AMI is the starting template used to launch an EC2 instance.

In this project, I used an Ubuntu Server AMI.

## Instance Type

An instance type defines the virtual hardware assigned to an EC2 instance.

It affects:

```text
CPU
RAM
network performance
cost
workload fit
```

Example instance types include:

```text
t2.micro
t3.micro
```

## Key Pair

A key pair is used for SSH authentication.

In this project:

```text
Private key = stayed on my local computer
Public key = associated with the EC2 instance
```

The private key allowed me to SSH into the instance as the `ubuntu` user.

## Security Group

A Security Group is a virtual firewall for AWS resources like EC2 instances.

Inbound rules used in this project:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   Anywhere
```

## SSH

SSH uses port 22 by default.

In this project, SSH was restricted to my public IP to reduce attack surface.

## HTTP

HTTP uses port 80 by default.

In this project, HTTP was allowed from anywhere so the NGINX web page could be tested publicly from a browser.

## Private IP

The private IP is used for internal communication inside the AWS VPC.

It is not directly reachable from my home browser.

## Public IP

The public IP is internet reachable.

I used the public IP to access the NGINX web page from my browser.

## Shared Responsibility Model

AWS was responsible for the security of the cloud, including the physical data centers, hardware, and underlying cloud infrastructure.

I was responsible for security in the cloud, including:

```text
Security Group rules
SSH key protection
Instance configuration
Installed software
Stopping the instance when done
Not exposing unnecessary ports
```

## Cost Control

The EC2 instance should be stopped or terminated when not being used.

This prevents unnecessary usage charges and supports good cloud cost management.

## Local Validation

```bash
curl localhost
```

This proved NGINX was responding from inside the EC2 instance.

## External Validation

```text
http://<EC2_PUBLIC_IP>
```

This proved the web server was reachable externally through the EC2 public IP and Security Group rule for port 80.

## Key Takeaway

This project connected AWS Cloud Practitioner concepts to a real hands-on build:

```text
EC2 = compute
AMI = server image/template
Instance type = virtual hardware size
Key pair = SSH authentication
Security Group = virtual firewall
Public IP = internet access
Private IP = internal VPC access
Shared Responsibility = AWS secures the cloud, I secure what I deploy in the cloud
```
