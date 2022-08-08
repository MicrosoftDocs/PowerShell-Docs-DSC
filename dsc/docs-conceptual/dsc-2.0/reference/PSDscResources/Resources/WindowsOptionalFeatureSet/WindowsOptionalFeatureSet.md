---
ms.date: 08/08/2022
ms.topic: reference
title: WindowsOptionalFeatureSet
description: PSDscResources WindowsOptionalFeatureSet composite resource
---

# WindowsOptionalFeatureSet

## Synopsis

Manage multiple Windows optional features with common settings.

## Syntax

```text
WindowsOptionalFeatureSet [String] #ResourceName
{
    [DependsOn = [String[]]]
    [PsDscRunAsCredential = [PSCredential]]
    Name = [String[]]
    Ensure = [String]
    [RemoveFilesOnDisable = [Boolean]]
    [NoWindowsUpdateCheck = [Boolean]]
    [LogPath = [String]]
    [LogLevel = [String]]
}
```

## Description

The `WindowsOptionalFeatureSet` composite resource enables you to configure multiple Windows
optional features. To configure one Windows optional feature at a time, use the
[WindowsOptionalFeature resource][1]. To manage a Windows Server's roles and features, use the
[WindowsFeature resource][2].

### Requirements

- Target machine must be running a Windows client operating system, Windows Server 2012 or later, or
  Nano Server.
- Target machine must have access to the **DISM** PowerShell module.

## Key properties

### Name

Specify the names of the Windows optional features as an array of strings.

Each value for this property should be the same as the **FeatureName** property of a Windows
optional feature. To list the available optional features for a computer, use the
`Get-WindowsOptionalFeature` cmdlet.

```yaml
Type: System.String[]
```

## Optional properties

### Ensure

Specify whether the Windows optional features should be enabled. Set this property to `Present` to
enable the Windows optional features. Set this property to `Absent` to disable the Windows optional
features.

The default value is `Present`.

```yaml
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### LogLevel

Specify the maximum output level to show in the DISM logs as a string. Valid log levels include:

- `ErrorsOnly` - The resource only logs errors.
- `ErrorsAndWarning` - The resource logs errors and warnings.
- `ErrorsAndWarningAndInformation` - The resource logs errors, warnings, and debug information.

The default value is `ErrorsAndWarningAndInformation`.

```yaml
Type: System.String
Accepted Values:
  - ErrorsOnly
  - ErrorsAndWarning
  - ErrorsAndWarningAndInformation
Default Value: ErrorsAndWarningAndInformation
```

### LogPath

Specify the path to a file to log the enabling or disabling of the Windows optional features.

If not set, the resource writes the log to `%WINDIR%\Logs\Dism\dism.log`.

```yaml
Type: System.String
Default Value: None
```

### NoWindowsUpdateCheck

Specify whether DISM contacts Windows Update (WU) when searching for the source files to enable the
Windows optional features. Set this property to `$true` to prevent DISM from contacting WU.

The default value is `$false`.

```yaml
Type: System.Boolean
Default Value: false
```

### RemoveFilesOnDisable

Specify whether the resource should remove all files associated with the Windows optional features
when disabling them. Set this property to `$true` to remove all associated files.

The default value is `$false`.

```yaml
Type: System.Boolean
Default Value: false
```

## Examples

- [Enable multiple features][2]
- [Disable multiple features][4]

[1]: ../WindowsOptionalFeature/WindowsOptionalFeature.md
[2]: ../WindowsFeature/WindowsFeature.md
[2]: Enable.md
[4]: Disable.md
