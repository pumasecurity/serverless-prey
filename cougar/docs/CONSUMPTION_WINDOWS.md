# Azure Consumption Execution Environment (Windows)

Running a Windows App under a consumption based Azure function (cold starts). Included a SP attached identity to the function for MSI testing.

## Execution Environment

When connecting to Cougar, we start out in `cmd.exe`.

```
echo %USERDOMAIN%\%USERNAME%

WORKGROUP\RD281878EF37E3$
```

```
pwd

D:\Program Files (x86)\SiteExtensions\Functions\3.0.13139\32bit
```

```
dir

 Volume in drive D is Windows
 Volume Serial Number is E83B-C639
 Directory of D:\Program Files (x86)\SiteExtensions\Functions\3.0.13139\32bit
02/24/2020  11:56 PM    <DIR>          .
02/24/2020  11:56 PM    <DIR>          ..
02/24/2020  11:56 PM               576 applicationHost.xdt
02/24/2020  11:56 PM               258 appsettings.Development.json
02/24/2020  11:56 PM               113 appsettings.json
02/24/2020  11:56 PM           470,528 Autofac.dll
02/24/2020  11:56 PM    <DIR>          cs
02/24/2020  11:56 PM    <DIR>          de
02/24/2020  11:56 PM            86,016 dotnet-aspnet-codegenerator-design.dll
02/24/2020  11:56 PM         7,452,672 DotNetTI.BreakingChangeAnalysis.dll
02/24/2020  11:56 PM    <DIR>          es
02/24/2020  11:56 PM    <DIR>          fr
02/24/2020  11:56 PM           799,232 Google.Protobuf.dll
02/24/2020  11:56 PM            40,960 Grpc.Core.Api.dll
02/24/2020  11:56 PM           650,240 Grpc.Core.dll
02/24/2020  11:56 PM         4,033,008 grpc_csharp_ext.x64.dll
02/24/2020  11:56 PM         3,034,608 grpc_csharp_ext.x86.dll
02/24/2020  11:56 PM    <DIR>          it
02/24/2020  11:56 PM    <DIR>          ja
02/24/2020  11:56 PM    <DIR>          ko
02/24/2020  11:56 PM           983,040 Marklio.Metadata.dll
02/24/2020  11:56 PM           226,304 Microsoft.AI.DependencyCollector.dll
02/24/2020  11:56 PM            49,664 Microsoft.AI.EventCounterCollector.dll
02/24/2020  11:56 PM           434,688 Microsoft.AI.PerfCounterCollector.dll
02/24/2020  11:56 PM           197,632 Microsoft.AI.ServerTelemetryChannel.dll
02/24/2020  11:56 PM            97,280 Microsoft.AI.WindowsServer.dll
02/24/2020  11:56 PM           161,280 Microsoft.ApplicationInsights.AspNetCore.dll
02/24/2020  11:56 PM           730,624 Microsoft.ApplicationInsights.dll
02/24/2020  11:56 PM         3,960,832 Microsoft.ApplicationInsights.SnapshotCollector.dll
02/24/2020  11:56 PM            49,152 Microsoft.AspNetCore.Authentication.JwtBearer.dll
02/24/2020  11:56 PM            98,816 Microsoft.AspNetCore.JsonPatch.dll
02/24/2020  11:56 PM           100,352 Microsoft.AspNetCore.Mvc.NewtonsoftJson.dll
02/24/2020  11:56 PM           153,600 Microsoft.AspNetCore.Mvc.Razor.Extensions.dll
02/24/2020  11:56 PM           108,032 Microsoft.AspNetCore.Mvc.WebApiCompatShim.dll
02/24/2020  11:56 PM         1,105,408 Microsoft.AspNetCore.Razor.Language.dll
02/24/2020  11:56 PM            51,200 Microsoft.Azure.AppService.Proxy.Client.dll
02/24/2020  11:56 PM         1,307,136 Microsoft.Azure.AppService.Proxy.Common.dll
02/24/2020  11:56 PM           407,552 Microsoft.Azure.AppService.Proxy.Runtime.dll
02/24/2020  11:56 PM         1,206,784 Microsoft.Azure.KeyVault.dll
02/24/2020  11:56 PM            89,088 Microsoft.Azure.KeyVault.WebKey.dll
02/24/2020  11:56 PM            92,160 Microsoft.Azure.Services.AppAuthentication.dll
02/24/2020  11:56 PM            18,432 Microsoft.Azure.WebJobs.dll
02/24/2020  11:56 PM           142,336 Microsoft.Azure.WebJobs.Extensions.dll
02/24/2020  11:56 PM           110,592 Microsoft.Azure.WebJobs.Extensions.Http.dll
02/24/2020  11:56 PM         1,080,320 Microsoft.Azure.WebJobs.Host.dll
02/24/2020  11:56 PM           142,336 Microsoft.Azure.WebJobs.Host.Storage.dll
02/24/2020  11:56 PM            98,816 Microsoft.Azure.WebJobs.Logging.ApplicationInsights.dll
02/24/2020  11:56 PM           162,304 Microsoft.Azure.WebJobs.Logging.dll
02/24/2020  11:56 PM         1,426,944 Microsoft.Azure.WebJobs.Script.dll
02/24/2020  11:56 PM            11,616 Microsoft.Azure.WebJobs.Script.dll.config
02/24/2020  11:56 PM           280,576 Microsoft.Azure.WebJobs.Script.Grpc.dll
02/24/2020  11:56 PM           474,944 Microsoft.Azure.WebJobs.Script.WebHost.deps.json
02/24/2020  11:56 PM         2,057,216 Microsoft.Azure.WebJobs.Script.WebHost.dll
02/24/2020  11:56 PM           136,192 Microsoft.Azure.WebJobs.Script.WebHost.exe
02/24/2020  11:56 PM               274 Microsoft.Azure.WebJobs.Script.WebHost.runtimeconfig.json
02/24/2020  11:56 PM            26,624 Microsoft.Azure.WebSites.DataProtection.dll
02/24/2020  11:56 PM         3,465,728 Microsoft.Build.dll
02/24/2020  11:56 PM           108,544 Microsoft.Build.Framework.dll
02/24/2020  11:56 PM         8,311,296 Microsoft.CodeAnalysis.CSharp.dll
02/24/2020  11:56 PM            32,768 Microsoft.CodeAnalysis.CSharp.Scripting.dll
02/24/2020  11:56 PM         1,182,208 Microsoft.CodeAnalysis.CSharp.Workspaces.dll
02/24/2020  11:56 PM         3,664,896 Microsoft.CodeAnalysis.dll
02/24/2020  11:56 PM            67,584 Microsoft.CodeAnalysis.Razor.dll
02/24/2020  11:56 PM           286,720 Microsoft.CodeAnalysis.Scripting.dll
02/24/2020  11:56 PM         7,749,632 Microsoft.CodeAnalysis.VisualBasic.dll
02/24/2020  11:56 PM         1,134,080 Microsoft.CodeAnalysis.VisualBasic.Workspaces.dll
02/24/2020  11:56 PM         3,902,976 Microsoft.CodeAnalysis.Workspaces.dll
02/24/2020  11:56 PM            22,528 Microsoft.DotNet.PlatformAbstractions.dll
02/24/2020  11:56 PM           118,272 Microsoft.Extensions.DependencyModel.dll
02/24/2020  11:56 PM            58,880 Microsoft.Extensions.DiagnosticAdapter.dll
02/24/2020  11:56 PM            20,480 Microsoft.Extensions.Logging.ApplicationInsights.dll
02/24/2020  11:56 PM             9,216 Microsoft.Extensions.PlatformAbstractions.dll
02/24/2020  11:56 PM           392,704 Microsoft.IdentityModel.Clients.ActiveDirectory.dll
02/24/2020  11:56 PM            20,992 Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll
02/24/2020  11:56 PM            95,744 Microsoft.IdentityModel.JsonWebTokens.dll
02/24/2020  11:56 PM            28,672 Microsoft.IdentityModel.Logging.dll
02/24/2020  11:56 PM            37,376 Microsoft.IdentityModel.Protocols.dll
02/24/2020  11:56 PM           128,000 Microsoft.IdentityModel.Protocols.OpenIdConnect.dll
02/24/2020  11:56 PM           259,072 Microsoft.IdentityModel.Tokens.dll
02/24/2020  11:56 PM           186,880 Microsoft.Rest.ClientRuntime.Azure.dll
02/24/2020  11:56 PM           152,064 Microsoft.Rest.ClientRuntime.dll
02/24/2020  11:56 PM            19,456 Microsoft.VisualStudio.Web.CodeGeneration.Contracts.dll
02/24/2020  11:56 PM           132,608 Microsoft.VisualStudio.Web.CodeGeneration.Core.dll
02/24/2020  11:56 PM            53,760 Microsoft.VisualStudio.Web.CodeGeneration.dll
02/24/2020  11:56 PM           104,448 Microsoft.VisualStudio.Web.CodeGeneration.EntityFrameworkCore.dll
02/24/2020  11:56 PM            31,232 Microsoft.VisualStudio.Web.CodeGeneration.Templating.dll
02/24/2020  11:56 PM            45,056 Microsoft.VisualStudio.Web.CodeGeneration.Utils.dll
02/24/2020  11:56 PM           274,432 Microsoft.VisualStudio.Web.CodeGenerators.Mvc.dll
02/24/2020  11:56 PM         1,755,136 Microsoft.WindowsAzure.Storage.dll
02/24/2020  11:56 PM            45,056 NCrontab.Signed.dll
02/24/2020  11:56 PM           216,064 Newtonsoft.Json.Bson.dll
02/24/2020  11:56 PM         1,637,888 Newtonsoft.Json.dll
02/24/2020  11:56 PM           171,008 NuGet.Common.dll
02/24/2020  11:56 PM           174,592 NuGet.Configuration.dll
02/24/2020  11:56 PM           115,712 NuGet.DependencyResolver.Core.dll
02/24/2020  11:56 PM           239,104 NuGet.Frameworks.dll
02/24/2020  11:56 PM            62,976 NuGet.LibraryModel.dll
02/24/2020  11:56 PM            74,752 NuGet.Packaging.Core.dll
02/24/2020  11:56 PM           917,504 NuGet.Packaging.dll
02/24/2020  11:56 PM           316,928 NuGet.ProjectModel.dll
02/24/2020  11:56 PM         1,406,464 NuGet.Protocol.dll
02/24/2020  11:56 PM            88,576 NuGet.Versioning.dll
02/24/2020  11:56 PM    <DIR>          pl
02/24/2020  11:56 PM    <DIR>          PreJIT
02/24/2020  11:56 PM           497,152 protobuf-net.Core.dll
02/24/2020  11:56 PM           520,704 protobuf-net.dll
02/24/2020  11:56 PM    <DIR>          pt-BR
02/24/2020  11:56 PM    <DIR>          ru
02/24/2020  11:56 PM            12,800 System.Composition.AttributedModel.dll
02/24/2020  11:56 PM            92,672 System.Composition.Convention.dll
02/24/2020  11:56 PM            95,232 System.Composition.Hosting.dll
02/24/2020  11:56 PM            24,576 System.Composition.Runtime.dll
02/24/2020  11:56 PM           100,864 System.Composition.TypedParts.dll
02/24/2020  11:56 PM           857,600 System.Configuration.ConfigurationManager.dll
02/24/2020  11:56 PM         1,762,816 System.Data.SqlClient.dll
02/24/2020  11:56 PM           199,168 System.Diagnostics.PerformanceCounter.dll
02/24/2020  11:56 PM           136,192 System.IdentityModel.Tokens.Jwt.dll
02/24/2020  11:56 PM           712,192 System.Interactive.Async.dll
02/24/2020  11:56 PM            58,368 System.IO.Abstractions.dll
02/24/2020  11:56 PM           390,144 System.Net.Http.Formatting.dll
02/24/2020  11:56 PM         4,917,760 System.Private.ServiceModel.dll
02/24/2020  11:56 PM           245,248 System.Reactive.Core.dll
02/24/2020  11:56 PM             8,704 System.Reactive.Interfaces.dll
02/24/2020  11:56 PM         1,808,896 System.Reactive.Linq.dll
02/24/2020  11:56 PM            51,200 System.Reactive.PlatformServices.dll
02/24/2020  11:56 PM            22,016 System.Security.Cryptography.ProtectedData.dll
02/24/2020  11:56 PM            22,904 System.ServiceModel.dll
02/24/2020  11:56 PM            20,856 System.ServiceModel.Primitives.dll
02/24/2020  11:56 PM    <DIR>          tr
02/24/2020  11:56 PM             1,804 web.config
02/24/2020  11:56 PM    <DIR>          workers
02/24/2020  11:56 PM    <DIR>          zh-Hans
02/24/2020  11:56 PM    <DIR>          zh-Hant
             116 File(s)     86,228,289 bytes
              17 Dir(s)   2,331,140,096 bytes free
```

```
set

APP_POOL_CONFIG=C:\DWASFiles\Sites\cougar3a3451e97680\Config\applicationhost.config
APP_POOL_ID=cougar3a3451e97680
ASPNETCORE_IIS_HTTPAUTH=anonymous;
ASPNETCORE_IIS_PHYSICAL_PATH=D:\Program Files (x86)\SiteExtensions\Functions\3.0.13139\32bit\
MACHINEKEY_DecryptionKey=XXXXX
PROCESSOR_ARCHITEW6432=AMD64
PROMPT=$P$G
SystemDrive=D:
ProgramFiles(x86)=D:\Program Files (x86)
ProgramW6432=D:\Program Files
PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 79 Stepping 1, GenuineIntel
TMP=D:\local\Temp
PROCESSOR_ARCHITECTURE=x86
Path=D:\Python27;D:\Program Files (x86)\PHP\v5.6;D:\Program Files (x86)\nodejs;D:\Windows\sys
tem32;D:\Windows;D:\Windows\System32\Wbem;D:\Windows\System32\WindowsPowerShell\v1.0\;D:\Progr
am Files\Git\cmd;D:\Program Files\Microsoft Network Monitor 3\;D:\Users\Administrator\AppData\Roaming\npm;D:\Program Files (x86)\nodejs\;D:\Program Files (x86)\Mercurial\;d:\Program Files (x86)\Microsoft ASP.NET\ASP.NET Web Pages\v1.0\;;D:\Program Files (x86)\dotnet;D:\Program Files\dotnet;D:\Windows\system32\config\systemprofile\AppData\Local\Microsoft\WindowsApps;E:\base\x64;E:\base\x86;D:\Packages\GuestAgent\GuestAgent\LegacyRuntime\x64;D:\Packages\GuestAgent\GuestAgent\LegacyRuntime\x86;D:\Program Files\Java\zulu8.38.0.13-jre8.0.212-win_x64\bin;
AZURE_TOMCAT7_CMDLINE=-Dport.http=%HTTP_PLATFORM_PORT% -Djava.util.logging.config.file="D:\Program Files (x86)\apache-tomcat-7.0.94\conf\logging.properties" -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dsite.logdir="d:/home/LogFiles/" -Dsite.tempdir="d:\home\site\workdir" -classpath "D:\Program Files (x86)\apache-tomcat-7.0.94\bin\bootstrap.jar;D:\Program Files (x86)\apache-tomcat-7.0.94\bin\tomcat-juli.jar" -Dcatalina.base="D:\Program Files (x86)\apache-tomcat-7.0.94" -Djava.io.tmpdir="d:\home\site\workdir" org.apache.catalina.startup.Bootstrap
AZURE_TOMCAT90_HOME=D:\Program Files (x86)\apache-tomcat-9.0.21
PROCESSOR_REVISION=4f01
TEMP=D:\local\Temp
USERPROFILE=D:\local\UserProfile
USERNAME=RD281878EF37E3$
SystemRoot=D:\Windows
AZURE_TOMCAT85_HOME=D:\Program Files (x86)\apache-tomcat-8.5.42
AZURE_TOMCAT7_HOME=D:\Program Files (x86)\apache-tomcat-7.0.94
AZURE_JETTY9_CMDLINE=-Djava.net.preferIPv4Stack=true -Djetty.port=%HTTP_PLATFORM_PORT% -Djetty.base="D:\Program Files (x86)\jetty-distribution-9.1.0.v20131115" -Djetty.webapps="d:\home\site\wwwroot\webapps" -jar "D:\Program Files (x86)\jetty-distribution-9.1.0.v20131115\start.jar" etc\jetty-logging.xml
CommonProgramFiles=D:\Program Files (x86)\Common Files
ProgramData=D:\local\ProgramData
AZURE_JETTY93_HOME=D:\Program Files (x86)\jetty-distribution-9.3.25.v20180904
COMPUTERNAME=RD281878EF37E3
ALLUSERSPROFILE=D:\local\ProgramData
CommonProgramW6432=D:\Program Files\Common Files
AZURE_JETTY9_HOME=D:\Program Files (x86)\jetty-distribution-9.1.0.v20131115
AZURE_TOMCAT90_CMDLINE=-noverify -Djava.net.preferIPv4Stack=true -Dcatalina.instance.name=%WEBSITE_INSTANCE_ID% -Dport.http=%HTTP_PLATFORM_PORT% -Djava.util.logging.config.file="D:\Program Files (x86)\apache-tomcat-9.0.21\conf\logging.properties" -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dsite.logdir="d:/home/LogFiles/" -Dsite.tempdir="d:\home\site\workdir" -classpath "D:\Program Files (x86)\apache-tomcat-9.0.21\bin\bootstrap.jar;D:\Program Files (x86)\apache-tomcat-9.0.21\bin\tomcat-juli.jar" -Dcatalina.base="D:\Program Files (x86)\apache-tomcat-9.0.21" -Djava.io.tmpdir="d:\home\site\workdir" org.apache.catalina.startup.Bootstrap
AZURE_JETTY93_CMDLINE=-Djava.net.preferIPv4Stack=true -Djetty.port=%HTTP_PLATFORM_PORT% -Djetty.base="D:\Program Files (x86)\jetty-distribution-9.3.25.v20180904" -Djetty.webapps="d:\home\site\wwwroot\webapps" -jar "D:\Program Files (x86)\jetty-distribution-9.3.25.v20180904\start.jar" etc\jetty-logging.xml
CommonProgramFiles(x86)=D:\Program Files (x86)\Common Files
windir=D:\Windows
NUMBER_OF_PROCESSORS=1
OS=Windows_NT
ProgramFiles=D:\Program Files (x86)
ComSpec=D:\Windows\system32\cmd.exe
PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW
AZURE_TOMCAT8_CMDLINE=-Dport.http=%HTTP_PLATFORM_PORT% -Djava.util.logging.config.file="D:\Program Files (x86)\apache-tomcat-8.0.53\conf\logging.properties" -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dsite.logdir="d:/home/LogFiles/" -Dsite.tempdir="d:\home\site\workdir" -classpath "D:\Program Files (x86)\apache-tomcat-8.0.53\bin\bootstrap.jar;D:\Program Files (x86)\apache-tomcat-8.0.53\bin\tomcat-juli.jar" -Dcatalina.base="D:\Program Files (x86)\apache-tomcat-8.0.53" -Djava.io.tmpdir="d:\home\site\workdir" org.apache.catalina.startup.Bootstrap
PSModulePath=D:\Program Files\WindowsPowerShell\Modules;D:\Windows\system32\WindowsPowerShell\v1.0\Modules;D:\Program Files\WindowsPowerShell\Modules\;D:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\;D:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\;D:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\Storage\;D:\Program Files\Microsoft Message Analyzer\PowerShell\
APPDATA=D:\local\AppData
USERDOMAIN=WORKGROUP
PROCESSOR_LEVEL=6
LOCALAPPDATA=D:\local\LocalAppData
AZURE_TOMCAT85_CMDLINE=-noverify -Djava.net.preferIPv4Stack=true -Dcatalina.instance.name=%WEBSITE_INSTANCE_ID% -Dport.http=%HTTP_PLATFORM_PORT% -Djava.util.logging.config.file="D:\Program Files (x86)\apache-tomcat-8.5.42\conf\logging.properties" -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dsite.logdir="d:/home/LogFiles/" -Dsite.tempdir="d:\home\site\workdir" -classpath "D:\Program Files (x86)\apache-tomcat-8.5.42\bin\bootstrap.jar;D:\Program Files (x86)\apache-tomcat-8.5.42\bin\tomcat-juli.jar" -Dcatalina.base="D:\Program Files (x86)\apache-tomcat-8.5.42" -Djava.io.tmpdir="d:\home\site\workdir" org.apache.catalina.startup.Bootstrap
DOTNET_HOSTING_OPTIMIZATION_CACHE=D:\DotNetCache
AZURE_TOMCAT8_HOME=D:\Program Files (x86)\apache-tomcat-8.0.53
PUBLIC=D:\Users\Public
AzureWebJobsDashboard=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
APPSETTING_AzureWebJobsDashboard=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
APPSETTING_AzureWebJobsStorage=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
FUNCTIONS_EXTENSION_VERSION=beta
APPSETTING_FUNCTIONS_EXTENSION_VERSION=beta
FUNCTIONS_WORKER_RUNTIME=dotnet
APPSETTING_FUNCTIONS_WORKER_RUNTIME=dotnet
FUNCTION_APP_EDIT_MODE=readonly
APPSETTING_FUNCTION_APP_EDIT_MODE=readonly
HASH=XXXXX
APPSETTING_HASH=XXXXX
WEBSITE_CONTENTAZUREFILECONNECTIONSTRING=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
APPSETTING_WEBSITE_CONTENTAZUREFILECONNECTIONSTRING=DefaultEndpointsProtocol=https;AccountName=cougar3a3451e97680;AccountKey=XXXXX;EndpointSuffix=core.windows.net
WEBSITE_CONTENTSHARE=cougar3a3451e97680-content
APPSETTING_WEBSITE_CONTENTSHARE=cougar3a3451e97680-content
WEBSITE_RUN_FROM_PACKAGE=https://cougar3a3451e97680.blob.core.windows.net/function-releases/./functionapp.zip?sv=2017-07-29&ss=b&srt=o&sp=r&se=2021-12-31&st=2019-01-01&spr=https&sig=XXXXX
APPSETTING_WEBSITE_RUN_FROM_PACKAGE=https://cougar3a3451e97680.blob.core.windows.net/function-releases/./functionapp.zip?sv=2017-07-29&ss=b&srt=o&sp=r&se=2021-12-31&st=2019-01-01&spr=https&sig=XXXXX
https_only=true
APPSETTING_https_only=true
ScmType=None
APPSETTING_ScmType=None
WEBSITE_SITE_NAME=cougar3a3451e97680
APPSETTING_WEBSITE_SITE_NAME=cougar3a3451e97680
WEBSITE_AUTH_ENABLED=False
APPSETTING_WEBSITE_AUTH_ENABLED=False
WEBSITE_SLOT_NAME=Production
APPSETTING_WEBSITE_SLOT_NAME=Production
WEBSITE_AUTH_LOGOUT_PATH=/.auth/logout
APPSETTING_WEBSITE_AUTH_LOGOUT_PATH=/.auth/logout
WEBSITE_AUTH_AUTO_AAD=False
APPSETTING_WEBSITE_AUTH_AUTO_AAD=False
REGION_NAME=Central US
HOME=D:\home
HOME_EXPANDED=C:\DWASFiles\Sites\cougar3a3451e97680\VirtualDirectory0
LOCAL_EXPANDED=C:\DWASFiles\Sites\cougar3a3451e97680
windows_tracing_flags=
windows_tracing_logfile=
WEBSITE_INSTANCE_ID=1e810a8adad532c9d33a12ea65f770cc6728bf37f540cd531d76356458882176
WEBSITE_HTTPLOGGING_ENABLED=0
WEBSITE_SCM_ALWAYS_ON_ENABLED=0
WEBSITE_ISOLATION=pico
WEBSITE_OS=windows
WEBSITE_DEPLOYMENT_ID=cougar3a3451e97680
WEBSITE_COMPUTE_MODE=Dedicated
WEBSITE_SKU=Basic
WEBSITE_ELASTIC_SCALING_ENABLED=0
WEBSITE_SCM_SEPARATE_STATUS=1
WEBSITE_IIS_SITE_NAME=cougar3a3451e97680
JAVA_HOME=D:\Program Files\Java\zulu8.38.0.13-jre8.0.212-win_x64
SITE_BITNESS=x86
WEBSITE_AUTH_ENCRYPTION_KEY=XXXXX
WEBSITE_AUTH_SIGNING_KEY=XXXXX
WEBSITE_CORS_ALLOWED_ORIGINS=https://functions.azure.com,https://functions-staging.azure.com,https://functions-next.azure.com
WEBSITE_CORS_SUPPORT_CREDENTIALS=False
WEBSITE_PROACTIVE_AUTOHEAL_ENABLED=True
WEBSITE_PROACTIVE_STACKTRACING_ENABLED=True
WEBSITE_DYNAMIC_CACHE=1
WEBSITE_FRAMEWORK_JIT=1
WEBSITE_HOME_STAMPNAME=waws-prod-dm1-153
WEBSITE_CURRENT_STAMPNAME=waws-prod-dm1-153
WEBSOCKET_CONCURRENT_REQUEST_LIMIT=350
WEBSITE_VOLUME_TYPE=PrimaryStorageVolume
WEBSITE_OWNER_NAME=47d488d2-f662-46c2-8183-8fce2aefa6aa+Cougar-CentralUSwebspace
WEBSITE_RESOURCE_GROUP=cougar
WEBSITE_CONTAINER_READY=1
REMOTEDEBUGGINGPORT=
REMOTEDEBUGGINGBITVERSION=vx86
WEBSITE_LOCALCACHE_ENABLED=False
WEBSITE_HOSTNAME=cougar3a3451e97680.azurewebsites.net
WEBSITE_RELAYS=
WEBSITE_REWRITE_TABLE=
MSI_ENDPOINT=http://127.0.0.1:41155/MSI/token/
MSI_SECRET=ABC123
IDENTITY_ENDPOINT=http://127.0.0.1:41155/MSI/token/
IDENTITY_HEADER=ABC123
```

```
dir \home\ASP.NET

 Volume in drive D is Windows
 Volume Serial Number is E83B-C639
 Directory of D:\home\ASP.NET
02/27/2020  05:08 AM    <DIR>          .
02/27/2020  05:08 AM    <DIR>          ..
02/27/2020  05:08 AM    <DIR>          DataProtection-Keys
               0 File(s)              0 bytes
               3 Dir(s)  10,737,332,224 bytes free
```

```
dir \home\site\wwwroot

 Volume in drive D is Windows
 Volume Serial Number is EA8C-FC9E
 Directory of D:\home\site\wwwroot
01/01/2049  12:00 AM    <DIR>          Cougar
01/01/2049  12:00 AM           128,384 Cougar.deps.json
01/01/2049  12:00 AM               158 appsettings.json
01/01/2049  12:00 AM    <DIR>          bin
01/01/2049  12:00 AM                26 host.json
               3 File(s)        128,568 bytes
               2 Dir(s)               0 bytes free
```
dir \home\ASP.NET\DataProtection-Keys

 Volume in drive D is Windows
 Volume Serial Number is EA8C-FC9E
 Directory of D:\home\ASP.NET\DataProtection-Keys
03/25/2020  06:03 AM    <DIR>          .
03/25/2020  06:03 AM    <DIR>          ..
03/25/2020  06:03 AM             1,015 key-6938ec56-d1f0-40ba-a61f-94dd10f3d1b3.xml
               1 File(s)          1,015 bytes
               2 Dir(s)  10,737,332,224 bytes free
```
type \home\ASP.NET\DataProtection-Keys\key-*.xml

ï»¿<?xml version="1.0" encoding="utf-8"?>
<key id="7187fd37-1a8a-44dc-9bd6-c57d996ba2f5" version="1">
  <creationDate>2020-02-27T05:08:21.7166856Z</creationDate>
  <activationDate>2020-02-27T05:08:21.5042361Z</activationDate>
  <expirationDate>2020-05-27T05:08:21.5042361Z</expirationDate>
  <descriptor deserializerType="Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorDescriptorDeserializer, Microsoft.AspNetCore.DataProtection, Version=3.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60">
    <descriptor>
      <encryption algorithm="AES_256_CBC" />
      <validation algorithm="HMACSHA256" />
      <masterKey p4:requiresEncryption="true" xmlns:p4="http://schemas.asp.net/2015/03/dataProtection">
        <!-- Warning: the key below is in an unencrypted form. -->
        <value>ABCq123==</value>
      </masterKey>
    </descriptor>
  </descriptor>
</key>
```

You can switch from `cmd.exe` to `powershell.exe`:

```
powershell.exe
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.
```
