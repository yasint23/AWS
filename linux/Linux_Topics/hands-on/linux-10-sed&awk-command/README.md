# Hands-on Linux-11 : sed & awk command

Purpose of the this hands-on training is to teach the students how to use sed & awk command.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- use sed & awk command.

## Outline

- Part 1 - sed command

- Part 2 - awk command

## Part 1 - sed command

- Sed is a stream editor. A stream editor is used to perform a lot of function on a file like searching, find and replace, insertion or deletion.

- Create a folder and name it `sed-awk-command`.

```bash
mkdir sed-awk-command && cd sed-awk-command
```

- Create a file named `sed.txt`. 

```txt
Linux is an OS. Linux is life. Linux is a concept.
I like linux. You like linux. Everyone likes linux.
Linux is free. Linux is good. Linux is hope.
```

### Replacing or substituting string

The following sed command replaces the word “linux” with “ubuntu” in the file.

```bash
sed 's/linux/unutu/' sed.txt
```
- `s` specifies the substitution operation. 
- The `/` are delimiters. 
- The `linux` is the search pattern and the `ubuntu` is the replacement string.

**Output:**
```bash
Linux is an OS. Linux is life. Linux is a concept.
I like unutu. You like linux. Everyone likes linux.
Linux is free. Linux is good. Linux is hope.
```
> Pay attention that, by default, the sed command replaces the `first occurrence` of the pattern in each line.


### 

### Replacing the any occurrence of a pattern in a line 
Use the /1, /2 etc flags to replace the first, second occurrence of a pattern in a line. The following command replaces the third occurrence of the word “linux” with “ubuntu” in a line.

```bash
sed 's/linux/ubuntu/3' sed.txt
```

**Output:**
```bash
Linux is an OS. Linux is life. Linux is a concept.
I like linux. You like linux. Everyone likes ubuntu.
Linux is free. Linux is good. Linux is hope.
```

### Replacing a string by ignoring case distinctions.

By, default sed command do not ignore case distinctions. For this `i` pattern can be used.

```bash
sed 's/linux/ubuntu/i' sed.txt
```

**Output:**
```bash
ubuntu is an OS. Linux is life. Linux is a concept.
I like ubuntu. You like linux. Everyone likes linux.
ubuntu is free. Linux is good. Linux is hope.
```

#### Replacing all the occurrence of the pattern in a line 

`g flag` (global replacement) defines the sed command to replace all the occurrences of the string in the line.

```bash
sed 's/linux/ubuntu/g' sed.txt
```

**Output:**
```bash
Linux is an OS. Linux is life. Linux is a concept.
I like ubuntu. You like ubuntu. Everyone likes ubuntu.
Linux is free. Linux is good. Linux is hope.
```

- We can do the same by ignoring case distinctions. Use the combination of `/i` and `/g`.

```bash
sed 's/linux/ubuntu/ig' sed.txt
```

**Output:**
```bash
ubuntu is an OS. ubuntu is life. ubuntu is a concept.
I like ubuntu. You like ubuntu. Everyone likes ubuntu.
ubuntu is free. ubuntu is good. ubuntu is hope.
```

#### Replacing from any occurrence to all occurrences in a line

We can replace all the patterns from the any occurrence of a pattern in a line by using the combination of /1, /2 etc and /g. The sed command below replaces the second, third, and so on “linux” word with “ubuntu” word in a line.

```bash
sed 's/linux/ubuntu/2ig' sed.txt
```

**Output:**
```bash
Linux is an OS. ubuntu is life. ubuntu is a concept.
I like linux. You like ubuntu. Everyone likes ubuntu.
Linux is free. ubuntu is good. ubuntu is hope.
```

#### Replacing string on a specific line number

We can limit the sed command to replace the string on a specific line number. The following command only replaces the second line.

```bash
sed '2 s/linux/ubuntu/ig' sed.txt
```

**Output:**
```bash
Linux is an OS. Linux is life. Linux is a concept.
I like ubuntu. You like ubuntu. Everyone likes ubuntu.
Linux is free. Linux is good. Linux is hope.
```

## Part 2 - awk command

- Awk is a text pattern scanning and processing language, created by Aho, Weinberger & Kernighan (hence
the name). It searches one or more files to see if they contain lines that matches with the specified patterns and then performs the associated actions. 

- While the sed program works well with character-based processing, the awk program works well with delimited field processing.

- Create a file named `awk.txt`. 

```txt
This is line 1
This is line 2
This is line 3
This is line 4
This is line 5
```

### Syntax of awk command

> awk options 'selection _criteria {action }' file

- By default Awk prints every line of data from the specified file.

```bash
awk '{print}' awk.txt
```

**Output:**
```bash
This is line 1
This is line 2
This is line 3
This is line 4
This is line 5
```

### Print the lines which matches with the given pattern

```bash
awk '/This/ {print}' awk.txt
```

**Output:**
```bash
This is line 1
This is line 2
This is line 3
This is line 4
This is line 5
```

### Splitting a Line Into Fields

By default, the awk command splits the record delimited by a whitespace character.  Awk assigns some variables for each data field as below:

$0 for the whole line.
$1 for the first field.
$2 for the second field.
$n for the nth field.

```bash
awk '{print $2}' awk.txt
```

**Output:**
```bash
This is line 1
This is line 2
This is line 3
This is line 4
This is line 5
```

We can display more field. The example below only display two field.

```bash
awk '{print $2,$4}' awk.txt
```

**Output:**
```bash
is 1
is 2
is 3
is 4
is 5
```

- We can change delimiter by using –F option. First, update the awk.txt as below.

```txt
This is part 1 of line 1 : This is part 2 of line 1
This is part 1 of line 2 : This is part 2 of line 2
This is part 1 of line 3 : This is part 2 of line 3
This is part 1 of line 4 : This is part 2 of line 4
This is part 1 of line 5 : This is part 2 of line 5
```

- Let's separate the fields by `:`.

```bash
awk -F: '{print $2}' awk.txt
```

**Output:**
```bash
 This is part 2 of line 1
 This is part 2 of line 2
 This is part 2 of line 3
 This is part 2 of line 4
 This is part 2 of line 5
```

- We can use awk command as filter. 

```bash
ls -l | awk '{print $9}'
```

**Output:**
```bash
awk.txt
sed.txt
```

- We can find any string in any specific column. 

```bash
awk '{ if($7 == "3") print $0;}' awk.txt
```

**Output:**
```bash
This is part 1 of line 3 : This is part 2 of line 3
```