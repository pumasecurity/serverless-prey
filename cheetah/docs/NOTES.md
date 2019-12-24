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
total 165
drwxr-xr-x 2 root root      0 Dec 24 18:28 .
drwxr-xr-x 2 root root      0 Dec 24 18:28 ..
-rw-r--r-- 1 root root    252 Dec 24 18:28 Makefile
-rw-r--r-- 1 root root   1688 Dec 24 18:28 cheetah.go
-rw------- 1 root root     24 Dec 24 18:28 go.mod
drwxr-xr-x 2 root root      0 Dec 24 18:28 node_modules
-rw-r--r-- 1 root root 166598 Dec 24 18:28 package-lock.json
-rw-r--r-- 1 root root    907 Dec 24 18:28 package.json

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

The supervisor service is definitely going to be a point of interest:

```
curl 169.254.8.129:8081
404 page not found
```