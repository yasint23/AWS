# Hands-on EC2-08 : Configuring Application Load Balancer (ALB) with Auto Scaling Group (ASG) using Launch Template

Purpose of the this hands-on training is to give the students basic knowledge of how to configure AWS Load Balancers with Auto Scaling Group and Launch Template.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create and configure a load balancer with Target Group.

- create and configure Auto Scaling Group with Launch Template.

- add policy to Auto Scaling Group.

- add Cloudwatch alarm.

## Outline

- Part 1 - Create Security Group

- Part 2 - Create Target Group

- Part 3 - Create Application Load Balancer

- Part 4 - Create Launch Template

- Part 5 - Create Auto Scaling Group

- Part 6 - Create Auto Scaling Policy

## Part 1 - Create a Security Group

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.

- Choose the Security Groups on left-hand menu

- Click the `Create Security Group`.

```text
Security Group Name  : ASGSecGroup
Description          : ASG Security Group
VPC                  : Default VPC
Inbound Rules:
    - Type: SSH ----> Source: Anywhere
    - Type: HTTP ---> Source: Anywhere
Outbound Rules: Keep it as default
Tag:
    - Key   : Name
      Value : ASGSecGroup
```

- Click `Create Security Group` button.

## Part 2 - Create Target Group

- Go to `Target Groups` section under the Load Balancing part on left-hand menu and select `Target Group`

- Click `Create Target Group` button

  - Basic configuration

    ```text
    Choose a target type    : Instances
    Target Groups Name      : MyTargetGroup
    Protocol                : HTTP
    Port                    : 80
    Protocol version        : HTTP1
    VPC                     : Default VPC
    ```

  - Health checks

    ```text
    Health check protocol   : HTTP
    Health check path       : /
    ```
      - Advance health check settings

      ```text
      Port                    : Traffic port
      Healthy threshold       : 3
      Unhealthy threshold     : 2
      Timeout                 : 5 seconds
      Interval                : 10 seconds
      Success codes           : 200
      ```

  - Tags

    ```text
    Key                     : Name
    Value                   : MyTargetGroup
    ```

- Click next >>>Register targets
   *** Unlike Application Load Balancer hands-on, do not register any instances into the target group.

- Click `Create Target Group` button.

## Part 3 - Create Application Load Balancer

Go to the Load Balancing section on left-hand menu and select `Load Balancers`.

- Click `Create Load Balancer` tab.

- Select the `Application Load Balancer` option.

- Basic configuration:

```text
Name            : MyALBforAutoScaling
SchemeInfo      : Internet-facing

IP address type : IPv4
```

- Network mapping :
```text
VPC             : default VPC
Mappings        : Select all 6 AZ
```

- Security groups :

```text
ASGSecGroup
```

- Listeners and routing:
```text
Protocol                                :HTTP
Port                                    :80
Default action (select target group )   :MyTargetGroup
```
- Tags  :
```text
    - Key   : Name
    - Value : MyALBforAutoScaling
```

- Review and if everything is ok, click the `Create` button.

```text
Successfully created load balancer!
```
- Click `Close`.

- Please wait for changing the state from `provisioning` to `active`.

## Part 4 - Create Launch Template

- Select `Launch template` from the left-hand menu and then click `Create Launch template` to start.

- Launch Template Name

```text
Launch template name            : MyTemplate_Auto_scaling
Template version description    : MyTemplate_Auto_scaling
Auto Scaling guidance           : Click on "Provide guidance to help me set up a 
                                  template that I can use with EC2 Auto Scaling"

```

- Amazon Machine Image (AMI)

```text
Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-02e136e904f3da870 (us-east-1)
```

- Instance Type

```text
t2.micro
```

- Key Pair

```text
Please select your key pair (pem key) that is created before
Example: clarusway.pem
```

- Network settings

```text
Network Platform : Virtual Private Cloud (VPC)
```

- Security groups

```text
ASGSecGroup
```

- Storage (volumes)

```text
Keep it as default (Volume 1 (AMI Root) (8 GiB, EBS, General purpose SSD (gp2)))
```

- Resource tags

```text
Key             : Name
Value           : Auto_Scaling
Resource type   : Instance
```

- Network interfaces

```text
Keep it as it is
```

- Advanced details:

   In this section , we will just use `user data` settings. Please paste the script below into the `user data` field.

```bash
#!/bin/bash

#update os
yum update -y
#install apache server
yum install -y httpd
# get private ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PRIVATE_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4`
# get public ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PUBLIC_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4` 
# get date and time of server
DATE_TIME=`date`
# set all permissions
chmod -R 777 /var/www/html
# create a custom index.html file
echo "<html>
<head>
    <title> Application Load Balancer</title>
</head>
<body>
    <h1>Testing Application Load Balancer</h1>
    <h2>Congratulations! You have created an instance from Launch Template</h2>
    <h3>This web server is launched from the launch template by YOUR_NAME</h3>
    <p>This instance is created at <b>$DATE_TIME</b></p>
    <p>Private IP address of this instance is <b>$PRIVATE_IP</b></p>
    <p>Public IP address of this instance is <b>$PUBLIC_IP</b></p>
</body>
</html>" > /var/www/html/index.html
# start apache server
systemctl start httpd
systemctl enable httpd
```

- Click Create Launch template

## Part 5 - Create Auto Scaling Group (Create an Auto Scaling Group that keeps the target group in initial size)

- EC2 AWS Management console, select Auto Scaling Group from the left-hand menu and then click Create Auto Scaling Group

```text
Name: First-AS-Group.
```

Step 1: Choose launch template or launch configuration:

- Switch to the `Launch template`, select newly created launch template and click `Next` to continue.

Step 2: Configure settings:

- Network

```text
VPC         : Default VPC
Subnets     : Select all Subnets
```

Step 3: Configure advanced options:

- Check `Enable Load Balancing` and Select `Application Load Balancer or Network Load Balancer` option

- Target Group: `MyTargetGroup`

- Health Check

```text
Health Check type           : ELB
Health check grace period   : 200 seconds
```

- Additional Settings : Keep it as default

Step 4: Configure group size and scaling policies:

- Group size

```text
Desired capacity        : 1
Minimum capacity        : 1
Maximum capacity        : 1
```

- Scaling policies : `!!!!!!!!!`

```text
None
```

- Instance scale-in protection

```text
Keep it as is. Do not check
```

Step 5: Add notifications:

- Skip Notification

Step 6: Add Tags

```text
Key     : Name
Value:  : Autoscaling
```

Step 7: Review and create Auto Scaling Group.

- Right click the `Instance` tap on left hand menu and open in new window and show the sub-sections and also show there is 1 instance created by auto scaling group,

- Right click the `Target Group` tap on left hand menu and open in new windows show the sub-sections and details. In Target Menu, show that the instance seems healthy based on rules that we set before.

- Right click the `Load Balancing` tap on left hand menu and open in new window show the sub-sections and details.

- Explain the sub-menu of ASG

- Change the configuration of Autoscaling Group

Step 1:

- Go to Auto Scaling Groups and check the `ALBforAutoScaling` flag

- Click `Edit` Tab

- Change Values of Group Size

```text
Desired capacity    : 2
Minimum capacity    : 2
Maximum capacity    : 4
```
- Explain Desired capacity, Minimum capacity and  Maximum capacity. Then show the capacity screen.

- Keep the rest of settings as default

- Click `Update`

Step 2:

- Show the changes in `instance number`, `activity tab` and `target group`.

- Go to `Instance Tab` on left hand-menu and show instances created by auto scaling group.

- Go to `Load Balancers` on the left-hand menu and copy Load Balancer DNS. Then paste it to browser, refresh the page and show the differences, like IP and dates.

Step 3: Observe that Autoscaling keeps the target group in initial size.

- Go to `Instance Tab` on left-hand menu and `STOP` one of the instances.

- Go to `Target Group` on left-hand menu and click `MyTargetGroup`---> `Targets`.

- Show the status of the stopped instance and refresh it. It probably takes a while to create a new instance by Auto Scaling.

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> `Activity` and show the changes in the `Activity` history.

- Click `Edit` Tab

- Change Values of Group Size

```text
Desired capacity    : 1
Minimum capacity    : 1
Maximum capacity    : 2
```

## Part 6 - Create Auto Scaling Policy

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> `Automatic Scaling` --> `Add Policy`-----> `Create dynamic scaling policy`

- Explain the Policy Types

Step 1: Create `Add-Policy`;

- Select `Simple Scaling` as Policy Type

```text
Scaling Policy Name : First Scaling Policy-Add
```

- Open  `Create a CloudWatch Alarm` in `new window` 

- Select Metric ---> `EC2` --> By Auto Scaling Group --> type in filter  with typing `First-AS-Group` and select `First-AS-Group CPUUtilization`

- Metric:

```text
Metric name           : CPUUtilization
AutoScalingGroupName  : First-AS-Group
Statistic             : Average
Period                : 1 minute
```
- Conditions:

```text
Threshold Type              : "Static"

Whenever CPUUtilization is  : Select Greater

Define the threshold value  :  60 
```

- Click `Next`

- Just expliain notification, but for now , Click `Remove` tab at the top of the page and do not set any Notification, Autoscaling and EC2 Action

- Click `Next`

- Add name and description

```text
Alarm name                      : Auto Scaling-Add
Alarm description - optional    : Auto Scaling-Add
```

- Click `Next`, Review and Create alarm

- Click `Create a CloudWatch alarm`

- Go back to Autoscaling page and refresh the cloudwatch alarm

- Select `Auto Scaling-Add` as Cloudwatch Alarm

- Take the Action :

```text
Add --- 1 ---- Capacity Unit
An Then wait   : 200
```

- Click Create

Step 2: Create `Remove-Policy`;

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> `Automatic Scaling` -----> `Create dynamic scaling policy`

- Explain the Policy Types

Step 1: Create `Add-Policy`;

- Select `Simple Scaling` as Policy Type

```text
Scaling Policy Name : First Scaling Policy-Add
```

- Open  `Create a CloudWatch Alarm` in `new window` 

- Select Metric ---> `EC2` --> By Auto Scaling Group --> type in filter  with typing `First-AS-Group` and select `First-AS-Group CPUUtilization`

- Metric:

```text
Metric name           : CPUUtilization
AutoScalingGroupName  : First-AS-Group
Statistic             : Average
Period                : 1 minute
```
- Conditions:

```text
Threshold Type              : "Static"

Whenever CPUUtilization is  : Select Smaller

Define the threshold value  :  30 
```

- Click `Next`

- Just expliain notification, but for now , Click `Remove` tab at the top of the page and do not set any Notification, Autoscaling and EC2 Action

- Click `Next`

- Add name and description

```text
Alarm name                      : Auto Scaling-remove
Alarm description - optional    : Auto Scaling-remove
```

- Click `Next`, Review and Create alarm

- Click `Create a CloudWatch alarm`

- Go back to Autoscaling page and refresh the cloudwatch alarm

- Select `Auto Scaling-Add` as Cloudwatch Alarm

- Take the Action :

```text
Remove --- 1 ---- Capacity Unit
An Then wait   : 200
```

- Click Create


Step 3: Testing

- Go to Instance Menu

- Select one of the Auto Scaling Instance and connect with SSH

- Upload `stress tool`

```bash
sudo amazon-linux-extras install epel -y
sudo yum install -y stress
stress --cpu 80 --timeout 20000   
```

- Click the instance's Monitoring Tab and show the effect of `stress tool` on CPU Utilization

- Show newly created instance based on `add-policy`

- Go to instance terminal and stop `stress tool` with `CTRL-C`

- Show the removed instance after `stress tool` stops based on `remove-policy`

- Delete the Simple Policies

Step 4: Add Step Scaling Policy

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> --> `Automatic Scaling` -----> `Create dynamic scaling policy`


  1. Create `Add-Policy`;

- Select `Step Scaling` as Policy Type

- Name :
```text
Step Policy Name : First Step Policy-Add- Do not test it just show how to configure it. 
```

- Select `Auto Scaling-Add` as Cloudwatch Alarm

- Take the Action : 

```text
Add --- 1 ---- Capacity Unit ----when 60---    <=    CPUUtilization 90


Clic "Add step"

Add ----2 -----Capacity Unit ----when 90 ----  <= Infinity

An Then wait   : 200
```

  2. Create `Remove-Policy`;

- Name :
```text
Step Policy Name : First Step Policy-Add
```

- Select `Step Scaling` as Policy Type

- Select `Auto Scaling-Remove` as Cloudwatch Alarm

- Take the Action :

```text
Remove --- 1 ---- Capacity Unit
An Then wait   : 200
```


- Delete the Step Polices

- Step 5: Show target Tracking Policy

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> `Automatic Scaling` -----> `Create dynamic scaling policy`


- Click `Add-Policy`;

Select `Policy Type : Target Tracking Policy`

```text
Scaling Policy Name : First Target Tracking
Target value        : 60
Instances need      : 200 sec
```
Use the stress tool on EC2 Instances

- Stop the stress tool with CTRL + C

- Delete the Target Tracking  Policy

- Delete `Auto-scaling group` and `Load Balancer`

