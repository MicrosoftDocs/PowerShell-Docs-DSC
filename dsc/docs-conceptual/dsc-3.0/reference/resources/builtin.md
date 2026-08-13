---
description: >-
  Lists the built-in DSC resources and links to the reference documentation for those resources.
ms.date: 08/10/2026
ms.topic: reference
title: Built-in DSC resources reference
---

# Built-in DSC resources reference

Each release of DSC includes built-in resources that you can use immediately after you install DSC.
This document lists the available resources and links to the reference documentation for each.

> [!NOTE]
> The team hasn't documented every built-in resource yet. As they add reference documentation for
> these resources, the team will update this article to link to the documentation for those
> resources.

## All built-in resources

- [DSC.PackageManagement/Apt][01] - Manage packages with the advanced package tool (APT) on Linux
  systems.
- [DSC.PackageManagement/Brew][02] - Manage packages using Homebrew on macOS systems.
- [Microsoft/OSInfo][03] - Returns information about the operating system.
- [Microsoft.Adapter/PowerShell][04] - Adapter for resources implemented as PowerShell DSC classes.
- [Microsoft.Adapter/WindowsPowerShell][05] - Adapter for resources implemented as binary, script,
  or PowerShell classes in Windows PowerShell.
- `Microsoft.DSC/Assertion`
- `Microsoft.DSC/Group`
- [Microsoft.DSC/Include][06] - Includes a nested configuration document, with optional parameters,
  into the current configuration.
- [Microsoft.DSC/PowerShell][07] - Adapter for resources implemented as PowerShell classes.
- [Microsoft.DSC.Debug/Echo][08] - A debug resource for testing and troubleshooting DSC behavior.
- [Microsoft.DSC.Transitional/PowerShellScript][09] - Enable running PowerShell 7 scripts inline.
- [Microsoft.DSC.Transitional/RunCommandOnSet][10] - Execute a command during DSC **Set**
  operation.
- [Microsoft.DSC.Transitional/WindowsPowerShellScript][11] - Enable running Windows PowerShell 5.1
  scripts inline.
- [Microsoft.Windows/FeatureOnDemandList][12] - Manage Windows features on demand (capabilities)
  using the DISM API.
- [Microsoft.Windows/FirewallRuleList][13] - Manage Windows Firewall rules using the netfw.h APIs.
- [Microsoft.Windows/OptionalFeatureList][14] - Manage Windows Optional features using the DISM
  API.
- [Microsoft.Windows/RebootPending][15] - Checks if a Windows system has a pending reboot.
- [Microsoft.Windows/Registry][16] - Manage Windows Registry keys and values.
- [Microsoft.Windows/Service][17] - Manage Windows services.
- [Microsoft.Windows/WindowsPowerShell][18] - Adapter for resources implemented as binary, script,
  or PowerShell classes.
- [Microsoft.Windows/WMI][19] - Adapter for querying and retrieving information from Windows
  Management Instrumentation (WMI).

## Built-in assertion resources

You can use the following built-in resources to query the current state of a machine but not to
change the state of the machine directly:

- [Microsoft/OSInfo][03] - Returns information about the operating system.
- `Microsoft.DSC/Assertion`
- [Microsoft.Windows/RebootPending][15] - Checks if a Windows system has a pending reboot.

## Built-in adapter resources

You can use the following built-in resources to handle resources that don't define a DSC resource
manifest:

- [Microsoft.Adapter/PowerShell][04] - Adapter for resources implemented as PowerShell DSC classes.
- [Microsoft.Adapter/WindowsPowerShell][05] - Adapter for resources implemented as binary, script,
  or PowerShell classes in Windows PowerShell.
- [Microsoft.DSC/PowerShell][07] - Adapter for resources implemented as PowerShell classes.
- [Microsoft.Windows/WindowsPowerShell][18] - Adapter for resources implemented as binary, script,
  or PowerShell classes.
- [Microsoft.Windows/WMI][19] - Adapter for querying and retrieving information from Windows
  Management Instrumentation (WMI).

> [!WARNING]
> `Microsoft.DSC/PowerShell` and `Microsoft.Windows/WindowsPowerShell` will be deprecated in a
> future release. Use `Microsoft.Adapter/PowerShell` and `Microsoft.Adapter/WindowsPowerShell`
> instead.

## Built-in configurable resources

You can use the following built-in resources to change the state of a machine directly:

- [DSC.PackageManagement/Apt][01] - Manage packages with the advanced package tool (APT) on Linux
  systems.
- [DSC.PackageManagement/Brew][02] - Manage packages using Homebrew on macOS systems.
- [Microsoft.DSC.Transitional/PowerShellScript][09] - Enable running PowerShell 7 scripts inline.
- [Microsoft.DSC.Transitional/RunCommandOnSet][10] - Execute a command during DSC **Set**
  operation.
- [Microsoft.DSC.Transitional/WindowsPowerShellScript][11] - Enable running Windows PowerShell 5.1
  scripts inline.
- [Microsoft.Windows/FeatureOnDemandList][12] - Manage Windows features on demand (capabilities)
  using the DISM API.
- [Microsoft.Windows/FirewallRuleList][13] - Manage Windows Firewall rules using the netfw.h APIs.
- [Microsoft.Windows/OptionalFeatureList][14] - Manage Windows Optional features using the DISM
  API.
- [Microsoft.Windows/Registry][16] - Manage Windows Registry keys and values.
- [Microsoft.Windows/Service][17] - Manage Windows services.

## Built-in debugging resources

You can use the following built-in resources when debugging or exploring DSC. They don't affect
the state of the machine.

- [Microsoft.DSC.Debug/Echo][08] - A debug resource for testing and troubleshooting DSC behavior.

## Built-in group resources

You can use the following built-in resources to change how DSC processes a group of nested resource
instances:

- `Microsoft.DSC/Assertion`
- `Microsoft.DSC/Group`
- [Microsoft.DSC/Include][06] - Includes a nested configuration document, with optional parameters,
  into the current configuration.

<!-- Link reference definitions -->
[01]: ./DSC/PackageManagement/APT/index.md
[02]: ./DSC/PackageManagement/Brew/index.md
[03]: ./Microsoft/OSInfo/index.md
[04]: ./Microsoft/Adapter/PowerShell/index.md
[05]: ./Microsoft/Adapter/WindowsPowerShell/index.md
[06]: ./Microsoft/DSC/Include/index.md
[07]: ./Microsoft/DSC/PowerShell/index.md
[08]: ./Microsoft/DSC/Debug/echo/index.md
[09]: ./Microsoft/DSC/Transitional/PowerShellScript/index.md
[10]: ./Microsoft/DSC/Transitional/RunCommandOnSet/index.md
[11]: ./Microsoft/DSC/Transitional/WindowsPowerShellScript/index.md
[12]: ./Microsoft/Windows/FeatureOnDemandList/index.md
[13]: ./Microsoft/Windows/FirewallRuleList/index.md
[14]: ./Microsoft/Windows/OptionalFeatureList/index.md
[15]: ./Microsoft/Windows/RebootPending/index.md
[16]: ./Microsoft/Windows/Registry/index.md
[17]: ./Microsoft/Windows/Service/index.md
[18]: ./Microsoft/Windows/WindowsPowerShell/index.md
[19]: ./Microsoft/Windows/WMI/index.md
