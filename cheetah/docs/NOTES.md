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

ls -al
total 2
drwxr-xr-x 2 root root    0 Dec 24 04:51 .
drwxr-xr-x 2 root root    0 Dec 24 04:51 ..
-rw-r--r-- 1 root root 1685 Dec 24 04:51 function.go
-rw-r--r-- 1 root root   33 Dec 24 04:51 go.mod

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
env
FUNCTION_IDENTITY=brandonevans@appspot.gserviceaccount.com
DEBIAN_FRONTEND=noninteractive
X_GOOGLE_WORKER_PORT=8091
X_GOOGLE_SUPERVISOR_INTERNAL_PORT=8081
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
X_GOOGLE_GCLOUD_PROJECT=brandonevans
GCP_PROJECT=brandonevans
FUNCTION_REGION=us-central1
X_GOOGLE_FUNCTION_NAME=reverseShell
ENTRY_POINT=HelloWorld
PWD=/srv/files/
X_GOOGLE_GCP_PROJECT=brandonevans
NODE_ENV=production
HOME=/root
FUNCTION_NAME=reverseShell
X_GOOGLE_FUNCTION_TRIGGER_TYPE=HTTP_TRIGGER
GCLOUD_PROJECT=brandonevans
X_GOOGLE_FUNCTION_IDENTITY=brandonevans@appspot.gserviceaccount.com
X_GOOGLE_FUNCTION_MEMORY_MB=256
FUNCTION_TIMEOUT_SEC=60
X_GOOGLE_FUNCTION_REGION=us-central1
CODE_LOCATION=/srv
PORT=8080
X_GOOGLE_ENTRY_POINT=HelloWorld
X_GOOGLE_CODE_LOCATION=/srv
X_GOOGLE_LOAD_ON_START=false
X_GOOGLE_FUNCTION_VERSION=28
X_GOOGLE_SUPERVISOR_HOSTNAME=169.254.8.129
FUNCTION_TRIGGER_TYPE=HTTP_TRIGGER
X_GOOGLE_CONTAINER_LOGGING_ENABLED=true
WORKER_PORT=8091
SUPERVISOR_HOSTNAME=169.254.8.129
SUPERVISOR_INTERNAL_PORT=8081
X_GOOGLE_FUNCTION_TIMEOUT_SEC=60
FUNCTION_MEMORY_MB=256
```

The supervisor service is definitely going to be a point of interest:

```
curl 169.254.8.129:8081
404 page not found
```