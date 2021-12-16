---
description: DSC configurations are PowerShell scripts that define a special type of function.
ms.date: 12/16/2021
title: DSC Configurations
---
# Configurations

DSC configurations are PowerShell scripts that define a special type of function. To define a
configuration, you use the PowerShell keyword **Configuration**.

```powershell
Configuration MyDscConfiguration {
  Import-DscResource -ModuleName 'PSDscResources'
  WindowsFeature MyFeatureInstance {
    Ensure = 'Present'
    Name   = 'RSAT'
  }
}
MyDscConfiguration
```

Save the script as a `.ps1` file.

## Configuration syntax

A configuration script consists of the following parts:

- The **Configuration** block. This is the outermost script block. You define it using the
  **Configuration** keyword and providing a name. In this case, the name of the configuration is
  `MyDscConfiguration`.
- One or more resource blocks. This is where the configuration sets the properties for the resources
  that it is configuring. In this case, there are two resource blocks, each of which call the
  **WindowsFeature** resource.

Within a **Configuration** block, you can do anything that you normally could in a PowerShell
function. For example, in the previous example, if you didn't want to hard code the name of the
Windows feature in the configuration, you could add a parameter.

In this example, you specify the name of the feature by passing it as the **WindowsFeature**
parameter when you compile the configuration. The name defaults to "RSAT".

```powershell
Configuration MyDscConfiguration
{
  param
  (
    [string[]]
    $WindowsFeature='RSAT'
  )
  Import-DscResource -ModuleName 'PSDscResources'
  WindowsFeature MyFeatureInstance
  {
    Ensure = 'Present'
    Name   = $WindowsFeature
  }
}
MyDscConfiguration
```

## Compiling the configuration

Before you can enact a configuration, you have to compile it into a MOF document. You do this by
calling the configuration like you would call a PowerShell function. The last line of the example
containing only the name of the configuration, calls the configuration.

When you call the configuration, it:

- Resolves all variables
- Creates a folder in the current directory with the same name as the configuration.
- Creates a file named _localhost.mof_ in the new directory.

> [!NOTE]
> The MOF file contains all of the configuration information for the target node.
> Because of this, it's important to keep it secure.

Compiling the first configuration above results in the following folder structure:

```powershell
. .\MyDscConfiguration.ps1
MyDscConfiguration
```

```output
    Directory: C:\users\default\Documents\DSC Configurations\MyDscConfiguration

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       10/23/2015   4:32 PM           2842 localhost.mof
```

If the configuration takes a parameter, as in the second example, The parameter must be provided at
compile time. Here's how that would look:

```powershell
. .\MyDscConfiguration.ps1
MyDscConfiguration -WindowsFeature 'Telnet-Client'
```

## Importing resources in your configuration

`Import-DscResource` is a dynamic keyword that can only be recognized within a **Configuration**
block, it is not a cmdlet. `Import-DscResource` supports the following parameters:

- **Name**: The DSC resource name(s) that you must import. If the module name is specified, the
  command searches for these DSC resources within this module. Otherwise, the command searches the
  DSC resources in all DSC resource paths. Wildcards are supported.
- **ModuleName**: The module name, or module specification. If you specify resources to import from
  a module, the command tries to import only those resources. If you specify the module only, the
  command imports all the DSC resources in the module.
- **ModuleVersion**: You can specify which version of a module a configuration should use.

## See Also

- [DSC Resources](resources.md)
