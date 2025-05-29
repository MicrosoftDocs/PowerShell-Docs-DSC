---
Download Help Link: https://aka.ms/powershell72-help
Help Version: 7.2.0.0
Locale: en-US
Module Guid: 779e0998-8c72-4567-89b5-49313fc15351
Module Name: PSDesiredStateConfiguration
ms.date: 05/19/2025
schema: 2.0.0
title: PSDesiredStateConfiguration
---
# PSDesiredStateConfiguration Module

## Description

The PSDesiredStateConfiguration module supports PowerShell Desired State Configuration (PSDSC).
Each major version of this module supports different use cases:

- v1.1 is only supported for Windows PowerShell. You can use it to invoke PSDSC resources and to
  author and apply PSDSC configurations.
- v2 is only supported for PowerShell. You can use it to invoke PSDSC resources and to compile
  PSDSC configurations. It's intended use is to support Azure Machine Configuration.
- v3 (preview) is only supported for PowerShell. You can use it to invoke PSDSC resources. It's
  intended use is for invoking PSDSC resources on Linux machines with Azure Machine Configuration.

Microsoft Desired State Configuration (DSC) enables you to manage PSDSC resources through two
adapters:

- The `Microsoft.Windows/WindowsPowerShell` adapter enables you to invoke any PSDSC resource usable
  with **PSDesiredStateConfiguration** version 1.1 in Windows PowerShell.
- The `Microsoft.DSC/PowerShell` adapter enables you to invoke any class-based PSDSC resource in
  PowerShell. It doesn't rely on the **PSDesiredStateConfiguration** module.

## PSDesiredStateConfiguration Cmdlets

### [Get-DscResource](Get-DscResource.md)

Gets Desired State Configuration (DSC) resources present on the computer.

### [Invoke-DscResource](Invoke-DscResource.md)

Runs a method of a specified PowerShell Desired State Configuration (DSC) resource.

### [New-DscChecksum](New-DscChecksum.md)

Creates checksum files for DSC documents and DSC resources.
