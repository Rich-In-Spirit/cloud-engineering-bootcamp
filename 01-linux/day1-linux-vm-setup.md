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
