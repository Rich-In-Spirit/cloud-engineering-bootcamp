# Day 1 Linux VM Setup

## Date
May 1, 2026

## Objective
Set up my first Linux VM for cloud engineering labs and run basic Linux commands.

## VM Details
- OS: Ubuntu Server 26.04 LTS
- Hypervisor: Oracle VirtualBox
- Host Machine: Windows gaming PC
- CPU Assigned: 2 cores
- RAM Assigned: 4096 MB
- Disk Assigned: 40 GB
- Network Mode: NAT
- VM Hostname: ubuntu-cloud-lab-01
- Linux Username: sal

## Commands Run

```bash
whoami
hostname
ip a
pwd
ls -la
sudo apt update
mkdir ~/day1-linux-test
cd ~/day1-linux-test
echo "Day 1 Linux lab complete" > notes.txt
cat notes.txt


```

## Key Observations

- I logged into the VM through the VirtualBox console, not through SSH yet.
- The VM is running Ubuntu Server 26.04 LTS.
- The VM hostname is `ubuntu-cloud-lab-01`.
- My Linux username is `sal`.
- The VM received the IP address `10.0.2.15` through VirtualBox NAT networking.
- The loopback interface `lo` uses `127.0.0.1`, which represents the machine talking to itself.
- The `enp0s3` interface is the VM's main virtual network adapter.
- Linux password prompts do not show characters while typing.
- I accidentally failed the first `sudo` authentication attempt, then successfully entered the password and ran `sudo apt update`.
- `sudo apt update` refreshed package repository information and showed that packages were up to date.

## What I Learned

- Logging into the VirtualBox console is like sitting directly in front of the Linux server.
- SSH is different because it lets me remotely connect to the server from another terminal.
- `whoami` shows the current logged-in user.
- `hostname` shows the system/server name.
- `ip a` shows network interfaces and IP addresses.
- `pwd` shows the current working directory.
- `ls -la` lists all files, including hidden files, with detailed information.
- `mkdir` creates directories.
- `cd` changes directories.
- `echo` can print text, and with `>` it can write text into a file.
- `cat` displays the contents of a file.
- `sudo apt update` updates Ubuntu's package index but does not actually install upgrades.

## What Confused Me

- I initially wondered whether logging into the VM console counted as SSH.
- `ip a` showed more information than I expected, so I need more practice reading Linux network output.
- `ls -la` showed permissions, owners, groups, hidden files, sizes, and timestamps, but I still need to understand Linux permissions better.
- I need more practice understanding the difference between the VM, the host machine, VirtualBox NAT, and SSH access.

## Troubleshooting / Issues

- The Ubuntu download page was slow/buggy at first, but the ISO eventually downloaded.
- I saw checksum/SHA256 information during the download process but did not fully verify the ISO yet.
- I had one failed `sudo` password attempt because Linux does not show password characters while typing.
- No major install issues occurred.

## Next Step

- Practice Linux navigation and file operations.
- Learn Linux permissions using `ls -la`, `chmod`, and `chown`.
- Configure SSH access from the Windows host machine into the Ubuntu VM.
- Document the SSH lab in GitHub.
