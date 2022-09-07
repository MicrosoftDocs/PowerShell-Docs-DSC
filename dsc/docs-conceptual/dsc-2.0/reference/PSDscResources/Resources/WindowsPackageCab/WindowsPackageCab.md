---
description: PSDscResources WindowsPackageCab resource
ms.date: 08/08/2022
ms.topic: reference
title: WindowsPackageCab
---

# WindowsPackageCab

## Synopsis

Install or uninstall a package from a Windows cabinet (`.cab`) file.

## Syntax

```Syntax
WindowsPackageCab [String] #ResourceName
{
    Ensure = [string]{ Absent | Present }
    Name = [string]
    SourcePath = [string]
    [DependsOn = [string[]]]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

## Description

The `WindowsPackageCab` resource enables you to ensure whether a package from a Windows cabinet
(`.cab`) file is installed.

### Requirements

- Target machine must have access to the **DISM** PowerShell module

## Key properties

### Name

Specify the name of the package as a string.

```
Type: System.String
```

## Mandatory properties

### Ensure

Specify whether the package should be installed. Set this property to `Present` to install the
package. Set this property to `Absent` to uninstall the package.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
```

### SourcePath

Specify the path to the package's `.cab` file as a string. If the file doesn't exist, the resource
throws an invalid argument exception when it attempts to install or uninstall the package.

```
Type: System.String
```

## Optional properties

### LogPath

Specify the path to a file to log the installing or uninstalling of the package.

If not set, the resource writes the log to `%WINDIR%\Logs\Dism\dism.log`.

```
Type: System.String
Behavior: Write
Default Value: No
```

## Examples

- [Install a cab file with the given name from the given path][1]

<!-- Reference Links -->

[1]: Install.md
