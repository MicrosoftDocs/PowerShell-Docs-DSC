---
description: >
  This topic explains how to get started using PowerShell Desired State Configuration (DSC) with the
  Invoke-DscResource cmdlet.
ms.date: 03/15/2023
title:  Get started with invoking DSC Resources
---

# Get started with invoking DSC resources

> Applies To: PowerShell 7.2

This topic explains how to get started using PowerShell Desired State Configuration (DSC) with the
`Invoke-DscResource` cmdlet.

Starting with version 2, DSC doesn't support applying configuration documents directly or running in
Windows PowerShell. Instead, you must use the [Invoke-DscResource][1] cmdlet in PowerShell 7.2 or
later to call the methods of a DSC resource to inspect or enforce the state of a resources on a
computer.

## Installing DSC

To install version 2 of the **PSDesiredStateConfiguration** module from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter **MaximumVersion** or you could install version 3 (or higher) of
> **PSDesireStateConfiguration** instead.

## Install a module containing DSC resources

DSC v2 doesn't include any DSC resources. You can install modules with DSC resources from external
sources, such as the [PowerShell Gallery][2].

You can search for DSC resources with the `Find-DscResource` cmdlet. To see the list of modules with
DSC resources, use the following command:

```powershell
Find-DscResource -Repository PSGallery | Select-Object -Property ModuleName, Version -Unique
```

For more information on searching for DSC resources in a PowerShell repository, see
[Find-DscResource][3].

To install the latest version of the PSDscResources module, use the following command:

```PowerShell
Install-Module 'PSDscResources' -Repository PSGallery
```

## Invoking DSC resources

When calling the `Invoke-DscResource`, you specify the method or function to call using the
**Method** parameter. Specify the properties of the resource as a hashtable value for the
**Property** parameter.

The following commands show how you can use the methods of a DSC Resource. The example uses the
**Environment** DSC resource in the **PSDscResources** module.

### Test whether a resource is correctly configured

The `Test` method inspects the state of a resource and returns an **InvokeDscResourceTestResult**
object with an **InDesiredState** property set to `$true` or `$false` depending on whether every
specified property is in the desired state.

```powershell
Invoke-DscResource -Name Environment -Module PSDscResources -Method Test -Property @{
    Name   = 'DSC_EXAMPLE'
    Ensure = 'Present'
    Value  = 'Desired State Configuration'
    Target = 'Process'
}
```

### Ensure an environment variable exists with the correct value

The `Set` method enforces the state of a resource on the system.

```powershell
Invoke-DscResource -Name Environment -Module PSDscResources -Method Set -Property @{
    Name   = 'DSC_EXAMPLE'
    Ensure = 'Present'
    Value  = 'Desired State Configuration'
    Target = 'Process'
}
```

> [!CAUTION]
> Calling `Invoke-DscResource` with `Set` doesn't verify whether the resource is already in the
> desired state. To ensure you aren't needlessly enforcing state, always use the `Test` method.

### Get the configuration of an environment variable

The `Get` method retrieves the current state of a resource.

```powershell
Invoke-DscResource -Name Environment -Module PSDscResources -Method Get -Property @{
    Name   = 'DSC_EXAMPLE'
    Target = 'Process'
}
```

## See Also

- [Installing DSC Resources][4]

<!-- Reference Links -->

[1]: /powershell/module/PSDesiredStateConfiguration/Invoke-DscResource
[2]: https://www.powershellgallery.com/
[3]: /powershell/module/powershellget/find-dscresource
[4]: ../how-tos/installing-dsc-resources.md
