# AWS CLI
# Guile - 11_06_2021


# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/index.html



# Installation

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Win:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Mac:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# https://graspingtech.com/install-and-configure-aws-cli/


# Linux:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


# Configuration

aws configure

cat .aws/config
cat .aws/credentials

aws configure --profile user1

export AWS_PROFILE=user1
export AWS_PROFILE=default

aws configure list-profiles

# IAM
aws iam list-users

aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user


# S3
aws s3 ls

aws s3 mb s3://guile-cli-bucket

aws s3 cp in-class.yaml s3://guile-cli-bucket

aws s3 ls s3://guile-cli-bucket

aws s3 rm s3://guile-cli-bucket/in-class.yaml

aws s3 rb s3://guile-cli-bucket


# EC2
aws ec2 describe-instances

aws ec2 run-instances \
   --image-id ami-083654bd07b5da81d \
   --count 1 \
   --instance-type t2.micro \
   --key-name keynamehere

aws ec2 stop-instances --instance-ids instanceidhere 

aws ec2 terminate-instances --instance-ids instanceidhere