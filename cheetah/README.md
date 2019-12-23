# Puma Prey Cheetah

Cheetah is a Go function running in GCP with vulnerabilities such as command injection, local file inclusion, and path traversal.

## Serverless Go Template

Creating the original function template using the serverless framework.

```bash
cd src
serverless create --template google-go --path cheetah
```

## Exploring Further

Refer to [Serverless Docs](https://serverless.com/framework/docs/providers/google/) for more information.
