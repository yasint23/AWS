# SNS Hands-on

## Part 1 - Creating Topic, Subscription and Publishing Message

### Step 1 : Create Topic

- Go to `SNS` service on AWS console.

- Click `Topics` >> `Create topic`.

- `Details`.
    - Type: Standart
    - Name: Demo-topic
    - Display Name: My-First-Topic

- Keep rest default.

- Click `Create`.

### Step 2 : Create Subscription

- On Demo-topic page Click `Create subscription`.

- `Details`.
    - Topic ARN: arn:aws:sns:us-east-1:046402772087:Demo-topic (comes default)
    - Protocol: Email
    - Endpoint: test@example.com (your mail here)

- Keep rest default.

- Click `Create subscription`.

- Show `Status` >> `Pending Confirmation`.

### Step 3 : Confirm subscription

- Go to your mail and check inbox.

- Open mail from `My-First-Topic`.

- Click `Confirm subscription`.

- Go back to Demo-topic subscription and refresh the page.

- Show `Status` >> `Confirmed`.

### Step 4 : Publish message

- Select `Topics` from the left-hand menu and click on `Demo-topic`.

- Click `Publish message`.

- `Message details`.
    - Subject: sns-test
    - Time to Live (TTL) : -

- `Message body`.
    - Message structure: Identical payload for all delivery protocols.
    - "This is a test message for sns inclass session".

- Keep rest default.

- Click `Publish message`.

- Go to your mail and check inbox.

- Open mail from `My-First-Topic`.

- Show the topic and the test message sent from SNS.

## Part 2 - Creating a CloudWatch Event (Amazon EventBridge) to Invoke SNS 

### Step 1 : Create Rule

- Go to `Amazon EventBridge` service on AWS console.

- Click `Rules` >> `Create Rule` from the left-hand menu.

- `Name and description`
    - Name : EC2StateChange
    - Description : -

- `Define pattern`
    - Event Pattern
    - Pre-defined pattern by service
    - Service provider: AWS
    - Service Name : EC2
    - Event Type : EC2 Instance State-change Notification
    - Any state
    - Any instance

- `Select Targets`
    - Target: SNS topic
    - Topic : Demo-topic
    
- Keep rest default.

- Click `Create`.

### Step 2 : Invoke SNS

- Go to `EC2` service on AWS console.

- Change state of any available instance like starting a stopped one (Launch a new one if you don't have any).

- Go to your mail and check inbox.

- Open mail from `My-First-Topic`.

- Show the topics and the messages sent from SNS.

- Delete/terminate the resources created.
