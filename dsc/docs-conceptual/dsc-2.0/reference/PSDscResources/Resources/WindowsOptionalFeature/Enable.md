---
description: >
  Use the PSDscResources WindowsOptionalFeature resource to enable the specified Windows optional
  feature and output logs to the specified path.
ms.date: 08/08/2022
ms.topic: reference
title: Enable the specified Windows optional feature and output logs to the specified path
---

# Enable the specified Windows optional feature and output logs to the specified path

## Description

This example shows how you can use the `WindowsOptionalFeature` resource with user-provided values
to ensure a Windows optional feature is enabled.

You must specify the name of the Windows optional feature to enable with the **FeatureName**
parameter, which sets the **Name** property of the resource.

You must specify the path to a log file with the **LogPath** parameter, which sets the **LogPath**
property of the resource.

With **Ensure** set to `Present` and the **Name** property set to the user-provided value from the
**FeatureName** parameter, the resource enables the specified Windows optional feature if it's
disabled.

With **LogPath** set to the user-provided value from the **LogPath** parameter, the resource writes
the logs for enabling the feature to that file instead of `%WINDIR%\Logs\Dism\dism.log`.

## With Invoke-DscResource

This script shows how you can use the `WindowsOptionalFeature` resource with the
`Invoke-DscResource` cmdlet to ensure a user-specified feature is enabled.

:::code source="Enable.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsOptionalFeature` resource
block to ensure a user-specified feature is enabled.

> [!IMPORTANT]
> There's a limitation in machine configuration that prevents a DSC Resource from using any
> PowerShell cmdlets not included in PowerShell itself or in a module on the PowerShell Gallery.
> This example is provided for demonstrative purposes, but because the DSC Resource uses cmdlets
> from the DISM module, which ships as one of the [Windows modules][1], it won't work in machine
> configuration.

:::code source="Enable.Config.ps1":::

<!-- Reference Links -->

[1]: /powershell/windows/module-compatibility#module-list