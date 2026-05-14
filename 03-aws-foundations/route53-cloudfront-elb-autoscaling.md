# Route 53, CloudFront, ELB, Auto Scaling, and High Availability

## Date

May 14, 2026

## Objective

Understand core AWS services used for DNS, content delivery, traffic distribution, scaling, and high availability.

This note connects Route 53, CloudFront, Elastic Load Balancing, Auto Scaling, Availability Zones, and production-style web architecture to AWS Cloud Practitioner exam concepts.

## Why This Matters

My first EC2 NGINX project used a direct public IP address to access a single web server.

That worked for a beginner lab, but production-style web applications usually need:

```text
domain names
lower latency
traffic distribution
health checks
multiple servers
multiple Availability Zones
automatic scaling
resilience
```

These are common AWS Cloud Practitioner service-recognition topics.

## Core Services

## Route 53

Route 53 is AWS's DNS service.

Plain-English explanation:

```text
Route 53 turns domain names into destinations.
```

Example:

```text
www.company.com -> load balancer DNS name
```

Use Route 53 when the scenario mentions:

```text
DNS
domain name
hosted zone
routing users to an endpoint
health-check-based routing
```

### What Route 53 Would Improve in My EC2 NGINX Project

My original project used a public IP address directly:

```text
http://EC2_PUBLIC_IP
```

Route 53 would allow users to access the site using a domain name instead:

```text
http://www.example.com
```

Key takeaway:

```text
Route 53 = DNS / domain routing
```

## CloudFront

CloudFront is AWS's content delivery network.

Plain-English explanation:

```text
CloudFront caches and delivers content from Edge Locations closer to users.
```

CloudFront helps improve:

```text
latency
global content delivery
static content performance
origin offload
user experience for geographically distributed users
```

Use CloudFront when the scenario mentions:

```text
CDN
edge locations
global users
low latency
caching static files
delivering images or videos
reducing load on origin
```

CloudFront origins can include:

```text
S3 bucket
Application Load Balancer
EC2 web server
custom origin
```

### What CloudFront Would Improve in My EC2 NGINX Project

CloudFront could cache content closer to users and reduce latency.

Instead of every request going directly back to the EC2 instance, users could receive cached content from a nearby Edge Location.

Key takeaway:

```text
CloudFront = CDN / edge caching / lower latency
```

## Elastic Load Balancing

Elastic Load Balancing distributes incoming traffic across multiple targets.

Plain-English explanation:

```text
Load balancer = traffic distributor.
```

Targets can include:

```text
EC2 instances
containers
IP addresses
Lambda functions depending on load balancer type
```

Use Elastic Load Balancing when the scenario mentions:

```text
distribute traffic
multiple EC2 instances
healthy targets
health checks
avoid sending traffic to unhealthy instances
single endpoint for multiple servers
```

### What ELB Would Improve in My EC2 NGINX Project

My beginner EC2 NGINX project used one server.

If I had multiple EC2 NGINX servers, an Elastic Load Balancer could distribute HTTP/HTTPS traffic across the healthy servers.

This improves availability because traffic can avoid unhealthy instances.

Key takeaway:

```text
ELB = distributes traffic across healthy targets
```

## Application Load Balancer

An Application Load Balancer is best for HTTP/HTTPS web applications.

It operates at Layer 7.

Use ALB when the scenario mentions:

```text
HTTP
HTTPS
web applications
Layer 7 routing
path-based routing
host-based routing
```

Example:

```text
/app1 -> target group 1
/app2 -> target group 2
```

Key takeaway:

```text
ALB = HTTP/HTTPS web app traffic
```

## Network Load Balancer

A Network Load Balancer is best for very high-performance TCP/UDP traffic.

It operates at Layer 4.

Use NLB when the scenario mentions:

```text
TCP
UDP
very high performance
low latency
millions of requests
static IP support
Layer 4 traffic
```

Key takeaway:

```text
NLB = high-performance TCP/UDP traffic
```

## Gateway Load Balancer

A Gateway Load Balancer is used for deploying and scaling third-party virtual appliances.

Use cases include:

```text
firewalls
intrusion detection systems
intrusion prevention systems
network security appliances
```

For AWS Cloud Practitioner, the basic idea is:

```text
Gateway Load Balancer = third-party security/network appliances
```

## Auto Scaling

Auto Scaling automatically adjusts compute capacity.

Plain-English explanation:

```text
Auto Scaling changes how many EC2 instances are running.
```

Auto Scaling can:

```text
add EC2 instances when demand increases
remove EC2 instances when demand decreases
maintain a desired number of instances
replace unhealthy instances
help control cost
help maintain availability
```

Use Auto Scaling when the scenario mentions:

```text
traffic spikes
changing demand
scale out
scale in
automatic capacity adjustment
maintain desired capacity
replace unhealthy instances
```

### What Auto Scaling Would Improve in My EC2 NGINX Project

If traffic to my EC2 NGINX app changed throughout the day, Auto Scaling could add or remove EC2 instances based on demand.

Key takeaway:

```text
Auto Scaling = changes the number of EC2 instances
```

## ELB vs Auto Scaling

These services are often used together, but they solve different problems.

```text
ELB = where should traffic go?
Auto Scaling = how many servers should exist?
```

Another way to remember it:

```text
ELB distributes traffic across servers.
Auto Scaling adds or removes servers.
```

Example:

```text
User request comes in
-> ALB sends request to a healthy EC2 instance
-> Auto Scaling decides whether more or fewer EC2 instances are needed
```

## High Availability

High availability means designing systems to reduce downtime and remain accessible.

Example:

```text
Run EC2 instances across multiple Availability Zones behind a load balancer.
```

Key takeaway:

```text
High availability = keep the application accessible
```

## Scalability

Scalability means the ability to handle changing demand by increasing or decreasing capacity.

Example:

```text
Auto Scaling adds EC2 instances during traffic spikes and removes them when demand drops.
```

Key takeaway:

```text
Scalability = handle demand changes
```

## Fault Tolerance

Fault tolerance means the system can continue operating even when a component fails.

Example:

```text
If one Availability Zone has an issue, the application continues running in another Availability Zone.
```

Key takeaway:

```text
Fault tolerance = survive failures
```

## Multi-AZ vs Multi-Region

### Multiple Availability Zones

Use multiple AZs for high availability inside one Region.

Example:

```text
Application runs in us-east-1a and us-east-1b.
```

Use this when the scenario says:

```text
high availability
same Region
reduce downtime
one geographic area
```

### Multiple Regions

Use multiple Regions for geographic disaster recovery or global resilience.

Example:

```text
Application runs in us-east-1 and us-west-2.
```

Use this when the scenario says:

```text
disaster recovery
entire Region outage
geographic resilience
global failover
```

## Production-Style Web Architecture

My beginner EC2 NGINX project:

```text
Browser
   ->
EC2 public IP
   ->
Security Group
   ->
NGINX
```

More production-style architecture:

```text
User
   ->
Route 53 domain name
   ->
CloudFront Edge Location
   ->
Application Load Balancer
   ->
EC2 instances across multiple Availability Zones
   ->
NGINX / application
```

What each part does:

```text
Route 53 = DNS / domain name
CloudFront = global edge caching and lower latency
Application Load Balancer = HTTP/HTTPS traffic distribution
Auto Scaling = adds/removes EC2 instances based on demand
Multiple AZs = high availability inside one Region
EC2 = compute running the application
NGINX/app = workload
```

## Service Recognition Cheat Sheet

```text
Need DNS/domain name?
-> Route 53

Need global caching or CDN?
-> CloudFront

Need lower latency for users around the world?
-> CloudFront

Need distribute traffic across healthy EC2 instances?
-> Elastic Load Balancing

Need HTTP/HTTPS Layer 7 routing?
-> Application Load Balancer

Need high-performance TCP/UDP traffic distribution?
-> Network Load Balancer

Need third-party security appliance scaling?
-> Gateway Load Balancer

Need add/remove EC2 instances automatically?
-> Auto Scaling

Need high availability inside one Region?
-> Multiple Availability Zones

Need disaster recovery across geography?
-> Multiple Regions
```

## How This Connects to My EC2 NGINX Project

The original project proved that I could run a public web server on one EC2 instance.

This topic shows how that design can be improved:

```text
Direct public IP
-> replace with Route 53 domain name

Single EC2 instance
-> improve with multiple EC2 instances across AZs

Manual capacity
-> improve with Auto Scaling

Single direct server access
-> improve with Application Load Balancer

Users far from the Region
-> improve with CloudFront
```

## Key Lessons Learned

- Route 53 is AWS DNS.
- CloudFront is AWS CDN.
- Edge Locations are used by CloudFront to deliver content closer to users.
- Elastic Load Balancing distributes traffic across healthy targets.
- Application Load Balancer is best for HTTP/HTTPS web apps.
- Network Load Balancer is best for high-performance TCP/UDP traffic.
- Auto Scaling changes the number of EC2 instances based on demand or health.
- ELB and Auto Scaling are different but often used together.
- High availability means reducing downtime.
- Scalability means handling changing demand.
- Fault tolerance means continuing to operate when a component fails.
- Multiple AZs improve high availability inside one Region.
- Multiple Regions support disaster recovery and geographic resilience.

## Interview-Ready Explanation

My first EC2 NGINX project used a public IP to reach one web server. A more production-ready design would use Route 53 for DNS, CloudFront for global edge caching and lower latency, an Application Load Balancer to distribute HTTP/HTTPS traffic across healthy EC2 instances, Auto Scaling to add or remove instances based on demand, and multiple Availability Zones to improve high availability inside one Region.

## AWS Cloud Practitioner Connections

This topic connects to common AWS Cloud Practitioner service-recognition questions:

```text
Route 53 = DNS
CloudFront = CDN
Elastic Load Balancing = traffic distribution
Application Load Balancer = HTTP/HTTPS Layer 7
Network Load Balancer = TCP/UDP Layer 4 high performance
Auto Scaling = automatic EC2 capacity adjustment
Multiple AZs = high availability
Multiple Regions = disaster recovery / global resilience
Edge Locations = content closer to users
```
