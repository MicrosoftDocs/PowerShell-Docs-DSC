---
ms.date: 12/04/2023
keywords:  dsc,powershell,configuration,setup
title:  Get started with Desired State Configuration (DSC) for Windows
description: This article explains how to get started using PowerShell Desired State Configuration (DSC) for Windows.
---

# Get started with Desired State Configuration (DSC) for Windows

This article explains how to get started using PowerShell Desired State Configuration (DSC) v1.1.

<!-- NEW TAB -->
# [Windows](#tab/windows)

## Supported Windows operating system versions

The following versions are supported:

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows 11
- Windows 10

The [Microsoft Hyper-V Server][W02] standalone product doesn't contain an implementation of Desired
State Configuration so you can't manage it using PowerShell DSC or Azure Automation State
Configuration.

## Installing DSC

PowerShell Desired State Configuration is included in Windows and updated through Windows Management
Framework. The latest version is [Windows Management Framework 5.1][W03].

> [!NOTE]
> You don't need to enable the Windows Server feature 'DSC-Service' to manage a machine using DSC.
> That feature is only needed when building a Windows Pull Server instance.

## Using DSC for Windows

The following sections explain how to create and run DSC configurations on Windows computers.

### Creating a configuration MOF document

The Windows PowerShell `Configuration` keyword is used to create a configuration. The following
steps describe the creation of a configuration document using Windows PowerShell.

#### Install a module containing DSC resources

Windows PowerShell Desired State Configuration includes built-in modules containing DSC resources.
You can also load modules from external sources such as the PowerShell Gallery, using the
PowerShellGet cmdlets.

```PowerShell
Install-Module 'PSDscResources' -Verbose
```

#### Define a configuration and generate the configuration document:

```powershell
Configuration EnvironmentVariable_Path
{
    param ()

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name = 'TestPathEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $true
            Target = @('Process', 'Machine')
        }
    }
}

EnvironmentVariable_Path -OutputPath:"./EnvironmentVariable_Path"
```

#### Apply the configuration to the machine

> [!NOTE]
> To allow DSC to run, Windows needs to be configured to receive PowerShell remote commands even
> when you're running a `localhost` configuration. To configure your environment correctly, just
> `Set-WsManQuickConfig -Force` in an elevated PowerShell Terminal.

You can apply Configuration documents (MOF files) to a machine with the
[Start-DscConfiguration][W08] cmdlet.

```powershell
Start-DscConfiguration -Path 'C:\EnvironmentVariable_Path' -Wait -Verbose
```

#### Get the current state of the configuration

The [Get-DscConfiguration][W04] cmdlet queries the current status of the machine and returns the
current values for the configuration.

```powershell
Get-DscConfiguration
```

The [Get-DscLocalConfigurationManager][W05] cmdlet returns the current meta-configuration applied to
the machine.

```powershell
Get-DscLocalConfigurationManager
```

#### Remove the current configuration from a machine

The [Remove-DscConfigurationDocument][W06]

```powershell
Remove-DscConfigurationDocument -Stage Current -Verbose
```

#### Configure settings in Local Configuration Manager

Apply a Meta Configuration MOF file to the machine using the [Set-DSCLocalConfigurationManager][W07]
cmdlet. Requires the path to the Meta Configuration MOF.

```powershell
Set-DSCLocalConfigurationManager -Path 'c:\metaconfig\localhost.meta.mof' -Verbose
```

## Windows PowerShell Desired State Configuration log files

Logs for DSC are written to the `Microsoft-Windows-Dsc/Operational` Windows Event Log. You can
enable other logs for debugging purposes by following the steps in [Where Are DSC Event Logs][W01].

<!-- link references -->
[W01]: ../troubleshooting/troubleshooting.md#where-are-dsc-event-logs
[W02]: /windows-server/virtualization/hyper-v/hyper-v-server-2016
[W03]: https://www.microsoft.com/download/details.aspx?id=54616
[W04]: xref:PSDesiredStateConfiguration/Get-DscConfiguration
[W05]: xref:PSDesiredStateConfiguration/Get-DscLocalConfigurationManager
[W06]: xref:PSDesiredStateConfiguration/Remove-DscConfigurationDocument
[W07]: xref:PSDesiredStateConfiguration/Set-DscLocalConfigurationManager
[W08]: xref:PSDesiredStateConfiguration/Start-DscConfiguration

<!-- NEW TAB -->
# [Windows Nano](#tab/windows-nano)

## Using DSC on Windows Nano Server

**DSC on Nano Server** is an optional package in the `NanoServer\Packages` folder of the Windows
Server 2016 media. The package can be installed when you create a VHD for a Nano Server by
specifying `Microsoft-NanoServer-DSC-Package` as the value of the **Packages** parameter of the
`New-NanoServerImage` function. For example, if you are creating a VHD for a virtual machine, the
command would look like the following:

```powershell
$newNanoServerImageSplat = @{
    Edition = 'Standard'
    DeploymentType = 'Guest'
    MediaPath = 'f:\'
    BasePath = '.\Base'
    TargetPath = '.\Nano1\Nano.vhd'
    ComputerName = 'Nano1'
    Packages = 'Microsoft-NanoServer-DSC-Package'
}
New-NanoServerImage @newNanoServerImageSplat
```

For information about installing and using Nano Server, as well as how to manage Nano Server with
PowerShell Remoting, see [Getting Started with Nano Server][N12].

## DSC features available on Nano Server

Because Nano Server supports only a limited set of APIs compared to a full version of Windows
Server, DSC on Nano Server does not have full functional parity with DSC running on full SKUs for
the time being. DSC on Nano Server is in active development and is not yet feature complete.

The following DSC features are currently available on Nano Server:

Both push and pull modes

- All DSC cmdlets that exist on a full version of Windows Server, including the following:
- [Get-DscLocalConfigurationManager][N18]
- [Set-DscLocalConfigurationManager][N25]
- [Enable-DscDebug][N15]
- [Disable-DscDebug][N14]
- [Start-DscConfiguration][N26]
- [Stop-DscConfiguration][N27]
- [Get-DscConfiguration][N16]
- [Test-DscConfiguration][N28]
- [Publish-DscConfiguration][N22]
- [Update-DscConfiguration][N29]
- [Restore-DscConfiguration][N24]
- [Remove-DscConfigurationDocument][N23]
- [Get-DscConfigurationStatus][N17]
- [Invoke-DscResource][N20]
- [Find-DscResource][N13]
- [Get-DscResource][N19]
- [New-DscChecksum][N21]

- Compiling configurations (see [DSC configurations][N01])

  **Issue:** Password encryption (see [Securing the MOF File][N09]) during configuration compilation
  doesn't work.

- Compiling metaconfigurations (see [Configuring the Local Configuration Manager][N05])

- Running a resource under user context (see [Running DSC with user credentials (RunAs)][N03])

- Class-based resources (see [Writing a custom DSC resource with PowerShell classes][N11]))

- Debugging of DSC resources (see [Debugging DSC resources][N10])

  **Issue:** Doesn't work if a resource is using PsDscRunAsCredential (see
  [Running DSC with user credentials][N03])

- [Specifying cross-node dependencies][N02]

- [Resource versioning][N04]

- Pull client (configurations & resources) (see
  [Setting up a pull client using configuration names][N07])

- [Partial configurations (pull & push)][N06]

- [Reporting to pull server][N08]

- MOF encryption

- Event logging

- Azure Automation DSC reporting

- Resources that are fully functional

  - **Archive**
  - **Environment**
  - **File**
  - **Log**
  - **ProcessSet**
  - **Registry**
  - **Script**
  - **WindowsPackageCab**
  - **WindowsProcess**
  - **WaitForAll** (see [Specifying cross-node dependencies][N02])
  - **WaitForAny** (see [Specifying cross-node dependencies][N02])
  - **WaitForSome** (see [Specifying cross-node dependencies][N02])

- Resources that are partially functional

  - **Group**
  - **GroupSet**

    **Issue:** Above resources fail if specific instance is called twice (running the same
    configuration twice)

  - **Service**
  - **ServiceSet**

    **Issue:** Only works for starting/stopping (status) service. Fails, if one tries to change
    other service attributes like startuptype, credentials, description etc.. The error thrown is
    similar to:

    ```Output
    Cannot find type [management.managementobject]: verify that the assembly containing
    this type is loaded.
    ```

- Resources that are not functional

  - **User**

## DSC features not available on Nano Server

The following DSC features are not currently available on Nano Server:

- Decrypting MOF document with encrypted password(s)
- Pull Server--you cannot currently set up a pull server on Nano Server
- Anything that is not in the list of feature works

## Using custom DSC resources on Nano Server

Due to a limited sets of Windows APIs and CLR libraries available on Nano Server, DSC resources that
work on the full CLR version of Windows do not necessarily work on Nano Server. Complete end-to-end
testing before deploying any DSC custom resources to a production environment.

## See Also

- [Getting Started with Nano Server][N12]

<!-- link references -->
[N01]: ../configurations/configurations.md
[N02]: ../configurations/crossNodeDependencies.md
[N03]: ../configurations/runAsUser.md
[N04]: ../configurations/sxsResource.md
[N05]: ../managing-nodes/metaConfig.md
[N06]: ../pull-server/partialConfigs.md
[N07]: ../pull-server/pullClientConfigNames.md
[N08]: ../pull-server/reportServer.md
[N09]: ../pull-server/secureMOF.md
[N10]: ../troubleshooting/debugResource.md
[N11]: ../resources/authoringresourceclass.md
[N12]: /windows-server/get-started/getting-started-with-nano-server
[N13]: xref:PowerShellGet.Find-DscResource
[N14]: xref:PSDesiredStateConfiguration.Disable-DscDebug
[N15]: xref:PSDesiredStateConfiguration.Enable-DscDebug
[N16]: xref:PSDesiredStateConfiguration.Get-DscConfiguration
[N17]: xref:PSDesiredStateConfiguration.Get-DscConfigurationStatus
[N18]: xref:PSDesiredStateConfiguration.Get-DscLocalConfigurationManager
[N19]: xref:PSDesiredStateConfiguration.Get-DscResource
[N20]: xref:PSDesiredStateConfiguration.Invoke-DscResource
[N21]: xref:PSDesiredStateConfiguration.New-DSCCheckSum
[N22]: xref:PSDesiredStateConfiguration.Publish-DscConfiguration
[N23]: xref:PSDesiredStateConfiguration.Remove-DscConfigurationDocument
[N24]: xref:PSDesiredStateConfiguration.Restore-DscConfiguration
[N25]: xref:PSDesiredStateConfiguration.Set-DscLocalConfigurationManager
[N26]: xref:PSDesiredStateConfiguration.Start-DscConfiguration
[N27]: xref:PSDesiredStateConfiguration.Stop-DscConfiguration
[N28]: xref:PSDesiredStateConfiguration.Test-DscConfiguration
[N29]: xref:PSDesiredStateConfiguration.Update-DscConfiguration

<!-- NEW TAB -->
# [Linux](#tab/linux)

## Get started with Desired State Configuration (DSC) for Linux

This topic explains how to get started using PowerShell Desired State Configuration (DSC) for Linux.

## Supported Linux operation system versions

The following Linux operating system versions are supported by DSC for Linux.

- CentOS 7, and 8 (x64)
- Debian GNU/Linux 8, 9, and 10 (x64)
- Oracle Linux 7 (x64)
- Red Hat Enterprise Linux Server 7, and 8 (x64)
- SUSE Linux Enterprise Server 12 and 15 (x64)
- Ubuntu Server 14.04 LTS, 16.04 LTS, 18.04 LTS, and 20.04 LTS (x64)

## Installing DSC for Linux

You must install the [Open Management Infrastructure (OMI)][L02] before
installing DSC for Linux.

### Installing OMI

Desired State Configuration for Linux requires the Open Management Infrastructure (OMI) CIM server,
version 1.0.8.1 or later. OMI can be downloaded from The Open Group:
[Open Management Infrastructure (OMI)][L02].

To install OMI, install the package that is appropriate for your Linux system (.rpm or .deb) and
OpenSSL version (ssl_098 or ssl_100), and architecture (x64/x86). RPM packages are appropriate for
CentOS, Red Hat Enterprise Linux, SUSE Linux Enterprise Server, and Oracle Linux. DEB packages are
appropriate for Debian GNU/Linux and Ubuntu Server. The ssl_098 packages are appropriate for
computers with OpenSSL 0.9.8 installed while the ssl_100 packages are appropriate for computers with
OpenSSL 1.0 installed.

> [!NOTE]
> To determine the installed OpenSSL version, run the command `openssl version`.

Run the following command to install OMI on a CentOS 7 x64 system.

`# sudo rpm -Uvh omiserver-1.0.8.ssl_100.rpm`

### Installing DSC

DSC for Linux is available for download from the
[PowerShell-DSC-for-Linux][L03]
repository in the repository.

To install DSC, install the package that is appropriate for your Linux system (.rpm or .deb),
OpenSSL version, and architecture (x64/x86). RPM packages are appropriate for CentOS, Red Hat
Enterprise Linux, SUSE Linux Enterprise Server, and Oracle Linux. DEB packages are appropriate for
Debian GNU/Linux and Ubuntu Server.

> [!NOTE]
> Support for DSC Linux OpenSSL up to version 1.1. To determine the installed OpenSSL version,
> run the command `openssl version`.

Run the following command to install DSC on a CentOS 7 x64 system.

`# sudo rpm -Uvh dsc-1.0.0-254.ssl_100.x64.rpm`

## Using DSC for Linux

The following sections explain how to create and run DSC configurations on Linux computers.

### Creating a configuration MOF document

The Windows PowerShell Configuration keyword is used to create a configuration for Linux computers,
just like for Windows computers. The following steps describe the creation of a configuration
document for a Linux computer using Windows PowerShell.

1. Import the nx module. The nx Windows PowerShell module contains the schema for Built-In resources
   for DSC for Linux, and must be installed to your local computer and imported in the
   configuration.

   - To install the nx module, copy the nx module directory to either
     `$env:USERPROFILE\Documents\WindowsPowerShell\Modules\` or `$PSHOME\Modules`. The nx module is
     included in the DSC for Linux installation package. To import the nx module in your
     configuration, use the `Import-DSCResource` command:

   ```powershell
   Configuration ExampleConfiguration{

    Import-DSCResource -ModuleName nx

   }
   ```

2. Define a configuration and generate the configuration document:

   ```powershell
   Configuration ExampleConfiguration
   {
        Import-DSCResource -ModuleName nx

        Node  "linuxhost.contoso.com"
        {
            nxFile ExampleFile
            {
                DestinationPath = "/tmp/example"
                Contents = "hello world `n"
                Ensure = "Present"
                Type = "File"
            }
        }
   }

   ExampleConfiguration -OutputPath:"C:\temp"
   ```

### Push the configuration to the Linux computer

Configuration documents (MOF files) can be pushed to the Linux computer using the
[Start-DscConfiguration][L08] cmdlet. In order to use this cmdlet, along with the
[Get-DscConfiguration][L05], or [Test-DscConfiguration][L09] cmdlets, remotely to a Linux computer,
you must use a CIMSession. The [New-CimSession][L04] cmdlet is used to create a **CIMSession** to
the Linux computer.

The following code shows how to create a CIMSession for DSC for Linux.

```powershell
$Node = "ostc-dsc-01"
$Credential = Get-Credential -UserName "root" -Message "Enter Password:"

#Ignore SSL certificate validation
# $opt = New-CimSessionOption -UseSsl -SkipCACheck -SkipCNCheck -SkipRevocationCheck

#Options for a trusted SSL certificate
$opt = New-CimSessionOption -UseSsl

$sessParams = @{
    Credential = $credential
    ComputerName = $Node
    Port = 5986
    Authentication = 'basic'
    SessionOption = $opt
    OperationTimeoutSec = 90
}

$Sess = New-CimSession @sessParams
```

> [!NOTE]
> For "Push" mode, the user credential must be the root user on the Linux computer. Only SSL/TLS
> connections are supported for DSC for Linux, the `New-CimSession` must be used with the **UseSSL**
> parameter set to $true. The SSL certificate used by OMI (for DSC) is specified in the file:
> `/etc/opt/omi/conf/omiserver.conf` with the properties: pemfile and keyfile. If this certificate
> is not trusted by the Windows computer that you are running the [New-CimSession][L04] cmdlet on,
> you can choose to ignore certificate validation with the CIMSession Options:
> `-SkipCACheck -SkipCNCheck -SkipRevocationCheck`

Run the following command to push the DSC configuration to the Linux node.

`Start-DscConfiguration -Path:"C:\temp" -CimSession $Sess -Wait -Verbose`

### Distribute the configuration with a pull server

Configurations can be distributed to a Linux computer with a pull server, just like for Windows
computers. For guidance on using a pull server, see
[Windows PowerShell Desired State Configuration Pull Servers][L01]. For additional information and
limitations related to using Linux computers with a pull server, see the Release Notes for Desired
State Configuration for Linux.

### Working with configurations locally

DSC for Linux includes scripts to work with configuration from the local Linux computer. These
scripts are locate in `/opt/microsoft/dsc/Scripts` and include the following:

- GetDscConfiguration.py

  Returns the current configuration applied to the computer. Similar to the Windows PowerShell cmdlet
  `Get-DscConfiguration` cmdlet.

  `# sudo ./GetDscConfiguration.py`

- GetDscLocalConfigurationManager.py

  Returns the current meta-configuration applied to the computer. Similar to the cmdlet
  [Get-DSCLocalConfigurationManager][L06] cmdlet.

  `# sudo ./GetDscLocalConfigurationManager.py`

- InstallModule.py

  Installs a custom DSC resource module. Requires the path to a .zip file containing the module
  shared object library and schema MOF files.

  `# sudo ./InstallModule.py /tmp/cnx_Resource.zip`

- RemoveModule.py

  Removes a custom DSC resource module. Requires the name of the module to remove.

  `# sudo ./RemoveModule.py cnx_Resource`

- StartDscLocalConfigurationManager.py

  Applies a configuration MOF file to the computer. Similar to the [Start-DscConfiguration][L08]
  cmdlet. Requires the path to the configuration MOF to apply.

  `# sudo ./StartDscLocalConfigurationManager.py -configurationmof /tmp/localhost.mof`

- SetDscLocalConfigurationManager.py

  Applies a Meta Configuration MOF file to the computer. Similar to the
  [Set-DSCLocalConfigurationManager][L07]
  cmdlet. Requires the path to the Meta Configuration MOF to apply.

  `# sudo ./SetDscLocalConfigurationManager.py -configurationmof /tmp/localhost.meta.mof`

## PowerShell Desired State Configuration for Linux Log Files

The following log files are generated for DSC for Linux messages.

|     Log file      |     Directory      |                                               Description                                                |
| ----------------- | ------------------ | -------------------------------------------------------------------------------------------------------- |
| **omiserver.log** | `/var/opt/omi/log` | Messages relating to the operation of the OMI CIM server.                                                |
| **dsc.log**       | `/var/opt/omi/log` | Messages relating to the operation of the Local Configuration Manager (LCM) and DSC resource operations. |

<!-- link references -->
[L01]: ../pull-server/pullServer.md
[L02]: https://github.com/Microsoft/omi
[L03]: https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/tag/v1.2.1-0
[L04]: xref:CimCmdlets.New-CimSession
[L05]: xref:PSDesiredStateConfiguration.Get-DscConfiguration
[L06]: xref:PSDesiredStateConfiguration.Get-DscLocalConfigurationManager
[L07]: xref:PSDesiredStateConfiguration.Set-DscLocalConfigurationManager
[L08]: xref:PSDesiredStateConfiguration.Start-DscConfiguration
[L09]: xref:PSDesiredStateConfiguration.Test-DscConfiguration

<!-- END OF TABS -->
---
