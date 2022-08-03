---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  DSC Configurations
description: >
  DSC configurations are PowerShell scripts that define a special type of function.
---
# DSC Configurations

> Applies To: PowerShell 7.2

DSC Configurations are PowerShell scripts that define a special type of function. To define a
Configuration, you use the PowerShell keyword `configuration`.

```powershell
configuration MyDscConfiguration {
    Node "TEST-PC1" {
        WindowsFeature MyFeatureInstance {
            Ensure = 'Present'
            Name = 'RSAT'
        }
        WindowsFeature My2ndFeatureInstance {
            Ensure = 'Present'
            Name = 'Bitlocker'
        }
    }
}
MyDscConfiguration
```

Save the script as a `.ps1` file.

## Configuration syntax

A configuration script consists of the following parts:

- The Configuration block. This is the outermost script block. You define it by using the
  `configuration` keyword and providing a name. In this case, the name of the Configuration is
  `MyDscConfiguration`.
- One or more **Node** blocks. These define the nodes (computers or VMs) that you are configuring.
  In the above configuration, there is one **Node** block that targets a computer named `TEST-PC1`.
  The **Node** block can accept multiple computer names.
- One or more resource blocks. This is where the configuration sets the properties for the resources
  that it is configuring. In this case, there are two resource blocks, each of which call the
  **WindowsFeature** resource.

> [!NOTE]
> The **WindowsFeature** DSC Resource is only available on Windows Server computers. For computers
> with a client OS, like Windows 11, you need to use **WindowsOptionalFeature** instead. For more
> information, see
> [the "WindowsOptionalFeature" in the PSDscResources documentation][1].

Within a Configuration block, you can do anything that you normally could in a PowerShell
function. In the previous example, if you didn't want to hard code the name of the target computer
in the Configuration, you could add a parameter for the node name.

In this example, you specify the name of the node by passing it as the **ComputerName** parameter
when you compile the configuration. The name defaults to `localhost`.

```powershell
configuration MyDscConfiguration {
    param (
        [string[]]$ComputerName='localhost'
    )

    Node $ComputerName {
        WindowsFeature MyFeatureInstance {
            Ensure = 'Present'
            Name   = 'RSAT'
        }

        WindowsFeature My2ndFeatureInstance {
            Ensure = 'Present'
            Name   = 'Bitlocker'
        }
    }
}

MyDscConfiguration
```

The **Node** block can also accept multiple computer names. In the above example, you can either use
the **ComputerName** parameter, or pass a comma-separated list of computers directly to the **Node**
block.

```powershell
MyDscConfiguration -ComputerName "localhost", "Server01"
```

When specifying a list of computers to the **Node** block from within a **Configuration**, you need
to use array-notation.

```powershell
configuration MyDscConfiguration {
    Node @('localhost', 'Server01') {
        WindowsFeature MyFeatureInstance {
            Ensure = 'Present'
            Name   = 'RSAT'
        }

        WindowsFeature My2ndFeatureInstance {
            Ensure = 'Present'
            Name   = 'Bitlocker'
        }
    }
}

MyDscConfiguration
```

## Compiling the configuration

Before you can use a Configuration, you have to compile it into a MOF document. You do this by
calling the Configuration like you would call a PowerShell function. The last line of the example
containing only the name of the configuration, calls the configuration.

> [!NOTE]
> To call a Configuration, it must be in global scope (as with any other PowerShell function). You
> can make this happen either by "dot-sourcing" the script, or by running the configuration script
> by using F5 or clicking on the **Run Script** button in VS Code. To dot-source the script, run the
> command `. .\myConfig.ps1` where `myConfig.ps1` is the name of the script file that contains your
> Configuration.

When you call the Configuration, it:

- Resolves all variables
- Creates a folder in the current directory with the same name as the Configuration.
- Creates a file named `<NodeName>.mof` in the new directory, where `<NodeName>` is the name of the
  target node of the configuration. If there is more than one node, PowerShell creates a MOF file
  for each node.

> [!NOTE]
> The MOF file contains all of the configuration information for the target node. Because of this,
> it's important to keep it secure.

Compiling the first Configuration above results in the following folder structure:

```powershell
. .\MyDscConfiguration.ps1
MyDscConfiguration
```

```Output
    Directory: C:\users\default\Documents\DSC Configurations\MyDscConfiguration
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       10/23/2015   4:32 PM           2842 localhost.mof
```

If the Configuration takes a parameter, as in the second example, that parameter has to be provided
at compile time. For example:

```powershell
. .\MyDscConfiguration.ps1
MyDscConfiguration -ComputerName 'MyTestNode'
```

```Output
    Directory: C:\users\default\Documents\DSC Configurations\MyDscConfiguration
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       10/23/2015   4:32 PM           2842 MyTestNode.mof
```

## Using new resources in Your configuration

If you ran the previous examples, you might have noticed that you were warned that you were using a
resource without explicitly importing it.

The cmdlet, [Get-DscResource][2], can be used to determine what resources are installed on the
system and available for use. Even when their modules have been placed in `$env:PSModulePath` and
are properly recognized by `Get-DscResource`, they still need to be loaded within your
configuration.

`Import-DscResource` is a dynamic keyword that can only be recognized within a Configuration
block. It is not a cmdlet. `Import-DscResource` supports two parameters:

- **ModuleName** is the recommended way of using `Import-DscResource`. It accepts the name of the
  module that contains the resources to be imported (as well as a string array of module names).
- **Name** is the name of the resource to import. This is not the friendly name returned as the
  **Name** property of `Get-DscResource`'s return object, but the class name used when defining the
  resource schema (the **ResourceType** property of the object returned by `Get-DscResource`).

For more information on using `Import-DSCResource`, see
[Using Import-DSCResource][3]

## See Also

- [PowerShell Desired State Configuration Overview][4]
- [DSC Resources][5]

<!-- Reference Links -->

[1]: https://github.com/PowerShell/PSDscResources#windowsoptionalfeature
[2]: /powershell/module/PSDesiredStateConfiguration/Get-DscResource
[3]: import-dscresource.md
[4]: ../overview.md
[5]: ../resources/resources.md
