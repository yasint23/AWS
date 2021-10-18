# hands-on-006

## A Simple EC2 Auto Scaling


## Goal

This goal of this hands-on is to illustrate how to setup a simple EC2 auto scaling service. You will create an auto scaling group with initially only one EC2 instance running. A rule will be setup to automatically launch a second EC2 instance when the CPU usage of the first instance reaches 75%. [Here](../images/auto-scaling.png) is a mind map of Auto Scaling. 

## Architecture Diagram
![hands-on-006-arch-01](images/hands-on-006-arch-01.png)

## Overview
The EC2 Auto Scaling service enables automatically launching EC2 instances based on pre-defined conditions named *scaling policies*. A common scenario for auto scaling is launching more instances to cope with a sudden demand increase, for example. Two concepts are key to understand how AWS auto scaling works:

* Launch Configurations: it allows creating EC2 configurations so the service knows what type of EC2 instance to create when needed; and
* Auto Scaling Groups: a logical group of EC2 instances controlled by the auto scaling service.

Begin this hands-on by running steps 1-3 of [hands-on-005](../hands-on-005), making sure to replace any references to hands-on-005 with hands-on-006. Then follow the steps described next.

### Step 1 - Create a Launch Configuration
![hands-on-006-scrn-01](images/hands-on-006-scrn-01.png)
![hands-on-006-scrn-02](images/hands-on-006-scrn-02.png)
![hands-on-006-scrn-03](images/hands-on-006-scrn-03.png)
![hands-on-006-scrn-04](images/hands-on-006-scrn-04.png)
Get the user data script [here](files/user-data.sh) which will install a stress tool and launch an Apache web server.
![hands-on-006-scrn-05](images/hands-on-006-scrn-05.png)
![hands-on-006-scrn-06](images/hands-on-006-scrn-06.png)
![hands-on-006-scrn-07](images/hands-on-006-scrn-07.png)
![hands-on-006-scrn-08](images/hands-on-006-scrn-08.png)

### Step 2 - Create an Auto Scaling Group
![hands-on-006-scrn-09](images/hands-on-006-scrn-09.png)
![hands-on-006-scrn-10](images/hands-on-006-scrn-10.png)
![hands-on-006-scrn-11](images/hands-on-006-scrn-11.png)
![hands-on-006-scrn-12](images/hands-on-006-scrn-12.png)
![hands-on-006-scrn-13](images/hands-on-006-scrn-13.png)
![hands-on-006-scrn-14](images/hands-on-006-scrn-14.png)
![hands-on-006-scrn-15](images/hands-on-006-scrn-15.png)
![hands-on-006-scrn-16](images/hands-on-006-scrn-16.png)

## Test and Validation
The EC2 Auto Scaling service must automatically launch one EC2 instance based on the EC2 launch configuration that you created. Connect to this instance through SSH and run the following commands to artificially increase CPU utilization.

```
stress -c 200
```

You can then begin monitoring the instance's CPU utilization increase and verify than when it reaches 75% or above a new EC2 instance will automatically be launched by the auto scaling service.

![hands-on-006-scrn-17](images/hands-on-006-scrn-17.png)
![hands-on-006-scrn-18](images/hands-on-006-scrn-18.png)
![hands-on-006-scrn-19](images/hands-on-006-scrn-19.png)
![hands-on-006-scrn-20](images/hands-on-006-scrn-20.png)
