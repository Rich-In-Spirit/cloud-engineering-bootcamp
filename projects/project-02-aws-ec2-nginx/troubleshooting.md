# AWS EC2 NGINX Troubleshooting Guide

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

## SSH Fails

Check:

```text
Is the EC2 instance running?
Am I using the right key file?
Is the key file permission correct?
Am I using the right username?
Is Security Group allowing port 22 from my IP?
Is the public IP correct?
```

Common SSH command:

```bash
ssh -i <key-file>.pem ubuntu@<ec2-public-ip>
```

## Website Does Not Load

Check Security Group:

```text
Is inbound 80/tcp allowed?
Is source 0.0.0.0/0 allowed for test?
```

Check NGINX:

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

## Port 80 Not Listening

Check:

```bash
sudo ss -tulnp | grep ':80'
```

If no output appears, NGINX may not be running or may not be configured to listen on port 80.

## Local Curl Works but Browser Fails

If this works:

```bash
curl localhost
```

but the browser cannot reach the EC2 public IP, likely causes include:

```text
Security Group blocking port 80
Wrong public IP
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
```

## Key Local-to-AWS Troubleshooting Mapping

```text
systemctl = is the service running?
curl localhost = does the service respond locally?
ss -tulnp = is the port listening?
journalctl = what do logs say?
Security Group = is AWS allowing the traffic?
```
