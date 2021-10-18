# hands-on-003

## A Single EC2 Instance in a Private Subnet + Bastion Host + NAT Gateway


## Goal
This hands-on illustrates how an EC2 instance running in a *private* subnet can be configured to access the internet with the help of a service called [Nat gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

## Architecture Diagram
![hands-on-003-arch-01](images/hands-on-003-arch-01.png)

## Overview

In order to achieve the goal of this hands-on, you will have to go through the following steps:

### Step 1 - Run hands-on-002
Repeat all of the steps described in [hands-on-002](../hands-on-002), making sure that any reference to hands-on-002 are replaced by hands-on-003.

### Step 2 - Create a NAT Gateway
Create a [NAT gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) in the public subnet. Note that an elastic public IP must be allocated before a NAT gateway can be created.  

![hands-on-003-scrn-01](images/hands-on-003-scrn-01.png)
![hands-on-003-scrn-02](images/hands-on-003-scrn-02.png)
![hands-on-003-scrn-03](images/hands-on-003-scrn-03.png)

### Step 3 - Create a Route Table
Create a new route table with the *Name tag* private and with a default route to the NAT gateway created in step 2.

![hands-on-003-scrn-04](images/hands-on-003-scrn-04.png)
![hands-on-003-scrn-05](images/hands-on-003-scrn-05.png)
![hands-on-003-scrn-06](images/hands-on-003-scrn-06.png)
![hands-on-003-scrn-07](images/hands-on-003-scrn-07.png)
![hands-on-003-scrn-08](images/hands-on-003-scrn-08.png)
![hands-on-003-scrn-09](images/hands-on-003-scrn-09.png)
![hands-on-003-scrn-10](images/hands-on-003-scrn-10.png)

### Step 4 - Associate the Route Table to the Private Subnet
Associate the newly created route table to the private subnet.

![hands-on-003-scrn-11](images/hands-on-003-scrn-11.png)
![hands-on-003-scrn-12](images/hands-on-003-scrn-12.png)
![hands-on-003-scrn-13](images/hands-on-003-scrn-13.png)
![hands-on-003-scrn-14](images/hands-on-003-scrn-14.png)


## Test and Validation
To validate this hands-on you need to access the EC2 instance in the private subnet (hands-oneled as B) and from there try to access the internet, for example:

```
curl www.google.com
```
