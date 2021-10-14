# Hands-on IAM-01 

Purpose of the this hands-on training is to give basic understanding of how to use IAM and IAM components.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- understand root user and IAM user

- create IAM user 

- explain the credentials 

- create a settings for IAM user

- create a group

- anatomy of the policy and attaching policy to the identities. 

- make troubleshooting about credentials

- create role and attach it to EC2

## Outline

- Part 1 - Creating IAM user and arrange user settings

- Part 2 - Creating Groups

- Part 3 - Troubleshooting about credentials

- Part 4 - Creating role and attaching to EC2


## Part 1 - Creating IAM user and arrange user settings

- Log in  as a Root user. !!!! Please use "your individual root account."

- Show the Dashboard of IAM 

- Show IAM users "sign-in link" and customize the alias . Tell the student to write down the account alias.

- Create IAM user with Administrator access for your daily work :

    - Explain that  unless it is needed,  students won't use root account anymore.
    - Explain policy Administrator access*  policy and policy format

- Click on newly created User---->>> Security Credentials show the credentials. 

- Create bill settings: Since we'll not use root account for daily work, we also need to check our billing from IAM user console .So we need to make some setting for this issue. 

     - Right top of the page click your name ----> Select My account -->> IAM User and Role Access to Billing Information--->> Edit--->>

- Sign Out and Sign in  with newly created IAM user with "Clarusway IAM user". 

- Check the users and Billing services to be accessible or not.

## Part 2 - Creating Groups

### Step 1  - Creating users of Database and Database Group

- Create group of database 
- Explain why we use group
- Explain inline policy and group relation
- Assign users to the Database Group

### Step 2 Create users of Developer and Developer Group

- Create group of Developer
- Assign users to the Developer Group
- Ask the status of the user without policy when you delete the group which has policy 

### Step 3 Create users of AWS_DEVOPS and AWS_DEVOPS Group

- Create group  with "power user" policy
- Explain Power User
- Assign user to the group while creating users.
- Show the permissions of group and users.

##  Part 3 - Troubleshooting about credentials

### Step 1 - What if you forget the password 

- Click User>>>>> Select user---->>Security Credential--->> Console Password---> Click "Manage"--->>Set  password >>>> Custom password

### Step 2-  What if you forgot your secret access keys key 

  Click User>>>>> Select user---->>Security Credential--->> Go Access keys ---> Deactivate---->> Delete --->>>Create new 


##  Part 4 - Creating role and attaching to EC2

- Create a role :

```text
Trusted Entity : AWS services
Use case       : EC2
Permission     : S3FullAccess
Name           : MyFirstRole
```
- Launch an Instance ******without role :

```text
-AMI             : Amazon Linux 2
-Instance Type   : t2.micro
-Step 3: Configure Instance Details:

  - ****IAM role     : "None"

  - User data       :

#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 

- Security Group: HTTP & SSH Allowed

```
- Launch an Instance with  ****MyFirstRole:
```text
-AMI             : Amazon Linux 2
-Instance Type   : t2.micro
-Step 3: Configure Instance Details:

  - ****IAM role     : MyFirstRole

  - User data       :

#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 

- Security Group: HTTP & SSH Allowed

```
- Show that the instance without role wasn't able to access S3 bucket. So the web page couldn't fetch the index.html and cat.jpg file.
