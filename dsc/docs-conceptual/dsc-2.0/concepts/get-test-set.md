---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,setup
title:  Get-Test-Set
description: >
  This article illustrates how to implement the Get, Test, and Set methods in a DSC Configuration.
---

# Get-Test-Set

> Applies To: PowerShell 7.2

DSC is constructed around a **Get**, **Test**, and **Set** process. [DSC Resources][1] are
implemented to complete each of these operations. In a [DSC Configuration][2], you define DSC Resource
blocks to fill in properties that define the desired state for that DSC Resource.

You can inspect a DSC Resource to see the properties it can manage with the `Get-DscResource`
cmdlet.

```powershell
Get-DscResource -Name Service -Module PSDscResources -OutVariable Resource
$Resource.Properties
```

```Output
ImplementationDetail : ScriptBased
ResourceType         : MSFT_ServiceResource
Name                 : Service
FriendlyName         : Service
Module               : PSDscResources
ModuleName           : PSDscResources
Version              : 2.12.0.0
Path                 : C:\Program Files\PowerShell\Modules\PSDscResources\2.12.0.0\DscResources\MSFT_ServiceResource\MSFT_ServiceResource.psm1
ParentPath           : C:\Program Files\PowerShell\Modules\PSDscResources\2.12.0.0\DscResources\MSFT_ServiceResource
ImplementedAs        : PowerShell
CompanyName          : Microsoft Corporation
Properties           : {Name, BuiltInAccount, Credential, Dependencies…}

Name                 PropertyType   IsMandatory Values
----                 ------------   ----------- ------
Name                 [string]              True {}
BuiltInAccount       [string]             False {LocalService, LocalSystem, NetworkService}
Credential           [PSCredential]       False {}
Dependencies         [string[]]           False {}
DependsOn            [string[]]           False {}
Description          [string]             False {}
DesktopInteract      [bool]               False {}
DisplayName          [string]             False {}
Ensure               [string]             False {Absent, Present}
Path                 [string]             False {}
PsDscRunAsCredential [PSCredential]       False {}
StartupTimeout       [UInt32]             False {}
StartupType          [string]             False {Automatic, Disabled, Manual}
State                [string]             False {Ignore, Running, Stopped}
TerminateTimeout     [UInt32]             False {}
```

## Get

The **Get** method of a DSC Resource retrieves the current state of that DSC Resource on the system.
This state is returned as a [hashtable][4]. The keys of the **hashtable** are the resource's
properties.

This is sample output from calling `Invoke-DscResource` with the **Get** method for the `Service`
DSC Resource to inspect the `Spooler` service's current state.

```powershell
$DscGetParameters = @{
    Name       = 'Service'
    ModuleName = 'PSDscResources'
    Method     = 'Get'
    Property   = @{
        Name = 'Spooler'
    }
}
Invoke-DscResource @DscGetParameters
```

```output
Name                           Value
----                           -----
State                          Running
Path                           C:\Windows\System32\spoolsv.exe
StartupType                    Automatic
Name                           Spooler
BuiltInAccount                 LocalSystem
DisplayName                    Print Spooler
Dependencies                   {RPCSS, http}
DesktopInteract                True
Ensure                         Present
Description                    This service spools print jobs and handles interaction with the printer.  If you turn of…
```

## Test

The **Test** method of a DSC Resource determines if the system's current state matches the desired
state. The **Test** method returns `$true` or `$false` to note whether the system is compliant.

This is sample output from calling `Invoke-DscResource` with the **Test** method for the `Service`
DSC Resource to check whether the `Spooler` service is stopped.

```powershell
$DscTestParameters = @{
    Name       = 'Service'
    ModuleName = 'PSDscResources'
    Method     = 'Test'
    Property   = @{
        Name  = 'Spooler'
        State = 'Stopped'
    }
}
Invoke-DscResource @DscTestParameters
```

```Output
InDesiredState
--------------
         False
```

> [!IMPORTANT]
> Notice that instead of returning a **Boolean** value directly, it returned an object with the
> **InDesiredState** property. While a DSC Resource's **Test** method or `Test-TargetResource`
> function returns a **Boolean**, `Invoke-DscResource -Method Test` always returns an
> **InvokeDscResourceTestResult** object.

## Set

The **Set** method of a DSC Resource attempts to force the system to enforce the desired state.

The **Set** method should be _idempotent_, which means that you can use it multiple times and always
get the same result without errors. However, a DSC Resource may not be idempotent. To reduce the
chances of errors and side effects, always use `Invoke-DscResource` with the **Test** method first.
Then, only use `Invoke-DscResource` with the **Set** method if **Test** returned `$false`.

This is sample output from using `Invoke-DscResource` with the **Set** method for the `Service` DSC
Resource to ensure the `Spooler` service is stopped.

```powershell
$DscParameters = @{
    Name       = 'Service'
    ModuleName = 'PSDscResources'
    Property   = @{
        Name  = 'Spooler'
        State = 'Stopped'
    }
}

Invoke-DscResource -Method Test @DscParameters -OutVariable TestResult

if (!$TestResult.InDesiredState) {
    Invoke-DscResource -Method Set @DscParameters
}
```

```Output
InDesiredState
--------------
         False

RebootRequired
--------------
         False
```

When you use `Invoke-DscResource` with the **Set** method, it returns an
**InvokeDscResourceSetResult** object with the **RebootRequired** property. In this example, no
reboot is required.

## See also

- [Azure Automation DSC Overview][5]

<!-- Reference Links -->

[1]: resources.md
[2]: configurations.md
[3]: /windows/desktop/wmisdk/managed-object-format--mof-
[4]: /powershell/module/microsoft.powershell.core/about/about_hash_tables
[5]: /azure/automation/automation-dsc-overview
