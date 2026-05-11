# AWS CloudShell and S3 Basics Lab

## Date

May 10, 2026

## Objective

Practice using AWS CloudShell and the AWS CLI to create, manage, upload to, download from, and clean up an Amazon S3 bucket.

This lab focused on basic AWS CLI usage, S3 buckets, S3 objects, prefixes, recursive copy/delete, and cloud resource cleanup.

## Why This Lab Matters

Cloud engineers need to be comfortable using AWS from the command line, not only through the AWS Console.

This lab introduced AWS CLI workflows in a safe browser-based environment using AWS CloudShell.

## AWS Services and Concepts Used

```text
AWS CloudShell
AWS CLI
AWS STS
Amazon S3
S3 buckets
S3 objects
S3 prefixes
IAM permissions
Resource cleanup
```

## Core Concepts

### AWS CloudShell

AWS CloudShell is a browser-based Linux shell inside the AWS Console.

It comes with the AWS CLI preinstalled and uses the AWS identity from the current console session.

Plain-English explanation:

```text
CloudShell = AWS terminal in the browser
```

CloudShell can run Linux commands such as:

```bash
pwd
ls
mkdir
cd
cat
echo
touch
rm
python3
```

It can also run AWS CLI commands such as:

```bash
aws s3 ls
aws sts get-caller-identity
```

### AWS CLI

AWS CLI stands for AWS Command Line Interface.

It is a command-line tool used to interact with AWS services.

Important distinction:

```text
CloudShell = terminal environment
AWS CLI = aws command-line tool used inside that environment
```

Example:

```bash
aws s3 ls
```

### AWS STS

STS stands for Security Token Service.

The command:

```bash
aws sts get-caller-identity
```

shows which AWS identity is currently making AWS API calls.

This matters because AWS permissions depend on the identity being used.

### Amazon S3

S3 stands for Simple Storage Service.

S3 is AWS object storage.

It stores data as objects inside buckets.

### S3 Bucket

An S3 bucket is a top-level container for objects.

Simple version:

```text
Bucket = top-level storage container
```

### S3 Object

An S3 object is the actual file/data stored inside a bucket.

Examples from this lab:

```text
day9-s3-test.txt
notes/s3-concept.txt
notes/bucket-names.txt
notes/object-storage.txt
```

### S3 Prefix

S3 does not use folders in the same way Linux does.

What looks like a folder is usually a prefix.

Example:

```text
s3://my-bucket/notes/s3-concept.txt
```

Breakdown:

```text
my-bucket        = bucket
notes/           = prefix
s3-concept.txt   = object key/name
```

### Globally Unique Bucket Names

S3 bucket names must be globally unique across AWS.

That means no two AWS accounts can use the same bucket name at the same time.

## Lab Commands

### Verify AWS CLI

```bash
aws --version
```

### Verify Current AWS Identity

```bash
aws sts get-caller-identity
```

### Create Local Lab Folder in CloudShell

```bash
mkdir -p ~/s3-lab
cd ~/s3-lab
echo "Day 9 S3 lab from AWS CloudShell" > day9-s3-test.txt
cat day9-s3-test.txt
```

### Create Bucket Name Variable

```bash
BUCKET_NAME="sal-cloud-bootcamp-s3-lab-20260510-728467"
echo $BUCKET_NAME
```

### Create S3 Bucket

```bash
aws s3 mb s3://$BUCKET_NAME
```

`mb` means make bucket.

### List Buckets

```bash
aws s3 ls
```

### Upload File to S3

```bash
aws s3 cp day9-s3-test.txt s3://$BUCKET_NAME/
```

### List Bucket Contents

```bash
aws s3 ls s3://$BUCKET_NAME/
```

### Download File from S3

```bash
mkdir -p ~/s3-lab-download
aws s3 cp s3://$BUCKET_NAME/day9-s3-test.txt ~/s3-lab-download/
cat ~/s3-lab-download/day9-s3-test.txt
```

### Create Multiple Local Files

```bash
mkdir -p notes
echo "S3 stores objects in buckets." > notes/s3-concept.txt
echo "Bucket names are globally unique." > notes/bucket-names.txt
echo "S3 is object storage, not block storage." > notes/object-storage.txt
```

### Upload Folder/Prefix Recursively

```bash
aws s3 cp notes/ s3://$BUCKET_NAME/notes/ --recursive
```

### List Bucket Recursively

```bash
aws s3 ls s3://$BUCKET_NAME/ --recursive
```

### Delete Objects Recursively

```bash
aws s3 rm s3://$BUCKET_NAME --recursive
```

### Delete Bucket

```bash
aws s3 rb s3://$BUCKET_NAME
```

### Confirm Bucket Was Deleted

```bash
aws s3 ls
```

## Issue Encountered

### Problem

The first attempt to delete the bucket failed with:

```text
BucketNotEmpty
```

### Cause

The bucket still contained objects under the `notes/` prefix.

S3 buckets generally must be empty before they can be deleted.

### Fix

I deleted all objects in the bucket recursively:

```bash
aws s3 rm s3://$BUCKET_NAME --recursive
```

Then I deleted the bucket:

```bash
aws s3 rb s3://$BUCKET_NAME
```

Finally, I verified the bucket was gone:

```bash
aws s3 ls
```

## Important Cleanup Lesson

This command only targets a specific object/path:

```bash
aws s3 rm s3://$BUCKET_NAME
```

This command deletes everything under the bucket path:

```bash
aws s3 rm s3://$BUCKET_NAME --recursive
```

## Sudo Lesson

`sudo` can give administrative privileges inside the CloudShell Linux environment.

However, `sudo` does not grant more AWS permissions.

Important distinction:

```text
sudo = Linux/root power inside CloudShell
IAM permissions = AWS API permissions
```

If AWS denies an action because of IAM permissions, `sudo` will not fix it.

## IAM Connection

This lab connects to IAM because AWS CLI actions depend on the permissions of the AWS identity currently being used.

If the current identity does not have S3 permissions, S3 commands will fail.

The command below shows which identity is being used:

```bash
aws sts get-caller-identity
```

## What I Learned

- CloudShell is a browser-based AWS terminal.
- AWS CLI is the command-line tool used to interact with AWS services.
- `aws sts get-caller-identity` shows the current AWS identity.
- S3 is AWS object storage.
- An S3 bucket is a top-level container.
- An S3 object is the actual file/data stored in a bucket.
- S3 prefixes look like folders but are not traditional Linux folders.
- Bucket names must be globally unique across AWS.
- `aws s3 mb` creates a bucket.
- `aws s3 cp` copies files between local storage and S3.
- `--recursive` applies the command to everything under a path/prefix.
- Buckets must be empty before deletion unless using force options.
- `sudo` does not provide additional AWS permissions.
- AWS permissions come from IAM.

## Why This Matters for Cloud Engineering

Cloud engineers need to work from both the AWS Console and the command line.

This lab introduced command-line cloud operations using CloudShell and AWS CLI.

It also reinforced important operational habits:

```text
verify identity before running commands
use unique resource names
upload and download safely
understand object storage
clean up resources
know the difference between local shell permissions and AWS IAM permissions
```

## AWS Cloud Practitioner Connections

This lab connects to these AWS Cloud Practitioner topics:

```text
S3
Object storage
AWS CLI
IAM permissions
Shared Responsibility Model
Cost/resource cleanup
CloudShell
```

## Next Step

Next, continue S3 with security-focused topics:

```text
S3 Block Public Access
Bucket policies
S3 encryption
S3 versioning
Storage classes
Lifecycle rules
```
