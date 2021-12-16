---
description: Learn how to use the Desired State Configuration feature of PowerShell to manage the state of a machine as code.
ms.date: 12/16/2021
title: Manage configuration using PowerShell DSC
---

# Manage configuration using PowerShell DSC

There are three options for managing the state of a machine from PowerShell DSC. The solutions are
the same for both Linux and Windows operating systems.

## The `Invoke-DSCResource` command

You can deliver changes to a machine using a script. The `Invoke-DSCResource` command can be used to
reference a DSC resource and pass through the properties that define how to manage the end state.

Test if the machine is in the correct state, for an example resource.

```powershell
Invoke-DscResource @{
  Name = 'Environment'
  ModuleName = 'PSDscResources'
  Property = @{
    Name = 'TestEnvironmentVariable'
    Value = 'TestValue'
    Ensure = 'Present'
    Path = $false
    Target = @('Process', 'Machine')
  }
  Method = Test
}
```

Get the current state of a machine, for an example resource.

```powershell
Invoke-DscResource @{
  Name = 'Environment'
  ModuleName = 'PSDscResources'
  Property = @{
    Name = 'TestEnvironmentVariable'
    Value = 'TestValue'
    Ensure = 'Present'
    Path = $false
    Target = @('Process', 'Machine')
  }
  Method = Get
}
```

Set the state of the machine, for an example resource.

```powershell
Invoke-DscResource @{
  Name = 'Environment'
  ModuleName = 'PSDscResources'
  Property = @{
    Name = 'TestEnvironmentVariable'
    Value = 'TestValue'
    Ensure = 'Present'
    Path = $false
    Target = @('Process', 'Machine')
  }
  Method = Set
}
```

For additional details, view the
[Invoke-DscResource](/powershell/module/psdesiredstateconfiguration/invoke-dscresource) help.

## The guest configuration feature of Azure Policy

For machines hosted in Microsoft Azure, or connected for hybrid management, the guest configuration
feature of Azure Policy offers the ability to audit or apply configurations. The feature can be used
stand-alone to assign configurations as a machine is deployed, or dynamically to assign
configurations to a machine based on properties defined by the API.

For more information, see the page
[Understand the guest configuration feature of Azure Policy](/azure/governance/policy/concepts/guest-configuration.md).

## DSC resources with third-party tools

PowerShell DSC resources can also be used with most popular configuration management platforms. For
additional details, see the documentation for each third-party solution.

## See Also

- [DSC Configurations](../concepts/configurations.md)
- [DSC Resources](../concepts/resources.md)
