# IAM Users, Groups, and Policies Lab

## Date

May 8, 2026

## Objective

Practice AWS IAM fundamentals by creating an IAM group, attaching a read-only policy, creating an IAM user, and assigning the user to the group.

This lab focused on identity and access management, least privilege, and the difference between root and IAM identities.

## Why This Lab Matters

Cloud engineering requires controlling who can access cloud resources and what actions they are allowed to perform.

IAM is one of the most important AWS services because it controls authentication and authorization.

This lab connects directly to AWS Cloud Practitioner topics:

```text
IAM users
IAM groups
IAM policies
IAM roles
MFA
least privilege
root user best practices
shared responsibility model
```

## AWS Services and Concepts Used

```text
IAM
IAM user
IAM group
IAM policy
AWS managed policy
ReadOnlyAccess
MFA
Least privilege
AWS Management Console access
```

## Core IAM Concepts

### IAM

IAM stands for Identity and Access Management.

IAM controls access to AWS services and resources.

Plain-English explanation:

```text
IAM decides who can access AWS and what they can do.
```

### IAM User

An IAM user is an identity that represents a person or workload in an AWS account.

In this lab, the IAM user was:

```text
cloud-lab-readonly
```

### IAM Group

An IAM group is a collection of IAM users.

In this lab, the IAM group was:

```text
CloudLabReadOnly
```

The group held permissions, and the user inherited permissions from the group.

### IAM Policy

An IAM policy is a permissions document.

Policies define what actions are allowed or denied.

In this lab, I used the AWS managed policy:

```text
ReadOnlyAccess
```

### AWS Managed Policy

An AWS managed policy is a policy created and maintained by AWS.

### Least Privilege

Least privilege means granting only the permissions required to perform a task.

For this lab, a read-only user was safer than creating another full admin user.

## Lab Design

The goal was to create this structure:

```text
IAM User: cloud-lab-readonly
        |
        v
IAM Group: CloudLabReadOnly
        |
        v
Policy: ReadOnlyAccess
```

## Steps Completed

### Part 1 - Open IAM

I opened the AWS IAM service from the AWS Console.

### Part 2 - Create IAM Group

I created an IAM group:

```text
CloudLabReadOnly
```

I attached the AWS managed policy:

```text
ReadOnlyAccess
```

### Part 3 - Create IAM User

I created an IAM user:

```text
cloud-lab-readonly
```

The user was given AWS Management Console access.

The user was added to:

```text
CloudLabReadOnly
```

### Part 4 - Test Access

I signed in as the read-only IAM user and tested access.

Expected behavior:

```text
Can view AWS resources
Cannot create, modify, or delete AWS resources
```

This demonstrated least privilege.

## Root User vs IAM User

### Root User

The root user is the original AWS account identity with full account-level access.

Root should be protected with MFA and should not be used for daily work.

### IAM User

An IAM user is a separate identity that can be granted specific permissions.

IAM users should be used instead of root for daily administrative or operational work.

## IAM User vs IAM Group vs IAM Policy

```text
User = identity that logs in
Group = collection of users
Policy = permissions document
```

Simple model:

```text
User belongs to group.
Group has policy.
Policy grants permissions.
```

## IAM Role Preview

An IAM role is an identity that can be assumed temporarily.

Roles are commonly used by AWS services and applications.

Example:

```text
An EC2 instance can assume a role to access S3 without storing access keys on the server.
```

Roles will be covered in a later lab.

## MFA Notes

MFA should be enabled for important identities, especially:

```text
root user
admin users
IAM users with console access
```

MFA adds a second layer of protection beyond the password.

## Security Notes

- Do not use the root user for daily work.
- Do not create root access keys.
- Use IAM users, groups, roles, and policies.
- Grant only the permissions needed.
- Avoid broad admin access unless required.
- Do not create access keys unless there is a specific need.
- Do not upload passwords, private keys, or access keys to GitHub.

## Shared Responsibility Model Connection

AWS is responsible for security of the cloud.

I am responsible for security in the cloud.

For IAM, my responsibilities include:

```text
creating secure identities
enabling MFA
assigning least privilege permissions
protecting credentials
removing unused access
not using root for daily tasks
```

## What I Learned

- IAM controls access to AWS services and resources.
- Root has full account-level power and should be protected.
- IAM users are identities for people or workloads.
- IAM groups help assign permissions to multiple users.
- IAM policies define allowed or denied actions.
- AWS managed policies are maintained by AWS.
- Read-only access is safer for learning than unnecessary admin access.
- Least privilege means giving only the access needed.
- IAM roles are used for temporary assumed permissions and AWS service access.
- MFA should be enabled on important identities.

## Why This Matters for Cloud Engineering

Cloud engineers must understand IAM because access control is central to cloud security.

Poor IAM design can lead to:

```text
over-permissioned users
credential leaks
unauthorized access
resource deletion
security incidents
compliance issues
```

This lab helped me understand the basic building blocks of AWS access control.

## Next Step

Continue AWS IAM learning with:

```text
IAM roles
custom policies
permission boundaries
AWS CLI authentication
S3 access control
EC2 instance roles
```
