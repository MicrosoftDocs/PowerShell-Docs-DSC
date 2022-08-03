---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,service,setup
title:  Write and compile a Configuration
description: >
  This exercise walks through creating and compiling a DSC Configuration from start to finish. In
  the following example, you will learn how to write and compile a minimal Configuration
---
# Write and compile a Configuration

> Applies To: PowerShell 7.2

This exercise walks through creating and compiling a Desired State Configuration (DSC) Configuration
from start to finish. In the following example, you will learn how to write and compile a minimal
Configuration. The Configuration will ensure a `DscTest` registry key exists on your local machine.

For an overview of what DSC is and how it works, see [Desired State Configuration 2.0][1].

## Requirements

To run this example, you need a Windows computer running PowerShell 7.2 or later.

## Write the configuration

A DSC [Configuration][2] is a type of PowerShell code that defines how you want to configure
one or more target computers (nodes).

In the VS Code, or another PowerShell editor, type the following:

```powershell
configuration Example {
    # Import the module that contains the Registry resource.
    Import-DscResource -ModuleName PSDscResources

    # The Node statement specifies which targets to compile MOF files for, when
    # this configuration is executed.
    Node 'localhost' {
        # The registry resource can ensure the state of registry keys
        registry DscTest {
            Key       = 'HKEY_CURRENT_USER\DscTest'
            ValueName = 'Example'
            Ensure    = 'Present'
            ValueData = 'Test Value'
            ValueType = 'String'
        }
    }
}
```

> [!IMPORTANT]
> In more advanced scenarios where multiple modules need to be imported so you can work with many
> DSC Resources in the same configuration, make sure to put each module in a separate line using
> `Import-DscResource`. This is easier to maintain in source control and required when working with
> DSC in Azure State Configuration.
>
> <!-- Required for guest configuration too? Can Azure State Configuration use v2? -->
>
> ```powershell
>  Configuration Example {
>
>   # Import the module that contains the File resource.
>   Import-DscResource -ModuleName PSDscResources
>   Import-DscResource -ModuleName xWebAdministration
>
> ```

Save the file as `DscExample.ps1`.

Defining a Configuration is like defining a function. The `Node` block specifies the target node
to be configured, in this case `localhost`.

The configuration calls one [resources][3], the `Registry` resource. Resources do the work
of ensuring that the target node is in the state defined by the configuration.

## Compile the configuration

Calling the Configuration compiles one `.mof` file for every node defined by the `Node` block. In
order to run the configuration, you need to _dot source_ your `DscExample.ps1` script into the
current scope. For more information, see [about_Scripts][4].

<!-- markdownlint-disable MD038 -->
_Dot source_ your `DscExample.ps1` script by typing in the path where you stored it, after the `. `
(dot, space). You may then run your configuration by calling it like a function. You could also
invoke the Configuration at the bottom of the script so that you don't need to dot-source.
<!-- markdownlint-enable MD038 -->

```powershell
. C:\Scripts\DscExample.ps1
Example
```

This generates the following output:

```Output
    Directory: C:\code\dsc\Example

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           7/21/2022  5:23 PM           1048 localhost.mof
```

<!--
    If we're going to have these sections, they need to be for guest configuration specifically.
    I don't see another use case to document here since there's no way to _apply_ configurations
    directly anymore.

    ## Apply the configuration

    ## Test the configuration

    ## Re-applying the configuration
-->

## Next steps

- Find out more about DSC configurations at [DSC configurations][2].
- See what DSC resources are available, and how to create custom DSC resources at
  [DSC resources][3].
- Find DSC configurations and resources in the [PowerShell Gallery][5].

<!-- Reference Links -->

[1]: ../overview.md
[2]: configurations.md
[3]: ../resources/resources.md
[4]: /powershell/module/microsoft.powershell.core/about/about_scripts#script-scope-and-dot-sourcing
[5]: https://www.powershellgallery.com/
