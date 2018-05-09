# Terraform Monitor Notify AWS Root login
How to Monitor and Notify on AWS Account Root User login using Terraform

We assume you have already enable AWS CloudTrail and you want to receive an email notification if the root account login.

## Steps
* download and install terraform https://www.terraform.io/downloads.html
* export your access/secret keys variables 
```
export AWS_ACCESS_KEY_ID=xxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxx
export AWS_REGION=us-east-1
```
* git clone this repo
```
git clone  https://github.com/giuseppeborgese/Terraform-Monitor-Notify-AWS-Root-login.git
```
* edit the vars.tf putting your email and eventually change the region
* run terraform
```
terraform init 
terraform plan -out /tmp/tf11.out
terraform apply /tmp/tf11.out
```
* confirm your subscripting click on the link in your email
* connect your CloudTrail to the objects created with terraform, watch the youtube video in this page to see how to do it
* login as root in your AWS account 
* wait 5/25 minutes and you can receive the notification

## Schema of the terraform objects 
![terraform object schema](/images/no-root-login.jpg)

## Video tutorial

[![How to Monitor and Notify on AWS Account Root User login using Terraform](https://img.youtube.com/vi/cNtZWdxqhRc/0.jpg)](https://youtu.be/cNtZWdxqhRc)

## Useful resources around this topic
* [Similar template in CloudFormation for CloudTrail Alarms](https://gist.github.com/rjsamson/c0875ef1410cb84fcfa5)
* [Bypassing CloudTrail and CloudWatch monitoring of AWS API](https://mysteriouscode.io/blog/bypassing-cloudtrail-and-cloudwatch-monitoring-of-aws-api/) 
* [AWS official Documentation about this topic](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail.html#cloudwatch-alarms-for-cloudtrail-iam-policy-changes)
