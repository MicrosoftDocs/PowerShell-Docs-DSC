---
ms.date: 08/01/2022
title:  Desired State Configuration 2.0
description: >
  Overview of Desired State Configuration 2.0
---
# Desired State Configuration 2.0

With the release of PowerShell 7.2, the **PSDesiredStateConfiguration** module is no longer included
in the PowerShell package. Separating DSC into its own module allows us to invest and develop DSC
independent of PowerShell and reduces the size of the PowerShell package. Users of DSC can enjoy
the benefit of upgrading DSC without the need to upgrade PowerShell, accelerating time to deployment
of new DSC features. Users that want to continue using DSC v2 can download
**PSDesiredStateConfiguration** 2.0.5 from the PowerShell Gallery.

Users working with non-Windows environments can expect cross-platform features in DSC v3. For more
information about the future of DSC, see the [PowerShell Team blog][1].

To install **PSDesiredStateConfiguration** 2.0.5 from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
```

> [!IMPORTANT]
> Be sure to include the parameter **MaximumVersion** or you could install version 3 (or higher) of
> **PSDesireStateConfiguration** that contains significant differences.

## Use Case for DSC 2.0

DSC 2.0 is supported for use with [Azure Policy's machine configuration][2]. Other scenarios, such
as directly calling DSC Resources with `Invoke-DscResource`, may be functional but aren't the
primary intended use of this version.

If you aren't using Azure Policy's machine configuration feature, you should use DSC 1.1.

DSC 3.0 is available in public beta and should only be used with Azure machine configuration (which
supports it) or for non-production environments to test migrating away from DSC 1.1.

## Changes from DSC 1.1

There are several major changes in DSC 2.0.

The only way to use DSC Resources in 2.0 is with the `Invoke-DscResource` cmdlet and Azure Policy's
machine configuration feature.

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
- Using nested DSC Configurations (composite DSC Configurations)

<!-- Reference Links -->

[1]: https://devblogs.microsoft.com/powershell/powershell-team-2021-investments/#dsc-for-powershell-7
[2]: /azure/governance/machine-configuration/overview
