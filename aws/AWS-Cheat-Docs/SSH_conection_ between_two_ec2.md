 **Configure ssh connection between master and slave ec2.**

- Go to the Master server: 

```bash
sudo su - master  #if it will not take you  .... .ssh]# bash below
#sudo su
#cd /root/.ssh
```

  - Generate a public and private key with keygen.

```bash
ssh-keygen
```
  - Press enter for every question to continue with default options. 

  - Check ".ssh" folder and see public(id_rsa.pub) and private keys(id_rsa). 

```bash
cd .ssh
ls
```
  - We need to copy public key to slave node.

```bash
cat id_rsa.pub
```
  - Select and copy all the codes in id_rsa.pub.

- Go to the /root/.ssh folder on the slave node instance.

```bash
sudo su
cd /root/.ssh
```

- Open the "authorized_keys" file with an editor and paste the code that you copied from public key(id_rsa.pub). Save "authorized_keys" file.

```bash
vi authorized_keys 

- Get the slave node ip:

```bash
ifconfig
```
- Copy ip number.

- Go to the Master server and test ssh connection.

```bash
ssh root@<slave-node-ip-number>