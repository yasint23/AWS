# hands-on-005

## An HTTP Load Balancer



## Goal
The goal of this hands-on is to illustrate how to use an [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html) to distribute requests over two web servers running on distinct Avaihands-onility Zones. [Here](../images/ELB.png) is a mind map of ELB (Elastic Load Balancing). 

## Architecture Diagram
![hands-on-005-arch-01](images/hands-on-005-arch-01.png)

## Overview
AWS Elastic Load Balancing (ELB) service supports three types of load balancers:
* Application Load Balancer,
* Network Load Balancer, and
* Classic Load Balancer.

As the name suggests, the *Application Load Balancer* works at the application layer and understands protocols such as HTTP. This gives the load balancer the ability to support routing rules based on the URL or the host field in the HTTP header, for example.

### Step 1 - Create VPC and Subnets
Create a new VPC with the *Name tag* hands-on-005 and the *IPv4 CIDR block* 192.168.0.0/16. Then create two public subnets in distinct avaihands-onility zones of your VPC.  Make sure to set the CIDR IPv4 block correctly to each subnet according to the ranges specified in the architecture diagram. You can use tags subnet-A and subnet-B for the subnets.

![hands-on-005-scrn-01](images/hands-on-005-scrn-01.png)
![hands-on-005-scrn-02](images/hands-on-005-scrn-02.png)
![hands-on-005-scrn-03](images/hands-on-005-scrn-03.png)
![hands-on-005-scrn-04](images/hands-on-005-scrn-04.png)
![hands-on-005-scrn-05](images/hands-on-005-scrn-05.png)
![hands-on-005-scrn-06](images/hands-on-005-scrn-06.png)
![hands-on-005-scrn-07](images/hands-on-005-scrn-07.png)

### Step 2 - Create an Internet Gateway
Create an [Internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) with the *Name tag* hands-on-005 and attach it to hands-on-005 VPC. This procedure is described in detail in step 2 of [hands-on-002](../hands-on-002).

### Step 3 - Modify the Main Route Table
Add a default route on your VPC router with a destination to the *Internet gateway* created in the previous step. Go to Subnet Associations and associate both subnets to the Main Route Table.

![hands-on-005-scrn-08](images/hands-on-005-scrn-08.png)
![hands-on-005-scrn-09](images/hands-on-005-scrn-09.png)
![hands-on-005-scrn-10](images/hands-on-005-scrn-10.png)
![hands-on-005-scrn-11](images/hands-on-005-scrn-11.png)

### Step 4 - Launch EC2 Instances
Launch an EC2 instance on each of the public subnets you created in the first step of this hands-on.

1. You can use *Amazon Linux 2 AMI*.
2. You can choose the *Free tier eligible* instance type.
3. Make sure to set the correct VPC and subnet for each instance; also, use the provided [user-data](files/user-data.sh) to setup an HTTP server on your instances.
4. You can select the suggested storage for your instances.
5. You should add a *Name tag* to help identifying your instances.
6. Both instances should be in a *Security Group* with inbound rules that accept SSH and HTTP traffic.
7. You should secure your instances by creating a *hands-on-005* key pair.

At this point you should be able to access both instances using a browser an the instances public IP addresses. You should be able to see the hostname of each instance as the index page.

### Step 5 - Create the Application Load Balancer
Follow the procedure described by the screenshots.
![hands-on-005-scrn-12](images/hands-on-005-scrn-12.png)
![hands-on-005-scrn-13](images/hands-on-005-scrn-13.png)
![hands-on-005-scrn-14](images/hands-on-005-scrn-14.png)
![hands-on-005-scrn-15](images/hands-on-005-scrn-15.png)
![hands-on-005-scrn-16](images/hands-on-005-scrn-16.png)
![hands-on-005-scrn-17](images/hands-on-005-scrn-17.png)
![hands-on-005-scrn-18](images/hands-on-005-scrn-18.png)
![hands-on-005-scrn-19](images/hands-on-005-scrn-19.png)
![hands-on-005-scrn-20](images/hands-on-005-scrn-20.png)

## Test and Validation
Copy the DNS name associated with the load balancer and, using a browser, try to access it. You should be able to see alternate responses (as you refresh the page) of the two instances webpages which proves that the load balancer is working properly by redirecting the request evenly to the two instances.

![hands-on-005-scrn-21](images/hands-on-005-scrn-21.png)

Another test you should do is to stop one of the instances and verify that the load balancer will not send requests to the stopped instance anymore.  
