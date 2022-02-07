---
description: Overview of the Desired State Configuration 2.0.
ms.date: 02/07/2022
title:  Desired State Configuration 2.0
---
# Desired State Configuration 2.0

DSC 2.0 is the version of DSC that shipped in PowerShell 7.0.

With the release of PowerShell 7.2, the PSDesiredStateConfiguration module is no longer included
in the PowerShell package. Separating DSC into its own module allows us to invest and develop DSC
independent of PowerShell and reduces the size of the PowerShell package. Users of DSC can enjoy
the benefit of upgrading DSC without the need to upgrade PowerShell, accelerating time to deployment
of new DSC features. Users that want to continue using DSC v2 can download
PSDesiredStateConfiguration 2.0.5 from the PowerShell Gallery.

Users working with non-Windows environments can expect cross-platform features in DSC v3. For more
information about the future of DSC, see the
[PowerShell Team blog](https://devblogs.microsoft.com/powershell/powershell-team-2021-investments/#dsc-for-powershell-7).

To install PSDesiredStateConfiguration 2.0.5 from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter MaximumVersion or you could install version 3 (or higher) of
> PSDesireStateConfiguration that contains significant differences.
