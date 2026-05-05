# Day 4 SSH Keys and UFW Firewall Lab

## Date
May 4, 2026

## Objective

Configure SSH key-based authentication for my Ubuntu Server VM and enable a basic Linux firewall using UFW.

This lab builds on previous Linux server administration work by moving from password-based SSH to SSH key authentication and adding firewall rules for SSH, HTTP, and basic port awareness.

## Lab Environment

- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- VM Hostname: ubuntu-cloud-lab-01
- Linux User: sal
- Access Method: SSH from Windows PowerShell
- SSH Port Forwarding: Windows `127.0.0.1:2222` forwards to Ubuntu VM port `22`
- Web Server: NGINX
- Firewall Tool: UFW

## Starting State

Before this lab:

- I could SSH into the Ubuntu VM from Windows PowerShell using a password.
- NGINX was already installed and running.
- The VM was using VirtualBox NAT networking.
- VirtualBox port forwarding allowed Windows port `2222` to reach the VM's SSH port `22`.

Existing SSH command:

```powershell
ssh sal@127.0.0.1 -p 2222
```

## Lab Goal

Generate an SSH key pair on Windows, add the public key to the Ubuntu VM, confirm SSH key-based login works, enable UFW firewall, allow required ports, and verify that SSH and NGINX still work after the firewall is enabled.

## Commands Run

```powershell
ssh sal@127.0.0.1 -p 2222

ssh-keygen -t ed25519 -C "sal-cloud-lab"

type "$env:USERPROFILE\.ssh\id_ed25519.pub"

ssh sal@127.0.0.1 -p 2222
```

```bash
whoami
hostname
exit

mkdir -p ~/.ssh
chmod 700 ~/.ssh

nano /home/sal/.ssh/authorized_keys

chmod 600 /home/sal/.ssh/authorized_keys
ls -ld /home/sal/.ssh
ls -l /home/sal/.ssh/authorized_keys

whoami
pwd
echo $HOME
ls -ld ~/.ssh
stat ~/.ssh

sudo chown -R sal:sal /home/sal/.ssh
sudo chmod 700 /home/sal/.ssh
ls -ld /home/sal/.ssh

exit
```

```powershell
ssh sal@127.0.0.1 -p 2222
```

```bash
sudo apt update
sudo apt install ufw -y
sudo ufw status verbose

sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw enable

sudo ufw status numbered
sudo ufw status verbose

systemctl status nginx
curl localhost
sudo ss -tulnp | grep ':80'
sudo ss -tulnp | grep ':443'
sudo ufw status verbose

exit
```

```powershell
ssh sal@127.0.0.1 -p 2222
```

## Key Concepts

### SSH Key Authentication

SSH key authentication allows a user to log in to a Linux server using a key pair instead of a password.

The key pair has two parts:

```text
Private key = stays on the client machine and must be protected
Public key  = copied to the server and placed in authorized_keys
```

In this lab:

```text
Private key location on Windows:
C:\Users\Salvador Yanes\.ssh\id_ed25519

Public key location on Windows:
C:\Users\Salvador Yanes\.ssh\id_ed25519.pub

Public key location on Ubuntu:
/home/sal/.ssh/authorized_keys
```

### Private Key

The private key is sensitive.

It should not be shared, uploaded to GitHub, pasted into documentation, or exposed publicly.

The private key file was:

```text
id_ed25519
```

### Public Key

The public key is safe to copy to the server.

The public key file was:

```text
id_ed25519.pub
```

The public key started with:

```text
ssh-ed25519
```

### authorized_keys

The `authorized_keys` file stores public keys that are allowed to log in as a specific Linux user.

Path used in this lab:

```text
/home/sal/.ssh/authorized_keys
```

Plain-English explanation:

```text
authorized_keys is the SSH guest list for the sal user.
```

If the private key on Windows matches a public key in `authorized_keys`, SSH login is allowed without entering the Ubuntu password.

### SSH Key Mental Model

```text
Windows private key
        |
        | proves identity
        v
Ubuntu authorized_keys file contains matching public key
        |
        v
Login allowed without password
```

Short version:

```text
Private key stays with me.
Public key goes on the server.
authorized_keys is the server's guest list.
```

### .ssh Directory Permissions

The `.ssh` directory must be locked down.

Expected permission:

```text
drwx------
```

Numeric permission:

```text
700
```

Meaning:

```text
Owner: read/write/execute
Group: no access
Others: no access
```

Command:

```bash
chmod 700 /home/sal/.ssh
```

### authorized_keys Permissions

The `authorized_keys` file must also be locked down.

Expected permission:

```text
-rw-------
```

Numeric permission:

```text
600
```

Meaning:

```text
Owner: read/write
Group: no access
Others: no access
```

Command:

```bash
chmod 600 /home/sal/.ssh/authorized_keys
```

### UFW

UFW stands for Uncomplicated Firewall.

It is a simpler way to manage Linux firewall rules.

Plain-English explanation:

```text
UFW controls what inbound network traffic is allowed into the Linux server.
```

### Firewall Ports

Common ports used in this lab:

```text
22  = SSH
80  = HTTP
443 = HTTPS
```

### Least Privilege

A better security habit is to only open ports that are actually needed.

Opening port `443` was useful as a rep because HTTPS uses 443, but if no service is listening on 443 yet, it does not need to remain open.

To check whether anything is listening on 443:

```bash
sudo ss -tulnp | grep ':443'
```

If no output appears, no service is listening on that port.

## Key Observations

- I successfully generated an SSH key pair on Windows.
- I confirmed the difference between the private key and public key.
- I accidentally displayed the private key at first, which was a good security lesson.
- The public key was the correct key to copy to the Ubuntu VM.
- SSH key authentication worked after adding the public key to `authorized_keys`.
- After key authentication worked, I could SSH into the VM without entering the Ubuntu password.
- The `.ssh` directory needed strict permissions.
- The `authorized_keys` file needed strict permissions.
- I ran into a permission issue because of how `.ssh` was created and referenced.
- I corrected the issue by fixing ownership and permissions.
- UFW was enabled successfully.
- SSH still worked after enabling UFW.
- NGINX still served the local web page after enabling UFW.
- UFW showed allowed inbound rules for SSH and HTTP.
- I also allowed 443/tcp as an extra rep, but learned that ports should only stay open when needed.

## Issues / Troubleshooting

### Issue 1 - Accidentally Displayed Private Key

I accidentally displayed the private key file instead of the public key file.

Wrong file:

```text
id_ed25519
```

Correct file:

```text
id_ed25519.pub
```

The private key output started with:

```text
-----BEGIN OPENSSH PRIVATE KEY-----
```

Lesson:

```text
Never share, upload, or paste private keys.
```

### Issue 2 - .ssh Permission Error

I received:

```text
chmod: Operation not permitted
```

This happened while trying to set permissions on `.ssh`.

Troubleshooting commands used:

```bash
whoami
pwd
echo $HOME
ls -ld ~/.ssh
stat ~/.ssh
```

Fix used:

```bash
sudo chown -R sal:sal /home/sal/.ssh
sudo chmod 700 /home/sal/.ssh
```

### Issue 3 - Windows Path vs Linux Path

I accidentally used a Windows-style path:

```text
~\.ssh
```

Correct Linux path:

```text
~/.ssh
```

Full correct path:

```text
/home/sal/.ssh
```

Lesson:

```text
Windows commonly uses backslashes.
Linux uses forward slashes.
```

### Issue 4 - Opened Port 443 Before HTTPS Was Configured

I allowed port 443 because I knew it was used for HTTPS.

Correction:

```text
Port 443 should only stay open if HTTPS is actually configured and needed.
```

Verification command:

```bash
sudo ss -tulnp | grep ':443'
```

Security lesson:

```text
Opening unused ports is not least privilege.
```

## What I Learned

- SSH key authentication is more realistic than password-based SSH.
- SSH keys come in pairs: private key and public key.
- The private key stays on the client machine.
- The public key goes on the Linux server.
- `authorized_keys` stores public keys that are allowed to log in.
- SSH permissions are strict.
- `.ssh` should be set to `700`.
- `authorized_keys` should be set to `600`.
- Linux paths use `/`, not `\`.
- Linux environment variables are case-sensitive, so `$HOME` works but `$home` does not.
- `sudo` should not be used unnecessarily in a user's home directory.
- `chown` can fix ownership issues.
- UFW controls inbound firewall traffic.
- SSH should be allowed before enabling UFW.
- HTTP uses port 80.
- HTTPS uses port 443.
- Open only the ports that are actually needed.
- Firewall changes should always be verified by testing connectivity afterward.

## New Commands Learned

### ssh-keygen

Creates SSH keys.

```powershell
ssh-keygen -t ed25519 -C "sal-cloud-lab"
```

### type

Displays file contents in PowerShell.

```powershell
type "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

### nano

Terminal-based text editor.

```bash
nano /home/sal/.ssh/authorized_keys
```

### stat

Shows detailed metadata about a file or directory.

```bash
stat /home/sal/.ssh
```

### chown

Changes ownership.

```bash
sudo chown -R sal:sal /home/sal/.ssh
```

### ufw

Manages firewall rules.

```bash
sudo ufw status verbose
```

### ufw allow

Allows inbound traffic for a service or port.

```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
```

### ufw enable

Turns on the firewall.

```bash
sudo ufw enable
```

## Final Verification

### SSH Key Login

Command from Windows PowerShell:

```powershell
ssh sal@127.0.0.1 -p 2222
```

Result:

```text
Logged in without entering the Ubuntu password.
```

### Firewall Status

Command:

```bash
sudo ufw status verbose
```

Result:

```text
Status: active
Default: deny incoming, allow outgoing
Allowed: SSH, HTTP, and 443/tcp if still present
```

### NGINX Test

Command:

```bash
curl localhost
```

Result:

```text
NGINX page returned successfully.
```

### Port 80 Check

Command:

```bash
sudo ss -tulnp | grep ':80'
```

Result:

```text
NGINX was listening on port 80.
```

## Why This Matters for Cloud Engineering

Cloud engineers frequently connect to Linux servers using SSH keys.

AWS EC2 Linux instances commonly use key-based SSH access instead of password login.

Cloud engineers also need to understand firewall rules, security groups, allowed ports, and least privilege network access.

This lab connects directly to future AWS work:

```text
Local SSH key auth       -> AWS EC2 key pair login
UFW firewall             -> Linux host firewall
Allowed port 22          -> SSH access
Allowed port 80          -> HTTP access
Least privilege ports    -> Cloud security group design
```

The same mental model will apply when configuring AWS Security Groups:

```text
Only allow the ports required for the workload.
```

## Next Step

- Decide whether to remove the unused 443 rule until HTTPS is configured.
- Practice documenting the Linux web server as a project artifact instead of only a learning log.
- Move toward AWS EC2 and repeat this same pattern in the cloud:
  - SSH key login
  - security group rules
  - install NGINX
  - verify port 80
  - test web access
  - document the project
