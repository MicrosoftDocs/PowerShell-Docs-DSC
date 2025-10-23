---
ms.date: 10/23/2025
keywords:  dsc,powershell,configuration,setup
title:  DSC Resources
description: DSC resources provide the building blocks for a DSC configuration. A resource exposes properties that can be configured (schema) and contains the PowerShell script functions used by the LCM to apply the configuration.
---

# DSC Resources

> Applies to Windows PowerShell 4.0 and up.

## Overview

Desired State Configuration (DSC) Resources provide the building blocks for a DSC configuration. A
resource exposes properties that can be configured (schema) and contains the PowerShell script
functions that the Local Configuration Manager (LCM) calls to "make it so".

A resource can model something as generic as a file or as specific as an IIS server setting. Groups
of like resources are combined in to a DSC Module, which organizes all the required files in to a
structure that is portable and includes metadata to identify how the resources are intended to be
used.

Each resource has a *schema that determines the syntax needed to use the resource in a
[Configuration][02]. A resource's schema can be defined in the following ways:

- `Schema.Mof` file: Most resources define their _schema_ in a `schema.mof` file, using
  [Managed Object Format][34].
- `<Resource Name>.schema.psm1` file: [Composite Resources][01] define their _schema_ in a
  `<ResourceName>.schema.psm1` file using a [Parameter Block][30].
- `<Resource Name>.psm1` file: Class based DSC resources define their _schema_ in the class
  definition. Syntax items are denoted as Class properties. For more information, see
  [about_Classes][32].

To retrieve the syntax for a DSC resource, use the [Get-DSCResource][33] cmdlet with the **Syntax**
parameter. This usage is similar to using [Get-Command][31] with the **Syntax** parameter to get
cmdlet syntax. The output you see will show the template used for a resource block for the resource
you specify.

```powershell
Get-DscResource -Syntax Service
```

The output you see should be similar to the output below, though this resource's syntax could change
in the future. Like cmdlet syntax, the _keys_ seen in square brackets, are optional. The types
specify the type of data each key expects.

> [!NOTE]
> The **Ensure** key is optional because it defaults to "Present".

```output
Service [String] #ResourceName
{
    Name = [string]
    [BuiltInAccount = [string]{ LocalService | LocalSystem | NetworkService }]
    [Credential = [PSCredential]]
    [Dependencies = [string[]]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [DisplayName = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Path = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [StartupType = [string]{ Automatic | Disabled | Manual }]
    [State = [string]{ Running | Stopped }]
}
```

> [!NOTE]
> In PowerShell versions below 7.0, `Get-DscResource` does not find Class based DSC resources.

Inside a Configuration, a **Service** resource block might look like this to **Ensure** that the
Spooler service is running.

> [!NOTE]
> Before using a resource in a Configuration, you must import it using [Import-DSCResource][04].

```powershell
Configuration TestConfig
{
    # It is best practice to always directly import resources, even if the
    # resource is a built-in resource.
    Import-DSCResource -Name Service
    Node localhost
    {
        # The name of this resource block, can be anything you choose, as l
        # ong as it is of type [String] as indicated by the schema.
        Service "Spooler - Running"
        {
            Name = "Spooler"
            State = "Running"
        }
    }
}
```

Configurations can contain multiple instances of the same resource type. Each instance must be
uniquely named. In the following example, a second **Service** resource block is added to configure
the "DHCP" service.

```powershell
Configuration TestConfig
{
    # It is best practice to always directly import resources, even if the
    # resource is a built-in resource.
    Import-DSCResource -Name Service
    Node localhost
    {
        # The name of this resource block, can be anything you choose, as
        # long as it is of type [String] as indicated by the schema.
        Service "Spooler - Running"
        {
            Name = "Spooler"
            State = "Running"
        }

        # To configure a second service resource block, add another Service
        # resource block and use a unique name.
        Service "DHCP - Running"
        {
            Name = "DHCP"
            State = "Running"
        }
    }
}
```

> [!NOTE]
> Beginning in PowerShell 5.0, IntelliSense was added for DSC. This new feature allows you to use
> <kbd>TAB</kbd> and <kbd>Ctr</kbd>+<kbd>Space</kbd> to auto-complete key names.

![Resource IntelliSense using Tab Completion][36]

## Types of resources

Windows comes with built in resources and Linux has OS specific resources. There are resources for
[cross-node dependencies][03], package management resources, as well as
[community owned and maintained resources][35]. You can use the above steps to determine the syntax
of these resources and how to use them. The pages that serve these resources have been archived
under **Reference**.

### Windows built-in resources

- [Archive Resource][08]
- [Environment Resource][09]
- [File Resource][10]
- [Group Resource][11]
- [GroupSet Resource][12]
- [Log Resource][13]
- [Package Resource][14]
- [ProcessSet Resource][15]
- [Registry Resource][16]
- [Script Resource][17]
- [Service Resource][18]
- [ServiceSet Resource][19]
- [User Resource][20]
- [WindowsFeature Resource][24]
- [WindowsFeatureSet Resource][25]
- [WindowsOptionalFeature Resource][26]
- [WindowsOptionalFeatureSet Resource][27]
- [WindowsPackageCabResource Resource][28]
- [WindowsProcess Resource][29]

### Cross-Node dependency resources

- [WaitForAll Resource][21]
- [WaitForSome Resource][23]
- [WaitForAny Resource][22]

### Package Management resources

- [PackageManagement Resource][06]
- [PackageManagementSource Resource][07]

#### Linux resources

The DSC for Linux resources are deprecated. For more information, see
[DSC for Linux Resources][05].

<!-- link references -->
[01]: ../configurations/compositeConfigs.md
[02]: ../configurations/configurations.md
[03]: ../configurations/crossNodeDependencies.md
[04]: ../configurations/import-dscresource.md
[05]: ../reference/resources/linux/index.md
[06]: ../reference/resources/packagemanagement/PackageManagementDscResource.md
[07]: ../reference/resources/packagemanagement/PackageManagementSourceDscResource.md
[08]: ../reference/resources/windows/archiveResource.md
[09]: ../reference/resources/windows/environmentResource.md
[10]: ../reference/resources/windows/fileResource.md
[11]: ../reference/resources/windows/groupResource.md
[12]: ../reference/resources/windows/groupSetResource.md
[13]: ../reference/resources/windows/logResource.md
[14]: ../reference/resources/windows/packageResource.md
[15]: ../reference/resources/windows/ProcessSetResource.md
[16]: ../reference/resources/windows/registryResource.md
[17]: ../reference/resources/windows/scriptResource.md
[18]: ../reference/resources/windows/serviceResource.md
[19]: ../reference/resources/windows/serviceSetResource.md
[20]: ../reference/resources/windows/userResource.md
[21]: ../reference/resources/windows/waitForAllResource.md
[22]: ../reference/resources/windows/waitForAnyResource.md
[23]: ../reference/resources/windows/waitForSomeResource.md
[24]: ../reference/resources/windows/windowsFeatureResource.md
[25]: ../reference/resources/windows/windowsFeatureSetResource.md
[26]: ../reference/resources/windows/windowsOptionalFeatureResource.md
[27]: ../reference/resources/windows/windowsOptionalFeatureSetResource.md
[28]: ../reference/resources/windows/windowsPackageCabResource.md
[29]: ../reference/resources/windows/windowsProcessResource.md
[30]: /powershell/module/microsoft.powershell.core/about/about_functions#functions-with-parameters
[31]: /powershell/module/microsoft.powershell.core/get-command
[32]: /powershell/module/psdesiredstateconfiguration/about/about_classes_and_dsc
[33]: /powershell/module/PSDesiredStateConfiguration/Get-DscResource
[34]: /windows/desktop/wmisdk/managed-object-format--mof-
[35]: https://github.com/dsccommunity
[36]: media/resources/resource-tabcompletion.png
