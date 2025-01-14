---
ms.date: 03/09/2024
keywords:  dsc,powershell,configuration,setup
title:  Get started with Desired State Configuration (DSC) for Linux
description: This topic explains how to get started using PowerShell Desired State Configuration (DSC) for Linux.
---
# Get started with Desired State Configuration (DSC) for Linux

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
