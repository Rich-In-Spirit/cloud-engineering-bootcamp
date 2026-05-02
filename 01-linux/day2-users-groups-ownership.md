# Day 2 Users, Groups, and Ownership Lab

## Date
May 5, 2026

## Objective

Practice Linux users, groups, ownership, and shared directory permissions.

## Lab Environment

- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- Access Method: SSH from Windows PowerShell
- SSH Command:

```powershell
ssh sal@127.0.0.1 -p 2222
````
## Lab Goal

Create a new Linux group, create a second user, add both users to the group, and test shared file access through Linux permissions.

## Commands Run
````
whoami
id
groups

sudo groupadd cloudteam
getent group cloudteam

sudo adduser devuser
id devuser

sudo usermod -aG cloudteam sal
sudo usermod -aG cloudteam devuser

groups sal
````
## Shared File Test Inside /home/sal

````
mkdir -p ~/linux-practice/day2-users-groups
cd ~/linux-practice/day2-users-groups

echo "Cloud team shared note" > shared-note.txt
ls -l shared-note.txt

sudo chown sal:cloudteam shared-note.txt
chmod 660 shared-note.txt
ls -l shared-note.txt

su - devuser

cat /home/sal/linux-practice/day2-users-groups/shared-note.txt
echo "devuser added a line" >> /home/sal/linux-practice/day2-users-groups/shared-note.txt
exit
````

## Result

The test under /home/sal failed with permission denied.

## Why It Failed

Even though devuser belonged to the cloudteam group and the file had group permissions, Linux checks permissions across the full path.

The file was located under:
````/home/sal/linux-practice/day2-users-groups/shared-note.txt````
````devuser```` did not have permission to traverse one or more parent directories, likely ````/home/sal````.

Key lesson:
File permissions are not enough. Directory path permissions matter too.

## Shared Directory Under /srv
````
sudo mkdir -p /srv/cloudteam
ls -l /srv

sudo chown root:cloudteam /srv/cloudteam
sudo chmod 2770 /srv/cloudteam
ls -ld /srv/cloudteam

echo "Shared cloudteam workspace" | sudo tee /srv/cloudteam/team-notes.txt
sudo chown root:cloudteam /srv/cloudteam/team-notes.txt
sudo chmod 660 /srv/cloudteam/team-notes.txt
ls -l /srv/cloudteam

su - devuser

whoami
groups
cat /srv/cloudteam/team-notes.txt
echo "devuser successfully wrote to the shared file" >> /srv/cloudteam/team-notes.txt
cat /srv/cloudteam/team-notes.txt
exit
````

## Successful Result 
````devuser```` was able to read and write to:
````/srv/cloudteam/team-notes.txt````
Outpit included: 
````
Shared cloudteam workspace
devuser successfully wrote to the shared file
````

## Key Concepts
### User
  A user is an individual account on the Linux System.
  Example:
  ````
  sal
  devuser
  ````
### Group 
  A group is a collection of users. Permissions can be assigned to a group so multiple users can share access.
  Example: 
  ````cloudteam````
### Ownership 
Linux files and directories have an owner and a group. 
Example: 
````root cloud team````
This means: 
````
Owner = root
Group = cloudteam
````
````chown root:cloudteam /srv/cloudteam````
This change the directory ownership so that the owner was ````root````and the group was ````cloud team````.

````chmod 2770 /srv/cloudteam````
This set permissions on the shared directory:
````
2 = setgid bit
7 = owner has read/write/execute
7 = group has read/write/execute
0 = others have no access
````
the setgid bit helps new files and folders created inside inherint the ````cloudteam```` group/

````chmod 660 team-notes.txt```` 
This set permissions on the file:
````
6 = owner read/write
6 = group read/write
0 = others no access
````

## What I Learned 
- Linux users and groups are used to control access.
- Group-based permissions are cleaner than giving access to everyone.
- ````groupadd```` creates a new group.
- ````adduser```` creates a new user.
- `````usermod -aG````` adds a user to a supplementary group.
- The ````-a```` flag is important because it appends group membership instead of replacing existing groups.
- ````chown```` changes file or directory ownership.
- ````chmod```` changes file or directory permissions.
- ````/home/sal```` is a personal user path and may block other users.
- ````/srv/cloudteam```` is a better shared location for team/service data.
- Directory permissions matter just as much as file permissions.

## What Confused Me
- I initially expected ````devuser```` to access the file under ````/home/sal```` because the file had group permissions.
- I learned that parent directory permissions can still block access.
- I initially forgot to use ````sudo```` when creating ````/srv/cloudteam````, which failed because ````/srv```` is owned by root.
- I need more practice with special permissions like setgid.


## Why This Matters for Cloud Engineering

Cloud engineers often manage Linux servers where applications, scripts, logs, and service directories need correct ownership and permissions. Misconfigured permissions can break deployments, block services from reading files, expose sensitive data, or create security risks.

This lab also connects to cloud IAM thinking: assign access by role or group instead of giving broad access to everyone.

## Next Step

Practice Linux services with ````systemctl````, logs with ````journalctl````, and package management with ````apt````.
