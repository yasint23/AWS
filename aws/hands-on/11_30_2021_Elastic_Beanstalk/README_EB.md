## Part 1 - Launch an Application

- First download the php-v1.zip and php-v2.zip files from GitHub and share them via Slack.

- Go to `Elastic Beanstalk` service on AWS console.

- Click `Create Application`.

- Enter your application name `MySampleApp`.  (You can also add Application tags if you need.)

- Select `PHP` for Platform, `PHP 7.4 running on 64bit Amazon Linux 2` for Platform Branch and `(Recommended)` for Platform Version.

- Select `Upload your code` for Application code.

- Type `mysampleapp-source-V1` for Version label and select Local file. Then click choose file and upload php-v1.zip file.
  Check File successfully uploaded to be sure.

- Click `Create Application`.

- Wait for Elastic Beanstalk to create the environment for the application. Show the resources being created and listed on the console.

- After the creation of the environment click the link (Application URL) and show the Web Page.

- From the left-hand menu show the app and env menus, talk about them. Click on the tabs like `Configuration`, `Monitoring` etc. and explain them.

- Go to `EC2` service on AWS console and show the resources 
- From the left-hand menu show the app and env menus, talk about them. Click on the tabs like `Configuration`, `Monitoring` etc. and explain them.

- Go to `EC2` service on AWS console and show the resources 
 - Instances, 
 - Load Balancers,
 - ASG,
 - CloudFormation
 - S3 bucket
 created by Elastic Beanstalk.

- Show that security group that allows only http 80

## Part 2 - Update the Application


### Step 1 - Update the Application

- Go to `Elastic Beanstalk` service on AWS console.

- Explain the deployment policies:

https://blog.shikisoft.com/which_elastic_beanstalk_deployment_should_you_use/

- Click `Mysampleapp-env` on the left hand menu, and click `Upload and deploy` to update the application. (You can also click `Application versions` on the left hand menu, and then click `Upload` to update but you have to deploy it manually)

```bash
- Choose file           : php-v2.zip
- Version label         : mysampleapp-source-V2

- Deployment Preferences : Keep it as is `All At Once`
```
- Wait for Elastic Beanstalk to update the application.

- After the update completed click the link (Application URL) and show the Updated Web Page.

- Click `Mysampleapp` >> `Application versions` and show we have one app but two versions.

### Step 2 - Update the Application

- Click `Mysampleapp-env` on the left hand menu, and click `Upload and deploy` to update the application. 

```bash
- Choose file           : php-v1.zip***
- Version label         : mysampleapp-source-V3***

- Deployment Preferences :

    - Deployment policy   : **Immutable**
    - Healthy threshold   : OK
    - Ignore health check : False

```

- Wait for Elastic Beanstalk to update the application.

- After the update completed click the link (Application URL) and show the Updated Web Page.

- Show that one more instnace is created and . the former instance will be terminated because of the `Immutable` deployment model.

- Click `Mysampleapp` >> `Application versions` and show we have one app but 3 versions.

### Step 3 - Connect to the EC2 instance hosting the App 


- Click `Mysampleapp-env` >> `Configuration` on the left hand menu, from `Security` Category click `Edit`.

- `Virtual machine permissions` >> `EC2 key pair` select your key pair and click `Apply`.

- Go to `EC2` service on AWS console.

- Copy the Public IP of the instance (Launced by Elastic Beanstalk).

- Open your terminal and connect to the instance.

## Part 3 - Terminate the Environment

### Step 1 - Terminate the Environment

- Go to `Elastic Beanstalk` service on AWS console.

- Click `Mysampleapp-env` on the left hand menu, from the Actions select `Terminate environment`. (You can also click `Environments` on the left hand menu, select `Mysampleapp-env` and then from the Actions select `Terminate environment` to delete AWS resources.)

- Read the confirmation message and type the name of the environment into the box and click `Terminate`.

- Wait for Elastic Beanstalk to terminate the environment and show events in `Recent events`.

### Step 2 - Restore Environment

- Click `Environments` on the left hand menu, select terminated `Mysampleapp-env` and then from Actions menu select `Restore`.
  `(The terminated environment will remain visible for about an hour.)`

- Show the environment is deployed and working again. 

### Step 3 - Delete Application

- Click `Applications` on the left hand menu, select `MySampleApp`. From `Actions` menu select `Delete application`. Enter the name of the application to confirm and click `Delete`.

- Wait for a while and show both the environment and the application is deleted.


