# AWS Global Infrastructure and VPC Basics

## Date

May 12, 2026

## Objective

Understand AWS global infrastructure and basic VPC networking by connecting the concepts to my EC2 NGINX web server project.

This lab focused on Regions, Availability Zones, Edge Locations, VPCs, subnets, route tables, Internet Gateways, NAT Gateways, Security Groups, NACLs, and public/private IP behavior.

## Why This Matters

Cloud networking is one of the core foundations of AWS.

Even though I previously deployed an EC2 NGINX web server successfully, I need to understand the network path behind why the browser was able to reach that server.

This lab helped connect the EC2 project to the underlying AWS network structure.

## Core AWS Global Infrastructure Concepts

### Region

An AWS Region is a geographic area where AWS has infrastructure.

Example:

```text
us-east-1 = N. Virginia
```

A Region contains multiple Availability Zones.

Simple version:

```text
Region = geographic AWS area
```

### Availability Zone

An Availability Zone is one or more isolated data centers inside an AWS Region.

Examples:

```text
us-east-1a
us-east-1b
us-east-1c
us-east-1d
```

Availability Zones help with high availability because workloads can be spread across isolated locations within the same Region.

Simple version:

```text
Availability Zone = isolated datacenter zone inside a Region
```

### Edge Location

An Edge Location is used by services like Amazon CloudFront to cache and deliver content closer to users.

Simple version:

```text
Edge Location = closer-to-user location for content delivery
```

### Region vs Availability Zone vs Edge Location

```text
Region = where workloads and data live geographically
Availability Zone = isolated datacenter zone inside a Region
Edge Location = location closer to end users for caching/content delivery
```

## VPC Concepts

### VPC

VPC stands for Virtual Private Cloud.

A VPC is a logically isolated private network inside AWS.

A VPC can contain:

```text
EC2 instances
subnets
route tables
internet gateways
NAT gateways
security groups
network ACLs
```

Simple version:

```text
VPC = my private AWS network
```

Important note:

```text
S3 does not live inside my VPC by default.
```

Amazon S3 is a regional AWS service. Later, VPC endpoints can allow private connectivity from a VPC to S3.

### Subnet

A subnet is a smaller IP range inside a VPC.

Subnets live inside one Availability Zone.

Simple version:

```text
VPC = big private AWS network
Subnet = smaller slice of the VPC inside one AZ
```

Example:

```text
VPC CIDR: 172.31.0.0/16
Subnet/private IP example: 172.31.45.23
```

### Route Table

A route table contains rules that tell traffic where to go.

Simple version:

```text
Route table = traffic directions
```

Example local route:

```text
172.31.0.0/16 -> local
```

This means traffic destined for IPs inside the VPC CIDR stays local inside the VPC.

Example internet route:

```text
0.0.0.0/0 -> Internet Gateway
```

This means all IPv4 traffic that does not match a more specific route goes to the Internet Gateway.

### Internet Gateway

An Internet Gateway allows resources in a VPC to communicate with the internet when routing and addressing are configured correctly.

Simple version:

```text
Internet Gateway = the VPC's internet door
```

For an EC2 web server to be reachable from the internet, it generally needs:

```text
EC2 instance running
Public IPv4 address or public DNS
Subnet route to Internet Gateway
Security Group allowing inbound traffic
Service running and listening on the correct port
```

### NAT Gateway

A NAT Gateway allows resources in a private subnet to initiate outbound internet access without allowing inbound internet connections directly to those private resources.

Simple version:

```text
NAT Gateway = outbound internet access for private subnet resources
```

Example use case:

```text
A private EC2 instance needs to download software updates from the internet but should not be directly reachable from the internet.
```

Traffic pattern:

```text
Private EC2 instance
   ->
NAT Gateway in public subnet
   ->
Internet Gateway
   ->
Internet
```

Important:

```text
NAT Gateway allows outbound internet access from private subnets.
It does not make private instances directly reachable from the internet.
```

## Public and Private Subnets

### Public Subnet

A subnet is public if its route table has a direct route to an Internet Gateway.

Typical route:

```text
0.0.0.0/0 -> Internet Gateway
```

Important lesson:

```text
A public subnet is not public because of its name.
A subnet is public because of its route table.
```

### Private Subnet

A private subnet does not have a direct route to an Internet Gateway.

Private subnet resources may still reach the internet outbound through a NAT Gateway.

Typical private subnet route for outbound internet:

```text
0.0.0.0/0 -> NAT Gateway
```

Simple version:

```text
Public subnet = direct route to Internet Gateway
Private subnet = no direct route to Internet Gateway
```

## Public IP vs Private IP

### Public IP

A public IP is reachable from the internet.

For EC2, a public IP allows users outside AWS to reach the instance if routing and firewall rules allow it.

Simple version:

```text
Public IP = internet-facing address
```

### Private IP

A private IP is used inside a private network.

For EC2, the private IP is used inside the VPC.

Simple version:

```text
Private IP = internal VPC address
```

### EC2 Public IP Behavior

If an EC2 instance uses an automatically assigned public IPv4 address, that public IP can disappear when the instance is stopped.

When the instance is started again, AWS may assign a new public IP.

Important lesson:

```text
Private IP usually remains with the instance while it exists.
Auto-assigned public IP can change after stop/start.
```

## Security Group vs NACL

### Security Group

A Security Group is a virtual firewall attached to AWS resources like EC2 instances.

Key points:

```text
Resource/instance level
Stateful
Allow rules only
Evaluates all rules
Return traffic is automatically allowed
```

Simple version:

```text
Security Group = stateful firewall for AWS resources like EC2
```

Example rules from my EC2 NGINX project:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   Anywhere
```

### NACL

NACL stands for Network Access Control List.

A NACL is a firewall at the subnet level.

Key points:

```text
Subnet level
Stateless
Allow and deny rules
Rules evaluated by number/order
Return traffic must be explicitly allowed
```

Simple version:

```text
NACL = stateless subnet firewall
```

### Stateful vs Stateless

```text
Stateful = return traffic is automatically allowed
Stateless = return traffic must be explicitly allowed
```

### Security Group vs NACL Summary

```text
Security Group:
- Resource/instance level
- Stateful
- Allow rules only
- Best for instance/resource-level control

NACL:
- Subnet level
- Stateless
- Allow and deny rules
- Rules evaluated in order
- Best for subnet-level guardrails
```

## EC2 NGINX Project Networking Review

For my EC2 NGINX project, I inspected the AWS networking information.

### Values Found

```text
Region: us-east-1 / N. Virginia
Availability Zone: us-east-1d
VPC ID: vpc-053ec7d3fa2fa2199
Subnet ID: subnet-052edf1f5fe22699c
Private IPv4: 172.31.45.23
Public IPv4: none shown while instance was stopped
Security Group: project-02-ec2-nginx-sg
```

### Route Table Found

The route table had these routes:

```text
0.0.0.0/0 -> igw-02d61502e9e17de9f
172.31.0.0/16 -> local
```

### What `0.0.0.0/0 -> igw` Means

```text
0.0.0.0/0 -> Internet Gateway
```

This means all IPv4 traffic that does not match a more specific route goes to the Internet Gateway.

This proves the subnet has a direct internet route.

### What `172.31.0.0/16 -> local` Means

```text
172.31.0.0/16 -> local
```

This means traffic destined for IPs inside the VPC CIDR stays local inside the VPC.

My EC2 private IP:

```text
172.31.45.23
```

is inside:

```text
172.31.0.0/16
```

So it belongs to the VPC's private address range.

## Why My EC2 NGINX Page Worked

My browser could reach the NGINX page because these conditions were true at the time:

```text
1. EC2 instance was running.
2. EC2 instance had a public IPv4 address.
3. The subnet route table had 0.0.0.0/0 -> Internet Gateway.
4. Security Group allowed inbound HTTP TCP 80 from 0.0.0.0/0.
5. NGINX was running on the EC2 instance.
6. NGINX was listening on TCP port 80.
7. I used the public IP in the browser, not the private IP.
```

## EC2 Web Server Traffic Flow

### Browser to EC2 NGINX

```text
User browser
   ->
EC2 public IP
   ->
Internet Gateway
   ->
Route table
   ->
Public subnet
   ->
Security Group allows inbound TCP 80
   ->
EC2 instance private IP
   ->
NGINX listening on TCP 80
   ->
Web page loads
```

### SSH to EC2

```text
My computer
   ->
EC2 public IP
   ->
Internet Gateway
   ->
Route table
   ->
Public subnet
   ->
Security Group allows inbound TCP 22 from my public IP
   ->
EC2 instance
   ->
SSH daemon listening on TCP 22
```

## Important Correction: Inbound vs Outbound

For my EC2 NGINX page, browser traffic was inbound from the instance's perspective.

```text
Browser -> EC2 NGINX = inbound TCP 80
```

This is why the Security Group needed an inbound HTTP rule:

```text
HTTP TCP 80 from 0.0.0.0/0
```

## Public Subnet Is Not Enough by Itself

A subnet route to an Internet Gateway is not enough for browser access.

For browser access to an EC2 web server, the instance also needs:

```text
Public IP
Security Group inbound rule
Web service running
Web service listening on the correct port
NACL not blocking traffic
```

Core minimum mental model:

```text
Public IP
Internet Gateway route
Security Group inbound rule
Service listening on the port
```

## What I Learned

- A Region is a geographic AWS area.
- An Availability Zone is one or more isolated data centers inside a Region.
- An Edge Location is used to serve/cached content closer to users.
- A VPC is a logically isolated private network inside AWS.
- S3 does not live inside my VPC by default.
- A subnet is a smaller slice of a VPC inside one AZ.
- A route table controls where traffic goes.
- `0.0.0.0/0 -> Internet Gateway` makes a subnet public.
- `172.31.0.0/16 -> local` means traffic inside the VPC CIDR stays local.
- An Internet Gateway allows VPC resources to communicate with the internet when routing and addressing are correct.
- A NAT Gateway allows private subnet resources to initiate outbound internet access.
- Security Groups are stateful and resource-level.
- NACLs are stateless and subnet-level.
- Port 80 traffic to my EC2 NGINX server was inbound traffic from the instance perspective.
- A stopped EC2 instance may show no public IP because auto-assigned public IPv4 addresses can disappear after stop/start.
- A public subnet route alone does not make an EC2 instance reachable.
- Browser access requires routing, public addressing, Security Group rules, and a listening service.

## AWS Cloud Practitioner Connections

This topic connects to these AWS Cloud Practitioner areas:

```text
AWS global infrastructure
Regions
Availability Zones
Edge locations
VPC
Subnets
Route tables
Internet Gateways
NAT Gateways
Security Groups
NACLs
Public and private IP addressing
High availability basics
Shared Responsibility Model
```

## Interview-Ready Explanation

I inspected the networking behind my EC2 NGINX project and found that the instance was in `us-east-1d` inside a VPC and subnet with a route table that included `0.0.0.0/0 -> Internet Gateway`. That route made the subnet public. The EC2 web page worked because the instance had a public IP while running, the subnet routed internet traffic through an Internet Gateway, the Security Group allowed inbound HTTP on port 80, and NGINX was running and listening on port 80. I also learned that Security Groups are stateful resource-level firewalls, while NACLs are stateless subnet-level firewalls.
