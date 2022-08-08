---
ms.date: 08/08/2022
ms.topic: reference
title: Overview of the PSDscResources module
description: >
  The PSDscResources module includes improved versions of the resources found in earlier versions of
  the PSDesiredStateConfiguration module.
---

# PSDscResources

**PSDscResources** is the new home of the in-box resources from **PSDesiredStateConfiguration**. The
resources in this module are maintained and supported by Microsoft.

These resources are a combination of those in the in-box **PSDesiredStateConfiguration** module as
well as community contributions from our experimental [xPSDesiredStateConfiguration][1] module on
GitHub. These resources have also recently been updated to meet the DSC Resource Kit
[High Quality Resource Module (HQRM) guidelines][2].

In-box resources not currently included in this module should not be affected and can still load
from the in-box **PSDesiredStateConfiguration** module.

Because **PSDscResources** overwrites in-box resources, it is only available for DSC 1.1 and
PowerShell 5.1 or later. Many of the resource updates provided here are also included in the
**xPSDesiredStateConfiguration** module which is still compatible earlier versions (though this
module is not supported and may be removed in the future).

To update your in-box resources to the newest versions provided by **PSDscResources**, first install
**PSDscResources** from the [PowerShell Gallery][3]:

```powershell
Install-Module PSDscResources
```

Then, add this line to your DSC configuration:

```powershell
Import-DscResource -ModuleName PSDscResources
```

This project has adopted the [Microsoft Open Source Code of Conduct][4]. For more information see
the [Code of Conduct FAQ][5] or contact [opencode@microsoft.com][6] with any additional questions or
comments.

## Resources

- [Archive][7]: Expand or remove the contents of an archive (`.zip`) file.
- [Environment][8]: Manage an environment variable for a machine or process.
- [Group][9]: Manage a local group.
- [GroupSet][10]: Manage multiple Group resources with common settings.
- [MsiPackage][11]: Install or uninstall an MSI package.
- [Registry][12]: Manage a registry key or value.
- [Script][13]: Run PowerShell script blocks.
- [Service][14]: Manage a Windows service.
- [ServiceSet][15]: Manage multiple services with common settings.
- [User][16]: Manage a local user.
- [WindowsFeature][17]: Install or uninstall a Windows role or feature.
- [WindowsFeatureSet][18]: Manage multiple Windows roles or features with common settings.
- [WindowsOptionalFeature][19]: Enable or disable an optional feature.
- [WindowsOptionalFeatureSet][20]: Manage multiple optional features with common settings.
- [WindowsPackageCab][21]: Install or uninstall a package from a Windows cabinet (`.cab`) file.
- [WindowsProcess][22]: Start or stop a Windows process.
- [ProcessSet][23]: Manage multiple Windows processes with common settings.

### Resources that Work on Nano Server

- [Group][9]
- [Script][13]
- [Service][14]
- [User][16]
- [WindowsOptionalFeature][19]
- [WindowsOptionalFeatureSet][20]
- [WindowsPackageCab][21]

<!-- Reference Links -->

[1]: https://github.com/PowerShell/xPSDesiredStateConfiguration
[2]: https://github.com/PowerShell/DscResources/blob/master/HighQualityModuleGuidelines.md
[3]: https://powershellgallery.com
[4]: https://opensource.microsoft.com/codeofconduct/
[5]: https://opensource.microsoft.com/codeofconduct/faq/
[6]: mailto:opencode@microsoft.com
[7]: Resources/Archive/Archive.md
[8]: Resources/Environment/Environment.md
[9]: Resources/Group/Group.md
[10]: Resources/GroupSet/GroupSet.md
[11]: Resources/MsiPackage/MsiPackage.md
[12]: Resources/Registry/Registry.md
[13]: Resources/Script/Script.md
[14]: Resources/Service/Service.md
[15]: Resources/ServiceSet/ServiceSet.md
[16]: Resources/User/User.md
[17]: Resources/WindowsFeature/WindowsFeature.md
[18]: Resources/WindowsFeatureSet/WindowsFeatureSet.md
[19]: Resources/WindowsOptionalFeature/WindowsOptionalFeature.md
[20]: Resources/WindowsOptionalFeatureSet/WindowsOptionalFeatureSet.md
[21]: Resources/WindowsPackageCab/WindowsPackageCab.md
[22]: Resources/WindowsProcess/WindowsProcess.md
[23]: Resources/ProcessSet/ProcessSet.md
