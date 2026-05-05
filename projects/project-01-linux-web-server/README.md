# Project 01 - Linux Web Server

## Project Summary

This project demonstrates basic Linux server administration by configuring an Ubuntu Server VM, enabling SSH access, installing NGINX, managing the NGINX service, checking listening ports, reviewing logs, and editing the default web page.

## Skills Demonstrated

- Ubuntu Server setup
- SSH access from Windows PowerShell
- Linux file and directory navigation
- Linux permissions and ownership basics
- User and group management
- NGINX installation and service management
- Service troubleshooting with `systemctl`
- Port verification with `ss`
- Local web testing with `curl`
- Log review with `journalctl`
- Web root editing under `/var/www/html`

## Environment

- Host: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest OS: Ubuntu Server 26.04 LTS
- Access: SSH from PowerShell using VirtualBox port forwarding
- Web Server: NGINX

## Architecture

```text
Windows Host
   |
   | SSH to 127.0.0.1:2222
   v
VirtualBox NAT Port Forward
   |
   | Guest Port 22
   v
Ubuntu Server VM
   |
   | NGINX listening on port 80
   v
Local Web Server
```

## Key Commands 

```text
ssh sal@127.0.0.1 -p 2222

sudo apt update
sudo apt install nginx -y

systemctl status nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl enable nginx

curl localhost
sudo ss -tulnp | grep ':80'
journalctl -u nginx --no-pager

ls -l /var/www/html
sudo cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bak
echo "<h1>Sal's Cloud Engineering Lab</h1><p>NGINX is running on my Ubuntu VM.</p>" | sudo tee /var/www/html/index.nginx-debian.html
curl localhost
```

## Troubleshooting Pattern Used 

```text
1. Check service state:
   systemctl status nginx

2. Test local response:
   curl localhost

3. Verify listening port:
   sudo ss -tulnp | grep ':80'

4. Check logs:
   journalctl -u nginx
```

## Outcome 

NGINX was installed and successfully served a local web page from the Ubnuntu Server VM. The service was stopped, started, restarted, ebavked at boot, verified on port 80, and tested with `curl`.

## Related Lab Notes
- `01-linux/day1-linux-vm-setup.md`
- `01-linux/day1-ssh-access.md`
- `01-linux/day2-linux-files-and-permissions.md`
- `01-linux/day2-users-groups-ownership.md`
- `01-linux/day3-linux-services-logs-nginx.md`

