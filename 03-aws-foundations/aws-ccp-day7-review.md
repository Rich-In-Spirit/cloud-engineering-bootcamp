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
