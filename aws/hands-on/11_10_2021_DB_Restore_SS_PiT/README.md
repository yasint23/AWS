# Hands-on DB-03 : Restoring RDS DB Instance from Manual Snapshot and Point in Time

Purpose of the this hands-on training is to give understanding to take a manual snapshot from RDS DB instance, restore RDS DB instance from this snapshot, and also restore RDS DB instance from a point in time. We'll use the RDS crated in former session.(Hands-on DB-01)

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install MariaDB Client on Ubuntu Instance.

- learn how to take a snapshot from RDS DB Instance.

- recover RDS DB Instance from manual snapshot.

- restore RDS DB Instance from point in time recovery.

- learn how to dump data from a snapshot.

## Outline

- Part 1 - Installing MariaDB Client on Ubuntu Instance and Setting up Database on RDS Instance Remotely

- Part 2 - Taking a Snapshot from RDS DB Instance

- Part 3 - Recovering RDS DB Instance from Manual snapshot

- Part 4 - Restoring RDS DB Instance from a Point in Time

- Part 5 - Dumping and Migrating Database

## Part 1 - Installing MariaDB Client on Ubuntu Instance and Setting up Database on RDS Instance Remotely

### STEP 0 - Creating a RDS Instance if you have deleted in the former session.

- First, lets create Security Group

```text
Name: DatabaseSecGrb
Inbound: Mysql/Aurora ------>3306------> Anywhere
```

- Go to the Amazon RDS Service and select Database section from the left-hand menu, click databases and then click Creating Database.

- Choose a database creation method.

```text
Standard Create
```

- Engine option

```text
MySQL
```

- Version

```text
8.0.20
```

- Template

```text
Free tier
```

- Settings

```text
DB instance identifier: RDS-mysql
Master username: admin
Master password: Pl123456789
```

- DB instance size

```text
Burstable classes (includes t classes) : db.t2.micro
```

- Storage

```text
Storage type          : ssd
Storage size          : default 20GiB
Storage autoscaling   : unchecked
```

- Availability & durability

```text
We can not select any option for free tier
```

- Connectivity

```text
VPC                           : default

Click Additional Connectivity Configuration;

Subnet group                  : default
*Publicly accessible          : ***Yes
VPC security groups           : *DatabaseSecGrb
Availability Zone             : No preference
Database port                 : 3306
```

- Database authentication

```text
DB Authentication: Password authentication
```

- Additional configuration

```text
Initial DB name                   : clarusway
DB parameter group & option group : default
Automatic backups                 : enable
Backup retention period           : 7 days (Explain how)

Select window for backup to show snapshots
Monitoring  : Unchecked
Log exports : Unchecked

Maintenance
  - Enable auto minor version upgrade: Enabled (Explain what minor and major upgrade are)
  - Maintenance window (be careful not to overlap maintenance and backup windows)

Deletion protection: *Disabled
```
### STEP 1 - Installing MariaDB-client on Ubuntu Instance

- Launch EC2 Instance.

```text
AMI: Ubuntu 18.04
Instance Type: t2.micro

Security Group
  - SSH           -----> 22    -----> Anywhere

```

- Connect Ubuntu Instance with SSH.

- Update instance.

```bash
sudo apt update -y

```

- Install the `mariadb-client`.

```bash
sudo apt-get install mariadb-client -y
```

### STEP 2 - Connecting to RDS DB Instance


- Connect the RDS MySQL DB instance with admin user, and paste the password when prompted.

```bash
mysql -h Your RDS Endpoint -u admin -p
```

- Show default databases in the MySQL server.

```sql
SHOW DATABASES;
```

- Choose a database 

```sql
USE clarusway;
```

- Show tables within the `clarusway` db.

```sql
SHOW TABLES;
```

- Show current users defined in the RDS DB instance.

```sql
SELECT Host, User, authentication_string FROM user;
```

### STEP 3 - Creating Tables in RDS DB Instance and Populating with Data


- Create a table named `offices` in clarusway database

```sql
CREATE TABLE `offices` (
  `office_id` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

- Insert sample data into the table named `offices` in clarusway database

```sql
INSERT INTO `offices` VALUES (1,'03 Reinke Trail','Cincinnati','OH');
INSERT INTO `offices` VALUES (2,'5507 Becker Terrace','New York City','NY');
INSERT INTO `offices` VALUES (3,'54 Northland Court','Richmond','VA');
INSERT INTO `offices` VALUES (4,'08 South Crossing','Cincinnati','OH');
INSERT INTO `offices` VALUES (5,'553 Maple Drive','Minneapolis','MN');
INSERT INTO `offices` VALUES (6,'23 North Plaza','Aurora','CO');
INSERT INTO `offices` VALUES (7,'9658 Wayridge Court','Boise','ID');
INSERT INTO `offices` VALUES (8,'9 Grayhawk Trail','New York City','NY');
INSERT INTO `offices` VALUES (9,'16862 Westend Hill','Knoxville','TN');
INSERT INTO `offices` VALUES (10,'4 Bluestem Parkway','Savannah','GA');
```

- Create a table named `employees`in clarusway database

```sql
CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `job_title` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `reports_to` int(11) DEFAULT NULL,
  `office_id` int(11) NOT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `fk_employees_offices_idx` (`office_id`),
  CONSTRAINT `fk_employees_offices` FOREIGN KEY (`office_id`) REFERENCES `offices` (`office_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

- Insert sample data into the table named `employees`in clarusway database

```sql
INSERT INTO `employees` VALUES (37270,'Yovonnda','Magrannell','Executive Secretary',63996,NULL,10);
INSERT INTO `employees` VALUES (33391,'Darcy','Nortunen','Account Executive',62871,37270,1);
INSERT INTO `employees` VALUES (37851,'Sayer','Matterson','Statistician III',98926,37270,1);
INSERT INTO `employees` VALUES (40448,'Mindy','Crissil','Staff Scientist',94860,37270,1);
INSERT INTO `employees` VALUES (56274,'Keriann','Alloisi','VP Marketing',110150,37270,1);
INSERT INTO `employees` VALUES (63196,'Alaster','Scutchin','Assistant Professor',32179,37270,2);
INSERT INTO `employees` VALUES (67009,'North','de Clerc','VP Product Management',114257,37270,2);
INSERT INTO `employees` VALUES (67370,'Elladine','Rising','Social Worker',96767,37270,2);
INSERT INTO `employees` VALUES (68249,'Nisse','Voysey','Financial Advisor',52832,37270,2);
INSERT INTO `employees` VALUES (72540,'Guthrey','Iacopetti','Office Assistant I',117690,37270,3);
INSERT INTO `employees` VALUES (72913,'Kass','Hefferan','Computer Systems Analyst IV',96401,37270,3);
INSERT INTO `employees` VALUES (75900,'Virge','Goodrum','Information Systems Manager',54578,37270,3);
INSERT INTO `employees` VALUES (76196,'Mirilla','Janowski','Cost Accountant',119241,37270,3);
INSERT INTO `employees` VALUES (80529,'Lynde','Aronson','Junior Executive',77182,37270,4);
INSERT INTO `employees` VALUES (80679,'Mildrid','Sokale','Geologist II',67987,37270,4);
INSERT INTO `employees` VALUES (84791,'Hazel','Tarbert','General Manager',93760,37270,4);
INSERT INTO `employees` VALUES (95213,'Cole','Kesterton','Pharmacist',86119,37270,4);
INSERT INTO `employees` VALUES (96513,'Theresa','Binney','Food Chemist',47354,37270,5);
INSERT INTO `employees` VALUES (98374,'Estrellita','Daleman','Staff Accountant IV',70187,37270,5);
INSERT INTO `employees` VALUES (115357,'Ivy','Fearey','Structural Engineer',92710,37270,5);
```

- Show newly created tables.

```sql
SHOW TABLES;
```

- List all records within `employees` table.

```sql
SELECT * FROM offices;
```

- List all records within `offices` table.

```sql
SELECT * FROM employees;
```

- Close the `clarusway` database terminal.

```sql
EXIT;
```

- For `point in time recovery` PART (PART-4), please note down the current time. (Exp: August 12, 2020, 22:45:34, UTC +3) and let the students know:

     -enter the time:

## Part 2 - Taking a Snapshot from RDS DB Instance

- Take a manual snapshot of RDS instance and name it as `manual-snapshot-RDS-mysql`.

  - Go to Amazon RDS from AWS Console.

  - Select `RDS-mysql` database ---> Action -----> Take Snapshot

  - Settings:

  ```text

  DB Instance: RDS-mysql
  Snapshot name : Manual-Snapshot-RDS-Mysql
  ```
  - Create
  

## Part 3 - Recovering RDS DB Instance from Manual Snapshot

- Connect to RDS DB instance from MariaDB Client. Note: We need to delete some data to simulate the data lost.

- Login back to the RDS MySQL DB instance (`RDS-mysql`) as `admin` using the password defined with SSL pass: `Pl123456789`.

```bash
mysql -h RDS_ENDPOINT -u admin -p
```
- Choose a database 

```sql
USE clarusway;
```

  - Delete `employees` who earns salary above `$70000` from the `clarusway` db on `RDS-mysql`.

    - Show all data in `employee` table.

    ```sql
    SELECT * FROM employees;
    ```

    - Delete `employees` who have salary above `$70000`:

    ```sql
    DELETE FROM employees WHERE salary > 70000;
    ```

    - Show that records left in `employees` tables are the ones who have salary lower than $70000. 

    ```sql
    SELECT * FROM employees;

    There are only 7 personal now.
    ```

- Restore database from manual snapshot as new DB instance and name it as `restored-from-man-snapshot`.

  - Go to snapshot on left hand menu and select snapshot named `manual-snapshot-RDS-mysql`.

  - Click Action ----> Restore snapshot.

  ```text
  - DB specifications:
    Engine : MySQL Community

  - Settings:
    DB Instance identifier : restored-from-man-snapshot

  - Connectivity:
    Virtual private cloud (VPC)Info: Default

  - Additional connectivity configuration:
    Subnet Group : Default
    Public Accessible: Yes
    Existing VPC security groups: DatabaseSecGrb

  - DB instance size:(System changed it automatically to the Standard classes) 
    ***Select Burstable classes (includes t classes)
    ***t2.micro

  - Storage:
    General Purpose SSD
    Allocated storage : 20 GiB

  - Availability & durability:
    Do not create standby Instance
    Availability Zone: No preference

  - Database authentication:
    Password authentication

  - Encryption:
    Keep it as is

  - Additional configuration:
    Keep it as is
  ```

- This time we are going to connect as `admin` using the password defined `Pl123456789` to the newly RDS Instance named `restored-from-man-snapshot` that is created from snapshot.

```bash
mysql -h [***restored-from-man-snapshot RDS endpoint] -u admin -p
```

- Choose a database (`clarusway` db) to work with.

```sql
USE clarusway;
```

- Show tables within the `clarusway` db.

```sql
SHOW TABLES;
```

- Show that deleted records of employees are back in `restored-from-man-snapshot`

```sql
SELECT * FROM employees;
```
- Exit from`restored-from-man-snapshot` database

```sql
EXIT;
```
## Part 4 - Restoring RDS DB Instance from a "Point in Time"

- Connect to the 'RDS-Mysql` database again.

```bash
mysql -h [RDS-MysqlENDPOINT] -u admin -p
```
- Choose a database 

```sql
USE clarusway;
```

- This time, delete `employees` who earn salary above `$60000` from the `clarusway` db on `RDS-Mysql`.

```sql
DELETE FROM employees WHERE salary > 60000;
```
- Show the data in employees table

```sql
SELECT * FROM employees;

there are only 4 records 
```
- To rescue the data we'll Restore database from the "point in time snapshot" that will be named as `restored-from-point-in-time-RDS`.

  - Go to Amazon RDS console and select `RDS-Mysql` database.

  ```text
  Actions ---> Restore to point in time
  ```

  - Launch DB Instance.

  ```text
  - Restore Time
    Custom ----> Enter the exact time that you wrote down at the end of the PART-1
  - DB Engine
    MySQL Community Edition
  - License model
    general public-licence
  - DB instance class
    t2.micro
  - Multi-AZ deployment
    No
  - Storage type
    General Purpose SSD

  Settings:
  - DB instance identifier
    restored-from-point-in-time-RDS
  - Parameter group
    default.mysql8.0

  Network & Security:
  Virtual Private Cloud (VPC)
    Default
  - Subnet group
    default
  - Public accessibility
    *Yes
  - Availability zone, Security groups, Database options, Backup, Log exports, Maintenance
    Keep it as is
  ```

- Go to the MariaDB Client instance.

- Log into the RDS instance (`restored-from-point-in-time-RDS`) as `admin` using the password defined `Pl123456789`

```bash
mysql -h [DNS Name of point in time recovery RDS Instance] -u admin -p clarusway
```

- Show that deleted records of employees are back in `restored-from-point-in-time-RDS`.

```sql
SELECT * FROM employees ORDER BY salary ASC;
```

## Part 5 - Dumping and Migrating Database

- Show that some information are absent in the `clarusway` database on RDS DB instance (`RDS-Mysql`). We need to recover absent data from snapshot via dumping.

- Go to MariaDB Client instance by connecting with SSH.

- Back up the `clarusway` db from RDS DB instance (`restored-from-point-in-time-RDS`) to the file named `backup.sql` on EC2 instance.

```bash
mysqldump -h [restored-from-point-in-time-RDS endpoint] -u admin -p clarusway > backup.sql
```

- Show `backup.sql` file with `ls` command.

- Restore the backup of `clarusway` db on to the MySQL DB Server (`RDS-mysql` instance) using  `backup.sql` file

```bash
mysql -h [RDS-mysql endpoint] -u admin -p clarusway < backup.sql
```

- Connect to the `RDS-mysql` instance.

```bash
mysql -h [RDS-mysql endpoint] -u admin -p;
```

- Show that all records are replicated in the `clarusway` database.

```sql
SHOW DATABASES;
USE clarusway;
SELECT * FROM employees;
```
