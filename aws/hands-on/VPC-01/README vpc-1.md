# Hands-on VPC-01 : Configuring of VPC

## Outline

- Part 1 - Creating VPC, Subnet and Subnet associations

## Part 1 - Creating VPC, Subnet and Subnet associations

STEP 1: Create VPC

- First, go to the VPC and select Your VPC section from the left-hand menu, click create VPC.

- create a vpc named 'yasin-vpc-a' with 10.7.0.0/16 CIDR
    - no ipv6 CIDR block
    - tenancy: default

- click create

- enable DNS hostnames for the vpc 'yasin-vpc-a'

  - select 'yasin-vpc-a' on VPC console ----> Actions ----> Edit DNS hostnames
  - Click enable flag
  - Click save 

STEP 2: Create an internet gateway named 'yasin-igw'

- Go to the Internet Gateways from left hand menu

- Create Internet Gateway
   - Name Tag "yasin-igw" 
   - Click create button

-  attach the internet gateway 'yasin-igw' to the vpc 'yasin-vpc-a'
  - Actions ---> attach to VPC
  - Select VPC named "yasin-vpc-a"
  - Push "Attach Internet gateway"

STEP 3 : Configuring Route Table

- Go to the Route Tables from left hand menu

- rename the route table of the vpc 'yasin-vpc-a' as 'yasin-default-rt'

- select Routes on the sub-section

- click edit routes

- click add route

- add a route
    - destination ------> 0.0.0.0/0 (any network, any host)
    - As target;
      - Select Internet Gateway
      - Select 'yasin-igw'
      - save routes

- explain routes in the yasin-default-rt

STEP 4: Create Subnets
- Go to the Subnets from left hand menu
- Push create subnet button

1. 
Name tag          :yasin-az1a-public-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1a
IPv4 CIDR block   :10.7.1.0/24

2. 
Name tag          :yasin-az1a-private-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1a
IPv4 CIDR block   :10.7.2.0/24

3. 
Name tag          :yasin-az1b-public-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1b
IPv4 CIDR block   :10.7.4.0/24

4. 
Name tag          :yasin-az1b-private-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1b
IPv4 CIDR block   :10.7.5.0/24

5. 
Name tag          :yasin-az1c-public-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1c
IPv4 CIDR block   :10.7.7.0/24

6. 
Name tag          :yasin-az1c-private-subnet
VPC               :yasin-vpc-a
Availability Zone :us-east-1c
IPv4 CIDR block   :10.7.8.0/24

- explain the subnet descriptions and reserved ips (why 251 instead of 256)

STEP 5: Route Tables

- Go to the Route Tables from left hand menu

- Select 'yasin-default-rt' and click the Subnet Association from sub-section

- show the default subnet associations on the route table 
yasin-default-rt (internet access is available even on private subnets)
- push the create route table button

- create a private route table (not allowing access to the internet) 
  - name: 'yasin-private-rt'
  - VPC : 'yasin-vpc-a'
  - click create button

- show the routes in the route table yasin-private-rt,

- click Subnet association button and show the route table yasin-private-rt with private subnets

- Click Edit subnet association
- select private subnets;
  - yasin-az1a-private-subnet
  - yasin-az1b-private-subnet
  - yasin-az1c-private-subnet
  - and click save

- create a public route table (allowing access to the internet) 

- push the create route table button
  - name: 'yasin-public-rt'
  - VPC : 'yasin-vpc-a'
  - click create button

- show the routes in the route table yasin-public-rt,

- click Subnet association button and show the route table 

-Show the default route table subnet association . There are only 3 subnet implicitly.

- yasin-public-rt with public subnets

- Click Edit subnet association

- select public subnets;
  - yasin-az1a-public-subnet
  - yasin-az1b-public-subnet
  - yasin-az1c-public-subnet
  - and click save

- select Routes on the sub-section of yasin-public-rt

- click edit routes

- click add route

- add a route
    - destination ------> 0.0.0.0/0 (any network, any host)
    - As target;
      - Select Internet Gateway
      - Select 'yasin-igw'
      - save routes    
      
STEP 6: enable Auto-Assign Public IPv4 Address for public subnets

- Go to the Subnets from left hand menu

  - Select 'yasin-az1a-public-subnet' subnet ---> Action ---> Modify auto-assign IP settings  ---> select 'Enable auto-assign public IPv4 address' ---> Save

  - Select 'yasin-az1b-public-subnet' subnet ---> Action ---> Modify auto-assign
  IP settings  ---> select 'Enable auto-assign public IPv4 address' ---> Save

  - Select 'yasin-az1c-public-subnet' subnet ---> Action ---> Modify auto-assign
  IP settings  ---> select 'Enable auto-assign public IPv4 address' ---> Save

- Create two instances . One is in the Private and the other one is in Public subnet. Show the public and private IPs of instances. 

- Compare the IP of instance and Subnet CIDR block.


