# S3 Security Basics Lab

## Date

May 11, 2026

## Objective

Practice Amazon S3 security fundamentals by creating a private bucket, uploading an object, checking Block Public Access, confirming default encryption, enabling versioning, reviewing object metadata, and cleaning up the bucket.

## Why This Lab Matters

S3 is one of the most commonly used AWS storage services, and it can become a major security risk if misconfigured.

This lab focused on keeping S3 private, encrypted, versioned, and properly cleaned up.

## AWS Services and Concepts Used

```text
Amazon S3
S3 buckets
S3 objects
S3 prefixes
S3 Block Public Access
Object Ownership
Bucket owner enforced
Default encryption
SSE-S3
Versioning
Storage classes
AWS CloudShell
AWS CLI
aws s3
aws s3api
IAM permissions
```

## Core Concepts

### Amazon S3

S3 stands for Simple Storage Service.

S3 is AWS object storage.

It stores data as objects inside buckets.

### S3 Bucket

An S3 bucket is a top-level container for objects.

```text
Bucket = top-level container
```

### S3 Object

An S3 object is the actual file/data stored in a bucket, along with metadata.

Example:

```text
s3-security-test.txt
version-test.txt
```

### S3 Prefix

S3 prefixes are folder-like paths inside a bucket.

S3 does not use folders exactly like Linux does.

Example:

```text
s3://my-bucket/notes/file.txt
```

Breakdown:

```text
my-bucket = bucket
notes/ = prefix
file.txt = object key/name
```

### S3 Block Public Access

S3 Block Public Access helps prevent buckets and objects from being accidentally exposed publicly.

Plain English:

```text
Block Public Access helps stop public access through ACLs, bucket policies, and access point policies.
```

For this lab, Block Public Access stayed enabled.

### Object Ownership - Bucket Owner Enforced

Bucket owner enforced means ACLs are disabled and the bucket owner owns the objects in the bucket.

Access is controlled through IAM and bucket policies rather than object ACLs.

### Default Encryption

Default encryption means S3 automatically encrypts new objects stored in the bucket.

### SSE-S3

SSE-S3 means server-side encryption with Amazon S3-managed keys.

In CLI output, this appeared as:

```text
ServerSideEncryption: AES256
```

### Versioning

Versioning keeps multiple versions of an object.

If the same object key is uploaded multiple times, S3 can preserve previous versions instead of only keeping the newest one.

Versioning helps with:

```text
accidental overwrite protection
accidental delete protection
rollback needs
data recovery scenarios
```

Versioning can also increase storage cost because old versions continue to consume storage.

### Storage Class

The default storage class for normal S3 objects is:

```text
S3 Standard
```

If `head-object` does not show a `StorageClass`, the object is usually using the default storage class.

Basic storage class awareness:

```text
S3 Standard = frequent access
S3 Standard-IA = infrequent access
S3 Glacier classes = archival / lower cost / slower retrieval
```

## Lab Configuration

The S3 bucket was created with:

```text
Region: us-east-1
Block Public Access: enabled
Object Ownership: Bucket owner enforced
Versioning: enabled
Default encryption: SSE-S3
```

## Lab Commands

### Set Bucket Name Variable

```bash
BUCKET_NAME="sal-cloud-bootcamp-s3-security-20260511-728467"
echo $BUCKET_NAME
```

### List Bucket Contents

```bash
aws s3 ls s3://$BUCKET_NAME/
```

### Check S3 Block Public Access

```bash
aws s3api get-public-access-block --bucket $BUCKET_NAME
```

Expected result:

```text
BlockPublicAcls: true
IgnorePublicAcls: true
BlockPublicPolicy: true
RestrictPublicBuckets: true
```

### Check Bucket Encryption

```bash
aws s3api get-bucket-encryption --bucket $BUCKET_NAME
```

Expected encryption:

```text
SSE-S3 / AES256
```

### Check Bucket Versioning

```bash
aws s3api get-bucket-versioning --bucket $BUCKET_NAME
```

Expected result:

```text
Status: Enabled
```

### Test Versioning

```bash
mkdir -p ~/s3-security-lab
cd ~/s3-security-lab

echo "Version 1 of S3 security lab file" > version-test.txt
aws s3 cp version-test.txt s3://$BUCKET_NAME/version-test.txt

echo "Version 2 of S3 security lab file" > version-test.txt
aws s3 cp version-test.txt s3://$BUCKET_NAME/version-test.txt
```

### List Object Versions

```bash
aws s3api list-object-versions --bucket $BUCKET_NAME --prefix version-test.txt
```

Result:

```text
Multiple versions of version-test.txt were returned.
```

### Check Object Metadata

```bash
aws s3api head-object --bucket $BUCKET_NAME --key version-test.txt
```

Important output:

```text
ContentType: text/plain
ServerSideEncryption: AES256
VersionId: present
```

No `StorageClass` appeared, which usually means the object was using the default storage class:

```text
S3 Standard
```

## Issue Encountered - Object URL / Upload Confusion

At first, the object URL or copy option appeared unavailable.

The issue was that the object had not actually finished uploading yet.

After uploading the file correctly, the object appeared when running:

```bash
aws s3 ls s3://$BUCKET_NAME/
```

Lesson:

```text
If an object does not appear in aws s3 ls, confirm it was actually uploaded before troubleshooting permissions.
```

## Issue Encountered - Versioned Bucket Cleanup

After enabling versioning, deleting a bucket became more complicated.

This is because versioned buckets may contain:

```text
current objects
older object versions
delete markers
```

The console method was easier for this beginner lab:

```text
S3 Console → Bucket → Empty → Delete bucket
```

## aws s3 vs aws s3api

### aws s3

`aws s3` provides higher-level commands for common S3 tasks.

Examples:

```bash
aws s3 ls
aws s3 cp file.txt s3://bucket/
aws s3 rm s3://bucket --recursive
```

### aws s3api

`aws s3api` provides more detailed API-style commands.

Examples:

```bash
aws s3api get-public-access-block --bucket bucket-name
aws s3api get-bucket-encryption --bucket bucket-name
aws s3api get-bucket-versioning --bucket bucket-name
aws s3api head-object --bucket bucket-name --key file.txt
```

## Sudo vs AWS Permissions

`sudo` can provide Linux admin permissions inside the shell environment.

However, `sudo` does not grant more AWS permissions.

Important distinction:

```text
sudo = Linux/root power inside CloudShell
IAM permissions = AWS API permissions
```

If AWS denies an action because of IAM permissions, `sudo` will not fix it.

## IAM Connection

This lab connects to IAM because S3 actions are allowed or denied based on the AWS identity’s permissions.

If the current user or role does not have permission to create buckets, upload objects, read bucket settings, or delete resources, the AWS CLI command will fail.

## Cleanup

The bucket was emptied and deleted using the AWS Console.

Cleanup was verified with:

```bash
aws s3 ls
```

The lab bucket was no longer listed.

## What I Learned

- S3 buckets should be private by default.
- S3 Block Public Access helps prevent accidental public exposure.
- Bucket owner enforced disables ACLs and makes the bucket owner own objects.
- Default encryption automatically encrypts new objects.
- SSE-S3 uses Amazon S3-managed encryption keys.
- Versioning preserves multiple versions of the same object.
- Versioning can increase storage cost.
- Deleting versioned buckets is more complicated because old versions and delete markers can remain.
- The default S3 storage class is S3 Standard.
- `aws s3` is for common/high-level S3 tasks.
- `aws s3api` is for detailed S3 API-style operations.
- `sudo` does not give more AWS permissions.
- IAM controls what AWS CLI actions the current identity can perform.

## Why This Matters for Cloud Engineering

S3 is widely used for storing application data, backups, logs, static website assets, exports, and cloud-native workloads.

Cloud engineers must understand how to secure S3 because misconfigured buckets can expose sensitive data.

Important cloud engineering habits:

```text
keep buckets private by default
block public access unless public access is intentional
encrypt data at rest
understand versioning and cost impact
clean up resources after labs
verify settings with AWS CLI
understand IAM permission boundaries
```

## AWS Cloud Practitioner Connections

This lab connects to these AWS Cloud Practitioner topics:

```text
S3 object storage
S3 buckets and objects
S3 security
Block Public Access
Encryption at rest
Storage classes
Versioning
IAM permissions
Shared Responsibility Model
Cost awareness
```

## Next Step

Continue AWS foundations with:

```text
S3 storage classes and lifecycle rules
IAM roles
EC2 instance role accessing S3
AWS CLI from local workstation
```
