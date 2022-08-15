---
ms.date: 08/08/2022
ms.topic: reference
title: Install multiple Windows features
description: >
  Use the PSDscResources WindowsFeatureSet composite resource to install multiple Windows features.
---

# Install multiple Windows features

## Description

This example shows how you can use the `WindowsFeatureSet` composite resource to ensure multiple
Windows features are installed with their subfeatures.

With **Ensure** set to `Present`, **IncludeAllSubFeature** set to `$true`, and **Name** set to the
array of `Telnet-Client` and `RSAT-File-Services`, the resource installs the `Telnet-Client` and
`RSAT-File-Services` Windows features and their subfeatures if they're not already installed.

With **LogPath** set to `C:\LogPath\Log.log`, if the resource needs to install `Telnet-Client` or
`RSAT-File-Services`, the resource writes the installation logs to `C:\LogPath\Log.log`.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[WindowsFeature resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsFeatureSet` resource block to
ensure that the `Telnet-Client` and `RSAT-File-Services` Windows features are installed with their
subfeatures.

:::code source="Install.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsFeature/WindowsFeature.md
