# AWS CCP Day 7 Review - Account Safety and Cost Controls

## Date

May 7, 2026

## Topics Reviewed

- EC2 cost hygiene
- Stop vs terminate
- Security Groups
- Root MFA
- AWS Budgets
- Shared Responsibility Model
- Least privilege
- Public IP vs private IP review

## Key Concepts

### Stop vs Terminate

Stop means the EC2 instance is shut down, but the instance and root EBS volume remain available for later use.

Terminate means the EC2 instance is deleted.

### EC2 Cost Hygiene

EC2 instances should be stopped or terminated when not actively being used.

Stopping the instance helps avoid unnecessary compute cost, but related resources such as EBS volumes, snapshots, or Elastic IPs may still create charges depending on configuration.

### Security Groups

Security Groups act as virtual firewalls for AWS resources such as EC2 instances.

For the EC2 NGINX project:

```text
SSH   TCP 22   My public IP only
HTTP  TCP 80   Anywhere
```

## Root MFA

Root MFA means enabling multi-factor authentication on the AWS root account.

The root account has powerful account-level permissions, so it should be protected and not used for daily work.

## AWS Budgets

AWS Budgets help track cost and usage.

A budget alert can notify me when spending approaches or exceeds a threshold.

A budget alert does not automatically stop resources by default.

## Shared Responsibility Model

AWS is responsible for security of the cloud.

I am responsible for security in the cloud.

AWS responsibilities include:
```text
Physical data centers
Hardware
Global infrastructure
Managed service infrastructure
```
My responsibilites include:
```text
MFA
IAM configuration
Security Group rules
SSH key protection
EC2 cleanup
Cost monitoring
Not opening unnecessary ports
```
## Key Takeaway 
Cloud engineering is not just building resources. It also includes securing access, controlling cost, monitoring usage, and cleaning up resources.
