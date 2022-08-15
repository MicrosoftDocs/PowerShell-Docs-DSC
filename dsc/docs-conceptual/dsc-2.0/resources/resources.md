---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  DSC Resources
description: >
  DSC Resources provide a standardized interface for managing the settings of a system.
---

# DSC Resources

> Applies to PowerShell 7.2

## Overview

DSC Resources provide a standardized interface for managing the settings of a system. A DSC Resource
defines properties you can manage and contains the PowerShell code that `Invoke-DscResource` calls
to "make it so."

A DSC Resource can model something as generic as a file or as specific as an IIS server setting.
Groups of related DSC Resources are combined into PowerShell modules. Modules provide a portable,
versioned package for DSC Resources and include metadata and documentation about them.

Every DSC Resource has a schema that determines the syntax needed to use the DSC Resource with
`Invoke-DscResource` or in a [Configuration][1]. A DSC Resource's schema is defined in the following
ways:

- `<Resource Name>.psm1` file: Class-based DSC Resources define their schema in the class
  definition. Syntax items are denoted as class properties. For more information, see
  [about_Classes][2].
- `Schema.Mof` file: MOF-based DSC Resources define their schema in a `schema.mof` file, using
  [Managed Object Format][3].

To retrieve the syntax for a DSC Resource, use the [Get-DSCResource][4] cmdlet with the **Syntax**
parameter. This is like using [Get-Command][5] with the **Syntax** parameter to get cmdlet syntax.
The output shows the template used for a DSC Resource block in a DSC Configuration.

```powershell
Get-DscResource -Syntax Service
```

```output
Service [String] #ResourceName
{
    Name = [string]
    [BuiltInAccount = [string]{ LocalService | LocalSystem | NetworkService }]
    [Credential = [PSCredential]]
    [Dependencies = [string[]]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [DesktopInteract = [bool]]
    [DisplayName = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Path = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [StartupTimeout = [UInt32]]
    [StartupType = [string]{ Automatic | Disabled | Manual }]
    [State = [string]{ Ignore | Running | Stopped }]
    [TerminateTimeout = [UInt32]]
}
```

Like cmdlet syntax, the _keys_ in square brackets are optional. The types specify the data type each
key expects.

To ensure that the `Spooler` service is running:

```powershell
$SharedDscParameters = @{
    Name = 'Service'
    ModuleName = 'PSDscResources'
    Property = @{
        Name  = 'Spooler'
        State = 'Running'
    }
}
$TestResult = Invoke-DscResource -Method Test @SharedDscParameters
if ($TestResult.InDesiredState) {
    Write-Host -ForegroundColor Cyan -Object 'Already in desired state.'
} else {
    Write-Host -ForegroundColor Magenta -Object 'Enforcing desired state.'
    Invoke-DscResource -Method Set @SharedDscParameters
}
```

The `$SharedDscParameters` variable is a hash table containing the parameters used when calling the
**Test** and **Set** methods of the resource with `Invoke-DscResource`. The first call to
`Invoke-DscResource` uses the **Test** method to verify whether the `Spooler` service is running and
stores the result in the `$TestResult` variable.

The next step depends on whether the service is already in the desired state. It's best practice to
always verify desired state before enforcing and to only call the **Set** method when required. In
the example, the script writes a message to the console about whether the DSC Resource is in the
desired state. Then, if the service isn't running, it calls `Invoke-DscResource` with the **Set**
method to enforce the desired state.

<!--
    Potentially we should say these are not meant to be used. It's unclear how (if at all) they will
    interact with v2 and the built-in resources are out of date. The links are all also broken and
    I don't think there's any such thing as "built-in" resources anymore. Anything that _is_ in the
    box is DSC v1.1 and there are caveats there we need to document.

## Types of resources

Windows comes with built in resources and Linux has OS specific resources. There are resources for
package management resources as well as
[community owned and maintained resources](https://github.com/dsccommunity). You can use the above
steps to determine the syntax of these resources and how to use them. The pages that serve these
resources have been archived under **Reference**.

### Windows built-in resources

- [Archive Resource](../reference/resources/windows/archiveResource.md)
- [Environment Resource](../reference/resources/windows/environmentResource.md)
- [File Resource](../reference/resources/windows/fileResource.md)
- [Group Resource](../reference/resources/windows/groupResource.md)
- [GroupSet Resource](../reference/resources/windows/groupSetResource.md)
- [Log Resource](../reference/resources/windows/logResource.md)
- [Package Resource](../reference/resources/windows/packageResource.md)
- [ProcessSet Resource](../reference/resources/windows/ProcessSetResource.md)
- [Registry Resource](../reference/resources/windows/registryResource.md)
- [Script Resource](../reference/resources/windows/scriptResource.md)
- [Service Resource](../reference/resources/windows/serviceResource.md)
- [ServiceSet Resource](../reference/resources/windows/serviceSetResource.md)
- [User Resource](../reference/resources/windows/userResource.md)
- [WindowsFeature Resource](../reference/resources/windows/windowsFeatureResource.md)
- [WindowsFeatureSet Resource](../reference/resources/windows/windowsFeatureSetResource.md)
- [WindowsOptionalFeature Resource](../reference/resources/windows/windowsOptionalFeatureResource.md)
- [WindowsOptionalFeatureSet Resource](../reference/resources/windows/windowsOptionalFeatureSetResource.md)
- [WindowsPackageCabResource Resource](../reference/resources/windows/windowsPackageCabResource.md)
- [WindowsProcess Resource](../reference/resources/windows/windowsProcessResource.md)

### Package Management resources

- [PackageManagement Resource](../reference/resources/packagemanagement/PackageManagementDscResource.md)
- [PackageManagementSource Resource](../reference/resources/packagemanagement/PackageManagementSourceDscResource.md)

#### Linux resources

- [Linux Archive Resource](../reference/resources/linux/lnxArchiveResource.md)
- [Linux Environment Resource](../reference/resources/linux/lnxEnvironmentResource.md)
- [Linux FileLine Resource](../reference/resources/linux/lnxFileLineResource.md)
- [Linux File Resource](../reference/resources/linux/lnxFileResource.md)
- [Linux Group Resource](../reference/resources/linux/lnxGroupResource.md)
- [Linux Package Resource](../reference/resources/linux/lnxPackageResource.md)
- [Linux Script Resource](../reference/resources/linux/lnxScriptResource.md)
- [Linux Service Resource](../reference/resources/linux/lnxServiceResource.md)
- [Linux SshAuthorizedKeys Resource](../reference/resources/linux/lnxSshAuthorizedKeysResource.md)
- [Linux User Resource](../reference/resources/linux/lnxUserResource.md)

-->

<!-- Reference Links -->

[1]: ../configurations/configurations.md
[2]: /powershell/module/psdesiredstateconfiguration/about/about_classes_and_dsc
[3]: /windows/desktop/wmisdk/managed-object-format--mof-
[4]: /powershell/module/PSDesiredStateConfiguration/Get-DscResource
[5]: /powershell/module/microsoft.powershell.core/get-command
