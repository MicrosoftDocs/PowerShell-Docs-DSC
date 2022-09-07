---
description: >
  Use the PSDscResources WindowsPackageCab resource to install a cab file with the given name from
  the given path.
ms.date: 08/08/2022
ms.topic: reference
title: Install a cab file with the given name from the given path
---

# Install a cab file with the given name from the given path

## Description

This example shows how you can use the `WindowsPackageCab` resource user-provided values to ensure a
package is installed.

You must specify the name of the package with the **Name** parameter, which sets the **Name**
property of the resource.

You must specify the path to the `.cab` file the package can be installed from with the
**SourcePath** parameter, which sets the **SourcePath** property of the resource.

You must specify the path to a log file with the **LogPath** parameter, which sets the **LogPath**
property of the resource.

With **Ensure** set to `Present`, the **Name** property set to the user-provided value from the
**Name** parameter, and **SourcePath** set to the user-provided value from the **SourcePath**
parameter, the resource installs the named package from the specified `.cab` file if it isn't
already installed.

With **LogPath** set to the user-provided value from the **LogPath** parameter, the resource writes
the logs for installing the package to that file instead of `%WINDIR%\Logs\Dism\dism.log`.

## With Invoke-DscResource

This script shows how you can use the `WindowsPackageCab` resource with the `Invoke-DscResource`
cmdlet to ensure a user-specified package is installed.

:::code source="Install.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsPackageCab` resource block to
ensure a user-specified package is installed.

> [!IMPORTANT]
> There's a limitation in machine configuration that prevents a DSC Resource from using any
> PowerShell cmdlets not included in PowerShell itself or in a module on the PowerShell Gallery.
> This example is provided for demonstrative purposes, but because the DSC Resource uses cmdlets
> from the DISM module, which ships as one of the [Windows modules][1], it won't work in machine
> configuration.

:::code source="Install.Config.ps1":::

<!-- Reference Links -->

[1]: /powershell/windows/module-compatibility#module-list
