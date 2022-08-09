---
ms.date: 08/08/2022
ms.topic: reference
title: WindowsProcess
description: PSDscResources WindowsProcess resource
---

# WindowsProcess

## Synopsis

Start or stop a Windows process.

## Syntax

```Syntax
WindowsProcess [String] #ResourceName
{
    Arguments = [string]
    Path = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [PsDscRunAsCredential = [PSCredential]]
    [StandardErrorPath = [string]]
    [StandardInputPath = [string]]
    [StandardOutputPath = [string]]
    [WorkingDirectory = [string]]
}
```

## Description

The `WindowsProcess` resource enables you to ensure whether a process is running.

### Requirements

None.

## Key properties

### Arguments

Specify the full list of arguments to pass to the process when starting it as a string. Set this
property to an empty string (`''`) if the process doesn't require any arguments.

```
Type: System.String
```

### Path

Specify the path to process's executable file. If the file is accessible through the `PATH`
environment variable, you may set this property to the executable file's name. Otherwise, set this
property to the full path to the file. Relative paths aren't supported.

```
Type: System.String
```

## Optional properties

### Credential

Specify the credential of the account to run the process under.

If this property is set to a local system account, you can't set the **StandardOutputPath**,
**StandardInputPath**, or **WorkingDirectory** properties. If you do, the resource throws an invalid
argument exception.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the process should be running. Set this property to `Present` to start the process
if it isn't running. Set this property to `Absent` to stop the process if it's running.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### StandardErrorPath

Specify the full path to a file for the process to write its standard error stream to. Relative
paths aren't supported. If the file exists, it's overwritten.

Don't set this property when setting the **Ensure** property to `Absent`. If you do, the resource
throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### StandardInputPath

Specify the full path to a file for the process to read as its standard input stream. Relative paths
aren't supported.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### StandardOutputPath

Specify the full path to a file for the process to write its standard output stream to. Relative
paths aren't supported. If the file exists, it's overwritten.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### WorkingDirectory

Specify the full path to a folder for the process's working directory. Relative paths aren't
supported.

Don't set this property when setting the **Ensure** property to `Absent` or the **Credential**
property to a local system account. If you do, the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

## Read-only properties

### HandleCount

The number of handles opened by the process.

```
Type: System.Int32
Behavior: Read
```

### NonPagedMemorySize

The amount of nonpaged memory, in bytes, allocated for the process.

```
Type: System.UInt64
Behavior: Read
```

### PagedMemorySize

The amount of paged memory, in bytes, allocated for the process.

```
Type: System.UInt64
Behavior: Read
```

### ProcessCount

The number of instances of the given process that are currently running.

```
Type: System.Int32
Behavior: Read
```

### ProcessId

The unique identifier of the process.

```
Type: System.Int32
Behavior: Read
```

### VirtualMemorySize

The amount of virtual memory, in bytes, allocated for the process.

```
Type: System.UInt64
Behavior: Read
```

## Examples

- [Start a process][1]
- [Stop a process][2]
- [Start a process under a user][3]
- [Stop a process under a user][4]

<!-- Reference Links -->

[1]: Start.md
[2]: Stop.md
[3]: StartUnderUser.md
[4]: StopUnderUser.md
