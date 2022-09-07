---
description: PSDscResources Environment resource
ms.date: 08/08/2022
ms.topic: reference
title: Environment
---

# Environment

## Synopsis

Manage an environment variable for a machine or process.

## Syntax

```Syntax
Environment [String] #ResourceName
{
    Name = [string]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [Path = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
    [Target = [string[]]{ Machine | Process }]
    [Value = [string]]
}
```

## Description

The `Environment` resource enables you to create, update, and remove environment variables in the
`Machine` and `Process` targets. It can manage path-type environment variables, ensuring a specific
value is included or removed from the environment variable.

### Requirements

None.

## Key properties

### Name

Specify the name of the environment variable.

```
Type: System.String
```

## Optional properties

### Ensure

Specify whether the environment variable should exist. Specify this property as `Absent` to remove
the environment variable if it exists. Specify this property as `Present` to create the environment
variable if it doesn't exist and enforce the **Value** property if it's set. The default value is
`Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### Path

Specify whether to treat the environment variable as a path variable. This modifies the **Ensure**
behavior for the environment variable:

- When **Path** is `$true`, **Ensure** is `Present`, and the **Value** isn't included in the current
  value of the environment variable, the resource appends the **Value** to the current value of the
  environment variable.
- When **Path** is `$true`, **Ensure** is `Absent`, and the **Value** is included in the current value
  of the environment variable, the resource removes the **Value** from the current value of the
  environment variable.
- When **Path** is `$false` and **Ensure** is `Present`, the resource sets the environment variable
  to **Value**.
- When **Path** is `$false` and **Ensure** is `Absent`, the resource removes the environment
  variable.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### Target

Specify one or more target to configure the environment variable in. Valid values include:

- `Process`
- `Machine`

By default, the environment variable is configured in both the `Process` and `Machine` targets.

```
Type: System.String[]
Accepted Values:
  - Process
  - Machine
Default Value: [Process, Machine]
```

### Value

Specify the environment variable's value as a string. Whether **Value** is an empty string (`''`)
modifies the **Ensure** behavior for the environment variable:

- When **Value** is an empty string, **Ensure** is `Present`, and the environment variable exists,
  the resource doesn't update the environment variable.
- When **Value** is an empty string, **Ensure** is `Present`, and the environment variable doesn't
  exist, the resource throws an invalid operation exception.
- When **Value** is an empty string, **Ensure** is `Absent`, and the environment variable exists,
  the resource removes the environment variable.

The default value is an empty string.

```
Type: System.String
Default Value: ''
```

## Examples

- [Create or update a non-path environment variable][1]
- [Create or update a path environment variable][2]
- [Remove an environment variable][3]

<!-- Reference Links -->

[1]: CreateNonPathVariable.md
[2]: CreatePathVariable.md
[3]: RemoveVariable.md
