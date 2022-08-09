---
ms.date: 08/08/2022
ms.topic: reference
title: ProcessSet
description: PSDscResources ProcessSet composite resource
---

# ProcessSet

## Synopsis

Manage multiple Windows processes with common settings.

## Syntax

```Syntax
ProcessSet [String] #ResourceName
{
    [DependsOn = [String[]]]
    [PsDscRunAsCredential = [PSCredential]]
    Path = [String[]]
    [Ensure = [String]]
    [Credential = [PSCredential]]
    [StandardOutputPath = [String]]
    [StandardErrorPath = [String]]
    [StandardInputPath = [String]]
    [WorkingDirectory = [String]]
}
```

## Description

The `ProcessSet` composite resource enables you to configure multiple Windows processes with a
limited set of common options. To manage processes with more control, including the ability to pass
arguments to the process, use the [WindowsProcess resource][1].

### Requirements

None.

## Key properties

### Path

Specify the paths to the processes' executable files. If a file is accessible through the `PATH`
environment variable, you may specify the file's name. Otherwise, specify the full path to the file.
Relative paths aren't supported.

```
Type: System.String[]
Behavior: Key
```

## Optional properties

### Credential

Specify the credential of the account to run the processes under.

If this property is set to a local system account, you can't set the **StandardOutputPath**,
**StandardInputPath**, or **WorkingDirectory** properties. If you do, the resource throws an invalid
argument exception.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the processes should be running. Set this property to `Present` to start the
processes if they aren't running. Set this property to `Absent` to stop the processes if they're
running.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### StandardErrorPath

Specify the full path to a file for the processes to write their standard error streams to. Relative
paths aren't supported. If the file exists, it's overwritten.

Don't set this property when setting the **Ensure** property to `Absent`. If you do, the resource
throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### StandardInputPath

Specify the full path to a file for the processes to read as their standard input stream. Relative
paths aren't supported.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### StandardOutputPath

Specify the full path to a file for the processes to write their standard output streams to.
Relative paths aren't supported. If the file exists, it's overwritten.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### WorkingDirectory

Specify the full path to a folder for the processes' working directory. Relative paths aren't
supported.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

## Read-only properties

### HandleCount

The number of handles opened by the processes.

```
Type: System.SInt32
Behavior: Read
```

### NonPagedMemorySize

The amount of nonpaged memory, in bytes, allocated for the processes.

```
Type: System.UInt64
Behavior: Read
```

### PagedMemorySize

The amount of paged memory, in bytes, allocated for the processes.

```
Type: System.UInt64
Behavior: Read
```

### ProcessCount

The number of instances of the given processes that are currently running.

```
Type: System.SInt32
Behavior: Read
```

### ProcessId

The unique identifier of the processes.

```
Type: System.SInt32
Behavior: Read
```

### VirtualMemorySize

The amount of virtual memory, in bytes, allocated for the processes.

```
Type: System.UInt64
Behavior: Read
```

## Examples

- [Start multiple processes][2]
- [Stop multiple processes][3]

<!-- Reference Links -->

[1]: ../WindowsProcess/WindowsProcess.md
[2]: Start.md
[3]: Stop.md
