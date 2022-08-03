---
ms.date: 07/25/2022
keywords:  dsc,powershell,configuration,setup
title:  Nesting Configurations
description: >
  DSC allows you to create composite configurations by nesting a configuration inside of another
  configuration.
---

# Nesting DSC Configurations

> Applies To: PowerShell 7.2

A composite Configuration (also called nested configuration) is a Configuration that's called
within another configuration as if it were a resource. Both Configurations must be defined in the
same file.

Let's look at a minimal example:

```powershell
configuration RegistryStringValue {
    param (
        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [String] $Value
    )

    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Registry RegistryTest {
        Key       = 'HKEY_CURRENT_USER\DscTest'
        ValueName = $Name
        Ensure    = 'Present'
        ValueData = $Value
        ValueType = 'String'
    }
}

configuration NestedRegistryStringValue {
    Node localhost {
        RegistryStringValue NestedConfig {
            Name  = 'Foo'
            Value = 'Bar'
        }
    }
}
```

In this example, `RegistryStringValue` takes two mandatory parameters, **Name** and **Value**, which
are used as the values for the **ValueName** and **ValueData** properties in the `Registry` resource
block. The `NestedRegistryStringValue` configuration calls `RegistryStringValue` as if it were a
resource. The properties in the `NestedConfig` resource block (**Name** and **Value**) are the
parameters of the `RegistryStringValue` configuration.

DSC doesn't support nesting configurations within nested configurations. You can only nest a
configuration one layer deep.
