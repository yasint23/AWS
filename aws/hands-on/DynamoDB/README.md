## Part 1 - Creating DynamoDB Tables

### Step 1 : Create Product Catalog Table

- Go to `DynamoDB` service on AWS console.

- Click `Create Table`. 

- Set table name as `ProductCatalog`.

- Set Partition Key as `Id` and select the type of key as `Number`. No Sort Key.

- Leave other settings default.

- Click `Create`.

### Step 2 : Create Forum Table

- Click `Create Table`.

- Set table name as `Forum`.

- Set Partition Key as `Name` and select the type of key as `String`. No Sort Key.

- Leave other settings default.

- Click `Create`.

### Step 3 : Create Thread Table

- Click `Create Table`.

- Set table name as `Thread`.

- Set Partition Key as `ForumName` and select the type of primary key as `String`.

- Set Sort Key as `Subject` and select the type of sort key as `String`.

- Leave other settings default.

- Click `Create`.

### Step 4 : Create Reply Table

- Click `Create Table`.

- Set table name as `Reply`.

- Set Partition Key as `Id` and select the type of primary key as `String`.

- Set sort key as `ReplyDateTime` and select the type of sort key as `String`.

- Select `Customize settings` under `Settings` pane.

- Click `Create global index` under `Secondary Indexes`.

  - Set Partition Key as `PostedBy` and select the type of primary key as `String`.

  - Set sort key as `Message` and select the type of sort key as `String`.

  - Leave the index name as `PostedBy-Message-Index` which is automatically created.

  - Leave the projected attributes as `All`.

  - Click `Create index`.

- Keep all the rest of settings as default.

- Click `Create`.

## Part 2 - Manipulating DynamoDB Database

- Create a folder in your local working directory, name it as `dynamodb` and cd in it.

```bash
mkdir dynamodb
cd dynamodb
```

- Go to [Amazon DynamoDB Load Data into Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SampleData.LoadData.html) and download `sampledata.zip` file to the local with `wget` command.

```bash
wget https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/samples/sampledata.zip
```

- Unzip `sampledata.zip` file into the `dynamodb` folder.There should be four unzipped files.

```bash
unzip sampledata.zip
```

- Upload sample data into the DynamoDB tables;

  - Populate the `ProductCatalog` table with data using AWS CLI.

  ```bash
  aws dynamodb batch-write-item --request-items file://ProductCatalog.json
  ```

  - Populate the `Forum` table with data using AWS CLI.

  ```bash
  aws dynamodb batch-write-item --request-items file://Forum.json
  ```

  - Populate the `Thread` table with data using AWS CLI.

  ```bash
  aws dynamodb batch-write-item --request-items file://Thread.json
  ```

  - Populate the `Reply` table with data using AWS CLI.

  ```bash
  aws dynamodb batch-write-item --request-items file://Reply.json
  ```

- Verify that data is uploaded into the tables from the AWS Management Console;

  - Open the `DynamoDB` console.

  - Choose tables in the navigation pane.

  - Select `ProductCatalog` from the list of tables.

  - Click on the `View Items` button to view the data in the table.

  - To see the detail of an item in the table, Click `Id` of it. (If you want, you can also edit the item.)

  - Repeat this process for each of the tables you have created: `Forum`, `Thread`, `Reply`.

## Part 3 - Running Queries on DynamoDB Tables

- In this part, we will run simple queries against the tables, using the Amazon DynamoDB console.

- Open the `DynamoDB` console.

- Choose tables in the navigation pane.

- Select `Reply` from the list of tables.

- Click on the `View Items` button to view the data in the table.

- In the data filtering pane, do the followings:

  - Change the operation from `Scan` to `Query`.

  - For the Partition key, enter `Amazon DynamoDB#DynamoDB Thread 1` as the value.

  - Click `Run`. (Only the items that match your query criteria are returned from the `Reply` table)

- The `Reply` table has a global secondary index on the `PostedBy` and `Message` attributes. You can execute queries on the secondary index by doing the followings:

  - Change the query source from `Reply` to `PostedBy-Message-Index`

  - For the Partition key, enter `User A` as the value.

  - Click `Run`. (Only the items that match your query criteria are returned from the `PostedBy-Message-Index`)

- Take some time to explore other tables using the `DynamoDB` console: `ProductCatalog`, `Forum`, `Thread`.