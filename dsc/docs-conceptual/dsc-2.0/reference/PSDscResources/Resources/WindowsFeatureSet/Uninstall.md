---
description: >
  Use the PSDscResources WindowsFeatureSet composite resource to uninstall multiple Windows
  features.
ms.date: 08/08/2022
ms.topic: reference
title: Uninstall multiple Windows features
---

# Uninstall multiple Windows features

## Description

This example shows how you can use the `WindowsFeatureSet` composite resource to ensure multiple
Windows features are installed with their subfeatures.

With **Ensure** set to `Absent` and **Name** set to the array of `Telnet-Client` and
`RSAT-File-Services`, the resource uninstalls the `Telnet-Client` and `RSAT-File-Services` Windows
features and their subfeatures if they're installed.

With **LogPath** set to `C:\LogPath\Log.log`, if the resource needs to uninstall `Telnet-Client` or
`RSAT-File-Services`, the resource writes the uninstallation logs to `C:\LogPath\Log.log`.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[WindowsFeature resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsFeatureSet` resource block to
ensure that the `Telnet-Client` and `RSAT-File-Services` Windows features and their subfeatures are
uninstalled.

> [!IMPORTANT]
> There's a limitation in machine configuration that prevents a DSC Resource from using any
> PowerShell cmdlets not included in PowerShell itself or in a module on the PowerShell Gallery.
> This example is provided for demonstrative purposes, but because the DSC Resource uses cmdlets
> from the DISM module, which ships as one of the [Windows modules][2], it won't work in machine
> configuration.

:::code source="Uninstall.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsFeature/WindowsFeature.md
[2]: /powershell/windows/module-compatibility#module-list
