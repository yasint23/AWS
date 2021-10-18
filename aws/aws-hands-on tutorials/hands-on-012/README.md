# hands-on-012

## A Simple Dynamodb Service


## Goal

This hands-on illustrates how to create and remotely access a dynamodb table.  Dynamodb is a NoSQL managed database service.   

## Overview

### Step 1 - Create a Dynamodb Table

Go to Database - Dynamodb service and click on *Create table*.  

![hands-on-012-scrn-01](images/hands-on-012-scrn-01.png)
![hands-on-012-scrn-02](images/hands-on-012-scrn-02.png)
![hands-on-012-scrn-03](images/hands-on-012-scrn-03.png)
![hands-on-012-scrn-04](images/hands-on-012-scrn-04.png)

### Step 2 - Create and Download an Access Key

Go to IAM - Users and then select your user. Then go to *Security credentials* and create an access key. Download the key you created (a csv file) and use it on the next step.

### Step 3 - Connect to Dynamodb Table

Download and install [NoSQL Workbench](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.settingup.html).  Follow the steps to connect to your dynamodb table.

![hands-on-012-scrn-05](images/hands-on-012-scrn-05.png)
![hands-on-012-scrn-06](images/hands-on-012-scrn-06.png)
![hands-on-012-scrn-07](images/hands-on-012-scrn-07.png)

## Test and Validation

After you connect, try to visualize the contents of the table and modify it.

![hands-on-012-scrn-08](images/hands-on-012-scrn-08.png)
![hands-on-012-scrn-09](images/hands-on-012-scrn-09.png)
