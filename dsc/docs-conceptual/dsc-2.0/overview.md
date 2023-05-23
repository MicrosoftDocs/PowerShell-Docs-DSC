---
description: >
  Overview of Desired State Configuration 2.0
ms.date: 05/15/2023
title:  Desired State Configuration 2.0
---
# Desired State Configuration 2.0

With the release of PowerShell 7.2, the **PSDesiredStateConfiguration** module is no longer included
in the PowerShell package. Separating DSC into its own module allows us to invest and develop DSC
independent of PowerShell and reduces the size of the PowerShell package. Users of DSC can enjoy
the benefit of upgrading DSC without the need to upgrade PowerShell, accelerating time to deployment
of new DSC features. Users that want to continue using DSC v2 can download
**PSDesiredStateConfiguration** 2.0.7 from the PowerShell Gallery.

Users working with non-Windows environments can expect cross-platform features in DSC v3. For more
information about the future of DSC, see the [PowerShell Team blog][01].

To install **PSDesiredStateConfiguration** 2.0.7 from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter **MaximumVersion** or you could install version 3 (or higher) of
> **PSDesireStateConfiguration** that contains significant differences.

## Use Case for DSC 2.0

DSC 2.0 is supported for use with [Azure Automanage's machine configuration feature][02]. Other
scenarios, such as directly calling DSC Resources with `Invoke-DscResource`, may be functional but
aren't the primary intended use of this version.

If you aren't using Azure Automanage's machine configuration feature, you should use DSC 1.1.

DSC 3.0 is available in public beta and should only be used with Azure machine configuration (which
supports it) or for non-production environments to test migrating away from DSC 1.1.

## Changes from DSC 1.1

There are several major changes in DSC 2.0.

The only way to use DSC Resources in 2.0 is with the `Invoke-DscResource` cmdlet and Azure
Automanage's machine configuration feature.

The following cmdlets have been removed:

- `Disable-DscDebug`
- `Enable-DscDebug`
- `Get-DscConfiguration`
- `Get-DscConfigurationStatus`
- `Get-DscLocalConfigurationManager`
- `Publish-DscConfiguration`
- `Remove-DscConfigurationDocument`
- `Restore-DscConfiguration`
- `Set-DscLocalConfigurationManager`
- `Start-DscConfiguration`
- `Stop-DscConfiguration`
- `Test-DscConfiguration`
- `Update-DscConfiguration`

The following features have been removed:

- The pull server
- The local configuration manager (LCM)

The following features aren't supported:

- Multi-system DSC Configurations
- Cross-system dependencies (the `WaitFor*` DSC Resources)
- Rebooting behavior for DSC Resources
- Adding parameters to DSC Configuration blocks
- Using flow control statements in DSC Configuration blocks
- Using credentials in DSC Configuration blocks
- Using the **ConfigurationData** parameter with a DSC Configuration
- Using the `Node` keyword in a DSC Configuration
- Using composite DSC Configurations (DSC Configurations that nest another DSC Configuration inside
  them)

The built-in DSC Resources have been removed. The [PSDscResources][03] module includes replacements
for some removed DSC Resources. Refer to the following table for the status of the DSC
Resources.

|        DSC Resource         |                                     Status                                      |
| :-------------------------- | :------------------------------------------------------------------------------ |
| `Archive`                   | Replaced by the [Archive DSC Resource in PSDscResources][04].                   |
| `Environment`               | Replaced by the [Environment DSC Resource in PSDscResources][05].               |
| `File`                      | Removed. This DSC Resource isn't available in DSC v2 and later.                 |
| `Group`                     | Replaced by the [Group DSC Resource in PSDscResources][06].                     |
| `GroupSet`                  | Replaced by the [GroupSet DSC Resource in PSDscResources][07].                  |
| `Log`                       | Removed. This DSC Resource isn't available in DSC v2 and later.                 |
| `Package`                   | Partially replaced by the [MsiPackage DSC Resource in PSDscResources][08].      |
| `ProcessSet`                | Replaced by the [ProcessSet DSC Resource in PSDscResources][09].                |
| `Registry`                  | Replaced by the [Registry DSC Resource in PSDscResources][10].                  |
| `Script`                    | Replaced by the [Script DSC Resource in PSDscResources][11].                    |
| `Service`                   | Replaced by the [Service DSC Resource in PSDscResources][12].                   |
| `ServiceSet`                | Replaced by the [ServiceSet DSC Resource in PSDscResources][13].                |
| `User`                      | Replaced by the [User DSC Resource in PSDscResources][14].                      |
| `WaitForAll`                | Removed. This DSC Resource isn't available in DSC v2 and later.                 |
| `WaitForAny`                | Removed. This DSC Resource isn't available in DSC v2 and later.                 |
| `WaitForSome`               | Removed. This DSC Resource isn't available in DSC v2 and later.                 |
| `WindowsFeature`            | Replaced by the [WindowsFeature DSC Resource in PSDscResources][15].            |
| `WindowsFeatureSet`         | Replaced by the [WindowsFeatureSet DSC Resource in PSDscResources][16].         |
| `WindowsOptionalFeature`    | Replaced by the [WindowsOptionalFeature DSC Resource in PSDscResources][17].    |
| `WindowsOptionalFeatureSet` | Replaced by the [WindowsOptionalFeatureSet DSC Resource in PSDscResources][18]. |
| `WindowsPackageCab`         | Replaced by the [WindowsPackageCab DSC Resource in PSDscResources][19].         |
| `WindowsProcess`            | Replaced by the [WindowsProcess DSC Resource in PSDscResources][20].            |

<!-- Reference Links -->

[01]: https://devblogs.microsoft.com/powershell/powershell-team-2021-investments/#dsc-for-powershell-7
[02]: /azure/governance/machine-configuration/overview
[03]: ./reference/PSDscResources/overview.md
[04]: ./reference/PSDscResources/Resources/Archive/Archive.md
[05]: ./reference/PSDscResources/Resources/Environment/Environment.md
[06]: ./reference/PSDscResources/Resources/Group/Group.md
[07]: ./reference/PSDscResources/Resources/GroupSet/GroupSet.md
[08]: ./reference/PSDscResources/Resources/MsiPackage/MsiPackage.md
[09]: ./reference/PSDscResources/Resources/ProcessSet/ProcessSet.md
[10]: ./reference/PSDscResources/Resources/Registry/Registry.md
[11]: ./reference/PSDscResources/Resources/Script/Script.md
[12]: ./reference/PSDscResources/Resources/Service/Service.md
[13]: ./reference/PSDscResources/Resources/ServiceSet/ServiceSet.md
[14]: ./reference/PSDscResources/Resources/User/User.md
[15]: ./reference/PSDscResources/Resources/WindowsFeature/WindowsFeature.md
[16]: ./reference/PSDscResources/Resources/WindowsFeatureSet/WindowsFeatureSet.md
[17]: ./reference/PSDscResources/Resources/WindowsOptionalFeature/WindowsOptionalFeature.md
[18]: ./reference/PSDscResources/Resources/WindowsOptionalFeatureSet/WindowsOptionalFeatureSet.md
[19]: ./reference/PSDscResources/Resources/WindowsPackageCab/WindowsPackageCab.md
[20]: ./reference/PSDscResources/Resources/WindowsProcess/WindowsProcess.md
