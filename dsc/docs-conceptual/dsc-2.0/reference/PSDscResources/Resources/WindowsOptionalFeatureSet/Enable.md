---
ms.date: 08/08/2022
ms.topic: reference
title: Enable multiple features
description: >
  Use the PSDscResources WindowsOptionalFeatureSet composite resource to enable multiple features.
---

# Enable multiple features

## Description

This example shows how you can use the `WindowsOptionalFeatureSet` composite resource to ensure
multiple Windows optional features are enabled.

With **Ensure** set to `Present` and the **Name** property set to the array of
`MicrosoftWindowsPowerShellV2` and `Internet-Explorer-Optional-amd64`, the resource enables those
Windows optional features if they're disabled.

With **LogPath** set to `C:\LogPath\Log.txt`, the resource writes the logs for enabling the features
to that file instead of `%WINDIR%\Logs\Dism\dism.log`.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[WindowsOptionalFeature resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsOptionalFeatureSet` resource
block to ensure that the `MicrosoftWindowsPowerShellV2` and `Internet-Explorer-Optional-amd64`
Windows optional features are enabled.

> [!IMPORTANT]
> There's a limitation in machine configuration that prevents a DSC Resource from using any
> PowerShell cmdlets not included in PowerShell itself or in a module on the PowerShell Gallery.
> This example is provided for demonstrative purposes, but because the DSC Resource uses cmdlets
> from the DISM module, which ships as one of the [Windows modules][2], it won't work in machine
> configuration.

:::code source="Enable.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsOptionalFeature/WindowsOptionalFeature.md
[2]: /powershell/windows/module-compatibility#module-list
