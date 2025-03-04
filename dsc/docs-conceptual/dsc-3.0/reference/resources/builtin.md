---
description: >-
  Lists the builtin DSC resources and links to the reference documentation for those resources.
ms.date: 03/25/2025
title: Builtin DSC resources reference
---

# Builtin DSC resources reference

Each release of DSC includes builtin resources that you can use immediately after you install DSC.
This document lists the available resources and links to the reference documentation for each.

> [!NOTE]
> The team hasn't documented every builtin resource yet. As they add reference documentation for
> these resources, the team will update this article to link to the documentation for those
> resources.

## All builtin resources

- [Microsoft/OSInfo][01] - Returns information about the operating system.
- `Microsoft.DSC/Assertion`
- `Microsoft.DSC/Group`
- `Microsoft.DSC/Include`
- `Microsoft.DSC/PowerShell`
- `Microsoft.DSC.Debug/Echo`
- `Microsoft.DSC.Transitional/RunCommandOnSet`
- `Microsoft.Windows/RebootPending`
- [Microsoft.Windows/Registry][09] - Manage Windows Registry keys and values.
- `Microsoft.Windows/WindowsPowerShell`
- `Microsoft.Windows/WMI`

## Builtin assertion resources

You can use the following builtin resources to query the current state of a machine but not to
change the state of the machine directly:

- [Microsoft/OSInfo][01] - Returns information about the operating system.
- `Microsoft.DSC/Assertion`
- `Microsoft.Windows/RebootPending`

## Builtin adapter resources

You can use the following builtin resources to handle resources that don't have a DSC resource
manifest:

- `Microsoft.DSC/PowerShell`
- `Microsoft.Windows/WindowsPowerShell`
- `Microsoft.Windows/WMI`

## Builtin configurable resources

The following builtin resources to change the state of a machine directly:

- `Microsoft.DSC.Transitional/RunCommandOnSet`
- [Microsoft.Windows/Registry][09] - Manage Windows Registry keys and values.

## Builtin debugging resources

You can use the following builtin resources when debugging or exploring DSC. They don't affect
the state of the machine.

- `Microsoft.DSC.Debug/Echo`

## Builtin group resources

You can use the following builtin resources to change how DSC processes a group of nested resource
instances:

- `Microsoft.DSC/Assertion`
- `Microsoft.DSC/Group`
- `Microsoft.DSC/Include`

<!-- Link reference definitions -->
[01]: ./Microsoft/OSInfo/index.md
[09]: ./Microsoft/Windows/Registry/index.md
