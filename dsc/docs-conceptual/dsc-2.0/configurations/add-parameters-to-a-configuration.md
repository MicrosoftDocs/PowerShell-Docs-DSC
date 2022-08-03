---
ms.date: 08/01/2022
keywords:  dsc,powershell,resource,gallery,setup
title:  Add parameters to a Configuration
description: >
  DSC Configurations can be parameterized to allow more dynamic configurations based on user input.
---

# Add Parameters to a Configuration

> Applies To: PowerShell 7.2

Like functions, [Configurations][1] can be parameterized to allow more dynamic behavior based
on user input. The steps are similar to the ones in
[Functions with Parameters][2].

This example starts with a basic Configuration that configures the **Spooler** service to be
`Running`.

```powershell
configuration TestConfig {
    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Node localhost {
        Service 'Spooler' {
            Name  = 'Spooler'
            State = 'Running'
        }
    }
}
```

## Built-in Configuration parameters

Unlike a function, the [CmdletBinding][3] attribute adds no functionality. In
addition to [Common Parameters][4], Configurations can also use the following
built-in parameters, without requiring you to define them.

|        Parameter         |                               Description                                |
| ------------------------ | ------------------------------------------------------------------------ |
| **InstanceName**         | Used in defining [Composite Configurations][5]            |
| **DependsOn**            | Used in defining [Composite Configurations][5]            |
| **PSDSCRunAsCredential** | Deprecated. This parameter is no longer supported.                       |
| **ConfigurationData**    | Used to pass in [Configuration Data][6] for the Configuration. |
| **OutputPath**           | Used to specify where compiled MOF files are written                     |

## Adding your own parameters to Configurations

In addition to the built-in parameters, you can add your own parameters to your Configurations.
The `param` block goes directly inside the `configuration` declaration, just like a function. A
Configuration parameter block should be outside any `Node` declarations, and above any `Import-*`
statements. By adding parameters, you can make your Configurations more robust and dynamic.

```powershell
configuration TestConfig {
    param()
}
```

### Add a ComputerName parameter

The first parameter you might add is **ComputerName** so you can dynamically compile a
`.mof` file for any **ComputerName** you pass to your Configuration. Like functions, you can also
define a default value, in case the user doesn't specify one.

```powershell
param (
    [String]
    $ComputerName="localhost"
)
```

Within your Configuration, you can then specify the **ComputerName** parameter when defining your
`Node` block.

```powershell
Node $ComputerName {}
```

### Calling your Configuration with parameters

After you have added parameters to your Configuration, you can use them like you would with a
cmdlet.

```powershell
TestConfig -ComputerName 'server01'
```

### Compiling multiple .mof files

The `Node` block can also accept a comma-separated list of computer names and will generate `.mof`
files for each. You can run the following example to generate `.mof` files for all of the computers
passed to the **ComputerName** parameter.

```powershell
configuration TestConfig {
    param (
        [String[]]
        $ComputerName="localhost"
    )

    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Node $ComputerName {
        Service 'Spooler' {
            Name = 'Spooler'
            State = 'Running'
        }
    }
}

TestConfig -ComputerName 'server01', 'server02', 'server03'
```

## Advanced parameters in Configurations

In addition to a `-ComputerName` parameter, we can add parameters for the service name and state.
The following example adds a parameter block with a `-ServiceName` parameter and uses it to
dynamically define the `Service` resource block. It also adds a `-State` parameter to dynamically
define the **State** in the `Service` resource block.

```powershell
configuration TestConfig {
    param (
        [String]
        $ServiceName,

        [String]
        $State,

        [String]
        $ComputerName = 'localhost'
    )

    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Node $ComputerName {
        Service $ServiceName {
            Name  = $ServiceName
            State = $State
        }
    }
}
```

> [!NOTE]
> In more advanced scenarios, it might make more sense to move your dynamic data into structured
> [Configuration Data][6].

The example Configuration now takes a dynamic **ServiceName**, but if one isn't specified, compiling
results in an error. You could add a default value like this example.

```powershell
[String]
$ServiceName = 'Spooler'
```

In this instance though, it makes more sense to force the user to specify a value for the
**ServiceName** parameter. The `Parameter` attribute allows you to add further validation and
pipeline support to your Configuration's parameters.

Above any parameter declaration, add the `Parameter` attribute block as in the example below.

```powershell
[Parameter()]
[String]
$ServiceName
```

You can specify arguments to each `Parameter` attribute, to control aspects of the defined
parameter. The following example makes **ServiceName** a **Mandatory** parameter.

```powershell
[Parameter(Mandatory)]
[String]
$ServiceName
```

For the **State** parameter, we can use the `ValidationSet` attribute to prevent the user from
specifying values outside of a predefined list of valid options. The following example adds the
`ValidationSet` attribute to the **State** parameter and limits the values to `Running` and
`Stopped`. To avoid making the **State** parameter **Mandatory**, it also sets a default value.

```powershell
[ValidateSet('Running', 'Stopped')]
[String]
$State = 'Running'
```

> [!NOTE]
> You don't need to specify a `Parameter` attribute when using a `Validation*` attribute.

For more information about the `Parameter` and `Validation*` attributes, see
[about_Functions_Advanced_Parameters][7].

## Fully parameterized Configuration

We now have a parameterized Configuration that forces the user to specify the **ComputerName** and
**ServiceName** parameters, and validates the **State** parameter.

```powershell
configuration TestConfig {
    param (
        [parameter(Mandatory)]
        [String]
        $ServiceName,

        [ValidateSet('Running', 'Stopped')]
        [String]
        $State = 'Running',

        [String]
        $ComputerName = 'localhost'
    )

    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Node $ComputerName {
        Service $ServiceName {
            Name  = $ServiceName
            State = $State
        }
    }
}
```

## See also

- [Write help for DSC Configurations][8]
- [Dynamic Configurations][9]
- [Use Configuration Data in your Configurations][6]
- [Separate Configuration and environment data][10]

<!-- Reference Links -->

[1]: configurations.md
[2]: /powershell/module/microsoft.powershell.core/about/about_functions
[3]: /powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute
[4]: /powershell/module/microsoft.powershell.core/about/about_commonparameters
[5]: compositeconfigs.md
[6]: configData.md
[7]: /powershell/module/microsoft.powershell.core/about/about_Functions_Advanced_Parameters
[8]: configHelp.md
[9]: flow-control-in-configurations.md
[10]: separatingEnvData.md
