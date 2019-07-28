<!--

title: 'AWS Serverless REST API with DynamoDB 

description: 'This example demonstrates how to create and run a REST API in AWS using lambda to manage the Post/Get stored in DynamoDB.
authorLink: 'https://github.com/fbcjunior'
Name: 'Franklin Correa'

-->

# Build a Serverless Web Application

I'm using an API to expose a lambda function, this example demonstrates how to create an RestAPi, AWS lambda and DynamoDB. to control POST and GET requests by username.
This example demonstrates how to create and run a REST API in AWS using lambda to manage the Post/Get stored in DynamoDB.

HTTP POST requests supply additional data from the client (browser) to the server in the message body.
GET requests include all required data in the URL by username

## Dependencies

1) Nodejs and (https://nodejs.org/en/) *
2) Serverless framework. (https://serverless.com/) *
3) AWS account. (https://aws.amazon.com/)

*Automatic installation

## Setup
1) Clone this repository localy
2) Update the Deploy.ps1 script and add your AWS credentials
3) Run: Deploy.ps1 (run as Administrator)

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/awskey.jpg)

**You can follow the install progression of the new stack in your AWS Cloud Formation - Ireland (West-eu-02) Region**

After the installation the output of the script will print the endpoints that can be used with postman.

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/scriptoputput.jpg)

## Usage
### Create POST

You can download postman here: https://www.getpostman.com/downloads/

1) type the endpoint address
2) select Body and type { "username": "USERNAME" }
3) click on send button
4) Output

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/post.jpg)

### Create GET

1) type the endpoint address and username
2) click on send button
3) Output

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/Get.jpg)


## Downtime Information

The AWS team recently introduced traffic shifting for Lambda function aliases, which basically means that we can now split the traffic of our functions between two different versions. 
We just have to specify the percentage of incoming traffic we want to direct to the new release, and Lambda will automatically load balance requests between versions when we invoke the alias.

Traffic is shifted gradually to the new version and the provided CloudWatch alarms are monitored, canceling and rolling back if any of them is triggered.

So, instead of completely replacing our function for another version, we could take a more conservative approach making the new code coexist with the old stable one and checking how it performs.

CodeDeploy is capable of automatically updating our functions' aliases weights according to our preferences. Even better, it will also roll back automatically if it notices that something goes wrong.

Basically, our Lambda function deployments will be on autopilot.

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/trafficlambda.jpg)


### Configuration:

#### the type of shifiting ting can be changed in the file serverless.yml, by default the script is configured to use the opction **AllAtOnce** 
further information: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/automating-updates-to-serverless-apps.html

#### type: (required) defines how the traffic will be shifted between Lambda function versions. It must be one of the following:

![alt text](https://github.com/fbcjunior/devopscode/blob/master/Images/LambdaUpdate.jpg)


## How To remove the AWS stack
run: serverless remove

## Invoke Lambda function:
serverless invoke -f listRequests