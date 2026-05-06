# AWS Security Group Plan

## Purpose

This file documents the planned Security Group rules for the AWS EC2 NGINX web server project.

Security Groups act like a cloud firewall around AWS resources such as EC2 instances.

## Planned Inbound Rules

| Type | Protocol | Port | Source | Reason |
|---|---:|---:|---|---|
| SSH | TCP | 22 | My public IP only | Admin access to EC2 |
| HTTP | TCP | 80 | Anywhere `0.0.0.0/0` | Public web test |

## Planned Outbound Rules

Default outbound traffic will remain allowed for this beginner lab.

## Important Security Notes

### SSH

SSH should not be open to the entire internet if avoidable.

Better:

```text
22/tcp from my public IP only
```

Riskier:

```text
22/tcp from 0.0.0.0/0
```

### HTTP

HTTP on port 80 can be open publicly for this lab because the goal is to test a public web server.

### HTTPS

Port 443 should not be opened until HTTPS/TLS is configured.

## UFW vs Security Group

```text
UFW = firewall on the Linux server itself
Security Group = AWS network firewall around the EC2 instance
```

For this beginner AWS lab, the Security Group is the main access control.

Later, UFW can be added as a second layer.

## Least Privilege Rule

Only allow traffic that is required for the workload.

For this project:

```text
Required:
- SSH from my IP
- HTTP from browser/internet

Not required yet:
- HTTPS
- Database ports
- RDP
- Random high ports
```
