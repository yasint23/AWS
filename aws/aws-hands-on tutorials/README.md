# aws-hands-ons
A collection of hands-on hands-ons to help learning the fundamentals of AWS cloud computing services. Each hands-on has:

* a title,
* a goal,
* an architecture diagram,
* a step-by-step guide, describing how to run the hands-on, with textual and visual information,
* links to AWS documentation or other relevant information,
* procedures to test and validate the hands-on, and
* optional challenges.

Supporting files such as scripts, policy documents, and CloudFormation templates are provided when relevant to completing the hands-on.

I hope you enjoy these hands-ons. Suggestions and contributions are welcomed. Thanks!

## Index

[hands-on-001 - A Single EC2 Instance](hands-on-001)

The goal of this hands-on is to launch a single EC2 instance in a public subnet accessible over the Internet via SSH.

[hands-on-002 - A Single EC2 Instance in a Private Subnet + Bastion Host](hands-on-002)

The goal of this hands-on is to demonstrate how to access an EC2 instance launched in a private subnet using a bastion host.

[hands-on-003 - A Single EC2 Instance in a Private Subnet + Bastion Host + NAT Gateway](hands-on-003)

This hands-on illustrates how an EC2 instance running in a *private* subnet can be configured to access the internet with the help of a service called [Nat gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

[hands-on-004 - A Single EC2 Instance in a Private Subnet + Bastion Host + Nat Instance](hands-on-004)

This hands-on is similar to [hands-on-003](hands-on-003) but instead of using a *Nat gateway* you are asked to use a [Nat instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html).

[hands-on-005 - An HTTP Load Balancer](hands-on-005)

The goal of this hands-on is to illustrate how to use an [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html) to distribute requests over two web servers running on distinct Avaihands-onility Zones.

[hands-on-006 - A Simple EC2 Auto Scaling](hands-on-006)

This goal of this hands-on is to illustrate how to setup a simple EC2 auto scaling service. You will create an auto scaling group with initially only one EC2 instance running. A rule will be setup to automatically launch a second EC2 instance when the CPU usage of the first instance reaches 75%.

[hands-on-007 - A Simple EC2 Auto Scaling + Load Balancing](hands-on-007)

This hands-on is a continuation of [hands-on-006](hands-on-006) with a Load Balancer added.

[hands-on-008 - Secure EC2 Auto Scaling + Load Balancing](hands-on-008)

This is hands-on is similar to [hands-on-007](hands-on-007) with a caveat: the auto scaling group is configured to create the EC2 instances in the private subnet. Also, two security groups control traffic in and out of the application load balancer and the EC2 instances (in the private subnets). To enable the EC2 instances to respond to requests coming from the internet, NAT gateways were configured on the public subnets of the VPC.

[hands-on-009 - A Standalone RDS Instance Running MySQL](hands-on-009)

This hands-on illustrates how to launch a standalone RDS instance running a MySQL database. An EC2 instance will also be launched to allow access to the database using phpMyAdmin.

[hands-on-010 - An RDS Instance with a Standby](hands-on-010)

This hands-on is similar to [hands-on-009](hands-on-009) with the addition of a standby RDS instance in another AZ to simulate a failover scenario.

[hands-on-011 - An RDS Instance with a Read Replica](hands-on-011)

This hands-on is similar to [hands-on-009](hands-on-009) with the addition of a *read replica* RDS instance, a read-only copy of the database.

[hands-on-012 - A Simple Dynamodb Service](hands-on-012)
This hands-on illustrates how to create and remotely access a dynamodb table.  Dynamodb is a NoSQL managed database service.   

[hands-on-013 - An S3 Bucket Accessed via AWS CLI](hands-on-013)

The goal of this hands-on is to illustrate how to create an S3 bucket and access it from a client computer via AWS CLI (command-line interface).

[hands-on-014 - An S3 Bucket Accessed via an S3 Gateway Endpoint](hands-on-014)

The goal of this hands-on is to illustrate how to access an S3 bucket from an EC2 instance in a private subnet using an S3 gateway endpoint.

[hands-on-015 - An S3 Bucket Accessed via AWS CLI + Resource-based Policy](hands-on-015)

This hands-on is similar to [hands-on-013](../hands-on-013). However, we will be creating a resource-based policy to only allow access to the bucket if requests are sent from a specific IP address.  

[hands-on-016 - Moving an EBS Volume Between EC2 Instances](hands-on-016)

The goal of this hands-on is to illustrate how to move an EBS volume from one EC2 instance to another.

[hands-on-017 - Snapshot an EBS Volume](hands-on-017)

This hands-on's goal is similar to [hands-on-016](hands-on-016) but because we want to move a volume from one AZ to another we will have to first create a snapshot of the volume and then create a new volume from the snapshot.

[hands-on-018 - Creating and Sharing an NFS File System via EFS](hands-on-018)

The goal of this hands-on is to illustrate how to create and share an NFS file system using AWS [EFS](https://aws.amazon.com/efs/) service.

[hands-on-019 - Connecting to an EC2 Instance via Systems Manager](hands-on-019)

This hands-on illustrates how to connect to an EC2 instance via [Systems Manager](https://aws.amazon.com/systems-manager/), a service that offers a central place to view and manage AWS resources.

[hands-on-20 - Running an Amazon ECS Sample App](hands-on-020)

This hands-on illustrates how to launch a web server using Amazon ECS's [Fargate service](https://aws.amazon.com/fargate/).

[hands-on-21 - VPC Peering](hands-on-021)

The goal of this hands-on is to illustrate a VPC peering connection, a way to connect two VPCs using a private connection.
