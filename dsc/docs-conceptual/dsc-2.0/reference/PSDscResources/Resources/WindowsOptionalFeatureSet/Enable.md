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

:::code source="Enable.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsOptionalFeature/WindowsOptionalFeature.md
