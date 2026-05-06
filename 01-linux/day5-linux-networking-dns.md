# Day 5 Linux Networking and DNS Lab

## Date
May 5, 2026

## Objective

Practice Linux networking and DNS troubleshooting commands that are commonly used when supporting Linux servers, cloud VMs, and AWS EC2 instances.

This lab focused on understanding how to check IP addresses, routing, DNS resolution, HTTP/HTTPS reachability, network paths, and listening ports.

## Lab Environment

- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- VM Hostname: ubuntu-cloud-lab-01
- Linux User: sal
- Access Method: SSH from Windows PowerShell
- SSH Port Forwarding: Windows `127.0.0.1:2222` forwards to Ubuntu VM port `22`
- Web Server: NGINX
- Firewall Tool: UFW

## Lab Goal

Use common Linux networking tools to answer these questions:

```text
Do I have an IP address?
Do I have a route/default gateway?
Can I reach the internet by IP?
Can I resolve DNS names?
Can I reach a web server?
Can I trace the network path?
Is my local service listening on the expected port?
```

## Commands Run

```powershell
ssh sal@127.0.0.1 -p 2222
```

```bash
mkdir -p ~/linux-practice/day5-networking
cd ~/linux-practice/day5-networking
pwd

ip a
hostname -I

ip route

ping -c 4 8.8.8.8
ping -c 4 google.com

resolvectl status
cat /etc/resolv.conf

nslookup google.com

sudo apt update
sudo apt install dnsutils -y
dig google.com

curl -I http://example.com
curl -I https://example.com

sudo apt install traceroute -y
traceroute google.com

sudo ss -tulnp
sudo ss -tulnp | grep ':22'
sudo ss -tulnp | grep ':80'

ping -c 4 8.8.8.8
ping -c 4 google.com

systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
sudo ufw status verbose
```

## Key Concepts

### `ip a`

`ip a` shows detailed network interface information.

It can show:

```text
loopback interface
network adapter names
IPv4 addresses
IPv6 addresses
MAC addresses
interface state
```

In this lab, important items included:

```text
lo = loopback interface
127.0.0.1 = this machine / localhost
enp0s3 = VM's main virtual network adapter
10.0.2.15 = VirtualBox NAT IP address
```

### `hostname -I`

`hostname -I` shows the IP address or addresses assigned to the host.

Important note:

```text
hostname -I uses a capital I.
```

This is different from lowercase `-i`.

### `ip route`

`ip route` shows the system routing table.

Plain-English explanation:

```text
ip route shows where Linux sends traffic to reach different networks.
```

A common default route looks like:

```text
default via 10.0.2.2 dev enp0s3
```

Meaning:

```text
If traffic needs to leave the local network, send it to 10.0.2.2 using interface enp0s3.
```

### Default Gateway

A default gateway is the next-hop router used when the machine needs to reach something outside its local network.

Simple version:

```text
Gateway = the exit door from the local network to other networks.
```

In this VirtualBox NAT lab:

```text
VM IP address was likely 10.0.2.15
Default gateway was likely 10.0.2.2
```

### `ping 8.8.8.8`

This tests raw IP connectivity to a public IP address.

Plain-English explanation:

```text
Can this VM reach the internet by IP without depending on DNS?
```

### `ping google.com`

This tests both DNS resolution and network connectivity.

Plain-English explanation:

```text
Can this VM resolve a domain name and reach the destination?
```

### Why Test IP Before Domain?

Testing `8.8.8.8` first helps isolate the issue.

```text
8.8.8.8 works + google.com works = routing and DNS likely work
8.8.8.8 works + google.com fails = likely DNS problem
8.8.8.8 fails + google.com fails = likely routing/network problem
```

### DNS

DNS stands for Domain Name System.

DNS resolves names to IP addresses.

Example:

```text
google.com -> IP address
```

Simple version:

```text
DNS is the phonebook of the internet.
```

### `nslookup`

`nslookup` queries DNS to resolve a domain name to an IP address.

Example:

```bash
nslookup google.com
```

Plain-English explanation:

```text
Ask DNS what IP address belongs to google.com.
```

### `dig`

`dig` is a detailed DNS lookup tool.

Example:

```bash
dig google.com
```

It provides more DNS-specific information than `nslookup` and is commonly used by engineers.

### `resolvectl status`

`resolvectl status` shows DNS configuration managed by systemd-resolved.

It can show:

```text
DNS servers
DNS domains
network links
resolver status
```

### `/etc/resolv.conf`

`/etc/resolv.conf` shows where the system sends DNS queries.

Command:

```bash
cat /etc/resolv.conf
```

### `curl -I`

`curl -I` sends an HTTP/HTTPS request and returns only the response headers, not the full page body.

Example:

```bash
curl -I https://example.com
```

This helps check:

```text
Is the web server reachable?
What HTTP status code came back?
Was there a redirect?
What server responded?
```

Common status codes:

```text
200 OK = success
301/302 = redirect
403 = forbidden
404 = not found
500 = server-side error
```

### `traceroute`

`traceroute` shows the network hops packets take toward a destination.

Example:

```bash
traceroute google.com
```

Plain-English explanation:

```text
Show the path traffic takes from this VM toward google.com.
```

Some hops may show:

```text
* * *
```

This does not always mean failure. Some routers do not respond to traceroute.

### `ss -tulnp`

`ss` shows socket/network information.

Options:

```text
-t = TCP
-u = UDP
-l = listening ports
-n = numeric output
-p = process using the port
```

Example:

```bash
sudo ss -tulnp | grep ':80'
```

Plain-English explanation:

```text
Show listening network ports and filter for port 80.
```

## Troubleshooting Flow

This is the main Day 5 troubleshooting flow:

```text
1. Do I have an IP address?
   ip a
   hostname -I

2. Do I have a route/default gateway?
   ip route

3. Can I reach the internet by IP?
   ping -c 4 8.8.8.8

4. Can I resolve DNS names?
   ping -c 4 google.com
   nslookup google.com
   dig google.com

5. Can I reach a web service?
   curl -I http://example.com
   curl -I https://example.com

6. What path does traffic take?
   traceroute google.com

7. Is my local service listening?
   sudo ss -tulnp | grep ':80'

8. Is the local service running/responding?
   systemctl status nginx
   curl localhost

9. Is the firewall involved?
   sudo ufw status verbose
```

## Key Observations

- `ip a` showed the VM's network interfaces and IP addresses.
- `hostname -I` showed the VM's assigned IP address.
- `ip route` showed where traffic is routed, including the default route.
- The default gateway acts as the exit point for traffic leaving the local network.
- `ping 8.8.8.8` tests internet reachability by IP.
- `ping google.com` tests DNS resolution plus reachability.
- DNS resolves names to IP addresses.
- `nslookup` and `dig` both perform DNS lookups.
- `dig` provides more detailed DNS information than `nslookup`.
- `curl -I` shows HTTP/HTTPS response headers.
- `traceroute` shows the route/hops traffic takes toward a destination.
- `ss -tulnp` shows listening ports and associated processes.
- If IP ping works but domain ping fails, DNS is likely the issue.
- If both IP ping and domain ping fail, routing/network connectivity may be the issue.

## What I Learned

- Linux networking troubleshooting starts with checking IP address and route information.
- `ip a` helps confirm whether the system has an IP address.
- `ip route` helps confirm whether the system has a default route/gateway.
- A gateway is the next-hop router used to reach networks outside the local network.
- Testing a public IP before a domain helps separate routing problems from DNS problems.
- DNS translates domain names into IP addresses.
- `nslookup` and `dig` help test DNS resolution.
- `curl -I` is useful for checking web server responses without downloading the full page.
- `traceroute` helps show the network path to a destination.
- `ss -tulnp` helps confirm whether a service is listening on the expected port.
- These commands are useful for troubleshooting Linux servers and cloud instances.

## What Confused Me

- I initially forgot what a gateway was.
- I needed clarification on `curl -I`.
- I mixed up `hostname -I` with lowercase `hostname -i`.
- I still feel shaky with Linux, but I understand that muscle memory will build through repeated use during AWS, Docker, Terraform, Kubernetes, and automation labs.

## Why This Matters for Cloud Engineering

Cloud engineers frequently troubleshoot cloud VM connectivity issues.

For AWS EC2, common questions include:

```text
Does the instance have an IP?
Does it have a route to the internet?
Is DNS working?
Is the service running?
Is the port listening?
Is the instance firewall blocking traffic?
Is the AWS Security Group blocking traffic?
```

This lab connects directly to AWS EC2 troubleshooting.

Local Linux concept mapping:

```text
ip a                    -> EC2 private/public IP checks
ip route                -> route table/default route thinking
DNS tools               -> resolving domain/service names
curl -I                 -> testing web endpoints
ss -tulnp               -> confirming local listening ports
UFW                     -> host firewall
AWS Security Group      -> cloud network firewall around EC2
```

## Next Step

Create the AWS EC2 NGINX project skeleton and repeat this local Linux web server pattern in AWS:

```text
Launch EC2 instance
Use SSH key pair
Configure Security Group
SSH into EC2
Install NGINX
Open port 80
Test web access
Document the project as a portfolio artifact
```
