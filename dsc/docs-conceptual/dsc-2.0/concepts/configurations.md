---
description: >
  DSC configurations are PowerShell scripts that define a special kind of command.
ms.date: 01/06/2023
title:  DSC Configurations
---

# DSC Configurations

> Applies To: PowerShell 7, Azure machine configuration

DSC Configurations are PowerShell scripts that define a special kind of command. To define a
Configuration, use the PowerShell keyword `configuration`.

```powershell
Configuration MyDscConfiguration {
    Environment FirstEnvironmentVariable {
        Ensure = 'Present'
        Name   = 'Foo'
        Value  = 'Example'
    }

    Environment SecondEnvironmentVariable {
        Ensure = 'Present'
        Name   = 'Bar'
        Value  = 'Another'
    }
}

MyDscConfiguration
```

Save the script as a `.ps1` file.

## Configuration syntax

A DSC Configuration script consists of the following parts:

- The `Configuration` block. This is the outermost script block. You define it with the
  `Configuration` keyword and provide a name. In this case, the name of the DSC Configuration is
  `MyDscConfiguration`.
- One or more DSC Resource blocks. This is where the DSC Configuration defines the settings for the
  component it's configuring. In this case, there are two DSC Resource blocks. They both use the
  `Environment` DSC Resource.

## Compiling the configuration

Before you can use a DSC Configuration, you have to compile it into a MOF document. You do this by
calling the DSC Configuration like you would call a PowerShell function. The last line of the
example, containing only the name of the DSC Configuration, executes the DSC Configuration.

> [!NOTE]
> To call a DSC Configuration, it must be loaded in the current scope (as with any other PowerShell
> function). You can make this happen either by "dot-sourcing" the script, or by running the script
> with <kbd>F5</kbd> or clicking on the **Run Script** button in VS Code. To dot-source the script,
> run the command `. .\myConfig.ps1` where `myConfig.ps1` is the name of the script file that
> contains your DSC Configuration.

When you call the DSC Configuration, it:

- Creates a folder in the current directory with the same name as the DSC Configuration.
- Creates a file named `localhost.mof` in the new directory.

> [!NOTE]
> The MOF file contains all the configuration information for the system. Because of this,
> it's important to keep it secure.

## Using new DSC Resources in your DSC Configuration

If you ran the previous examples, you might have noticed that you were warned that you were using a
resource without explicitly importing it.

You can use the [Get-DscResource][1] cmdlet to determine what resources are installed on the
system and available for use. Even when their modules have been placed in `$env:PSModulePath` and
are recognized by `Get-DscResource`, they still need to be loaded within your DSC Configuration.

`Import-DscResource` is a dynamic keyword that can only be recognized within a `Configuration`
block. It's not a cmdlet. `Import-DscResource` supports two parameters:

- **ModuleName** is the recommended way of using `Import-DscResource`. It accepts the name of the
  module that contains the resources to be imported (as well as a string array of module names).
- **Name** is the name of the resource to import. This isn't the friendly name returned as the
  **Name** property of `Get-DscResource`'s return object, but the class name used when defining the
  resource schema (the **ResourceType** property of the object returned by `Get-DscResource`).

For more information on using `Import-DSCResource`, see [Using Import-DSCResource][2]

> [!IMPORTANT]
> There's a limitation in machine configuration that prevents a DSC Resource from using any
> PowerShell cmdlets not included in PowerShell itself or in a module on the PowerShell Gallery.
> DSC Resources that use cmdlets from one or more [Windows modules][3] won't work in machine
> configuration.

## See Also

- [Desired State Configuration 2.0][4]
- [DSC Resources][5]

<!-- Reference Links -->

[1]: /powershell/module/PSDesiredStateConfiguration/Get-DscResource
[2]: import-dscresource.md
[3]: /powershell/windows/module-compatibility#module-list
[4]: ../overview.md
[5]: resources.md
