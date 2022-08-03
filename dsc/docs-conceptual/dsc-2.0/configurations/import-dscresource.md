---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Using Import-DSCResource
description: >
  Import-DSCResource is a dynamic keyword that can only be used inside a Configuration script block.
  It is used to import the resource modules needed in your Configuration.
---

# Using Import-DSCResource

`Import-DSCResource` is a dynamic keyword, which can only be used inside a `configuration` script
block to import any resources needed in your Configuration. Resources under `$PSHOME` are imported
automatically, but it is best practice to explicitly import all resources used in your
[Configuration][1].

The syntax for `Import-DSCResource` is shown below. When specifying modules by name, it is a
requirement to list each on a new line.

```syntax
Import-DscResource [-Name <ResourceName(s)>]
 [-ModuleName <ModuleName>]
 [-ModuleVersion <ModuleVersion>]
```

Parameters

- **Name** - The DSC resource name(s) that you must import. If the module name is specified, the
  command searches for these DSC resources within that module; otherwise the command searches the
  DSC resources in all DSC resource paths. Wildcards are supported.
- **ModuleName** - The module name or module specification. If you specify resources to import from
  a module, the command will try to import only those resources. If you specify the module only, the
  command imports all the DSC resources in the module.
- **ModuleVersion** - You can specify which version of a module a configuration should use. For more
  information, see [Import a specific version of an installed resource][2].

```powershell
Import-DscResource -ModuleName xActiveDirectory
```

## Example: Use Import-DSCResource within a configuration

```powershell
configuration MSDSCConfiguration {
    # Search for and imports Service, File, and Registry from the module xPSDesiredStateConfiguration.
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration -Name Service, File, Registry

    # Search for and import Resource1 from the module that defines it.
    # If only -Name parameter is used then resources can belong to different PowerShell modules as well.
    # TimeZone resource is from the ComputerManagementDSC module which is not installed by default.
    # As a best practice, list each requirement on a different line if possible.  This makes reviewing
    # multiple changes in source control a bit easier.
    Import-DSCResource -Name File
    Import-DSCResource -Name TimeZone

    # Search for and import all DSC resources inside the Module xPSDesiredStateConfiguration.
    # When specifying the ModuleName parameter, it is a requirement to list each on a new line.
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    # In PowerShell 5.0 and later, you can specify a ModuleVersion parameter
    Import-DSCResource -ModuleName ComputerManagementDsc -ModuleVersion 6.0.0.0
...
```

> [!NOTE]
> Specifying multiple values for resource names and modules names in same command is not supported.
> It can have non-deterministic behavior about which resource to load from which module if the same
> resource exists in multiple modules. The command below returns an in error during compilation.
>
> ```powershell
> Import-DscResource -Name UserConfigProvider*,TestLogger1 -ModuleName UserConfigProv,PsModuleForTestLogger
> ```

Things to consider when using only the **Name** parameter:

- It is a resource-intensive operation depending on the number of modules installed on machine.
- It loads the first resource found with the given name. If there is more than one resource with
  same name installed, it could load the wrong resource.

The recommended usage is to specify **ModuleName** with the **Name** parameter, as described below.

This usage has the following benefits:

- It reduces the performance impact by limiting the search scope for the specified resource.
- It explicitly defines the module providing the resource, ensuring the correct resource is loaded.

> [!NOTE]
> DSC resources can have multiple versions, and versions can be installed on a computer
> side-by-side. This is implemented by having multiple versions of a resource module that are
> contained in the same module folder. For more information, see
> [Using resources with multiple versions][2].

## IntelliSense with Import-DSCResource

When authoring the DSC configuration in VS Code, PowerShell provides IntelliSense for resources and
resource properties. Resource definitions under the `$PSHOME` module path are loaded automatically.
When you import resources using the `Import-DSCResource` keyword, the specified resource definitions
are added and IntelliSense is expanded to include the imported resources' schemas.

![IntelliSense in VS Code for a DSC Resource][3]

When compiling the Configuration, PowerShell uses the imported resource definitions to validate all
resource blocks in the Configuration. Each resource block is validated by the resource's schema
definition, for the following rules:

- Only properties defined in schema are specified.
- The data types for each property are correct.
- Keys properties are specified.
- No read-only property is specified.

Consider the following configuration:

```powershell
configuration SchemaValidationInCorrectEnumValue {
    Import-DSCResource -Name WindowsFeature -Module PSDscResources

    Node localhost {
        WindowsFeature ROLE1 {
            Name   = 'Telnet-Client'
            Ensure = 'Invalid'
        }
    }
}
```

Compiling this Configuration results in an error.

```Output
Write-Error: C:\code\dsc\Sample.ps1:6
Line |
   6 |          WindowsFeature ROLE1
     |          ~~~~~~~~~~~~~~
     | At least one of the values 'Invalid' is not supported or valid for property
     | 'Ensure' on class 'WindowsFeature'. Please specify only supported values:
     | Present, Absent.

InvalidOperation: Errors occurred while processing configuration 'SchemaValidationInCorrectEnumValue'.
```

IntelliSense and schema validation allow you to catch more errors during parse and compilation time,
avoiding future complications.

> [!NOTE]
> Each DSC resource can have a name and a **FriendlyName** defined by the resource's schema. Below
> are the first two lines of "MSFT_ServiceResource.shema.mof".
>
> ```syntax
> [ClassVersion("1.0.0"),FriendlyName("Service")]
> class MSFT_ServiceResource : OMI_BaseResource
> ```
>
> When using this resource in a Configuration, you can specify **MSFT_ServiceResource** or
> **Service**.

## See also

- [Resources][4]

<!-- Reference Links -->

[1]: Configurations.md
[2]: sxsresource.md
[3]: media/import-dscresource/resource-intellisense.png
[4]: ../resources/resources.md
