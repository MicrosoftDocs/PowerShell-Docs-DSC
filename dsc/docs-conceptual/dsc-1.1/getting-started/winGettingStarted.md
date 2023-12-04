---
ms.date: 12/04/2023
keywords:  dsc,powershell,configuration,setup
title:  Get started with Desired State Configuration (DSC) for Windows
description: This article explains how to get started using PowerShell Desired State Configuration (DSC) for Windows.
---

# Get started with Desired State Configuration (DSC) for Windows

This article explains how to get started using PowerShell Desired State Configuration (DSC) for
Windows. For general information about DSC, see
[Get Started with Windows PowerShell Desired State Configuration][01].

## Supported Windows operating system versions

The following versions are supported:

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows 11
- Windows 10

The [Microsoft Hyper-V Server][08] standalone product doesn't contain an implementation of Desired
State Configuration so you can't manage it using PowerShell DSC or Azure Automation State
Configuration.

## Installing DSC

PowerShell Desired State Configuration is included in Windows and updated through Windows Management
Framework. The latest version is [Windows Management Framework 5.1][09].

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
[Start-DscConfiguration][06] cmdlet.

```powershell
Start-DscConfiguration -Path 'C:\EnvironmentVariable_Path' -Wait -Verbose
```

#### Get the current state of the configuration

The [Get-DscConfiguration][02] cmdlet queries the current status of the machine and returns the
current values for the configuration.

```powershell
Get-DscConfiguration
```

The [Get-DscLocalConfigurationManager][03] cmdlet returns the current meta-configuration applied to
the machine.

```powershell
Get-DscLocalConfigurationManager
```

#### Remove the current configuration from a machine

The [Remove-DscConfigurationDocument][04]

```powershell
Remove-DscConfigurationDocument -Stage Current -Verbose
```

#### Configure settings in Local Configuration Manager

Apply a Meta Configuration MOF file to the machine using the [Set-DSCLocalConfigurationManager][05]
cmdlet. Requires the path to the Meta Configuration MOF.

```powershell
Set-DSCLocalConfigurationManager -Path 'c:\metaconfig\localhost.meta.mof' -Verbose
```

## Windows PowerShell Desired State Configuration log files

Logs for DSC are written to the `Microsoft-Windows-Dsc/Operational` Windows Event Log. You can
enable other logs for debugging purposes by following the steps in [Where Are DSC Event Logs][07].

<!-- link references -->
[01]: ../overview.md
[02]: /powershell/module/psdesiredstateconfiguration/get-dscconfiguration
[03]: /powershell/module/psdesiredstateconfiguration/get-dscLocalConfigurationManager
[04]: /powershell/module/psdesiredstateconfiguration/remove-dscconfigurationdocument
[05]: /powershell/module/PSDesiredStateConfiguration/Set-DscLocalConfigurationManager
[06]: /powershell/module/psdesiredstateconfiguration/start-dscconfiguration
[07]: /powershell/scripting/dsc/troubleshooting/troubleshooting#where-are-dsc-event-logs
[08]: /windows-server/virtualization/hyper-v/hyper-v-server-2016
[09]: https://www.microsoft.com/download/details.aspx?id=54616
