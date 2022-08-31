---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,service,setup
title:  Write and compile a DSC Configuration
description: >
  This exercise walks through creating and compiling a DSC Configuration from start to finish. In
  the following example, you will learn how to write and compile a minimal Configuration
---

# Write and compile a DSC Configuration

> Applies To: PowerShell 7.2, Azure Policy's machine configuration feature

This exercise walks through creating and compiling a DSC Configuration from start to finish. In the
following example, you'll learn how to write and compile a minimal DSC Configuration to ensure a
`DscTest` registry key exists on your local machine.

For an overview of what DSC is and how it works, see [Desired State Configuration 2.0][1].

> [!IMPORTANT]
> Starting in DSC 2.0, there is no supported way to use DSC Configurations directly. They're only
> supported for use with [Azure Policy's machine configuration feature][2].

## Requirements

To run this example, you need a Windows computer running PowerShell 7.2 or later.

## Write the configuration

A [DSC Configuration][3] is a kind of PowerShell code that defines how you want to configure a
system.

In the VS Code, or another PowerShell editor, type the following:

```powershell
Configuration Example {
    # Import the module that contains the Registry DSC Resource.
    Import-DscResource -ModuleName PSDscResources

    # The Registry DSC Resource can ensure the state of registry keys
    Registry DscTest {
        Key       = 'HKEY_CURRENT_USER\DscTest'
        ValueName = 'Example'
        Ensure    = 'Present'
        ValueData = 'Test Value'
        ValueType = 'String'
    }
}
```

> [!IMPORTANT]
> In more advanced scenarios where multiple modules need to be imported so you can work with several
> DSC Resources in the same configuration, make sure to put each module in a separate line using
> `Import-DscResource`. This is easier to maintain in source control and required when working with
> DSC in Azure State Configuration.
>
> <!-- Required for machine configuration too? Can Azure State Configuration use v2? -->
>
> ```powershell
>  Configuration Example {
>
>      Import-DscResource -ModuleName PSDscResources
>      Import-DscResource -ModuleName xWebAdministration
>
> ```

Save the file as `DscExample.ps1`.

Defining a DSC Configuration is like defining a function.

This DSC Configuration calls one [DSC Resource][4], the `Registry` DSC Resource. Resources do the
work of ensuring that the system is in the state defined by the DSC Configuration.

## Compile the configuration

Calling the DSC Configuration compiles a `.mof` file. To run the configuration, you need to
_dot source_ your `DscExample.ps1` script into the current scope. For more information, see
[about_Scripts][5].

<!-- markdownlint-disable MD038 -->
_Dot source_ your `DscExample.ps1` script by typing in the path where you stored it, after the `. `
(dot, space). You may then run your DSC onfiguration by calling it like a function. You could also
invoke the DSC Configuration at the bottom of the script so that you don't need to dot-source.
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

## Next steps

- Find out more about DSC Configurations at [DSC Configurations][3].
- Find out more about DSC Resources at [DSC resources][4].
- Find DSC Resources in the [PowerShell Gallery][6].

<!-- Reference Links -->

[1]: ../../overview.md
[2]:  /azure/governance/machine-configuration/overview
[3]: ../../concepts/configurations.md
[4]: ../../concepts/resources.md
[5]: /powershell/module/microsoft.powershell.core/about/about_scripts#script-scope-and-dot-sourcing
[6]: https://www.powershellgallery.com/
