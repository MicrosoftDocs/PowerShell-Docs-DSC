---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,setup
title:  Using Import-DSCResource
description: >
  Import-DSCResource is a dynamic keyword that can only be used inside a Configuration block. It is
  used to import the resource modules needed in your DSC Configuration.
---

# Using Import-DSCResource

`Import-DSCResource` is a dynamic keyword, which can only be used inside a `configuration` block to
import any resources needed in your DSC Configuration. DSC Resources under `$PSHOME` are imported
automatically, but it's best practice to explicitly import all DSC Resources used in your
[DSC Configuration][1].

The syntax for `Import-DSCResource` is shown below. When specifying modules by name, it's required
to list each on a new line.

```syntax
Import-DscResource [-Name <ResourceName(s)>]
 [-ModuleName <ModuleName>]
 [-ModuleVersion <ModuleVersion>]
```

Parameters

- **Name** - The Resources that you must import. If the module name is specified, the command
  searches for these DSC Resources within that module; otherwise the command searches the DSC
  Resources in all modules. Wildcards are supported.
- **ModuleName** - The module name or module specification. If you specify DSC Resources to import
  from a module, the command tries to import only those DSC Resources. If you specify the module
  only, the command imports all the DSC Resources in the module.
- **ModuleVersion** - You can specify the version of a module a configuration should use with this
  parameter. By default, the latest available version of the DSC Resource is imported.

```powershell
Import-DscResource -ModuleName xActiveDirectory
```

## Example: Use Import-DSCResource within a DSC Configuration

```powershell
Configuration MSDSCConfiguration {
    # Search for and imports three DSC Resources from the xPSDesiredStateConfiguration module.
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration -Name Service, RemoteFile, Registry

    # Search for and import Resource1 from the module that defines it.
    # If only -Name parameter is used then resources can belong to different PowerShell modules as well.
    # TimeZone resource is from the ComputerManagementDSC module which is not installed by default.
    # As a best practice, list each requirement on a different line if possible.  This makes reviewing
    # multiple changes in source control a bit easier.
    Import-DSCResource -Name Registry
    Import-DSCResource -Name TimeZone

    # Search for and import all DSC resources inside the Module xPSDesiredStateConfiguration.
    # When specifying the ModuleName parameter, it is a requirement to list each on a new line.
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    # You can specify a ModuleVersion parameter
    Import-DSCResource -ModuleName ComputerManagementDsc -ModuleVersion 6.0.0.0
...
```

> [!NOTE]
> Specifying multiple values for DSC Resource names and modules names in same command isn't
> supported. It can have non-deterministic behavior about which DSC Resource to load from which
> module if the same DSC Resource exists in multiple modules. The command below returns an in error
> during compilation.
>
> ```powershell
> Import-DscResource -Name UserConfigProvider*,TestLogger1 -ModuleName UserConfigProv,PsModuleForTestLogger
> ```

Things to consider when using only the **Name** parameter:

- It's a resource-intensive operation depending on the number of modules installed on the machine.
- It loads the first DSC Resource found with the given name. If there is more than one DSC Resource
  with same name installed, it could load the wrong DSC Resource.

The recommended usage is to specify **ModuleName** with the **Name** parameter, as described below.

This usage has the following benefits:

- It reduces the performance impact by limiting the search scope for the specified DSC Resource.
- It explicitly defines the module providing the DSC Resource, ensuring the correct DSC Resource is
  loaded.

> [!NOTE]
> DSC resources can have multiple versions, and versions can be installed on a computer
> side-by-side. This is implemented by having multiple versions of a DSC Resource module that are
> contained in the same module folder.

## IntelliSense with Import-DSCResource

When authoring the DSC Configuration in VS Code, PowerShell provides IntelliSense for DSC Resources
and DSC Resource properties. Resource definitions under the `$PSHOME` module path are loaded
automatically. When you import DSC Resources using the `Import-DSCResource` keyword, the specified
DSC Resource definitions are added and IntelliSense is expanded to include the imported DSC
Resources' schemas.

![IntelliSense in VS Code for a DSC Resource][3]

When compiling the DSC Configuration, PowerShell uses the imported DSC Resource definitions to
validate the DSC Resource blocks in the `Configuration` block. Each DSC Resource block is validated
by the DSC Resource's schema definition, for the following rules:

- Only properties defined in schema are specified.
- The data types for each property are correct.
- Keys properties are specified.
- No read-only property is specified.

Consider the following DSC Configuration:

```powershell
Configuration SchemaValidationInCorrectEnumValue {
    Import-DSCResource -Name WindowsFeature -Module PSDscResources

    WindowsFeature ROLE1 {
        Name   = 'Telnet-Client'
        Ensure = 'Invalid'
    }
}
```

Compiling this DSC Configuration results in an error.

```Output
Write-Error: C:\code\dsc\Sample.ps1:4
Line |
   4 |          WindowsFeature ROLE1
     |          ~~~~~~~~~~~~~~
     | At least one of the values 'Invalid' is not supported or valid for property
     | 'Ensure' on class 'WindowsFeature'. Please specify only supported values:
     | Present, Absent.

InvalidOperation: Errors occurred while processing configuration 'SchemaValidationInCorrectEnumValue'.
```

IntelliSense and schema validation allow you to catch more errors during parse and compilation time,
avoiding future complications.

> [!NOTE]
> Each DSC Resource can have a name and a **FriendlyName** defined by the DSC Resource's schema.
> Below are the first two lines of `MSFT_ServiceResource.shema.mof`.
>
> ```syntax
> [ClassVersion("1.0.0"),FriendlyName("Service")]
> class MSFT_ServiceResource : OMI_BaseResource
> ```
>
> When using this DSC Resource in a `Configuration` block, you can specify **MSFT_ServiceResource**
> or **Service**.

## See also

- [Resources][4]

<!-- Reference Links -->

[1]: configurations.md
[3]: media/import-dscresource/resource-intellisense.png
[4]: resources.md
