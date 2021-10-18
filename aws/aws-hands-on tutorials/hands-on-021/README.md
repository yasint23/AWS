# hands-on-021

## VPC Peering


## Goal

The goal of this hands-on is to illustrate a VPC peering connection, a way to connect two VPCs using a private connection.

## Architecture Diagram

![hands-on-021-arch-01](images/hands-on-021-arch-01.png)

## Overview

Once the VPCs and subnets are created, the internet gateway and the EC2 instances are launched and configured, follow the steps described next.

### Step 1 - Create the Peering Connection

![hands-on-021-scrn-01](images/hands-on-021-scrn-01.png)
![hands-on-021-scrn-02](images/hands-on-021-scrn-02.png)
![hands-on-021-scrn-03](images/hands-on-021-scrn-03.png)

### Step 2 - Accept the Peering Connection

![hands-on-021-scrn-04](images/hands-on-021-scrn-04.png)
![hands-on-021-scrn-05](images/hands-on-021-scrn-05.png)
![hands-on-021-scrn-06](images/hands-on-021-scrn-06.png)
![hands-on-021-scrn-07](images/hands-on-021-scrn-07.png)

### Step 3 - Modify Route Tables

First on the VPC A side:

![hands-on-021-scrn-08](images/hands-on-021-scrn-08.png)

Then on the VPC B side:

![hands-on-021-scrn-09](images/hands-on-021-scrn-09.png)

To test the setting, first ssh to the EC2 instance A (the one on VCP A).  Then try to ssh to EC2 instance B (the on on VPC B) using its private IP address.
