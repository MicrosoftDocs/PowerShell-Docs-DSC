---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Get started with invoking DSC Resources
description: >
  This topic explains how to get started using PowerShell Desired State Configuration (DSC) with the
  Invoke-DscResource cmdlet.
---

# Get started with invoking DSC resources

This topic explains how to get started using PowerShell Desired State Configuration (DSC) with the
`Invoke-DscResource` cmdlet.

Starting with version 2, DSC does not support applying configuration documents directly or running
in Windows PowerShell. Instead, you must use the [Invoke-DscResource][1]
cmdlet in PowerShell 7.2 or later to call the methods of a DSC resource to inspect or enforce the
state of a resources on a computer.

## Installing DSC

To install version 2 of the **PSDesiredStateConfiguration** module from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter **MaximumVersion** or you could install version 3 (or higher) of
> **PSDesireStateConfiguration** instead.

## Install a module containing DSC resources

DSC v2 does not include any DSC resources. You can install modules with DSC resources from external
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

When calling the `Invoke-DscResource`, you specify which method or function to call using the
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
> Calling `Invoke-DscResource` with `Set` does not verify whether the resource is already in the
> desired state. To ensure you are not unnecessarily enforcing state, always use the `Test` method.

### Get the configuration of an environment variable

The `Get` method retrieves the current state of a resource.

```powershell
Invoke-DscResource -Name Environment -Module PSDscResources -Method Get -Property @{
    Name   = 'DSC_EXAMPLE'
}
```

<!-- Commented out for now: this section implies that it (and the companion authoring doc) should
     be removed and a note added to the overview that composite resources are not supported.

> [!NOTE]
> Directly calling composite resource methods is not supported. Instead, call the methods of the
> underlying resources that make up the composite resource.
-->

## See Also

- [Writing a custom DSC resource with MOF][3]
- [Writing a custom DSC resource with PowerShell classes][4]
- [Debugging DSC resources][5]

<!-- Reference Links -->

[1]: /powershell/module/PSDesiredStateConfiguration/Invoke-DscResource
[2]: https://www.powershellgallery.com/
[3]:/powershell/module/powershellget/find-dscresource
[4]: ../resources/authoringResourceMOF.md
[5]: ../resources/authoringResourceClass.md
[6]: ../troubleshooting/debugResource.md
