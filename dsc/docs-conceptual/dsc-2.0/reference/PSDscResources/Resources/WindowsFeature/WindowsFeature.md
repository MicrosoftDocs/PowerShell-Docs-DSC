---
ms.date: 08/08/2022
ms.topic: reference
title: WindowsFeature
description: PSDscResources WindowsFeature resource
---

# WindowsFeature

## Synopsis

Install or uninstall a Windows role or feature.

## Syntax

```text
WindowsFeature [String] #ResourceName
{
    Name = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [IncludeAllSubFeature = [bool]]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

## Description

The `WindowsFeature` resource enables you to ensure whether a Windows role or feature is installed
on a Windows Server. To manage a client computer, use the [WindowsOptionalFeature resource][1].

### Requirements

- Target machine must be running Windows Server 2008 or later.
- Target machine must have access to the **DISM** PowerShell module.
- Target machine must have access to the **ServerManager** PowerShell module.

## Properties

## Key properties

### Name

Specify the name of the role or feature as a string.

This value for this property should be the same as the **Name** property of the role or feature, not
the **DisplayName** property. To list the available roles and features for a computer, use the
`Get-WindowsFeature` cmdlet.

```yaml
Type: System.String
```

## Optional properties

### Credential

Specify the credential for an account to add or remove the role or feature as.

```yaml
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the role or feature should be installed. Set this property to `Present` to install
the role or feature if it isn't installed. Set this property to `Absent` to uninstall the role or
feature if it's installed.

The default value is `Present`.

```yaml
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### IncludeAllSubFeature

Specify whether to install every subfeature of the feature or role. Set this property to `$true` to
install any missing subfeatures. Set this property to `$false` to ignore subfeatures. Regardless of
this property's setting, the resource removes all subfeatures if **Ensure** is set to `Absent`.

The default value is `$false`.

```yaml
Type: System.Boolean
Behavior: Write
Default Value: false
```

### LogPath

Specify the path to a file to log the installation or uninstallation of the feature or role.

```yaml
Type: System.String
Default Value: None
```

## Read-only properties

### DisplayName

The display name of the retrieved role or feature.

```yaml
Type: System.String
```

## Examples

- [Install or uninstall a Windows feature][2]

<!-- Reference Links -->

[1]: ../WindowsOptionalFeature/WindowsOptionalFeature.md
[2]: Example.md
