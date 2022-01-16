# Hands-on Linux-11: Linux Process management

The purpose of this hands-on training is to teach the students how to manage the process in Linux.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- describe Linux processes.

- use Linux process commands

## Outline

- Part 1 - What is a Process?

- Part 2 - Types of Processes

- Part 3 - Viewing Processes in Linux

- Part 4 - Changing priority and nice values in the Linux

- Part 5 - Controlling Processes in Linux

- Part 6 - `df` and `free` command

## Part 1 - What is a Process?

- A process is a running instance of a program that is a passive collection of instructions typically stored in a file on disk.

- Whenever a program/command is executed in Linux, it starts a new process. For example, When we give `ls` command, the Linux machine starts a new process.

## Part 2 - Types of Processes

- In Linux, there are two types of processes.

Foreground Processes: They are also known as interactive processes. They receive input from the keyboard and send output to the screen. 

- For example, when we issue `pwd` command, it displays the current directory on the screen.

```bash
pwd
```

Output:
```bash
/home/james
```

Background Processes: They are also known as non-interactive/automatic processes. They run in the background and do not expect any user input.

- If we start a foreground program/process from the terminal, we will be unable to work on the terminal until the program has completed its execution. Consider this:
When we execute `sleep 120` command in the terminal, we can not work on the terminal for two minutes.

```bash
sleep 120
```

- To get back terminal, press `ctrl + c`

- To avoid such a situation, we can run the program with an ampersand (&) sign that starts it as a background process. Thus, other processes can be done in parallel with the process running in the background since they do not have to wait for the previous process to be completed.

```bash
sleep 120 &
```

- We can also suspend a process and send it to the background by pressing `Ctrl + Z`.


## Part 3 - Viewing Processes in Linux

### ps

- `ps` displays information about a selection of the active processes. It can be used to list all the running processes.

```bash
ps
```

Output:

```bash
  PID TTY          TIME CMD
    1 pts/0    00:00:00 bash
  148 pts/0    00:00:00 ps
```

- With -f flag, we can get more information.

```bash
ps -f
```

Output:

```bash
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 14:42 pts/0    00:00:00 bash
root       928     1  0 15:17 pts/0    00:00:00 ps -f
```

Fields described by ps:

| Fields | Description |
| ------ | ----------- |
| UID    | User ID that this process belongs to the person running it  |
| PID    | Process ID              |
| PPID   | Parent process ID     |
| C      | CPU utilization of process              |
| STIME  | Process start time |
| TTY    | Terminal type associated with the process              |
| TIME   | CPU time taken by the process |
| CMD    | The command that started this process    |

- The most common options to use `ps command` to add “-aux”.

-a = View processes of all users rather than just the current user.
-u = Provide detailed information about each of the processes
-x = Include processes that are controlled not by users but by daemons.

- For example, the command `ps -aux` will return a detailed process list of all processes.

```bash
ps -aux
```

### How Does Linux Identify Processes?

- Since Linux is a multi-user system, multiple users may run different programs at the same time, the kernel must identify each running instance of a program uniquely.

- A program's process ID (PID) and parent processes ID (PPID) are used to identify it.

- Processes can be categorized into:

Parent processes: These are processes that create other processes during run-time.
Child processes: These processes are created by other processes during run-time.

- Let's understand this with a simple example. Create a script file and name it `sleep.sh`.

```bash
#!/bin/bash
sleep 60
```

- Make the script executable and execute it in the background.

```bash
chmod +x sleep.sh
./sleep.sh &
```

- Execute the ps -f command and pay attention to PID and PPID.

```bash
ps -f
```

Output:

```bash
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 16:02 pts/0    00:00:00 bash
root       541     1  0 16:20 pts/0    00:00:00 /bin/bash ./sleep.sh
root       542   541  0 16:20 pts/0    00:00:00 sleep 60
root       543     1  0 16:20 pts/0    00:00:00 ps -f
```

- In this case, we execute the sleep command via `sleep.sh`. As a result of this,  the PID of the command `/bin/bash ./sleep.sh` is 541, and, it is the PPID of the `sleep 60` command.

- To find the process ID and parent process ID of the current shell, run the following command.

```bash
echo $$
echo $PPID
```

### top

- This command provides a dynamic real-time view of running processes.

```bash
top
```

Output:

```bash
top - 16:51:17 up 74 days,  5:17,  0 users,  load average: 5.35, 5.71, 6.94
Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
%Cpu(s): 22.9 us, 11.1 sy,  0.0 ni, 64.9 id,  0.8 wa,  0.0 hi,  0.4 si,  0.0 st
KiB Mem:  13191135+total, 94149888 used, 37761464 free,   456332 buffers
KiB Swap:  8378364 total,   690996 used,  7687368 free. 30721496 cached Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                               
    1 root      20   0   18188   2772   2292 S   0.0  0.0   0:00.21 bash                                  
 1303 root      20   0   19888   2480   2132 R   0.0  0.0   0:00.00 top 
```

Fields described by top:

| Fields | Description |
| ------ | ----------- |
| PID    | Process ID              |
| UID    | User ID that this process belongs to the person running it  |
| PR     | Priority Can be 20(highest) or -20(lowest) |
| NI     | The nice value of a task |
| VIRT   | Virtual memory used (kb) |
| RES    | Physical memory used (kb)| 
| SHR    | Shared memory used (kb)  |
| S      | Status |
| %CPU   | % of CPU time   |
| %MEM   | Physical memory used  |
| TIME+  |Total CPU time |
| Command | Command name|


### The status of processes

There are five types of statuses:

**D:** Uninterruptible sleep (usually a critical system process, a process that cannot be killed without rebooting)

**R:** Running or runnable (on run queue)

**S:** Interruptible sleep (waiting for an event to complete)

**T:** Stopped, either by a job control signal or because it is being traced.

**Z:** Defunct (“zombie”) process, terminated but not closed by the parent process that created it

## Part 4 - Changing priority and nice values in the Linux

- Linux can run a large number of processes concurrently, which can slow down the speed of some high-priority processes and lead to poor performance. To prevent this, we can instruct our device to prioritize processes based on our requirements. We have already learned there are two fields in the output of `top` command. PR (Priority value) and NI (Nice value).

**Priority value:** The priority value is the process’s actual priority which is used by the Linux kernel to schedule a task.  

**Nice value:**  
- Nice values are user-space values that we can use to control the priority of a process. 
- The lower we issue the niceness value, the higher the priority will be. 
- Likewise, the higher we issue the niceness value, the lower the priority will be. 
- Notice that normal users can assign a nice value ranging from 0 to 20 to processes that they own. Only the root user can use negative nice values.

- The relation between nice value and priority is as follows:

```
Priority_value = Nice_value + 20
```

> For the sake of clarity, we'll run it on a single-core CPU such as t2.micro in AWS.

- Let's understand this issue with an example. First, we will create a script that takes a lot of processing power continuously.

```
cat << EOF > infinite.sh
#!/bin/bash
while [[ true ]]
do 
  continue
done
EOF
```

- Make the script executable and execute it in the background.

```bash
chmod +x infinite.sh
./infinite.sh &
```

- Let's check the CPU usage with `top` command.

```bash
top
```

Output:

```bash
   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                              
   1457 ubuntu    20   0    8616   3420   3196 R  99.9   0.3   4:13.24 infinite.sh 
```

- When we run infinite.sh in the background, we see that this process (PID-1457) is consuming 99.9% of the CPU's processing power.

- Let's execute infinite.sh twice and see the results.

```bash
./infinite.sh &
./infinite.sh &
top
```

Output:

```bash
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                               
   1457 ubuntu    20   0    8616   3420   3196 R  31.2   0.3   4:56.99 infinite.sh                                                                               
   1491 ubuntu    20   0    8616   3500   3276 R  31.2   0.3   0:04.58 infinite.sh                                                                               
   1492 ubuntu    20   0    8616   3552   3328 R  31.2   0.4   0:04.59 infinite.sh 
```

- As we see all of infinite.sh (PID-1457,1491,1492) get equal CPU as all have the same priority. We can change this by giving different nice values. For this, there are two ways: `nice` and `renice` commands.

### nice

- With `nice` command, we can run a program with modified scheduling priority.

```bash
nice -n 10 ./infinite.sh &
top
```

Output:

```bash
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND 
   1457 ubuntu    20   0    8616   3420   3196 R  32.2   0.3   5:28.94 infinite.sh                                                                               
   1491 ubuntu    20   0    8616   3500   3276 R  32.2   0.3   0:36.53 infinite.sh                                                                               
   1492 ubuntu    20   0    8616   3552   3328 R  32.1   0.4   0:36.53 infinite.sh                                                                               
   1497 ubuntu    30  10    8616   3508   3280 R   3.5   0.4   0:00.47 infinite.sh
```

- As we see, the priority of the process (P-1497) is 30 (priority = 20 + nice_value). It receives the least amount of CPU because it has the lowest priority.

### renice

- Let's change the nice value of a running process using its PID with `renice -n nice-value - p [PID]` command.

```bash
renice -n 5 -p 1457
```

Output:
```bash
1457 (process ID) old priority 0, new priority 5
```

- When we run this, the priority of the process with PID-1457 is changed from 20 to 25, and the CPU is allocated appropriately.

```bash
top
```

Output:

```bash
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                               
   1491 ubuntu    20   0    8616   3500   3276 R  40.0   0.3   1:37.80 infinite.sh                                                                               
   1492 ubuntu    20   0    8616   3552   3328 R  40.0   0.4   1:37.80 infinite.sh                                                                               
   1457 ubuntu    25   5    8616   3420   3196 R  13.3   0.3   6:03.37 infinite.sh                                                                               
   1497 ubuntu    30  10    8616   3508   3280 R   6.7   0.4   0:07.05 infinite.sh
```

## Part 5 - Controlling Processes in Linux

-  The most fundamental way of controlling processes in Linux is to send them signals. There are several signals that we can send to a process. To see all of them, we can use `kill -l` command.

```bash
$ kill -l
 1) SIGHUP   2) SIGINT   3) SIGQUIT  4) SIGILL   5) SIGTRAP
 6) SIGABRT  7) SIGBUS   8) SIGFPE   9) SIGKILL 10) SIGUSR1
11) SIGSEGV 12) SIGUSR2 13) SIGPIPE 14) SIGALRM 15) SIGTERM
16) SIGSTKFLT 17) SIGCHLD 18) SIGCONT 19) SIGSTOP 20) SIGTSTP
21) SIGTTIN 22) SIGTTOU 23) SIGURG  24) SIGXCPU 25) SIGXFSZ
26) SIGVTALRM 27) SIGPROF 28) SIGWINCH  29) SIGIO 30) SIGPWR
31) SIGSYS  34) SIGRTMIN  35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX
```

- For example, with `kill -9 PID`, we can immediately terminate (kills) a process.

```bash
$ sleep 60 &  
[1] 851
$ ps 
  PID TTY          TIME CMD
    1 pts/0    00:00:00 bash
  851 pts/0    00:00:00 sleep
  852 pts/0    00:00:00 ps
$ kill -9 851
$ ps
  PID TTY          TIME CMD
    1 pts/0    00:00:00 bash
  853 pts/0    00:00:00 ps
[1]+  Killed                  sleep 60
```

## Part 6 - `df` and `free` command


### df

- The `df` command (short for disk free) displays the amount of available disk space being used by file systems. 

```bash
$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
overlay        902060100 265504196 590663964  32% /
tmpfs              65536         0     65536   0% /dev
tmpfs          132017140         0 132017140   0% /sys/fs/cgroup
shm                65536         0     65536   0% /dev/shm
/dev/md3       902060100 265504196 590663964  32% /etc/hosts
tmpfs          132017140         0 132017140   0% /proc/acpi
tmpfs          132017140         0 132017140   0% /proc/scsi
tmpfs          132017140         0 132017140   0% /sys/firmware
```

Fields described by top:

| Fields | Description |
| ------ | ----------- |
| Filesystem | The name of the disk partition|
| Size       | The total size of the file system|
| used       | The total amount of space allocated to existing files in the file system|
| Available  | The total amount of space available within the file system|
| Percentage used | The percentage of the available space that currently allocated to all files on the file system|
| Mounted on | The directory in which the file system appears|

-To get the information above in a readable format, we can use the `df -h` command.

```bash
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay         861G  254G  564G  32% /
tmpfs            64M     0   64M   0% /dev
tmpfs           126G     0  126G   0% /sys/fs/cgroup
shm              64M     0   64M   0% /dev/shm
/dev/md3        861G  254G  564G  32% /etc/hosts
tmpfs           126G     0  126G   0% /proc/acpi
tmpfs           126G     0  126G   0% /proc/scsi
tmpfs           126G     0  126G   0% /sys/firmware
```

### Free

This command displays the free and used memory (RAM) on the Linux system. We can use the arguments `free -m` to display output in MB or `free -g` to display output in GB.

```bash
$ free
              total        used        free      shared  buff/cache   available
Mem:      264034280    37823420   127251136       10288    98959724   221324296
Swap:       8380412        4608     8375804
$ free -m
              total        used        free      shared  buff/cache   available
Mem:         257845       36940      124260          10       96644      216133
Swap:          8183           4        8179
$ free -g
              total        used        free      shared  buff/cache   available
Mem:            251          36         121           0          94         211
Swap:             7           0           7
```