# Hands-on S3-01 : Basic Operations, S3 Website Hosting and Versioning

Purpose of the this hands-on training is to instruct students how to to create a S3 bucket, how to configure S3 to host static website and to give understanding to versioning and logging.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create a S3 bucket,

- upload and customize files to S3 bucket,

- deploy static Website on S3,

- set the S3 bucket policies,

- configure S3 bucket with versioning options,

- monitor logging records,


## Outline

- Part 1 - S3 Bucket Basic Operations

- Part 2 - Creating a new Bucket for Static Website

- Part 3 - Creating S3 Bucket with Versioning


## Part 1 - S3 Bucket Basic Operations

- Open S3 Service from AWS Management Console.

- Create 2 bucket with following properties, 

```text
Bucket name                 : myfirstbucket-osvaldo-01(instead of "osvaldo", students use their own    
                              clarusway student number)
Region                      : N.Virginia
Block all public access     : Checked (KEEP BlOCKED)
Versioning                  : Disabled
Tagging                     : 0 Tags
Default encryption          : None
Object-level logging        : Disabled

```

- Explain;

  - Naming convention (unique, global),

  - Why we choose region,

  - Redundancy,

  - Availability.

- Upload `index.html` and `cat.jpg`files to the bucket with default values.

- Show the file details.

- Open the file URL in the browser and show that it is not accessible.

- Try to make the object public, face with `Error Access denied`.

- Open the bucket permissions, change it to public.

```
PERMISSIONS >> BLOCK PUBLIC ACCESS>>>> EDIT>>> UNCHECKED 
```
- Select the file uploaded and make it "Public Also."

- Open the file URL in the browser, show it is accessible now.

- Create a folder named it as 'images', explain why a folder is also called as prefix in S3

- Upload `cat1.jpg` file under `images` folder with `drag and drop`.

- Open the file URL in the browser and show that it is "Not Accessible."

- Select the file uploaded and make it "Public Also".

- Open the file URL in the browser, show it is accessible now.

- Upload `cat2.jpg` and `cat3.jpg` files under `myfirstbucket-osvaldo-01` bucket.

- Show how to use `move` function to transfer data under `images` folder.

```text
move ---> cat1.jpg
```

- Show how to delete `cat2.jpg`.

```text
delete ---> cat2.jpg
```

- Show how to rename `cat3.jpg` file.

```text
rename cat3.jpg as cat_renamed.jpg
```

- Show how to delete the `images` folder,

```text
delete ---> images
```

- Show that it is deleted even if there are objects in folder.

- Upload a file into the S3 Bucket (without drag and drop) and navigate to advanced step `Set permissions` part and explain the storage classes (S3 Standard, Standard IA, Glacier: 3 AZs, Durability 11/9)

## Part 2 - Creating a new Bucket for Static Website

- Create a new bucket for static website with name of `pet.clarusway.static.web.hosting` and with following properties

```text
Bucket name                 : pet.clarusway.static.web.hosting
Region                      : N.Virginia
Block all public access     : Checked (KEEP BlOCKED)
Versioning                  : ENABLED****
Tagging                     : 0 Tags
Default encryption          : None
Object-level logging        : Disabled
```

- Click the S3 bucket `pet.clarusway.static.web.hosting` and upload following files.

```text
index.html
cat.jpg
```

- Show static website hosting settings from properties of `pet.clarusway.static.web.hosting` bucket.

```
PROPERTIES>>>>> STATIC WEBSITE HOSTING
```

- Click static web hosting and put check mark to `Use this bucket to host a website` and enter `index.html` as default file.

- Copy endpoint and show that the website is Not Accessible.

-  Change the bucket Public Access status from CHECKED(BLOCKED) to UNCHECKED(PUBLIC).

```
PERMISSIONS >> BLOCK PUBLIC ACCESS>>>> EDIT>>> UNCHECKED 
```
- Set the static website bucket policy as shown below (PERMISSIONS >> BUCKET POLICY) and change `bucket-name`  with your own bucket.

!!!! Use the `aws-s3-static-website-policy.json` file not from the script seen below. You may get a indentation failure.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::don't forget to change me/*"
        }
    ]
}
```

- Open static website URL in browser and show its working.

- Create folder called `kitten` under the bucket named `pet.clarusway.static.web.hosting`.

- Move the `index.html` and `cat.jpg` into the `kitten` folder. 

- Open static website URL in browser again, show it's not working at with default URL and facing with `404 Not Found`

- Add path `kitten` to the end of URL to show the content without file name.

```text
http://.......amazonaws.com/kitten/
```

- Rename the `index.html` under `kitten` folder as `cutest.html`.

- Open static website URL in browser again with path `kitten` added, show it's not working as with default `index.html`, facing with `404 Not Found`

- Go to properties >> static web hosting and change the index.html to cutest.html.

```text
index.html ---> cutest.html
```

- Copy the endpoint and paste it web browser with `kitten` path at the end of URL to show the content.

```text
http://.......amazonaws.com/kitten/
```

## Part 3 - Creating S3 Bucket with Versioning

- Create a new bucket named `pet.clarusway.versioning` with following properties.

```text
Bucket name                 : pet.clarusway.versioning
Region                      : N.Virginia
Block all public access     : UNCHECKED(PUBLIC)*****
Versioning                  : ENABLED****
Tagging                     : 0 Tags
Default encryption          : None
Object-level logging        : Disabled

```

- Click the S3 bucket `pet.clarusway.versioning` and upload following files.

```text
index.html
cat.jpg
```

- Show static website hosting settings from properties of `pet.clarusway.versioning` bucket.
```
PROPERTIES>>>>> STATIC WEBSITE HOSTING
```
- Click static web hosting and put check mark to `Use this bucket to host a website` and enter `index.html` as default file.

- Set the static website bucket policy as shown below (PERMISSIONS >> BUCKET POLICY) and change `bucket-name`  with your own bucket.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::don't forget to change me/*"
        }
    ]
}
```

- Open static website URL in browser and show its working.

- Show versioning of the files right under the bucket `pet.clarusway.versioning`

- Delete `index.html`.

- Turn the version option `ON` from `List version` tab.

- Show the `index.html` file is still in the bucket.

- Show the `delete marker` below the `index.html` file.

- Delete `delete markers` of the index.html and show that they are available again.

- Open `index.html` from local with VS Code and change the statement as shown below.

```text
<center><h1> My Cute Cat Origin</h1><center>
    |             |              |
    |             |              |
    |             |              |
    V             V              V
<center><h1> My Cute Cat Version 1</h1><center>
```

- Upload a new version of the `index.html`.

- Turn the version option `ON` from `List version` tab and see two versions of `index.html`.

- Open static website URL in browser again, observe that it is showing the new content (Version 1).

- Again open `index.html` from local with VS Code and change statement as shown below.

```text
<center><h1> My Cute Cat Version 1</h1><center>
    |             |              |
    |             |              |
    |             |              |
    V             V              V
<center><h1> My Cute Cat Version 2</h1><center>
```

- Upload the newest version of `index.html` to the bucket.

- Turn the version option `ON` from `List version` tab  and see three versions of `index.html`.

- Open static website URL in browser again, observe that it is showing the new content (Version 2).

- Show versioning of the index.html, and delete the latest version.

- Open static website URL in browser again, observe that it is showing the "Version 1" content.
