---
ms.date: 08/08/2022
ms.topic: reference
title: WindowsFeatureSet
description: PSDscResources WindowsFeatureSet composite resource
---

# WindowsFeatureSet

## Synopsis

Manage multiple Windows roles or features with common settings.

## Syntax

```Syntax
WindowsFeatureSet [String] #ResourceName
{
    [DependsOn = [String[]]]
    [PsDscRunAsCredential = [PSCredential]]
    Name = [String[]]
    [Ensure = [String]]
    [Source = [String]]
    [IncludeAllSubFeature = [Boolean]]
    [Credential = [PSCredential]]
    [LogPath = [String]]
}
```

## Description

The `WindowsFeatureSet` resource enables you to configure multiple Windows roles or features with a
limited set of common options. To manage roles or features with more control, use the
[WindowsFeature resource][1]. To manage To manage a client computer, use the
[WindowsOptionalFeature resource][2].

### Requirements

- Target machine must be running Windows Server 2008 or later.
- Target machine must have access to the **DISM** PowerShell module.
- Target machine must have access to the **ServerManager** PowerShell module.

## Properties

## Key properties

### Name

Specify the names of the roles or features as an array of strings.

The values for this property should be the same as the **Name** property of each role or feature,
not their **DisplayName** property. To list the available roles and features for a computer, use the
`Get-WindowsFeature` cmdlet.

```
Type: System.String
```

## Optional properties

### Credential

Specify the credential for an account to add or remove the roles or features as.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the roles or features should be installed. Set this property to `Present` to install
the role or feature if it isn't installed. Set this property to `Absent` to uninstall the role or
feature if it's installed.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### IncludeAllSubFeature

Specify whether to install every subfeature of each feature or role. Set this property to `$true` to
install any missing subfeatures. Set this property to `$false` to ignore subfeatures. Regardless of
this property's setting, the resource removes every subfeature of each role or feature if **Ensure**
is set to `Absent`.

The default value is `$false`.

```
Type: System.Boolean
Behavior: Write
Default Value: false
```

### LogPath

Specify the path to a file to log the installation or uninstallation of the features or roles.

```
Type: System.String
Default Value: None
```

## Read-only properties

### DisplayName

The display names of the retrieved roles or features.

```
Type: System.String
Behavior: Read
```

## Examples

- [Install multiple Windows features][3]
- [Uninstall multiple Windows features][4]

<!-- Reference Links -->

[1]: ../WindowsFeature/WindowsFeature.md
[2]: ../WindowsOptionalFeature/WindowsOptionalFeature.md
[3]: Install.md
[4]: Uninstall.md
