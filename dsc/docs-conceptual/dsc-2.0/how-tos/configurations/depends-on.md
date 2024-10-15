---
description: >
  As your DSC Configuration grows larger and more complex, you can use the `DependsOn` meta-property
  to change the applied order of your DSC Resources by specifying that one DSC Resource depends on
  another DSC Resource.
ms.date: 01/06/2023
title: Managing dependencies in DSC Configurations
---

# Managing dependencies in DSC Configurations

> Applies To: PowerShell 7, Azure machine configuration

When you write [DSC Configurations][1] for [Azure machine configuration][2], you add
[Resource blocks][3] to configure aspects of a system. As you continue to add DSC Resource blocks,
your DSC Configurations can grow large and cumbersome to manage. One such challenge is the applied
order of your DSC Resource blocks. By default, DSC Resources are applied in the order they're
defined within the `Configuration` block. As your DSC Configuration grows larger and more complex,
you can use the **DependsOn** meta-property to change the applied order of your DSC Resources by
specifying that one DSC Resource depends on another DSC Resource.

The **DependsOn** meta-property can be used in any DSC Resource block. It's defined with the same
key/value mechanism as other DSC Resource properties. The **DependsOn** meta-property expects an
array of strings with the following syntax.

```text
DependsOn = '[<Resource Type>]<Resource Name>', '[<Resource Type>]<Resource Name>'
```

The following example configures a group's membership after creating a user.

```powershell
Configuration ConfigureExampleUserGroup {
    Import-DSCResource -Name User, Group -Module PSDscResources

    Group Example {
        GroupName = 'DscExampleGroup'
        Members   = 'DscExampleUser'
        DependsOn = '[User]Example'
    }

    User Example {
        UserName    = 'DscExampleUser'
        Ensure      = 'Present'
        Description = 'Example user who should be a member of DscExampleGroup.'
    }
}

ConfigureExampleUserGroup
```

<!-- Reference Links -->

[1]: ../../concepts/configurations.md
[2]: /azure/governance/machine-configuration/overview
[3]: ../../concepts/resources.md
