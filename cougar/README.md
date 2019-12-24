# Puma Prey Cougar

Cougar is an Azure function written in C# with vulnerabilities such as command injection, local file inclusion, and path traversal. Using these vulnerabilities, we can inspect the execution environment, extract access keys, test persistence in warn environments, and more.

## Install Azure Functions Core Tools

Details here: [https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)

## Creating The Function

```bash
func init Cougar --csharp --dotnet
func new --template "HTTP trigger" --name GetCougar
```

## Running Locally

```bash
func start --build
```

## Testing Locally

```bash
curl --request POST http://localhost:7071/api/cougar --data '{"name":"Puma Rocks"}'
```

## Infrastructure

Requires the Function, App Service Plan, App Insights, and Storage Account to be created. TODO: TF all the things.

```bash
az ad sp create-for-rbac -n "PumaPreyCougar"
```

## Deploying the Function

```bash
func azure functionapp publish pumapreycougar
```

Manually configure the function to run under the SP created above. TODO: TF all the things.

## Testing in Azure

Using the Invoke URL returned from the publish command above:

```bash
curl "<INSERT INVOKE URL>&ip=[ip-address]&port=[port]"
```

## Destroying The Stack

```bash
az group delete --name pumaprey-cougar
```