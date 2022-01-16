# Hands-on Linux-01 : Managing Files in Linux

Purpose of the this hands-on training is to teach the students how to manage files in Linux.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Explain files in linux system.

- Create and edit files.

- Work with file contents

- Search files.

## Outline

- Part 1 - Working with File Contents

- Part 2 - Searching Files

## Part 1 - Working with File Contents

- Create a folder and name it linux-lessons.

```bash
mkdir linux-lessons
cd linux-lessons
```

- Create a `text` file named `clarusway.txt`.

```txt
Welcome to the linux lessons
line 2
line 3
line 4
line 5
line 6
line 7
line 8
line 9
line 10
line 11
line 12
line 13
line 14
Line 15
```

- Show the first 10 lines of clarusway.txt.

```bash
head clarusway.txt
```

- Show the first 5 lines of clarusway.txt.

```bash
head -5 clarusway.txt
```

- Show the last 10 lines of clarusway.txt.

```bash
tail clarusway.txt
```

- Show the last 5 lines of clarusway.txt.

```bash
tail -5 clarusway.txt
```

- Display the clarusway.txt file on the screen.

```bash
cat clarusway.txt
```

- Create three files with echo command and name them file1 file2 file3.

```bash
echo "this is file1" > file1
echo "this is file2" > file2
echo "this is file3" > file3
```

- Display the file1, file2 and file3 files on the screen.

```bash
cat file1 file2 file3
```

- Concatenate file1, file2 and file3 to `all.txt` file.

```bash
cat file1 file2 file3 > all.txt
```

- Create a file with `cat` command.

```bash
cat > summer.txt 
Today is cold.
Today is rainy
```

- After the last line, type and hold the Control (Ctrl) key and press d.

- View the clarusway.txt file with the `more` command.

```bash
more clarusway.txt
```

- View the clarusway.txt file with the `less` command.

```bash
less clarusway.txt
```

- The main difference between more and less is that less command is faster because it does not load the entire file at once and allows navigation though file using page up/down keys. 

- Display clarusway.txt file in reverse.

```bash
tac clarusway.txt
```

- Create reverse-clarusway.txt in reverse of clarusway.txt.

```bash
tac clarusway.txt > reverse-clarusway.txt
```

## Part 2 - Searching Files

### `find` command

- Find all the files whose name is clarusway.txt in a current working directory.

```bash
find . -name clarusway.txt
```

- Find all the files under /home directory with name clarusway.txt.

```bash
find /home -name clarusway.txt
```

- Find all the files whose name is clarusway.txt and contains both capital and small letters in /home directory.

```bash
find /home -iname clarusway.txt
```

- Find all directories whose name is linux-lessons in /home directory.

```bash
find /home -type d -name linux-lessons
```

- Find all txt files in the working directory.

```bash
find . -type f -name "*.txt"
```

- Find all empty files in the working directory.

```bash
find . -type f -empty
```

- Find all empty files in the /home directory.

```bash
find /home -type f -empty
```

- To find all 100MB files under home directory. 

```bash
find /home -size 100M
```

- Find all the files which are greater than 50MB and less than 100MB under home directory. Note that the `+` and `-` prefixes signify greater than and less than.

```bash
find /home -size +50M -size -100M
```

- Find all the files which are modified 10 days ago in /home directory.

```bash
find /home -mtime 10
```

- Find all the files which are modified in the last 10 days in /home directory.

```bash
find /home -mtime -10
```

- Find all the files which are modified in more than 10 days in /home directory.

```bash
find /home -mtime +10
```

- Find all the files which are modified more than 10 minutes back and less than 30 minutes in current folder.

```bash
find . -mmin +10 -mmin -30
```

### `grep` command

Grep is a Linux / Unix command-line tool used to search for a string of characters in a specified file. 

- Create a file and name it `grep.txt`.

```txt
grep  searches  for  PATTERNS  in  each  FILE.
PATTERNS  is  one  or more patterns separated by newline characters, and grep prints each line that matches a pattern.  
Typically PATTERNS should be  quoted  when grep is used in a shell command.
```

- Create another file and name it `linux.txt`

```txt
Linux is a family of open-source Unix-like operating systems based on the Linux kernel.
It is an operating system kernel first released on September 17, 1991, by Linus Torvalds.Linux is typically packaged in a Linux distribution.
Distributions include the Linux kernel and supporting system software and libraries.
Popular Linux distributions include Debian, Fedora, and Ubuntu. 
Commercial distributions include Red Hat Enterprise Linux and SUSE Linux Enterprise Server.
```

- Search `linux.txt` file for `kernel`. 

```bash
grep "kernel" linux.txt
```

- Search all files for `is`.

```bash
grep  "is" *
```

- Search `linux.txt` file for `linux`.

```bash
grep "linux" linux.txt
```

- It didn't find linux expression. Because grep is case sensitive. Now try with the following command.

```bash
grep -i "linux" linux.txt
```

- Search `linux.txt` file for `ker`.

```bash
grep -i "ker" linux.txt
```

- Now search `linux.txt` file for `ker` with the following command.

```bash
grep -w "ker" linux.txt
```

- It didn't find `ker`. Grep allows you to find and print the results for whole words only with `-w` flag. Let's try with the following command.

```bash
grep -w "kernel" linux.txt
```

- We can display the lines that are not matched with the specified search sting pattern using the -v option. 

```bash
grep -v "kernel" linux.txt
```

- The `^` regular expression pattern specifies the start of a line. This can be used in grep to match the lines which start with the given string or pattern. 

```bash
grep "^li" clarusway.txt
```

- The $ regular expression pattern specifies the end of a line. This can be used in grep to match the lines which end with the given string or pattern.

```bash
grep "kernel.$" linux.txt
```

- Sometimes we need more content in search results to decide what is most relevant. For this, we can use the following operators to add the desired lines before, after a match, or both:

    - Use -A and a number of lines to display after a match.
    
    ```bash
    grep -A3 "line 5" clarusway.txt # this command prints three lines after the match.
    ```

    - Use -B and a number of lines to display before a match.
    
    ```bash
    grep -B2 "line 5" clarusway.txt # this command prints two lines before the match.
    ```

    - Use -C and a number of lines to display before and after the match.
    
    ```bash
    grep -C4 "line 5" clarusway.txt # this command prints four lines before and after the match.
    ```

- We can also use `grep` command with | (pipe).

```bash
man pwd | grep "print"
```

```bash
man find | grep -A5 "size"
```

```bash
history | grep "find"
```