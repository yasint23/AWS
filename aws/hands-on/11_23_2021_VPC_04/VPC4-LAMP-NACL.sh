# LAMP STACK

# 1.Create Sec.Groups in Clarus-vpc-a:

   Wordpress/BastionHost: In bound : "SSH 22, HTTP 80 > anywhere(0:/00000)"
   Maria_dB_Sec.Grp: In bound      : "SSH 22, Mysql 3306 > anywhere (0:/00000)"
   Natinstance_Sec.Grp: In bound   : "SSH 22, HTTP 80, HTTPS 443 > anywhere (0:/00000)"

# 2.Create EC2 that is installed LAMP with user data seen below for "Wordpress app in Subnet Public-B"

   # VPC: Clarus-vpc-a
   # Subnet: clarus-az1b-public-subnet
   # Sec Group: Wordpress/BastionHost_Sec.Grp
   # Tag: Wordpress_BastionHost

#!/bin/bash

yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd
systemctl start httpd
systemctl enable httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
cd /var/www/html/
cp wp-config-sample.php wp-config.php
chown -R apache /var/www
chgrp -R apache /var/www
chmod 775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
systemctl restart httpd

# 3.Create MariaDB ec2 instance in Private-B

   # VPC: VPC-clarus-a
   # Subnet: PrivateB
   # Sec Group: Maria_dB_Sec.Grp
   # Tag: MariaDB-ec2

#!/bin/bash

yum update -y
yum install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb


# 4. Control the instance status.

# 5. We need to establish Database Configuration in DB instance which is in Private-B Subnet 
So we need to use Wordpress instance as a Bastionhost to access DB instance. Bastion host is in Public-B. So first we need to ensure DB instance Sec Group inbound rule that it only permit BastionHost Secgroup to access

Rule: Mysql 3306, SSH 22  > "anywhere (0:/00000)"
							 V
 							 V
 							 V
Rule: Mysql 3306, SSH 22  >>>>>> "Wordpress/BastionHost_Sec.Grp"

# 6. To conncet to private instance first we ensure the .pem file be exist in Wordpress instance.

- connect to Wordpress instance
- create a .pem file with the same name of your .pem file 
   -sudo vi key.pem
- open the .pem file in local with text editor
- copy the text file
- paste it in to the vi file
- Esc :wq ---> Enter
- chmod 400 .pem 
-ssh ec2-user@"privateIP of private instance that you want to conncet"

"OR"

- go to folder that your pem file is located and send your pem file with the scp command to wordpress/bastionhost_ec2

scp -i key.pem /c/Users/home/.ssh/blueman.pem(the path of file you want to send) ec2-user@3.232.129.39:/home/ec2-user/

"OR" 

# 7 Type following code to start
eval "$(ssh-agent)"

# 8 Add your private key to the ssh agent
ssh-add p.pem

# 9 Connect to the "Wordpress instance -Bastion Host "instance in "publicB" subnet
ssh -A ec2-user@ec2-3-88-199-43.compute-1.amazonaws.com

# 10 connect to the Database instance in the privateA subnet 
ssh ec2-user@10.7.2.20 (Private IP of Database Instance)


# 11 Check yum update and mariadb installation were done with userdata
# but it's not possible because one way ticket. And try to install and upload them.

	sudo yum update -y
	sudo yum install -y mariadb-server
	
# 12 Create Natinstance in "Subnet Public-A"

  # Please select NAT Type instance
  # VPC: clarus-vpc-a
  # Subnet: clarus-az1a-public-subnet
  # Sec Group: Natinstance_Sec.Grp
  # Tag: NAT_instance

# 13 Try to install mariadb  but it's not possible because route table isn't set yet.

	sudo yum update -y
	
# 14 Change "clarus-private-rt" table:

Destination              target

10.0.0.... >>>>>>        Local
00000/0 >>> Instance >>> Natinstance

---> Try again ---> it is not upload or install from outside
---> Go to Instance consol and select NAT instance and 

# 15 On Natinstance click Networking from the Actions menu and then go to Change Source/ Destination Check

click "Disable" option from the window that opens.

# 16 Install mariadb to "DB instance".

	sudo yum update -y
	sudo yum install -y mariadb-server
	sudo systemctl start mariadb
  sudo systemctl enable mariadb
    
----> Warning!!! for upload of yum package, http/https must be allowed in NAT Instance\'s security group.

# 17  Setup secure installation of MariaDB
sudo mysql_secure_installation

# 18. Connect mysql terminal without password anymore
mysql -u root -p

# 19.Show that test db is gone.
SHOW databases;

# 20. Select msql and List the users defined in the server
USE mysql;

# 21. Create new database named "clarusway";
CREATE DATABASE clarusway;

# 22. Create a user named "admin"; 
CREATE USER admin IDENTIFIED BY '123456789';

# 23. Grant permissions to the user "admin" for database "clarusway"
GRANT ALL ON clarusway.* TO admin IDENTIFIED BY '123456789' WITH GRANT OPTION;  

# 24. Update privileges
FLUSH PRIVILEGES;

# 25. List the users defined.
SELECT Host, User, Password FROM user;

# 26. Close the mysql terminal
EXIT;

# 28. Return to the Connect "Wordpres Instance" to confgire Word press database settings  "cd /var/www/html/" to secure config file before change
cd /var/www/html/

# 29. Change the config file for database assosiation
sudo vi wp-config.php

     #define( 'DB_NAME', 'clarusway' );

     #define( 'DB_USER', 'admin' );

     #define( 'DB_PASSWORD', '123456789' );

     # local ("Private DNS")
Esc :wq ---> Enter
sudo systemctl restart httpd

# 30. Check the browser. You'll see the home page of Wordpress
      # enter pasword,user name etc... 
-------------------------------------------------------------

# Part 7 - Configuring NACL (Network Access List)

# 1  Go to the 'Network ACLs' menu from left hand pane on VPC

# 2 click 'Create network ACL' button

Name Tag      :clarus-private1a-nacl
VPC           :clarus-vpc-a

- Select Inbound Rules ---> Edit Inbound rules ---> Add Rule
  Rule        Type              Protocol      Port Range        Source      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0   Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0   Deny


- Select Outbound Rules ---> Edit Inbound rules ---> Add Rule
  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Allow

# 3 In the  NACL menu, Select Subnet associations sub-menu ---> Edit subnet association ---> select "clarus-az1a-private-subnet" ---> edit

# 4 launch one instance on clarus-az1a-public-subnet and one instance clarus-az1a-private-subnet

# 5 go to terminal and try to connect the private EC2 with bastion host and show that there is no connectivity with ssh (the reason is ephemeral port)

# 6 go to the NACL table named "clarus-private1a-nacl"

# 7 Select Outbound Rules ---> Edit Outbound rules ---> Add Rule
  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         SSH(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Deny
  |                                           |                                   |
  |                                           |                                   |
  V                                           V                                   V
  100         Custom TCP Rule   TCP(6)        32768 - 65535     0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Allow

# 8 click save, go to the terminal and reconnect to the private EC2

# 9 exit from private EC2 and go to bastion host

# 10 using ping command, try to ping private EC2

ping [private EC2 Ip Address]

# 11 go to the Inbound submenu of NACL named 'clarus-private1a-nacl' ---> Edit Inbound rules ---> change "allow" from "deny" the status of the rule numbered 200 

# 12 go to terminal, ping to the private EC2 instance again and show that you can ping to it at this time.