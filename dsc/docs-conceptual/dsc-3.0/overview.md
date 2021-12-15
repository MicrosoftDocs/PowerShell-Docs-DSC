---
description: Overview of the PSDesiredStateConfiguration v3.0.0-beta1 module.
ms.date: 12/15/2021
title:  PSDesiredStateConfiguration v3.0.0-beta1
---
# PSDesiredStateConfiguration v3.0.0-beta1

DSC 3.0 is the new version of DSC. This version is a preview release that is still being developed.
Users working with non-Windows environments can expect cross-platform features in DSC v3. DSC 3.0 is
the version that is supported by the Azure Guest Configuration feature of Azure Policy.

Users that want to continue using DSC v2 can download PSDesiredStateConfiguration 2.0.5
from the PowerShell Gallery.

To install PSDesiredStateConfiguration 2.0.5 from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter MaximumVersion or you could install version 3 (or higher) of
> PSDesireStateConfiguration that contains significant differences.

For more information about the future of DSC, see the
[PowerShell Team blog](https://devblogs.microsoft.com/powershell/powershell-team-2021-investments/#dsc-for-powershell-7).
