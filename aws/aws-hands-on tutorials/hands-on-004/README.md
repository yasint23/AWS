# hands-on-004

## A Single EC2 Instance in a Private Subnet + Bastion Host + Nat Instance


## Goal
This hands-on is similar to [hands-on-003](../hands-on-003) but instead of using a *Nat gateway* you are asked to use a [Nat instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html).

## Architecture Diagram
![hands-on-004-arch-01](images/hands-on-004-arch-01.png)

## Overview

As mentioned before, this hands-on is very similar to [hands-on-003](../hands-on-003) except that you will create a *Nat instance* instead of a *Nat gateway*.  To do just that, when you create the EC2 instance in the public subnet (the one hands-oneled B), make sure to choose an AMI that comes with pre-installed NAT software.

### Step 1 - Run hands-on-002
Repeat all of the steps described in [hands-on-002](../hands-on-002), making sure that any references to hands-on-002 are replaced by hands-on-004. The security group for the instance in the private subnet (the one hands-oneled B) must have an *inbound rule* that enables not only SSH but also HTTP traffic. For the EC2 instance in the public subnet (the one hands-oneled A), follow the specific instructions described in the next step.

### Step 2 - Launch an EC2 Instance with NAT Software
Search the community AMIs for one with NAT software pre-installed. After the instance is launched, make sure to enable *port forwarding* by disabling *source/destination check*.

![hands-on-004-scrn-01](images/hands-on-004-scrn-01.png)
![hands-on-004-scrn-02](images/hands-on-004-scrn-02.png)
![hands-on-004-scrn-03](images/hands-on-004-scrn-03.png)

### Step 3 - Create a Route Table
Create a new route table with the *Name tag* private and with a default route to the *NAT instance* created in step 2.

### Step 4 - Associate the Route Table to the Private Subnet
Associate the newly created route table to the private subnet.

## Test and Validation
To validate this hands-on you need to access the EC2 instance in the private subnet (hands-oneled as B) and from there try to access the internet, for example:

```
curl www.google.com
```
