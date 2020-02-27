# Azure Execution Environment

Running under a premium Azure function (always on - no cold starts). No SP in this run.

## Execution Environment

The default execution environment recon:

```
pwd
/
```

```
whoami
root
```

```
ps
   PID TTY          TIME CMD
     1 ?        00:00:00 bash
    18 ?        00:00:00 sshd
    19 ?        00:00:06 Microsoft.Azure
    65 ?        00:00:00 bash
    70 ?        00:00:00 ps
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
ls azure	
ls /azure-functions-host
Autofac.dll
Google.Protobuf.dll
Grpc.Core.Api.dll
Grpc.Core.dll
Microsoft.AI.DependencyCollector.dll
Microsoft.AI.EventCounterCollector.dll
Microsoft.AI.PerfCounterCollector.dll
Microsoft.AI.ServerTelemetryChannel.dll
Microsoft.AI.WindowsServer.dll
Microsoft.ApplicationInsights.AspNetCore.dll
Microsoft.ApplicationInsights.SnapshotCollector.dll
Microsoft.ApplicationInsights.dll
Microsoft.AspNetCore.Antiforgery.dll
Microsoft.AspNetCore.Authentication.Abstractions.dll
Microsoft.AspNetCore.Authentication.Cookies.dll
Microsoft.AspNetCore.Authentication.Core.dll
Microsoft.AspNetCore.Authentication.Facebook.dll
Microsoft.AspNetCore.Authentication.Google.dll
Microsoft.AspNetCore.Authentication.JwtBearer.dll
Microsoft.AspNetCore.Authentication.MicrosoftAccount.dll
Microsoft.AspNetCore.Authentication.OAuth.dll
Microsoft.AspNetCore.Authentication.OpenIdConnect.dll
Microsoft.AspNetCore.Authentication.Twitter.dll
Microsoft.AspNetCore.Authentication.WsFederation.dll
Microsoft.AspNetCore.Authentication.dll
Microsoft.AspNetCore.Authorization.Policy.dll
Microsoft.AspNetCore.Authorization.dll
Microsoft.AspNetCore.Connections.Abstractions.dll
Microsoft.AspNetCore.CookiePolicy.dll
Microsoft.AspNetCore.Cors.dll
Microsoft.AspNetCore.Cryptography.Internal.dll
Microsoft.AspNetCore.Cryptography.KeyDerivation.dll
Microsoft.AspNetCore.DataProtection.Abstractions.dll
Microsoft.AspNetCore.DataProtection.Extensions.dll
Microsoft.AspNetCore.DataProtection.dll
Microsoft.AspNetCore.Diagnostics.Abstractions.dll
Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore.dll
Microsoft.AspNetCore.Diagnostics.HealthChecks.dll
Microsoft.AspNetCore.Diagnostics.dll
Microsoft.AspNetCore.HostFiltering.dll
Microsoft.AspNetCore.Hosting.Abstractions.dll
Microsoft.AspNetCore.Hosting.Server.Abstractions.dll
Microsoft.AspNetCore.Hosting.dll
Microsoft.AspNetCore.Html.Abstractions.dll
Microsoft.AspNetCore.Http.Abstractions.dll
Microsoft.AspNetCore.Http.Connections.Common.dll
Microsoft.AspNetCore.Http.Connections.dll
Microsoft.AspNetCore.Http.Extensions.dll
Microsoft.AspNetCore.Http.Features.dll
Microsoft.AspNetCore.Http.dll
Microsoft.AspNetCore.HttpOverrides.dll
Microsoft.AspNetCore.HttpsPolicy.dll
Microsoft.AspNetCore.Identity.EntityFrameworkCore.dll
Microsoft.AspNetCore.Identity.UI.Views.V3.dll
Microsoft.AspNetCore.Identity.UI.Views.V4.dll
Microsoft.AspNetCore.Identity.UI.dll
Microsoft.AspNetCore.Identity.dll
Microsoft.AspNetCore.JsonPatch.dll
Microsoft.AspNetCore.Localization.Routing.dll
Microsoft.AspNetCore.Localization.dll
Microsoft.AspNetCore.MiddlewareAnalysis.dll
Microsoft.AspNetCore.Mvc.Abstractions.dll
Microsoft.AspNetCore.Mvc.ApiExplorer.dll
Microsoft.AspNetCore.Mvc.Core.dll
Microsoft.AspNetCore.Mvc.Cors.dll
Microsoft.AspNetCore.Mvc.DataAnnotations.dll
Microsoft.AspNetCore.Mvc.Formatters.Json.dll
Microsoft.AspNetCore.Mvc.Formatters.Xml.dll
Microsoft.AspNetCore.Mvc.Localization.dll
Microsoft.AspNetCore.Mvc.Razor.Extensions.dll
Microsoft.AspNetCore.Mvc.Razor.dll
Microsoft.AspNetCore.Mvc.RazorPages.dll
Microsoft.AspNetCore.Mvc.TagHelpers.dll
Microsoft.AspNetCore.Mvc.ViewFeatures.dll
Microsoft.AspNetCore.Mvc.WebApiCompatShim.dll
Microsoft.AspNetCore.Mvc.dll
Microsoft.AspNetCore.NodeServices.dll
Microsoft.AspNetCore.Owin.dll
Microsoft.AspNetCore.Razor.Language.dll
Microsoft.AspNetCore.Razor.Runtime.dll
Microsoft.AspNetCore.Razor.dll
Microsoft.AspNetCore.ResponseCaching.Abstractions.dll
Microsoft.AspNetCore.ResponseCaching.dll
Microsoft.AspNetCore.ResponseCompression.dll
Microsoft.AspNetCore.Rewrite.dll
Microsoft.AspNetCore.Routing.Abstractions.dll
Microsoft.AspNetCore.Routing.dll
Microsoft.AspNetCore.Server.HttpSys.dll
Microsoft.AspNetCore.Server.IIS.dll
Microsoft.AspNetCore.Server.IISIntegration.dll
Microsoft.AspNetCore.Server.Kestrel.Core.dll
Microsoft.AspNetCore.Server.Kestrel.Https.dll
Microsoft.AspNetCore.Server.Kestrel.Transport.Abstractions.dll
Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets.dll
Microsoft.AspNetCore.Server.Kestrel.dll
Microsoft.AspNetCore.Session.dll
Microsoft.AspNetCore.SignalR.Common.dll
Microsoft.AspNetCore.SignalR.Core.dll
Microsoft.AspNetCore.SignalR.Protocols.Json.dll
Microsoft.AspNetCore.SignalR.dll
Microsoft.AspNetCore.SpaServices.Extensions.dll
Microsoft.AspNetCore.SpaServices.dll
Microsoft.AspNetCore.StaticFiles.dll
Microsoft.AspNetCore.WebSockets.dll
Microsoft.AspNetCore.WebUtilities.dll
Microsoft.AspNetCore.dll
Microsoft.Azure.AppService.Proxy.Client.dll
Microsoft.Azure.AppService.Proxy.Common.dll
Microsoft.Azure.AppService.Proxy.Runtime.dll
Microsoft.Azure.KeyVault.WebKey.dll
Microsoft.Azure.KeyVault.dll
Microsoft.Azure.Services.AppAuthentication.dll
Microsoft.Azure.WebJobs.Extensions.Http.dll
Microsoft.Azure.WebJobs.Extensions.dll
Microsoft.Azure.WebJobs.Host.Storage.dll
Microsoft.Azure.WebJobs.Host.dll
Microsoft.Azure.WebJobs.Logging.ApplicationInsights.dll
Microsoft.Azure.WebJobs.Logging.dll
Microsoft.Azure.WebJobs.Script.Grpc.dll
Microsoft.Azure.WebJobs.Script.WebHost
Microsoft.Azure.WebJobs.Script.WebHost.deps.json
Microsoft.Azure.WebJobs.Script.WebHost.dll
Microsoft.Azure.WebJobs.Script.WebHost.runtimeconfig.json
Microsoft.Azure.WebJobs.Script.dll
Microsoft.Azure.WebJobs.Script.dll.config
Microsoft.Azure.WebJobs.dll
Microsoft.Azure.WebSites.DataProtection.dll
Microsoft.Build.Framework.dll
Microsoft.Build.dll
Microsoft.CSharp.dll
Microsoft.CodeAnalysis.CSharp.Scripting.dll
Microsoft.CodeAnalysis.CSharp.Workspaces.dll
Microsoft.CodeAnalysis.CSharp.dll
Microsoft.CodeAnalysis.Razor.dll
Microsoft.CodeAnalysis.Scripting.dll
Microsoft.CodeAnalysis.VisualBasic.Workspaces.dll
Microsoft.CodeAnalysis.VisualBasic.dll
Microsoft.CodeAnalysis.Workspaces.dll
Microsoft.CodeAnalysis.dll
Microsoft.DotNet.PlatformAbstractions.dll
Microsoft.EntityFrameworkCore.Abstractions.dll
Microsoft.EntityFrameworkCore.Design.dll
Microsoft.EntityFrameworkCore.InMemory.dll
Microsoft.EntityFrameworkCore.Relational.dll
Microsoft.EntityFrameworkCore.SqlServer.dll
Microsoft.EntityFrameworkCore.dll
Microsoft.Extensions.Caching.Abstractions.dll
Microsoft.Extensions.Caching.Memory.dll
Microsoft.Extensions.Caching.SqlServer.dll
Microsoft.Extensions.Configuration.Abstractions.dll
Microsoft.Extensions.Configuration.Binder.dll
Microsoft.Extensions.Configuration.CommandLine.dll
Microsoft.Extensions.Configuration.EnvironmentVariables.dll
Microsoft.Extensions.Configuration.FileExtensions.dll
Microsoft.Extensions.Configuration.Ini.dll
Microsoft.Extensions.Configuration.Json.dll
Microsoft.Extensions.Configuration.KeyPerFile.dll
Microsoft.Extensions.Configuration.UserSecrets.dll
Microsoft.Extensions.Configuration.Xml.dll
Microsoft.Extensions.Configuration.dll
Microsoft.Extensions.DependencyInjection.Abstractions.dll
Microsoft.Extensions.DependencyInjection.dll
Microsoft.Extensions.DependencyModel.dll
Microsoft.Extensions.DiagnosticAdapter.dll
Microsoft.Extensions.Diagnostics.HealthChecks.Abstractions.dll
Microsoft.Extensions.Diagnostics.HealthChecks.dll
Microsoft.Extensions.FileProviders.Abstractions.dll
Microsoft.Extensions.FileProviders.Composite.dll
Microsoft.Extensions.FileProviders.Embedded.dll
Microsoft.Extensions.FileProviders.Physical.dll
Microsoft.Extensions.FileSystemGlobbing.dll
Microsoft.Extensions.Hosting.Abstractions.dll
Microsoft.Extensions.Hosting.dll
Microsoft.Extensions.Http.dll
Microsoft.Extensions.Identity.Core.dll
Microsoft.Extensions.Identity.Stores.dll
Microsoft.Extensions.Localization.Abstractions.dll
Microsoft.Extensions.Localization.dll
Microsoft.Extensions.Logging.Abstractions.dll
Microsoft.Extensions.Logging.ApplicationInsights.dll
Microsoft.Extensions.Logging.Configuration.dll
Microsoft.Extensions.Logging.Console.dll
Microsoft.Extensions.Logging.Debug.dll
Microsoft.Extensions.Logging.EventSource.dll
Microsoft.Extensions.Logging.TraceSource.dll
Microsoft.Extensions.Logging.dll
Microsoft.Extensions.ObjectPool.dll
Microsoft.Extensions.Options.ConfigurationExtensions.dll
Microsoft.Extensions.Options.DataAnnotations.dll
Microsoft.Extensions.Options.dll
Microsoft.Extensions.PlatformAbstractions.dll
Microsoft.Extensions.Primitives.dll
Microsoft.Extensions.WebEncoders.dll
Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll
Microsoft.IdentityModel.Clients.ActiveDirectory.dll
Microsoft.IdentityModel.JsonWebTokens.dll
Microsoft.IdentityModel.Logging.dll
Microsoft.IdentityModel.Protocols.OpenIdConnect.dll
Microsoft.IdentityModel.Protocols.WsFederation.dll
Microsoft.IdentityModel.Protocols.dll
Microsoft.IdentityModel.Tokens.Saml.dll
Microsoft.IdentityModel.Tokens.dll
Microsoft.IdentityModel.Xml.dll
Microsoft.Net.Http.Headers.dll
Microsoft.Rest.ClientRuntime.Azure.dll
Microsoft.Rest.ClientRuntime.dll
Microsoft.VisualBasic.dll
Microsoft.Win32.Primitives.dll
Microsoft.Win32.Registry.dll
Microsoft.WindowsAzure.Storage.dll
NCrontab.Signed.dll
Newtonsoft.Json.Bson.dll
Newtonsoft.Json.dll
NuGet.Common.dll
NuGet.Configuration.dll
NuGet.DependencyResolver.Core.dll
NuGet.Frameworks.dll
NuGet.LibraryModel.dll
NuGet.Packaging.Core.dll
NuGet.Packaging.dll
NuGet.ProjectModel.dll
NuGet.Protocol.dll
NuGet.Versioning.dll
Remotion.Linq.dll
SOS.NETCore.dll
System.AppContext.dll
System.Buffers.dll
System.Collections.Concurrent.dll
System.Collections.Immutable.dll
System.Collections.NonGeneric.dll
System.Collections.Specialized.dll
System.Collections.dll
System.ComponentModel.Annotations.dll
System.ComponentModel.DataAnnotations.dll
System.ComponentModel.EventBasedAsync.dll
System.ComponentModel.Primitives.dll
System.ComponentModel.TypeConverter.dll
System.ComponentModel.dll
System.Composition.AttributedModel.dll
System.Composition.Convention.dll
System.Composition.Hosting.dll
System.Composition.Runtime.dll
System.Composition.TypedParts.dll
System.Configuration.ConfigurationManager.dll
System.Configuration.dll
System.Console.dll
System.Core.dll
System.Data.Common.dll
System.Data.SqlClient.dll
System.Data.dll
System.Diagnostics.Contracts.dll
System.Diagnostics.Debug.dll
System.Diagnostics.DiagnosticSource.dll
System.Diagnostics.FileVersionInfo.dll
System.Diagnostics.PerformanceCounter.dll
System.Diagnostics.Process.dll
System.Diagnostics.StackTrace.dll
System.Diagnostics.TextWriterTraceListener.dll
System.Diagnostics.Tools.dll
System.Diagnostics.TraceSource.dll
System.Diagnostics.Tracing.dll
System.Drawing.Primitives.dll
System.Drawing.dll
System.Dynamic.Runtime.dll
System.Globalization.Calendars.dll
System.Globalization.Extensions.dll
System.Globalization.Native.so
System.Globalization.dll
System.IO.Abstractions.dll
System.IO.Compression.Brotli.dll
System.IO.Compression.FileSystem.dll
System.IO.Compression.Native.a
System.IO.Compression.Native.so
System.IO.Compression.ZipFile.dll
System.IO.Compression.dll
System.IO.FileSystem.AccessControl.dll
System.IO.FileSystem.DriveInfo.dll
System.IO.FileSystem.Primitives.dll
System.IO.FileSystem.Watcher.dll
System.IO.FileSystem.dll
System.IO.IsolatedStorage.dll
System.IO.MemoryMappedFiles.dll
System.IO.Pipelines.dll
System.IO.Pipes.AccessControl.dll
System.IO.Pipes.dll
System.IO.UnmanagedMemoryStream.dll
System.IO.dll
System.IdentityModel.Tokens.Jwt.dll
System.Interactive.Async.dll
System.Linq.Expressions.dll
System.Linq.Parallel.dll
System.Linq.Queryable.dll
System.Linq.dll
System.Memory.dll
System.Native.a
System.Native.so
System.Net.Http.Formatting.dll
System.Net.Http.Native.a
System.Net.Http.Native.so
System.Net.Http.dll
System.Net.HttpListener.dll
System.Net.Mail.dll
System.Net.NameResolution.dll
System.Net.NetworkInformation.dll
System.Net.Ping.dll
System.Net.Primitives.dll
System.Net.Requests.dll
System.Net.Security.Native.a
System.Net.Security.Native.so
System.Net.Security.dll
System.Net.ServicePoint.dll
System.Net.Sockets.dll
System.Net.WebClient.dll
System.Net.WebHeaderCollection.dll
System.Net.WebProxy.dll
System.Net.WebSockets.Client.dll
System.Net.WebSockets.WebSocketProtocol.dll
System.Net.WebSockets.dll
System.Net.dll
System.Numerics.Vectors.dll
System.Numerics.dll
System.ObjectModel.dll
System.Private.CoreLib.dll
System.Private.DataContractSerialization.dll
System.Private.Uri.dll
System.Private.Xml.Linq.dll
System.Private.Xml.dll
System.Reactive.Core.dll
System.Reactive.Interfaces.dll
System.Reactive.Linq.dll
System.Reactive.PlatformServices.dll
System.Reflection.DispatchProxy.dll
System.Reflection.Emit.ILGeneration.dll
System.Reflection.Emit.Lightweight.dll
System.Reflection.Emit.dll
System.Reflection.Extensions.dll
System.Reflection.Metadata.dll
System.Reflection.Primitives.dll
System.Reflection.TypeExtensions.dll
System.Reflection.dll
System.Resources.Reader.dll
System.Resources.ResourceManager.dll
System.Resources.Writer.dll
System.Runtime.CompilerServices.Unsafe.dll
System.Runtime.CompilerServices.VisualC.dll
System.Runtime.Extensions.dll
System.Runtime.Handles.dll
System.Runtime.InteropServices.RuntimeInformation.dll
System.Runtime.InteropServices.WindowsRuntime.dll
System.Runtime.InteropServices.dll
System.Runtime.Loader.dll
System.Runtime.Numerics.dll
System.Runtime.Serialization.Formatters.dll
System.Runtime.Serialization.Json.dll
System.Runtime.Serialization.Primitives.dll
System.Runtime.Serialization.Xml.dll
System.Runtime.Serialization.dll
System.Runtime.dll
System.Security.AccessControl.dll
System.Security.Claims.dll
System.Security.Cryptography.Algorithms.dll
System.Security.Cryptography.Cng.dll
System.Security.Cryptography.Csp.dll
System.Security.Cryptography.Encoding.dll
System.Security.Cryptography.Native.OpenSsl.a
System.Security.Cryptography.Native.OpenSsl.so
System.Security.Cryptography.OpenSsl.dll
System.Security.Cryptography.Pkcs.dll
System.Security.Cryptography.Primitives.dll
System.Security.Cryptography.ProtectedData.dll
System.Security.Cryptography.X509Certificates.dll
System.Security.Cryptography.Xml.dll
System.Security.Permissions.dll
System.Security.Principal.Windows.dll
System.Security.Principal.dll
System.Security.SecureString.dll
System.Security.dll
System.ServiceModel.Web.dll
System.ServiceProcess.dll
System.Text.Encoding.CodePages.dll
System.Text.Encoding.Extensions.dll
System.Text.Encoding.dll
System.Text.Encodings.Web.dll
System.Text.RegularExpressions.dll
System.Threading.Channels.dll
System.Threading.Overlapped.dll
System.Threading.Tasks.Dataflow.dll
System.Threading.Tasks.Extensions.dll
System.Threading.Tasks.Parallel.dll
System.Threading.Tasks.dll
System.Threading.Thread.dll
System.Threading.ThreadPool.dll
System.Threading.Timer.dll
System.Threading.dll
System.Transactions.Local.dll
System.Transactions.dll
System.ValueTuple.dll
System.Web.HttpUtility.dll
System.Web.dll
System.Windows.dll
System.Xml.Linq.dll
System.Xml.ReaderWriter.dll
System.Xml.Serialization.dll
System.Xml.XDocument.dll
System.Xml.XPath.XDocument.dll
System.Xml.XPath.dll
System.Xml.XmlDocument.dll
System.Xml.XmlSerializer.dll
System.Xml.dll
System.dll
WindowsBase.dll
applicationHost.xdt
appsettings.Development.json
appsettings.json
createdump
libclrjit.so
libcoreclr.so
libcoreclrtraceptprovider.so
libdbgshim.so
libgrpc_csharp_ext.x64.so
libgrpc_csharp_ext.x86.so
libhostfxr.so
libhostpolicy.so
libmscordaccore.so
libmscordbi.so
libsos.so
libsosplugin.so
mscorlib.dll
netstandard.dll
protobuf-net.dll
sosdocsunix.txt
start.sh
web.InProcess.win-x64.xdt
web.InProcess.win-x86.xdt
web.config
workers
```

```
ls FuncExtensionBundles
Microsoft.Azure.Functions.ExtensionBundle
```

```
ls bin
bash
cat
chgrp
chmod
chown
cp
dash
date
dd
df
dir
dmesg
dnsdomainname
domainname
echo
egrep
false
fgrep
findmnt
grep
gunzip
gzexe
gzip
hostname
kill
ln
login
ls
lsblk
mkdir
mknod
mktemp
more
mount
mountpoint
mv
nisdomainname
pidof
ps
pwd
rbash
readlink
rm
rmdir
run-parts
sed
sh
sh.distrib
sleep
stty
su
sync
tailf
tar
tempfile
touch
true
umount
uname
uncompress
vdir
wdctl
which
ypdomainname
zcat
zcmp
zdiff
zegrep
zfgrep
zforce
zgrep
zless
zmore
znew
```

```
env
WEBSITE_SITE_NAME=pumapreycougar
ScmType=None
HOSTNAME=dda2efeeb805
APPSETTING_ScmType=None
APPSETTING_WEBSITE_RUN_FROM_PACKAGE=1
WEBSITE_RUN_FROM_PACKAGE=1
WEBSITE_AUTH_ENCRYPTION_KEY=XXXXX
WEBSITE_ROLE_INSTANCE_ID=0
ASPNETCORE_URLS=http://*:80
APPSETTING_AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=YYYYY;AccountKey=XXXXX;EndpointSuffix=core.windows.net
AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=YYYYY;AccountKey=XXXXX;EndpointSuffix=core.windows.net
FUNCTIONS_LOGS_MOUNT_PATH=/var/log/functionsLogs
AzureWebJobsScriptRoot=/home/site/wwwroot
APPSETTING_APPINSIGHTS_INSTRUMENTATIONKEY=ZZZZZ
APPSETTING_FUNCTIONS_WORKER_RUNTIME=dotnet
COMPUTERNAME=RD0003FFD1FC35
FUNCTIONS_EXTENSION_VERSION=~2
WEBSITE_CORS_ALLOWED_ORIGINS=https://functions.azure.com,https://functions-staging.azure.com,https://functions-next.azure.com
PWD=/
HOME=/home
WEBSITE_OWNER_NAME=AAAAAA
WEBSITE_AUTH_ENABLED=False
APPSETTING_FUNCTIONS_EXTENSION_VERSION=~2
APPSETTING_WEBSITE_SITE_NAME=pumapreycougar
PLATFORM_VERSION=86.0.7.96
PORT=80
WEBSITE_HOSTNAME=pumapreycougar.azurewebsites.net
WEBSITE_RESOURCE_GROUP=pumaprey-cougar
WEBSITE_INSTANCE_ID=0e61d4b29262aa3ad2e6c45187f7a1e5582c4704217387c9dff52d201191d58f
DOTNET_USE_POLLING_FILE_WATCHER=true
DOTNET_RUNNING_IN_CONTAINER=true
MACHINEKEY_DecryptionKey=ABC123
APPSETTING_WEBSITE_SLOT_NAME=Production
FUNCTIONS_WORKER_RUNTIME=dotnet
SHLVL=2
DIAGNOSTIC_LOGS_MOUNT_PATH=/var/log/diagnosticLogs
APPINSIGHTS_INSTRUMENTATIONKEY=YYYYY
APPSVC_RUN_ZIP=FALSE
SSH_PORT=2222
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
APPSETTING_WEBSITE_AUTH_ENABLED=False
WEBSITE_SLOT_NAME=Production
WEBSITE_AUTH_SIGNING_KEY=ABC123
WEBSITE_CORS_SUPPORT_CREDENTIALS=False
_=/usr/bin/env
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
ls /home/site/wwwroot/bin
Cougar.dll
Cougar.pdb
Microsoft.AspNetCore.Authentication.Abstractions.dll
Microsoft.AspNetCore.Authentication.Core.dll
Microsoft.AspNetCore.Authorization.Policy.dll
Microsoft.AspNetCore.Authorization.dll
Microsoft.AspNetCore.Hosting.Abstractions.dll
Microsoft.AspNetCore.Hosting.Server.Abstractions.dll
Microsoft.AspNetCore.Http.Abstractions.dll
Microsoft.AspNetCore.Http.Extensions.dll
Microsoft.AspNetCore.Http.Features.dll
Microsoft.AspNetCore.Http.dll
Microsoft.AspNetCore.JsonPatch.dll
Microsoft.AspNetCore.Mvc.Abstractions.dll
Microsoft.AspNetCore.Mvc.Core.dll
Microsoft.AspNetCore.Mvc.Formatters.Json.dll
Microsoft.AspNetCore.Mvc.WebApiCompatShim.dll
Microsoft.AspNetCore.ResponseCaching.Abstractions.dll
Microsoft.AspNetCore.Routing.Abstractions.dll
Microsoft.AspNetCore.Routing.dll
Microsoft.AspNetCore.WebUtilities.dll
Microsoft.Azure.WebJobs.Extensions.Http.dll
Microsoft.Azure.WebJobs.Extensions.dll
Microsoft.Azure.WebJobs.Host.Storage.dll
Microsoft.Azure.WebJobs.Host.dll
Microsoft.Azure.WebJobs.dll
Microsoft.Build.Framework.dll
Microsoft.Build.Utilities.Core.dll
Microsoft.DotNet.PlatformAbstractions.dll
Microsoft.Extensions.Configuration.Abstractions.dll
Microsoft.Extensions.Configuration.Binder.dll
Microsoft.Extensions.Configuration.EnvironmentVariables.dll
Microsoft.Extensions.Configuration.FileExtensions.dll
Microsoft.Extensions.Configuration.Json.dll
Microsoft.Extensions.Configuration.dll
Microsoft.Extensions.DependencyInjection.Abstractions.dll
Microsoft.Extensions.DependencyInjection.dll
Microsoft.Extensions.DependencyModel.dll
Microsoft.Extensions.FileProviders.Abstractions.dll
Microsoft.Extensions.FileProviders.Physical.dll
Microsoft.Extensions.FileSystemGlobbing.dll
Microsoft.Extensions.Hosting.Abstractions.dll
Microsoft.Extensions.Hosting.dll
Microsoft.Extensions.Logging.Abstractions.dll
Microsoft.Extensions.Logging.Configuration.dll
Microsoft.Extensions.Logging.dll
Microsoft.Extensions.ObjectPool.dll
Microsoft.Extensions.Options.ConfigurationExtensions.dll
Microsoft.Extensions.Options.dll
Microsoft.Extensions.Primitives.dll
Microsoft.Net.Http.Headers.dll
Microsoft.WindowsAzure.Storage.dll
NCrontab.Signed.dll
Newtonsoft.Json.Bson.dll
Newtonsoft.Json.dll
System.Net.Http.Formatting.dll
extensions.json
function.deps.json
```

```
ls -la /home/site/wwwroot
total 136
drwxr-xr-x 1 app app   4096 Jan  6 16:43 .
drwxr-xr-x 1 app app   4096 Nov 23 05:12 ..
drwxr-xr-x 2 app app   4096 Jan  6 16:43 Cougar
-rw-r--r-- 1 app app 114189 Jan  6 10:43 Cougar.deps.json
-rw-r--r-- 1 app app    158 Jan  5 21:10 appsettings.json
drwxr-xr-x 2 app app   4096 Jan  6 16:43 bin
-rw-r--r-- 1 app app     26 Jan  3 13:06 host.json
```

```
ls /home/
6fcb9844bfba3da60033a324
ASP.NET
LogFiles
data
site
```

```
ls /home/data
Functions
SitePackages
```

```
ls /home/data/Functions
sampledata
secrets
```

```
ls /home/data/Functions/secrets/
Sentinels
```

```
ls /home/data/Functions/secrets/Sentinels
cougar.json
host.json
```

```
find / -name "*.json"
/azure-functions-host/appsettings.Development.json
/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost.deps.json
/azure-functions-host/appsettings.json
/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost.runtimeconfig.json
/home/data/Functions/secrets/Sentinels/cougar.json
/home/data/Functions/secrets/Sentinels/host.json
/home/site/wwwroot/Cougar.deps.json
/home/site/wwwroot/Cougar/function.json
/home/site/wwwroot/bin/extensions.json
/home/site/wwwroot/bin/function.deps.json
/home/site/wwwroot/host.json

cat /azure-functions-host/appsettings.json
{
  "Logging": {
    "IncludeScopes": false,
    "LogLevel": {
      "Default": "Warning"
    }
  }
}

cat /home/data/Functions/secrets/Sentinels/cougar.json

cat /home/site/wwwroot/Cougar/function.json

{
  "generatedBy": "Microsoft.NET.Sdk.Functions-3.0.2",
  "configurationSource": "attributes",
  "bindings": [
    {
      "type": "httpTrigger",
      "methods": [
        "get",
        "post"
      ],
      "authLevel": "function",
      "name": "req"
    }
  ],
  "disabled": false,
  "scriptFile": "../bin/Cougar.dll",
  "entryPoint": "Puma.Security.Functions.Azure.Cougar.Run"
```

## Machine Key Research

Seriously, why?

https://social.msdn.microsoft.com/Forums/azure/en-US/a4b49641-00f8-4f2a-a4ea-187b87b36e06/decrypt-the-machine-key-from-inside-a-function-app?forum=AzureFunctions

## VPC Endpoints

### Cold Start Times

This is not really an issue in this environment becase the premium app service stays warm the entire time. But, let's see about the launch times before and after attaching the network interface to the function environemn.

```
Reqeust 1: 0.623724
Request 2: 0.308747
Reqeust 3: 0.299407
Request 4: 0.300875
```

### VPC Integrated Start Times

Feature is in beta for Linux environments at the time of this writing. No data available. Function does not run after enabling the VPC integration feature.
