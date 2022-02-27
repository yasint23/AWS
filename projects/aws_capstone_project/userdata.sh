#!/bin/bash

apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/
TOKEN="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"
git clone https://$TOKEN@github.com/yasint23/aws_capstone_project.git
cd /home/ubuntu/aws_capstone_project
apt install python3-pip -y
apt-get install python3.7-dev libmysqlclient-dev -y
pip3 install -r requirements.txt
cd /home/ubuntu/aws_capstone_project/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80