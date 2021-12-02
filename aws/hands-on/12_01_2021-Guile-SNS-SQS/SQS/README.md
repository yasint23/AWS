# SQS Hands-on

## Part 1 - Creating Queue, Sending and Receiving Messages

### Step 1 : Create Queue

- Go to `SQS` service on AWS console.

- Click `Create queue`.

- `Details`.
    - Type: Standart (Keep default)
    - Name: My-First-Queue

- Talk about Configuration, Access policy and Dead-letter queue (Keep default)

- Keep rest default.

- Click `Create queue`.

### Step 2 : Send Message

- On My-First-Queue page Click `Send and receive messages`.

- `Send message`.
    - Message body: "This is the first message for sqs."

- Keep rest default.

- Click `Send message`.

- Show `Receive messages` >> `Messages available` = 1.

### Step 3 : Poll for Messages

- Click `Poll for messages` under `Receive messages`.

- Click on the polled message under `Messages`.

- Show the message.

- Click `Done`.

- Select the polled message and click `Delete` and delete the message.


### Step 4 : Populate Queue

- Do the Step 2 again with 3 messages.

- Send 3 new messages consecutively to the queue ("This is the 2nd/3rd/4th message for sqs.")

- Show the messages in the queue.

- Do the Step 3 again and poll the messages.

- Delete the messages in the queue.

## Part 2 - Creating Lambda Function to Be Triggered by SQS

### Step 1 : Create Lambda Function

- Go to `Lambda` service on AWS console.

- Click `Create function`.

- Select `Use a blueprint`.

- Search `sqs` in the the blueprints search bar.

- Select `sqs-poller` and click `Configure`.

- `Basic information`
    - Function name : sqs-poller
    - Execution role : Create a new role from AWS policy templates (Keep default)
    - Role name : sqs-poller-role
    - Policy templates : Keep the default "Amazon SQS poller permissions"

- `SQS trigger`
    - SQS queue : My-First-Queue

- Keep rest default.

- Click `Create function`.

- Click `Configuration` tab under `sqs-poller` function.

- Select `SQS: My-First-Queue` and click `Enable` to enable trigger.(Wait for it to be "Enabled")

### Step 2 : Send Message to Invoke Lambda

- Go back to `SQS` service on AWS console.

- Send a new message like "This message is sent from sqs to trigger lambda" to the `My-First-Queue`.

- Show there is no message since it has been polled by lambda.

### Step 3 : Check Logs

- Go back to `CloudWatch` service on AWS console.

- From left-hand menu `Logs` >> `Log groups`

- Click on `/aws/lambda/sqs-poller`

- Click on the log stream and show the message sent from sqs and processed by lambda.

- Delete/terminate the resources created.
