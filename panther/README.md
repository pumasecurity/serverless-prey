# Puma Prey Panther

Panther is a Node.js function that can be deployed to the AWS to establish a TCP reverse shell for the purposes of introspecting the Lambda container runtime.

## Installing Prerequisites

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [Node.js / NPM](https://nodejs.org/en/download/)
* [Serverless Framework](https://serverless.com/framework/docs/providers/aws/guide/installation#installing-the-serverless-framework)

## Getting Started

```
cd /PATH/TO/panther
aws configure
npm install
serverless deploy
```

Record the API key provided in the output:

```
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

## Usage

Set up a TCP listener for your reverse shell, such as with [Netcat](http://netcat.sourceforge.net/):

```
nc -l 4444
```

To make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```
ngrok tcp 4444
```

Navigate to your function, supplying your connection details and API key:

```
curl 'https://YOUR_API_GATEWAY_ID.execute-api.us-east-1.amazonaws.com/dev/panther?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER' -H "X-API-Key: YOUR_API_KEY"
```

Your listener will now act as a reverse shell for the duration of the function invocation. You can adjust the function timeout in the serverless.yml file, though it cannot be extended past 30 seconds as it is attached to an API Gateway.

## Teardown

```
serverless remove
```

## Linting

```
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
