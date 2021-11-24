# Hands-on : Route 53- 02

Purpose of the this hands-on training is to creating a DNS record sets and implement Route 53 routing policies. 


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create record sets

- manage the domain name routing

- implement routing policies in different use case

- use active-passive architecture in local vpc

## Outline

- Part 1 - Prep.

- Part 2 - Creating a fail-over routing policies

- Part 3 - Creating a geolocation routing policies

- Part 4- Creating Private Hosted Zone and records

## Part 1 - Part 1 - Prep.

### STEP 1: Create Sec.Group:
```bash
   Route 53 Sec: In bound : "SSH 22, HTTP 80  > anywhere(0:/00000)"
```
### STEP 2: Create Instances:

- We'll totally create "4 Linux" instances and "1 Windows" instance.
   
1. Create EC2 in default VPC as named  "N.virginia_1"
```bash
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

user data: 

#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_1/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/N.virginia_1/N.virginia_1.jpg
systemctl start httpd
systemctl enable httpd


2. Create EC2 in default VPC as named "Geo-Japon"

```bash
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

   user data:

#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/geo-japon/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/geo-japon/Tsubasa.jpg
systemctl start httpd
systemctl enable httpd

```

3. Create EC2 in default VPC as named "Geo-Frankfurt"

 ```bash 
Region: "N.Virginia"
VPC: Default VPC
Subnet: PublicA
Sec Group: "Route 53 Sec"

user data:

#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/frankfurt/frankfurt.jpg
systemctl start httpd
systemctl enable httpd
```

4. Create EC2 in "clarus-vpc-a" named "Local"

```bash 
Region: "N.Virginia"
VPC: clarus-vpc-a
Subnet: PublicA
Sec Group: ssh-http---->0.0.0.0/0

user data:

#!/bin/bash

yum update -y
yum install -y httpd
yum install -y wget
chkconfig httpd on
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/local/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/local/Local.jpg
service httpd start

```
4. Create "Windows" instance in "clarus-vpc-a" named "Windows"

```bash 
Region: "N.Virginia"
VPC: clarus-vpc-a
Subnet: PublicA
Sec Group: RDP---->0.0.0.0/0

```

### STEP 3: Create a Static WebSite Hosting :

 1. Create Static WebSite Hosting-1/ "www.[your sub-domain name].net"
 
  - Go to S3 service and create a bucket with sub-domain name: "www.[your sub-domain name].net"
  - Public Access "Enabled"
  - Upload Files named "index.html" and "sorry.jpg" in "s3.bucket.www" folder
  - Permissions>>> Bucket Policy >>> Paste bucket Policy
```bash
{
    "Version": "2012-10-17", 
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::don't forget to change me/*"
        }
    ]
}

```
  - Properties>>> Set Static Web Site >>> Enable >>> Index document : index.html 
   
## Part 2 - Creating a fail-over routing policies

### STEP 1 : Create health check for "N. Virginia_1" instance

- Go to left hand pane and click the Health check menu 

- Click Health check button

- Configure Health Check

```bash 
1. Name: firsthealthcheck

What to monitor     : Endpoint

Specify endpoint by : IP address

Protocol            : HTTP

IP address          : N.Virginia_1 IP address

Hostname:           : -

Port                : 80

Path                : leave it as /

Advance Configuration 

Request Interval    :  Standard (30seconds)

Failure Threshold   : 3

Explain Response Time:

Failure = Time Interval * Threshold. If its a standard 30 seconds check then three checks is actually equal to 90 seconds. So be careful of how these two different settings interact each other.

String Matching     : No 

Latency Graphs:     : Keep it as is

Invert Health Check Status: Keep it as is

Disable Health Check:
Explain: If you disable a health check, Route 53 considers the status of the health check to always be healthy. If you configured DNS failover, Route 53 continues to route traffic to the corresponding resources. If you want to stop routing traffic to a resource, change the value of Invert health check status.

Health Checker Regions: Keep it as default

click Next

Get Notification   : None

click create and show that the status is unhealthy approximately after 90 seconds the instance healthcheck will turned into the "healthy" from "unhealthy"
```
### Step 2: Create A record for  "N. Virginia_1" instance IP - Primary record

- Got to the hosted zone and select the public hosted zone of our domain name

- Clear all teh record sets except NS and SOA

- Click create record

- select "Failover" as a routing policy

- click next

```bash
Record Name :"www"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - enter IP IP address of N.Virginia_1 
Routing: "Failover"
Failover record type    : Primary
Health check            : firsthealthcheck
Record ID               : Failover Scenario-primary
```
- click defined Failover record button

- select created failover record flag and push the create records button

### Step 3: Create A record for S3 website endpoint - Secondary record

- Click create record

- select "Failover" as a routing policy

- click next

```bash
Record Name :"www"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Alias to S3 website endpoint"
  - N.Virginia(us-east-1)
  - Choose your S3 bucket named "www.[your sub-domain name].net"
Routing: "Failover" 
Failover record type    : Secondary
Health check            : keep it as is
Record ID               : Failover Scenario-secondary
```
- click define Failover record button

- select created failover record flag and push the create records button

- Go to browser and show the web page with N.Virginia_1 instance content 

- Stop the N.Virginia_1 instance

- check the healtcheck status and wait until it appears as unhealthy

- go to the browser and show the web site content turned into S3 bucket content with the help of the failover record



## Part 3 - Creating a Gelocation routing policies

### STEP 1 :Create Geolocation record for Japan

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - "IP of Geo-Japon Instance"
Routing: "Geolocation" 
Location               :
  - Countries Japan
Health check            : Keep it as is
Record ID               : Geolocation Scenario-Japan
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" button


### STEP 2 : Create geolocation record for Europe

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - "IP of Geo-Frankfurt Instance"
Routing: "Geolocation "
Location               :
  - Countinent : Europe
Health check            : Keep it as is
Record ID               : Geolocation Scenario-Europe
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" 
button


### STEP 3 : Create geolocation record for others

- Click create record

- select "Geolocation" as a routing policy

- click next

```bash
Record Name :"geo"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - "IP of N.Virginia"
Routing: "Geolocation"  
Location               : Select Default option
Health check           : Keep it as is
Record ID              : Geolocation Scenario-Others
```
- click "define geolocation record" button

- select created Geolocation record flag and push the "create records" 
button

- change the IP of your computer via VPN and see the Japon page.

- change the IP of your computer via VPN and see the Europe page.

- Send the DNS to students try for US and show them different web page based on location.

## Part 4 - Creating Private Hosted Zone and DNS Records 

### STEP 1: Creating Private Hosted Zone

- go to the dashboard and click on "Hosted Zones"
- Click "Create Hosted Zone"

```bash
   Domain name: the same name of your domain(clarusway.us)
   Description: ---
   Type       :Private hosted zone
   VPCs to associate with the hosted zone
     Region : N.Virginia
     VPC ID : clarus-vpc-a
  Tags:---

```
- Click on "create Hosted Zone"

- Show that NS and SOA records automatically created. 

### STEP 2: Creating in A record with "wwww" in Private Hosted Zone

- Go  to "PRIVATE" Hosted Zone 
- Create A record in "PRIVATE" Hosted Zone 
```bash
Record Name :"www"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - enter IP IP address of "Local" 
Routing: "Simple"
```
### STEP 3: Creating in A record with "wwww" in Public Hosted Zone

- Go  to "PUBLIC" Hosted Zone 
- Create A record in "PUBLIC" Hosted Zone 
```bash
Record Name :"www"
Record Type : A
TTL:"60"
Value/Route traffic to : 
  - "Ip address or another value depending on the record type"
    - enter IP IP address of "N.Virginia" 
Routing: "Simple"
```
- go to "Window" instance and connect it with RDP
- open the Internet Explorer of "Window" instance 
- type "www.clarusway.us". show which content is seen "local instance content" in VPC 
- go to the public browser than type browser: "www.clarusway.us" than show that, N.Virginia instance is seen on public internet.

### STEP 4: Cleaning 
- Delete Instances.
- Delete bucket 
- Delete A recordS If they exist. 
- Delete the HEALTH CHECK
