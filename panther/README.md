# Puma Prey Panther

Panther is a Node.js function that can be deployed to the AWS to establish a TCP reverse shell for the purposes of introspecting the Lambda container runtime.

## Serverless AWS NodeJS Template

Creating the original function template using the serverless framework.

```bash
cd src
serverless create --template aws-nodejs --path panther
```

## Exploring Further

Refer to [Serverless Docs](https://serverless.com/framework/docs/providers/aws/) for more information.
