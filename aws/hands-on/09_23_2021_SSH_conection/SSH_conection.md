# Hands-on EC2-00 : How to Connect EC2 instance with SSH.

## Outline

- Part 1 - Launching an Amazon Linux 2 EC2 instance

- Part 2 - Connect with SSH for WINDOWS-"Gitbash"

- Part 3 - Connect with SSH for WINDOWS- "WSL"

- Part 4 - Connect with SSH for MAC and Linux 


## Part 1 - Launching an Amazon Linux 2 EC2 instance

1. Launch an Amazon EC2 instance with name of "First EC2"
```text
AMI             : "Amazon Linux 2"
Instance Type   : "t2micro"
Region:          "N.Virginia"
VPC             : "Default VPC"
Security Group: "0.0.0.0/0-----> Port 22"
Keypair         : Create a new one as "firstkey"
```
- Explain roughly all steps.
- BUT , explain the "Public key" and "Private key" concepts elaborately 

## Part 1 - Connect with SSH for WINDOWS-"Gitbash"

# STEP_1_ Gitbash

- Open gitbash 

- Go the directory of ".pem file" and try to see "firstkey.pem" file.

```text
cd \Downloads\
ls
```
- You need to see "firstkey.pem" as a response 

# STEP_2_Connecting with Gitbash

- Go to EC2 instance pane 

- Click on "First EC2" instance

- Click on "Connect"

- Show the connection alternatives 

- Select SHH connection option 

- Copy the connection script

```text
ssh -i .....pem ec2-user@
```

- Paste the script on gitbash terminal 

- Hit the enter and then type "y" if asked.

- You are inside the EC2 


## Part 3 - Part 3 - Connect with SSH for WINDOWS- "WSL"

# STEP_1_ Copy the .pem file to the "WSL" filesystem

- Open WSL 

- Go the directory of ".pem file" and try to see "firstkey.pem" file.

```text
cd /mnt/c/Users/??????/Downloads
ls
```
- You need to see "firstkey.pem" as a response  

- Since "firstkey.pem" is in the Windows file system we need to transfer it to teh WSL file system. 

```text
cp firstkey.pem ~
cd (go to home directory)
ls
```
- You need to "firstkey.pem" response 
- type "ls -al""
- Show that .pem file is writeable readable and executable. It is not suitable for secure connection. 

- Make "firstkey.pem" only readable 

```text
sudo chmod 400 firstkey.pem
```
# STEP_2_Connecting with WSL

- Go to EC2 instance pane 

- Click on "First EC2" instance

- Click on "Connect"

- Select SHH connection option 

- Copy the connection script

```text
ssh -i .....pem ec2-user@
```

- Paste the script on WSL terminal 

- Hit the enter and then type "y" if asked.

- You are inside the EC2 

## Part 4 - Connect with SSH for MAC and Linux 


# STEP_1_ Linux and MAC Terminal

- Open terminal

- Go the directory of ".pem file" and try to see "firstkey.pem" file.

```text
cd \Downloads\
ls
```
- You need to "firstkey.pem" response 
- type "ls -al"
- Show that .pem file is writeable readable and executable. It is not suitable for secure connection. 

- Make "firstkey.pem" only readable 

```text
sudo chmod 400 firstkey.pem
```
# STEP_2_Connecting with terminal

- Go to EC2 instance pane 

- Click on "First EC2" instance

- Click on "Connect"

- Select SHH connection option 

- Copy the connection script

```text
ssh -i .....pem ec2-user@
```

- Paste the script on terminal 

- Hit the enter and then type "y" if asked.

- You are inside the EC2 