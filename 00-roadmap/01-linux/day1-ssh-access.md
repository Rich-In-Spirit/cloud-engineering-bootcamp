# Day 1 SSH Access Lab

## Date
May 1, 2026

## Objective
Connect from my Windows gaming PC host machine into my Ubuntu Server VM using SSH.

## Lab Setup
- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- VM Name: ubuntu-cloud-lab-01
- VM Username: sal
- VM Network Mode: NAT
- SSH Service: OpenSSH Server

## Problem
The Ubuntu VM was running in VirtualBox NAT mode. The VM had an internal NAT IP address of `10.0.2.15`, but the Windows host could not directly SSH into that IP normally.

## Solution
I configured VirtualBox port forwarding so that traffic from my Windows host on port `2222` forwards to the Ubuntu VM on port `22`.

## Port Forwarding Rule

```text
Name: SSH
Protocol: TCP
Host IP: 127.0.0.1
Host Port: 2222
Guest IP: blank
Guest Port: 22

```
## Commands Used on Ubuntu VM 

```text
sudo systemctl start ssh
systemctl status ssh
sudo systemctl enable ssh
systemctl is-enabled ssh
systemctl is-active ssh
sudo ss -tulnp | grep ':22'
```

## Commands Used from Windws Powershell

````text
ssh sal@127.0.0.1 -p 2222
````
## Commands Used after SSH Login

````text
whoami
hostname
pwd
ip a
mkdir -p ~/ssh-lab
echo "SSH from Windows host to Ubuntu VM Successful" > ~/ssh-lab/ssh-proof.txt
cat ~/ssh-lab/ssh-proof.txt
exit
````


## What I Learned
- Logging into the VirtualBox console is not the same thing as SSH.
- SSH lets me remotely access and manage a Linux server from another terminal.
- OpenSSH Server must be installed and running on the Linux VM.
- Port 22 is the default SSH port.
- Because the VM used NAT networking, I needed VirtualBox port forwarding.
- I connected from Windows PowerShell to 127.0.0.1 on port 2222, which forwarded into the VM's port 22.
- systemctl is used to check, start, and enable Linux services.
- ss can be used to check listening network ports.

## What Confused Me
- SSH was installed but initially showed as inactive.
- Ubuntu appeared to use socket activation for SSH, but I manually started and enabled the SSH service to make the behavior clearer.
- I did not initially understand why I could not just SSH directly into 10.0.2.15.
- The ss -tulnp | grep ssh command did not show output until I used sudo and/or searched by port :22.

## Why This Matters for Cloud Engineering 
- Cloud engineers often manage Linux servers remotely using SSH. This lab simulates the same pattern used when connecting to cloud VMs like AWS EC2 instances or Azure Linux VMs.


## Next Step 
- Practice SSH key-based authentication later, because it is more secure and more realistic thn password-based SSH


