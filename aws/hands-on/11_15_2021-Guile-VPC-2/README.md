## Part 2 - Creating Bastion Host and connect to the private subnet from internet

- discuss about how to connect to the "clarus-az1b-private-subnet" instance

- Explain logic of why we need Bastion Host?

- Launch two Instance. One is in Private Subnet-1b, the other one is in Public Subnet-1b

- Configure Private instance.

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1b-private-subnet
Security Group  : 
    Sec.Group Name : Private Sec.group
    Rules          : TCP --- > 22 ---> Anywhere
                     All ICMP IPv4  ---> Anywhere
Tag             :
    Key         : Name
    Value       : Private EC2
```
- show that you can't connect directly to private instance from local with ssh connection.

- Configure Public instance (Bastion Host).

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1b-public-subnet
Security Group  : 
    Sec.Group Name : Public Sec.group(Bastion Host)
    Rules          : TCP --- > 22 ---> Anywhere
                   : All ICMP IPv4  ---> Anywhere
Tag             :
    Key         : Name
    Value       : Public EC2 (Bastion Host)
```

- This configuration adds an extra layer of security and can also be used.
```text
Rules        : TCP --- > 22 ---> Anywhere
                |         |         |
                |         |         |
                V         V         V
               TCP --- > 22 ---> Public Sec.Group
``` 
- Try to connect private instance via ssh
  (As you see in the dashboard there is no public IP for instance)

- Since there is no public IP of private instance, we need to connect ssh via Bastion Host instance

- go to your local terminal

- add your private key to the ssh agent on your `localhost`. ``ssh-agent is a program that runs in background and stores your keys in memory`.

- Enable ssh-agent (start the ssh-agent in the background)

```bash
eval "$(ssh-agent)"
```
-  Add the your private ssh key to the ssh-agent.

```bash
ssh-add ./[your pem file name]
```
- connect to the ec2-in-az1b-public-sn instance in public subnet. 

- if we don't want to create a config file, we have another option, using -A flag with the ssh command. `-A` option `enables forwarding of the authentication agent connection`. It means that, it forwards your SSH auth schema to the remote host. So you can use SSH over there as if you were on your local machine.

```bash
ssh -A ec2-user@ec2-3-88-199-43.compute-1.amazonaws.com
```
- once logged into the ec2-in-az1b-public-sn (bastion host/jump box), connect to 
the ec2-in-az1b-private-sn instance in the private subnet 
```bash
ssh ec2-user@[Your private EC2 private IP]
```
- Show connection of the private EC2 over the Bastion Host

### Part 3 - Creating NAT Gateway

-  discuss about how to connect to internet from the Private EC2 in private subnet 

Step 1 : Create Elastic IP

- Go to VPC console on left hand menu and select Elastic IP tab

- Tab Allocate Elastic IP address

Elastic IP address settings

```text
Network border Group : Keep it as is (us-east-1)

Amazon's pool of IPv4 addresses
```
- Click Allocate button and name it as "First Elastic IP"

- create a NAT Gateway in the public subnet

STEP 2: Create Nat Gateway

- Go to VPC console on left hand menu and select Nat Gateway tab

- Click Create Nat Gateway button 
```bash
Name                      : clarus-nat-gateway

Subnet                    : clarus-az1b-public-subnet

Elastic IP allocation ID  : First Elastic IP
```
- click "create Nat Gateway" button

STEP 3 : Modify Route Table of Private Instance's Subnet

- Go to VPC console on left hand menu and select Route Table tab

- Select "clarus-private-rt" ---> Routes ----> Edit Rule ---> Add Route
```
Destination     : 0.0.0.0/0
Target ----> Nat Gateway ----> clarus-nat-gateway
```
- click save routes

- go to private instance via terminal using bastion host

- try to ping www.google.com and show response.

- Go to VPC console on left hand menu and select Nat Gateway tab

- Select clarus-nat-gateway --- > Actions ---> delete Nat Gateway

- Go to VPC console on left hand menu and select Elastic IP tab

- Select "First Elastic IP" ----> Actions ----> Release Elastic IP Address ----> Release 

### Part 4 - Creating NAT Instance

STEP 1: Create NAT Instance

- Go to EC2 Menu Using AWS Console

```text
AMI             : ami-00a36856283d67c39 (Nat Instance)
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1a-public-subnet
Security Group  : 
    Sec.Group Name : Public Sec.group
    Rules          : TCP ---> 22 ---> Anywhere
                   : All ICMP IPv4  ---> Anywhere

Tag             :
    Key         : Name
    Value       : Clarus NAT Instance
```

- Select created Nat Instance on EC2 list

- Tab Actions Menu ----> Networking ----> Enable Source/Destination Check ---> Yes, Disable

- Explain why we need to implement this process mentioned above

STEP 2: Configuring the Route Table

- Go to Route Table and select "clarus-private-rt"

- Select Routes sub-menu ----> Edit Rules ----> Delete blackhole for Nat Gateway

- Add Route
```
Destination     : 0.0.0.0/0
Target ----> Instance ----> Nat Instance
```

- Connect to private Instance via bastion host and ping www.google.com to show response.

