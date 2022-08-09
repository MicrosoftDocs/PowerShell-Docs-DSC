---
ms.date: 08/08/2022
ms.topic: reference
title: WindowsOptionalFeature
description: PSDscResources WindowsOptionalFeature resource
---

# WindowsOptionalFeature

## Synopsis

Enable or disable a Windows optional feature.

## Syntax

```Syntax
WindowsOptionalFeature [String] #ResourceName
{
    Name = [string]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [LogLevel = [string]{ ErrorsAndWarning | ErrorsAndWarningAndInformation | ErrorsOnly }]
    [LogPath = [string]]
    [NoWindowsUpdateCheck = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
    [RemoveFilesOnDisable = [bool]]
}
```

## Description

The `WindowsOptionalFeature` resource allows you to ensure whether a Windows optional feature is
enabled or disabled on a Windows client computer. To manage the roles and features of a Windows
Server, use the [WindowsFeature resource][1].

### Requirements

- Target machine must be running a Windows client operating system, Windows Server 2012 or later, or
  Nano Server.
- Target machine must have access to the **DISM** PowerShell module

## Key Properties

### Name

Specify the name of the Windows optional feature as a string.

This value for this property should be the same as the **FeatureName** property of the Windows
optional feature. To list the available optional features for a computer, use the
`Get-WindowsOptionalFeature` cmdlet.

```
Type: System.String
```

## Optional properties

### Ensure

Specify whether the Windows optional feature should be enabled. Set this property to `Present` to
enable the Windows optional feature if it's disabled. Set this property to `Absent` to disable the
Windows optional feature if its enabled.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### LogLevel

Specify the maximum output level to show in the DISM log as a string. Valid log levels include:

- `ErrorsOnly` - The resource only logs errors.
- `ErrorsAndWarning` - The resource logs errors and warnings.
- `ErrorsAndWarningAndInformation` - The resource logs errors, warnings, and debug information.

The default value is `ErrorsAndWarningAndInformation`.

```
Type: System.String
Accepted Values:
  - ErrorsOnly
  - ErrorsAndWarning
  - ErrorsAndWarningAndInformation
Default Value: ErrorsAndWarningAndInformation
```

### LogPath

Specify the path to a file to log the enabling or disabling of the Windows optional feature.

If not set, the resource writes the log to `%WINDIR%\Logs\Dism\dism.log`.

```
Type: System.String
Default Value: None
```

### NoWindowsUpdateCheck

Specify whether DISM contacts Windows Update (WU) when searching for the source files to enable the
Windows optional feature. Set this property to `$true` to prevent DISM from contacting WU.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### RemoveFilesOnDisable

Specify whether the resource should remove all files associated with the Windows optional feature
when disabling it. Set this property to `$true` to remove all associated files.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

## Read-only properties

### CustomProperties

The Windows optional feature's custom properties as an array of strings.

```
Type: System.String[]
```

### Description

The Windows optional feature's description as a string.

```
Type: System.String
```

### DisplayName

The Windows optional feature's display name as a string.

```
Type: System.String
```

## Examples

- [Enable the specified Windows optional feature and output logs to the specified path][2]

<!-- Reference Links -->

[1]: ../WindowsFeature/WindowsFeature.md
[2]: Enable.md
