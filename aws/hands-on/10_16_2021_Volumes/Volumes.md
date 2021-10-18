
# Hands-on EC2-04 : Extending and Partitioning EBS Volumes

Purpose of the this hands-on training is to teach the students how to add or attach an EBS (Elastic Block Storage) volume on an AWS instance, how to extend and resize volumes, and how to create partitions in volumes on running Amazon Linux 2 EC2 instances.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- understand what is the difference between root volume and EBS Volume.

- list volumes to show current status of primary (root) and additional volumes

- demonstrate their knowledge on how to create EBS volume.

- create mounting point on EC2 instances.

- partition volume on EC2 instances.

- resize the volume or partitions on the new EBS volumes.

- understand how to auto-mount EBS volumes and partitions after reboots.

## Outline

- Part 1 - Extend EBS Volume without Partitioning

- Part 2 - Extend EBS Volume with Partitioning

- Part 3 - Auto-mount EBS Volumes and Partitions on Reboot

![EBS Volumes](./ebs_backed_instance.png)

## PART 1 - EXTEND EBS VOLUME WITHOUT PARTITIONING

- launch an instance from aws console in "us-east-1a" AZ.
- check volumes which volumes attached to instance. 
- only root volume should be listed
```
lsblk
```
### Section 0 - Create new Volume 

- create a new volume in the same AZ "us-east-1" with the instance from AWS console "5 GB" for this demo.
- attach the new volume from aws console, then list block storages again.
- root volume and secondary volume should be listed
```
lsblk
```
### Section 1 - Mounting Volume

- check if the attached volume is already formatted or not and has data on it.
```
sudo file -s /dev/xvdf
```
- if not formatted, format the new volume
```
sudo mkfs -t ext4 /dev/xvdf
```
- check the format of the volume again after formatting
```
sudo file -s /dev/xvdf
```
- create a mounting point path for new volume (volume-1)
```
sudo mkdir /mnt/mp1
```
- mount the new volume to the mounting point path
```
sudo mount /dev/xvdf /mnt/mp1/
```
- check if the attached volume is mounted to the mounting point path
```
lsblk
```
- show the available space, on the mounting point path
```
df -h
```
- check if there is data on it or not.
```
ls  /mnt/mp1/
```
- if there is no data on it, create a new file to show persistence in later steps

```
cd /mnt/mp1
sudo touch hello.txt
ls
```
### Section 2: Enlarge the new volume (volume-1) in AWS console and modify from terminal

- modify the new volume in aws console, and enlarge capacity from 5GB to 6GB .
- check if the attached volume is showing the new capacity
```
lsblk
```
- show the real capacity used currently at mounting path, old capacity should be shown.
```
df -h
```
- resize the file system on the new volume to cover all available space.
```
sudo resize2fs /dev/xvdf
```
- show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
```
df -h
```
- show that the data still persists on the newly enlarged volume.
```
ls /mnt/mp1/
```
## Section 3: Rebooting Instance

- show that mounting point path will be gone when instance rebooted 
```
sudo reboot now
```
- show the new volume is still attached, but not mounted
```
lsblk
```
- check if the attached volume is "already formatted" or not and has data on it.
```
sudo file -s /dev/xvdf
```
- mount the new volume to the mounting point path
```
sudo mount /dev/xvdf /mnt/mp1/
```
- show the used and available capacity is same as the disk size.
```
lsblk
df -h
```
- if there is data on it, check if the data still persists.
```
ls  /mnt/mp1/
```

## PART 2 - EXTEND EBS VOLUME WITH PARTITIONING

- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html

- https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/

- list volumes to show current status, primary (root) and secondary volumes should be listed
```
lsblk
```
- show the used and available capacities related with volumes
```
df -h
```
### Section 0: Create new volume

- create tertiary volume (5 GB for this demo) in the same AZ "us-east-1" with the instance on aws console
- attach the new volume from aws console, then list volumes again.
-  primary (root), secondary and tertiary volumes should be listed
```
lsblk
```
- show the used and available capacities related with volumes
```
df -h
```
- show the current partitions... use "fdisk -l /dev/xvda" for specific partition
```
sudo fdisk -l
```

### Section 1: Make partition-1

- check all available fdisk commands and using "m".

```
sudo fdisk /dev/xvdg

 n -> add new partition (with 1G size)
 p -> primary
 Partition number: 1
 First sector: default - use Enter to select default
 Last sector: +2G
  
 
 n -> add new partition (with rest of the size-1G)
 p -> primary
 Partition number: 2
 First sector: default - use Enter to select default
 Last sector: default - use Enter to select default
 w -> write partition table
 
 ```
- format the new partitions
```
sudo mkfs -t ext4 /dev/xvdg1
sudo mkfs -t ext4 /dev/xvdg2
```
- create a mounting point path for new volume
```
sudo mkdir /mnt/mp2
sudo mkdir /mnt/mp3
```
- mount the new volume to the mounting point path
```
sudo mount /dev/xvdg1 /mnt/mp2/
sudo mount /dev/xvdg2 /mnt/mp3/
```
- list volumes to show current status, all volumes and partittions should be listed
```
lsblk
```
- show the used and available capacities related with volumes and partitions
```
df -h
```

- if there is no data on it, create a new file to show persistence in later steps
```
sudo touch /mnt/mp3/helloguys.txt
ls  /mnt/mp3/
```
### Section 3: Enlarge capacity 

- modify the new (3rd) volume in aws console, and enlarge capacity 1 GB more (from 5GB to 6GB for this demo).
- check if the attached volume is showing the new capacity
```
lsblk
```
- show the real capacity used currently at mounting path, old capacity should be shown.
```
df -h
```
- extend the partition 2 and occupy all newly avaiable space.  Warning for space !!!!!!
```
sudo growpart /dev/xvdg 2
```
- ​show the real capacity used currently at mounting path, updated capacity should be shown.
```
lsblk
```
- resize and extend the FILE System.
```
sudo resize2fs /dev/xvdg2
```
- show the newly created file to show persistence

```
ls  /mnt/mp3/
```
- reboot and show that configuration is gone
```
sudo reboot now
```


## PART 3 - AUTOMOUNT EBS VOLUMES AND PARTITIONS ON REBOOT

- back up the /etc/fstab file.
```
sudo cp /etc/fstab /etc/fstab.bak
```
- open /etc/fstab file and 

```
sudo nano /etc/fstab 
```
- add the following info to the existing.(UUID's can also be used)
```
 /dev/xvdf       mnt/mp1   ext4    defaults,nofail        0       0
 /dev/xvdg1      mnt/mp2   ext4  defaults,nofail        0       0
 /dev/xvdg2      mnt/mp3   ext4  defaults,nofail        0       0
```
 

- reboot and show that configuration exists (NOTE)
```
sudo reboot now
```
- list volumes to show current status, all volumes and partitions should be listed
```
lsblk
```
- show the used and available capacities related with volumes and partitions
```
df -h
```
- if there is data on it, check if the data still persists.
```
ls  /mnt/mp1/
ls  /mnt/mp3/
```

# NOTE: You can use "sudo mount -a" to mount volumes and partitions after editing fstab file without rebooting.
