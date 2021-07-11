# Site Down Notifier

Function to periodically check that my websites are up, and sends me a text-message if not.

I have a couple small websites (eg [havewemadeagiyet.com](https://www.havewemadeagiyet.com) and [tomhenighan.com](https://tomhenighan.com)). Recently one of them went down for a silly reason and I didn't realize for a while. If that happens again, this should send me a text message so I can fix it.

This is meant to be simple, and doesnt check latency or global availability.

I'm sure there are much better off-the-shelf tools I could have used here instead. But I deicded to use this as an opportunity to play with terraform.

## How it Works

This uses a [lambda function](https://aws.amazon.com/lambda/) which makes get-requests to my websites and asserts that the returncode is 200. If not, it uses [SNS](https://aws.amazon.com/sns/) to notify me via text. The lambda function is triggered every 24 hours using [eventbridge](https://aws.amazon.com/eventbridge/). Most of the cloud infra is managed using [terraform](https://www.terraform.io/), though I had to set up a few SNS things via the aws console.

## Steps to Reproduce

### 0. Prerequisites
You will need:

a. An aws account

b. Terraform installed with admin priviliges on your aws account (including the ability to create iam roles and policies).

### 1. Purchase origination Phone Number
To be able to text my US number, I needed to purchase an [origination phone number](https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-originating-identities.html). I went [here](https://console.aws.amazon.com/pinpoint/home?region=us-east-1#/sms-account-settings/requestLongCode) on the pinpoint console and purchased a transactional, toll-free, sms-only phone number. This annoyingly costs $2/month.

Because of the above cost, I also tried using aws SES instead, but all the emails I sent to myself went straight to spam (unsurprising). This was also a sub-optimal solution for me because I rarely check email.

### 2. Add Phone Number
In the aws console, navigate to SNS->"SMS and voice" in the SNS [here](https://console.aws.amazon.com/pinpoint/home?region=us-east-1#/sms-account-settings) and add your number to the destination phone numbers. Follow the steps to verify it.

Note I'm keeping my account in the "SMS Sandbox", as I have no need for sending notifications to anyone but myself.

### 3. Edit lambda_script.py to check _your_ websites
Find the following list of urls and replace with the urls you'd like to check:
```python
    urls_to_check = [
        "https://tomhenighan.com",
        "https://www.tomhenighan.com",
        ...
```

### 4. Zip python code and dependencies to run on lambda
```bash
./update_zip.sh
```
This will install the required python packages (listed in [requirements.txt](./requirements.txt)) to a "packages" folder and zip that together with [./lambda_script.py](./lambda_script.py). We will upload this zip to the lambda function.

### 5. Initialize Terraform
```bash
terraform init
```
(must be run inside this directory)

### 6. Deploy with Terraform
```bash
terraform apply -var 'PHONE_NUMBER=12223334444'
```
(also must be run inside this directory)
Replace `12223334444` with your phone number, including country code (ie for US numbers should start with a `1`, then area code, etc).
Terraform will display the resources to be created and ask for confirmation.
