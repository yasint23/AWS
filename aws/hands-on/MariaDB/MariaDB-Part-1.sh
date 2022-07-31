# Part 1 - Creating EC2 Instance and Installing MariaDB Server

# Launch EC2 Instance.

# AMI: Amazon Linux 2
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere
#   - MYSQL/Aurora  -----> 3306  -----> Anywhere

# Connect to EC2 instance with SSH.

# Update yum package management and install MariaDB server.
sudo yum update -y
sudo yum install mariadb-server -y

# Start MariaDB service.
sudo systemctl start mariadb

# Check status of MariaDB service.
sudo systemctl status mariadb

# Enable MariaDB service, so that MariaDB service will be activated on restarts.
sudo systemctl enable mariadb
