---
ms.date: 07/08/2020
keywords:  dsc,powershell,configuration,setup
title:  Get-Test-Set
description: This article illustrates how to implement the Get, Test, and Set methods in a DSC Configuration.
---

# Get-Test-Set

>Applies To: Windows PowerShell 4.0, Windows PowerShell 5.0

PowerShell Desired State Configuration is constructed around a **Get**, **Test**, and **Set**
process. DSC [resources](resources.md) each contains methods to complete each of these operations.
In a [Configuration](../configurations/configurations.md), you define resource blocks to fill in
keys that become parameters for a resource's **Get**, **Test**, and **Set** methods.

This is the syntax for a **Service** resource block. The **Service** resource configures Windows
services.

```syntax
Service [String] #ResourceName
{
    Name = [string]
    [BuiltInAccount = [string]{ LocalService | LocalSystem | NetworkService }]
    [Credential = [PSCredential]]
    [Dependencies = [string[]]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [DisplayName = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Path = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [StartupType = [string]{ Automatic | Disabled | Manual }]
    [State = [string]{ Running | Stopped }]
}
```

The **Get**, **Test**, and **Set** methods of the **Service** resource will have parameter blocks
that accept these values.

```powershell
param
(
    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $Name,

    [System.String]
    [ValidateSet("Automatic", "Manual", "Disabled")]
    $StartupType,

    [System.String]
    [ValidateSet("LocalSystem", "LocalService", "NetworkService")]
    $BuiltInAccount,

    [System.Management.Automation.PSCredential]
    [ValidateNotNull()]
    $Credential,

    [System.String]
    [ValidateSet("Running", "Stopped")]
    $State="Running",

    [System.String]
    [ValidateNotNullOrEmpty()]
    $DisplayName,

    [System.String]
    [ValidateNotNullOrEmpty()]
    $Description,

    [System.String]
    [ValidateNotNullOrEmpty()]
    $Path,

    [System.String[]]
    [ValidateNotNullOrEmpty()]
    $Dependencies,

    [System.String]
    [ValidateSet("Present", "Absent")]
    $Ensure="Present"
)
```

> [!NOTE]
> The language and method used to define the resource determines how the **Get**, **Test**, and
> **Set** methods will be defined.

Because the **Service** resource only has one required key (`Name`), a **Service** block resource
could be as simple as this:

```powershell
Configuration TestConfig
{
    Import-DSCResource -Name Service
    Node localhost
    {
        Service "MyService"
        {
            Name = "Spooler"
        }
    }
}
```

When you compile the Configuration above, the values you specify for a key are stored in the `.mof`
file that is generated. For more information, see [MOF](/windows/desktop/wmisdk/managed-object-format--mof-).

```
instance of MSFT_ServiceResource as $MSFT_ServiceResource1ref
{
SourceInfo = "::5::1::Service";
 ModuleName = "PsDesiredStateConfiguration";
 ResourceID = "[Service]MyService";
 Name = "Spooler";

ModuleVersion = "1.0";

 ConfigurationName = "Test";

};
```

When applied, the Local Configuration Manager (LCM) will read the value "Spooler" from the `.mof`
file, and pass it to the **Name** parameter of the **Get**, **Test**, and **Set** methods for the
"MyService" instance of the **Service** resource.

## Get

The **Get** method of a resource, retrieves the state of the resource as it is configured on the
machine. This state is returned as a
[hashtable](/powershell/module/microsoft.powershell.core/about/about_hash_tables). The keys of the
**hashtable** will be the configurable values, or parameters, the resource accepts.

This is sample output from calling `Invoke-DscResource` with the **Get** method for a **Service**
resource that configures the "Spooler" service.

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

You can inspect a DSC resource to see what properties it can manage with the `Get-DscResource`
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

## Test

The **Test** method of a resource determines if the target node is currently compliant with the
resource's _desired state_. The **Test** method returns `$true` or `$false` only to indicate whether
the Node is compliant.

This is sample output from calling `Invoke-DscResource` with the **Test** method for a **Service**
resource that configures the "Spooler" service and expects the service to be `Stopped`.

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
> **InDesiredState** property. While the DSC resource's **Test** method returns a **Boolean**,
> `Invoke-DscResource -Method Test` always returns an **InvokeDscResourceTestResult** object.

## Set

The **Set** method of a resource attempts to force the machine to become compliant with the
resource's _desired state_. The **Set** method is meant to be _idempotent_, which means that **Set**
could be run multiple times and always get the same result without errors.

However, resource may not be idempotent. To reduce the chances of errors and side effects, you
should always call `Invoke-DscResource` with the **Test** method first. Then, if the command and
only call it with the **Set** method if **Test** returns `$false`.

This is sample output from calling `Invoke-DscResource` with the **Set** method for a **Service**
resource that configures the "Spooler" service and enforces the service to be `Stopped`.

```powershell
$DscParameters = @{
    Name = 'Service'
    ModuleName = 'PSDscResources'
    Property = @{
        Name = 'Spooler'
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

- [Azure Automation DSC Overview](/azure/automation/automation-dsc-overview)
