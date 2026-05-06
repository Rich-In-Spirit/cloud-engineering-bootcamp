# Project 02 - AWS EC2 NGINX Web Server

## Project Summary

This project demonstrates deploying and securing a basic Linux web server on AWS EC2.

I launched an Ubuntu EC2 instance, configured a Security Group for SSH and HTTP access, connected to the instance using an AWS SSH private key, installed NGINX, customized the default web page, and verified public browser access using the EC2 public IPv4 address.

## Status

Completed initial EC2 NGINX deployment.

## Skills Demonstrated

- AWS EC2 instance deployment
- AWS key pair usage
- SSH access to a cloud Linux server
- Security Group configuration
- Public vs private IP understanding
- Linux package management with `apt`
- NGINX installation and service management
- HTTP access over port `80`
- Service troubleshooting with `systemctl`
- Port verification with `ss`
- Web testing with `curl`
- Basic cloud security using least privilege

## Environment

- Cloud Provider: AWS
- Region: us-east-1 / N. Virginia
- Compute: EC2
- OS: Ubuntu Server
- Access Method: SSH key pair
- Linux User: `ubuntu`
- Web Server: NGINX
- Firewall Layer: AWS Security Group
- Protocols:
  - SSH: port `22`
  - HTTP: port `80`

## Architecture

```text
My Computer
   |
   | SSH using AWS private key
   | Port 22
   v
AWS Security Group
   |
   | Allows SSH from my public IP only
   | Allows HTTP from anywhere
   v
AWS EC2 Ubuntu Instance
   |
   | NGINX listening on port 80
   v
Public web page served over HTTP
```

## Security Group Rules Used

| Type | Protocol | Port | Source | Purpose |
|---|---:|---:|---|---|
| SSH | TCP | 22 | My public IP `/32` | Admin access to EC2 |
| HTTP | TCP | 80 | `0.0.0.0/0` | Public web server test |

## Important Security Notes

- SSH was restricted to my own public IP address.
- HTTP was opened to the internet for this lab so the web page could be viewed publicly.
- HTTPS/443 was not opened because TLS was not configured.
- No unnecessary ports were opened.
- The private key file was not uploaded to GitHub.
- The instance should be stopped or terminated when not actively being used.

## Public vs Private IP Lesson

I initially tried to access the EC2 instance using the private IP address, then realized that was not correct from my home browser.

```text
Private IP = internal AWS VPC address
Public IP  = internet-reachable address
```

The browser needed the EC2 public IPv4 address to reach the NGINX web page over the internet.

## Commands Used

### SSH Into EC2

```powershell
ssh -i .\sal-aws-ec2-lab-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Verify Instance Identity

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

### Check NGINX Service

```bash
systemctl status nginx
```

### Test NGINX Locally from EC2

```bash
curl localhost
```

### Verify Port 80 Is Listening

```bash
sudo ss -tulnp | grep ':80'
```

### Check NGINX Logs

```bash
journalctl -u nginx --no-pager | tail -n 20
```

### Customize the Web Page

```bash
echo "<h1>Sal's AWS EC2 NGINX Web Server</h1><p>Deployed as Project 02 of my Cloud Engineering Bootcamp.</p>" | sudo tee /var/www/html/index.nginx-debian.html
```

### Test Again

```bash
curl localhost
```

Then I refreshed the browser using:

```text
http://<EC2_PUBLIC_IP>
```

## Final Result

The custom NGINX page successfully loaded in the browser using the EC2 public IPv4 address.

Displayed page:

```text
Sal's AWS EC2 NGINX Web Server

Deployed as Project 02 of my Cloud Engineering Bootcamp.
```

## Troubleshooting Pattern Used

```text
1. Is the EC2 instance running?
2. Does the instance have a public IP?
3. Does the Security Group allow SSH from my IP?
4. Does the Security Group allow HTTP from the internet?
5. Can I SSH into the instance?
6. Is NGINX installed?
7. Is NGINX running?
8. Is NGINX listening on port 80?
9. Does curl localhost work from inside the instance?
10. Does the browser reach the EC2 public IP?
```

## Local-to-Cloud Mapping

```text
VirtualBox Ubuntu VM       -> AWS EC2 Ubuntu instance
Local SSH key auth         -> AWS EC2 key pair authentication
VirtualBox port forwarding -> AWS public IP + Security Group rules
UFW firewall               -> AWS Security Group concept
Local NGINX page           -> Public EC2 NGINX page
curl localhost             -> Same local service test inside EC2
```

## What I Learned

- EC2 is AWS virtual compute.
- A Security Group controls inbound and outbound access to the instance.
- SSH access should be restricted to my public IP when possible.
- HTTP on port 80 can be opened publicly for a web server test.
- Private IPs are used inside the AWS VPC.
- Public IPs are used for internet access.
- AWS Linux instances commonly use SSH key authentication.
- NGINX can serve a web page from `/var/www/html`.
- `curl localhost` proves the service works from inside the server.
- Browser access to the public IP proves external access works.
- The same Linux troubleshooting commands from the local VM apply to EC2.

## Why This Matters

This project is my first real cloud deployment.

It proves I can launch a Linux server in AWS, connect securely, configure a web service, control inbound traffic with a Security Group, and verify the application from both the server and the public internet.

## Next Improvements

- Add screenshots folder with sanitized proof images.
- Add an architecture diagram.
- Add AWS CLI version of the deployment later.
- Add UFW as a second firewall layer later.
- Rebuild the same project using Terraform.
- Add HTTPS/TLS later instead of opening port 443 without configuration.
