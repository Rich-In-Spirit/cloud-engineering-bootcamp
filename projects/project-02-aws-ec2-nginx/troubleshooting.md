# AWS EC2 NGINX Troubleshooting Guide

## Project Context

This troubleshooting guide supports Project 02: AWS EC2 NGINX Web Server.

The project deployed an Ubuntu EC2 instance, installed NGINX, configured Security Group rules, and served a custom web page over HTTP.

## Troubleshooting Flow

When the EC2 web server does not work, troubleshoot in layers.

```text
1. Is the instance running?
2. Does it have a public IP?
3. Can I SSH into it?
4. Is the Security Group allowing the right traffic?
5. Is NGINX installed?
6. Is NGINX running?
7. Is NGINX listening on port 80?
8. Can the instance curl localhost?
9. Can my browser reach the public IP?
10. Are logs showing errors?
```

## Issue: Tried Private IP First

### Problem

I initially tried to access the EC2 instance using the private IP address.

### Why It Failed

The private IP is only reachable inside the AWS VPC/internal AWS network.

My home browser is outside the VPC, so I needed to use the EC2 public IPv4 address.

```text
Private IP = internal AWS VPC communication
Public IP  = internet/browser access
```

### Fix

Use:

```text
http://<EC2_PUBLIC_IP>
```

instead of the private IP.

## SSH Fails

Check:

```text
Is the EC2 instance running?
Am I using the right private key file?
Am I using the correct username?
Is the public IP correct?
Did my public IP change?
Does the Security Group allow SSH from my current IP?
```

Common SSH command:

```powershell
ssh -i .\sal-aws-ec2-lab-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Important:

```text
Ubuntu EC2 username = ubuntu
Amazon Linux username = ec2-user
```

## Website Does Not Load in Browser

Check AWS Security Group:

```text
Is inbound 80/tcp allowed?
Is the source 0.0.0.0/0 for this public web test?
Is the instance running?
Am I using the public IP, not the private IP?
```

Check NGINX from inside EC2:

```bash
systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
```

Check logs:

```bash
journalctl -u nginx --no-pager | tail -n 20
```

## NGINX Not Running

Try:

```bash
sudo systemctl start nginx
systemctl status nginx
```

If needed:

```bash
sudo systemctl restart nginx
```

## Port 80 Not Listening

Check:

```bash
sudo ss -tulnp | grep ':80'
```

Expected:

```text
nginx listening on 0.0.0.0:80
```

If no output appears, NGINX may not be running or may not be configured to listen on port 80.

## Local Curl Works but Browser Fails

If this works from inside EC2:

```bash
curl localhost
```

but the browser cannot reach the public IP, likely causes include:

```text
Security Group blocking port 80
Using private IP instead of public IP
Instance has no public IP
Network ACL or route issue
Local browser/network issue
```

## Browser Works but SSH Fails

Likely causes:

```text
Security Group allows 80 but not 22
Wrong SSH key
Wrong username
Public IP changed after stop/start
My home public IP changed and Security Group no longer allows it
```

## Security Group Checks

Correct beginner lab inbound rules:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   0.0.0.0/0
```

Do not open:

```text
All traffic
SSH from 0.0.0.0/0 if avoidable
443 unless HTTPS/TLS is configured
Random unused ports
```

## Key Local-to-AWS Troubleshooting Mapping

```text
systemctl      = is the service running?
curl localhost = does the service respond locally?
ss -tulnp      = is the port listening?
journalctl     = what do logs say?
Security Group = is AWS allowing the traffic?
Public IP      = internet access point
Private IP     = internal VPC access point
```

## Final Working State

The project worked when:

```text
EC2 instance was running
Security Group allowed 22 from my IP
Security Group allowed 80 from anywhere
SSH key authentication worked
NGINX was active/running
NGINX was listening on port 80
curl localhost returned the custom page
Browser loaded the custom page using the EC2 public IP
```
