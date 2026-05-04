# Day 3 Linux Services, Logs, and NGINX Lab

## Date
May 3, 2026

## Objective

Practice installing, managing, testing, and troubleshooting a Linux service using NGINX.

## Lab Environment

- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- Access Method: SSH from Windows PowerShell
- SSH Command:

```powershell
ssh sal@127.0.0.1 -p 2222
```

## Lab Goal 
Install NGINX, verify that it is running, confirm that it listens on http port 80, test it locally with ```curl```, inspect logs with ```journalctl```, and practice stopping/starting the service. 

## Commands Run 
```
whoami
hostname
pwd

sudo apt update
sudo apt install nginx -y

systemctl status nginx
curl localhost

sudo ss -tulnp | grep ':80'
sudo ss -tulnp | grep nginx

sudo systemctl stop nginx
systemctl status nginx
curl localhost

sudo systemctl start nginx
systemctl status nginx
curl localhost

sudo systemctl restart nginx
systemctl status nginx

sudo systemctl enable nginx
systemctl is-enabled nginx

journalctl -u nginx --no-pager | tail -n 20
journalctl -u nginx --since "10 minutes ago" --no-pager

sudo systemctl stop nginx
systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
journalctl -u nginx --since "5 minutes ago" --no-pager

sudo systemctl start nginx
systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
```

## Key Concepts 
### NGINX
NGINX is a high-performance web server and reverse proxy. It is commonly used to serve websites, proxy traffic, load balance requests, terminate TLS, and support application infrastructure.
```systemctl```

```systemctl``` is used to manage Linux services. 

Important commands: 

```Bash
systemctl status nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
systemctl is-enabled nginx
```
Important correction:
````
enabled does not always mean currently running.
active/running means currently using.
````

````curl localhost````

````curl localhost```` sends and HTTP request to the same machine. 
In this lab, it tested whether the Ubuntu VM could reach it own NGINX web server locally.

```ss -tulnp```
````ss```` shows socket/network information. 
`````
-t = TCP
-u = UDP
-l = listening ports
-n = numeric output
-p = process using the port

`````

Example: 
```Bash
sudo ss -tulnp | grep ':80'
```
Plain English:
````Show listening network ports and filter for port 80````

### Port 80
Port 80 is the default port for HTTP web traffic

### Port 22 is the the default port for SSH 

```Journalctl```

```Journalctl``` is used to view systemd logs.
Example:
```Bash
journalctl -u nginx --no-pager
```
Plain English:
```Show logs for the nginx service.```

## Key Obsercations 
- NGINX successfully installed with ```apt```.
- ```systemctl status nginx``` showed whether NGINX was active or inactive.
- ```curl localhost``` returned the default NGINX HTML page when NGINX was running.
- ```sudo ss -tulnp | grep ':80'``` showed NGINX listening on port 80.
- When NGINX was stopped, ```curl localhost``` failed.
- When NGINX was started again, ```curl localhost``` returned the NGINX HTML
- ```jounalctl -u nginx```showed service logs for NGINX start/stop events.
## What I Learned 
- A Linux service can be installed, started, stopped, restarted, enabled, and checked using ```systemctl```.
- ```enable``` means start at boot, not necessarily start right now.
- ```active/running``` means the service is currently running.
- ```curl localhost``` is a quick way to test whether a local web service is responding.
-  ```ss -tulnp``` helps confirm whether a service is listening on the expected port.
-  ```journalctl -u nginx``` shows logs for the NGINX service.

## Troubleshooting Pattern 
```
1. Is the service running?
   systemctl status nginx

2. Is the service responding?
   curl localhost

3. Is the port listening?
   sudo ss -tulnp | grep ':80'

4. What do the logs say?
   journalctl -u nginx
```

## What Confused Me
- I initially thought NGINX was exclusively for Linux, but it is not.
- I needed clarification on the ```ss -tulnp | grep ':80'``` command.
- I learned that `enable` does not mean the service is currently running; it means the service is configured to start at boot.

## Why This Matters for Cloud Engineering 
Cloud engineers frequently troubleshoot Linux servers, web services, EC2 Instances, load-balanced applications, recerse proxies, containers, and Kubernetes workloads. The same pattern applies often: check the service, test the response, verify the listening port, and inspect the logs. 

## Next Step
Practice editing a basic NGINX web page, restarting the service, and testing the change with `curl`

## Bonus: Edited Default NGINX Web Page

### Commands Run

```bash
ls -l /var/www/html

sudo cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bak
ls -l /var/www/html

echo "<h1>Sal's Cloud Engineering Lab</h1><p>NGINX is running on my Ubuntu VM.</p>" | sudo tee /var/www/html/index.nginx-debian.html

curl localhost

sudo systemctl restart nginx
systemctl status nginx
curl localhost

sudo cp /var/www/html/index.nginx-debian.html.bak /var/www/html/index.nginx-debian.html
curl localhost
```

## What I Learned
- `/var` stores variable/changing system and application data.
- `/var/www/html` is the default web root directory for NGINX on Ubuntu.
- I needed `sudo` because `/var/www/html` is a protected system/application path.
- Creating a `.bak` backup before editing a file is a good safety habit.
- `tee` can write piped command output into a file.
- `curl localhost` confirmed that NGINX served the updated HTML content locally.
- Restarting NGINX confirmed the service still worked after the page edit.


## Why This Matters

This was a small example of a server-side web change: locate the web root, back up the original file, modify content, verify the service response, and restore if needed.
