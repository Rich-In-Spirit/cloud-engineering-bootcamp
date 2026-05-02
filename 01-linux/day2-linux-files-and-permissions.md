# Day 2 Linux Files and Permissions

## Date
May 5, 2026

## Objective

Practice Linux navigation, file operations, and basic permissions.

## Lab Environment

- Host Machine: Windows gaming PC
- Hypervisor: Oracle VirtualBox
- Guest VM: Ubuntu Server 26.04 LTS
- Access Method: SSH from Windows PowerShell
- SSH Command:

```powershell
ssh sal@127.0.0.1 -p 2222

```
## Lab 1: Navigation and File Operations 
- Commands Run
  
````text
whoami
hostname
pwd
ls
ls -la

mkdir -p ~/linux-practice/day2
cd ~/linux-practice/day2
pwd

touch notes.txt commands.txt mistakes.txt
ls -la

echo "Day 2 Linux practice" > notes.txt
cat notes.txt

echo "Today I am practicing navigation, files, and permissions." >> notes.txt
cat notes.txt

cp notes.txt notes-copy.txt
ls -la
cat notes-copy.txt

mv mistakes.txt lessons-learned.txt
ls -la

rm commands.txt
ls -la

sudo apt update
sudo apt install tree -y

cd ~
tree linux-practice
````

## What I learned
- ````mkdir -p```` create a directory path, including parent directories if needed
- ````touch```` creates empty files or updates an existing file's timestamp.
- ````>```` writes to a file and overwrites existing content.
- ````>>```` appends to a file without deleting existing content.
- ````cp```` copies files.
- ````mv```` can rename or move files.
- ````rm```` removes files.
- ````tree```` shows a visual directory structure.

# Lab 2: Linux Permissions
````
cd ~/linux-practice/day2
pwd
ls -la

echo "echo Hello from my first script" > hello.sh
ls -la hello.sh
cat hello.sh

./hello.sh

ls -l hello.sh

chmod u+x hello.sh
ls -l hello.sh

./hello.sh

touch private.txt public.txt
ls -l private.txt public.txt

chmod 600 private.txt
chmod 644 public.txt

ls -l private.txt public.txt

id
groups
whoami
ls -l
````

## Permission Notes 
Linux Permissions are show in the column of ````ls -l```` or ````ls -la````
Example:

````-rw-r--r--````

Break Down:

````
-r   rw-   r--   r--
|   |     |     |
|   |     |     others
|   |     group
|   owner
file type
````
The first character tells the file type: 
````
- = regular file
d = directory
l = symbolic link
````
Permission letters:
````
r = read
w = write
x = execute
````
Numeric values:
````
r = 4
w = 2
x = 1
````
Common permission examples:
````
600 = owner read/write, group no access, others no access
644 = owner read/write, group read, others read
755 = owner read/write/execute, group read/execute, others read/execute
````

## Key Observations
- A file can be readable but not executable.
- ````hello.sh```` could not run at first because it did not have execute permission.
- ````chmod u+x hello.sh```` added execute permission for the owner/user.
- ````chmod 600 private.txt```` made the file private to the owner.
- ````chmod 644 public.txt```` made the file readable by group and others.
- ````id```` shows the current user's UID, GID, and group memberships.
- Linux groups are conceptually similar to Active Directory groups because permissions can be assigned to a group instead of only individual users.


## What Confused Me
- I need more practice reading permission strings quickly.
- I understand owner and group conceptually, but I need more hands-on practice with multiple users and shared group permissions.
- I need more reps with numeric permissions like 600, 644, and 755.


## Why This Matters for Cloud Engineering

Cloud engineers frequently troubleshoot Linux servers, SSH keys, scripts, application files, logs, and service permissions. Understanding Linux permissions helps prevent access issues, broken deployments, and insecure configurations.

## Next Step

- Practice creating users and groups, assigning file ownership, and testing access between different Linux users.
