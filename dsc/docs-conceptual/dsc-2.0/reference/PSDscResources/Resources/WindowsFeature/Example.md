---
ms.date: 08/08/2022
ms.topic: reference
title: Install or uninstall a Windows feature
description: >
  Use the PSDscResources WindowsFeature resource to install or uninstall a Windows feature.
---

# Install or uninstall a Windows feature

## Description

This example shows how you can use the `WindowsFeature` resource to ensure a
Windows Feature is:

- Installed or uninstalled
- Whether it's installed with its subfeatures
- Whether it's installed as a specific account

All of the values provided for the resource are user-provided, not hard-coded. The parameters map
to the resource's properties, changing its behavior.

### Name

If you don't specify the **Name** parameter, the resource's **Name** property is set to
`Telnet-Client`. This the Windows feature the resource will install or uninstall.

### Ensure

If you don't specify the **Ensure** parameter, the resource's **Ensure** property is set to
`Present` and the resource installs the Windows feature if it isn't already installed.

If you specify **Ensure** as `Absent`, the resource uninstalls the Windows feature if it's
installed.

### IncludeAllSubFeature

If you don't specify the **IncludeAllSubFeature** parameter, the resource's **IncludeAllSubFeature**
property is set to `$false` and the resource does not install the Windows feature's subfeatures if
**Ensure** is set to `Present`.

If **Ensure** is set to `Absent`, the resource always uninstalls the subfeatures for any Windows
feature it removes.

### Credential

If you don't specify the **Credential** parameter, the resource doesn't set the **Credential**
property and installs or uninstalls of the Windows feature under the default account.

### LogPath

If you don't specify the **LogPath** parameter, the resource doesn't set the **LogPath** property
and doesn't write the logs for installing or uninstalling the Windows feature to a file.

## With Invoke-DscResource

This script shows how you can use the `WindowsFeature` resource with the `Invoke-DscResource` cmdlet
to ensure a Windows Feature is installed or installed with user-provided settings.

By default, it ensures the `Telnet-Client` Windows feature is installed without subfeatures and
doesn't write the installation logs to a file.

:::code source="Example.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsFeature` resource block to
ensure a Windows Feature is installed or installed with user-provided settings.

By default, it ensures the `Telnet-Client` Windows feature is installed without subfeatures and
doesn't write the installation logs to a file.

:::code source="Example.Config.ps1":::
