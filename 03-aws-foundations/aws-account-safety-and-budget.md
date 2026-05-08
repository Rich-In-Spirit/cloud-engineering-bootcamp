# AWS Account Safety and Budget Lab

## Date

May 7, 2026

## Objective

Set up basic AWS account safety controls before continuing additional AWS labs.

This lab focused on EC2 cost hygiene, Security Group review, root account MFA, and AWS Budgets.

## Why This Lab Matters

Before building more cloud resources, I need to understand how to protect the AWS account from unnecessary cost, exposed access, and poor security hygiene.

Cloud engineering is not just deploying resources. It also includes:

```text
cost awareness
identity security
least privilege
resource cleanup
billing visibility
operational discipline
```

## AWS Services and Concepts Used

```text
EC2
Security Groups
AWS Budgets
Billing and Cost Management
Root user MFA
Cost alerts
Shared Responsibility Model
```

## Part 1 - EC2 Instance State Review

I reviewed my EC2 instance from Project 02:

```text
project-02-aws-ec2-nginx
```

The instance was confirmed to be stopped.

## Stop vs Terminate

```text
Stop = shut down the instance but keep the root EBS volume
Terminate = delete the instance
```

Stopping is useful when I want to keep the instance for later labs.

Terminating is better when I am completely done with the resource.

## Public IP Note

When an EC2 instance is stopped and started again, its automatically assigned public IPv4 address may change.

This matters because:

```text
SSH commands may need the new public IP
browser testing may need the new public IP
documentation should avoid depending on a temporary public IP
```

## Part 2 - Security Group Review

I reviewed the Security Group for the EC2 NGINX project:

```text
project-02-ec2-nginx-sg
```

Expected inbound rules:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   Anywhere
```

## Security Group Reasoning

### SSH

SSH should be restricted to my public IP when possible.

```text
Better:
22/tcp from my public IP only

Riskier:
22/tcp from 0.0.0.0/0
```

### HTTP

HTTP on port 80 was allowed from anywhere because this was a public web server lab.

### HTTPS

HTTPS on port 443 was not opened because TLS/SSL was not configured.

## UFW vs Security Group

```text
UFW = host-based firewall inside Linux
Security Group = AWS network-level firewall around EC2
```

Both control traffic, but they operate at different layers.

## Part 3 - Root User MFA

I checked whether the AWS root user had MFA enabled.

Root user MFA is important because the root user has powerful account-level permissions.

## Root User Best Practices

```text
Enable MFA on root
Use a strong password
Do not create root access keys
Do not use root for daily work
Use IAM users/roles or IAM Identity Center for normal administration
```

## Part 4 - AWS Budget

I created a monthly AWS cost budget.

Recommended beginner lab budget:

```text
Budget name: monthly-lab-budget
Budget type: Cost budget
Period: Monthly
Amount: $5
Alert threshold: 80%
Notification: email
```

## Budget Reasoning

Budgets help prevent surprise cloud costs by alerting when spending approaches or exceeds a threshold.

Important note:

```text
A budget alert does not automatically stop resources by default.
It notifies me so I can take action.
```

## Shared Responsibility Model Connection

AWS is responsible for security of the cloud:

```text
physical data centers
hardware
AWS global infrastructure
managed service infrastructure
```

I am responsible for security in the cloud:

```text
MFA
IAM/security configuration
Security Group rules
protecting SSH keys
stopping unused instances
monitoring cost
not exposing unnecessary ports
```

## What I Learned

- Cloud engineering includes cost control and account safety.
- Stopped EC2 instances are safer for cost than running instances, but associated resources can still exist.
- Security Groups should follow least privilege.
- SSH should not be open to the entire internet if avoidable.
- Port 443 should not be opened until HTTPS/TLS is actually configured.
- Root MFA is a critical AWS account security control.
- AWS Budgets provide cost visibility and alerts.
- Budget alerts are not the same thing as automatic shutdown.
- Public IPv4 addresses can change after stopping and starting an EC2 instance.

## Why This Matters for Cloud Engineering

Cloud engineers are responsible for more than building resources.

They also need to:

```text
secure access
control cost
monitor usage
reduce attack surface
clean up resources
understand shared responsibility
```

This lab helps build the discipline needed to operate safely in AWS.

## Next Step

Continue AWS foundations by creating a dedicated IAM/admin workflow and learning:

```text
IAM users
IAM groups
IAM roles
IAM policies
least privilege
AWS CLI configuration
```
