---
ms.date: 08/08/2022
ms.topic: reference
title: Registry
description: PSDscResources Registry resource
---

# Registry

## Synopsis

Manage a registry key or value.

## Syntax

```Syntax
Registry [String] #ResourceName
{
    Key = [string]
    ValueName = [string]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [Force = [bool]]
    [Hex = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
    [ValueData = [string[]]]
    [ValueType = [string]{ Binary | DWord | ExpandString | MultiString | QWord | String }]
}
```

## Description

The `Registry` resource enables you to add and remove registry keys and to add, update, and remove
registry key values.

### Requirements

None.

## Parameters

## Key properties

### Key

Specify the path to the registry key as a string. This path must include the registry hive or drive,
such as `HKEY_LOCAL_MACHINE` or `HKLM:`.

```
Type: System.String
Behavior: Key
```

### ValueName

Specify the name of the registry value as a string. To add or remove a registry key, specify this
property as an empty string without specifying the **ValueType** or **ValueData** property. To
modify or remove the default value of a registry key, specify this property as an empty string with
the **ValueType** or **ValueData** property.

```
Type: System.String
```

## Optional properties

### Ensure

Specify whether the registry key or value should exist. To add or modify a registry key or
value, set this property to `Present`. To remove a registry key or value, set this property to
`Absent`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### Force

Specify whether to overwrite the registry key value if it already has a value or to delete a
registry key that has subkeys. The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### Hex

Specify whether the specified registry key data is provided in a hexadecimal format. Specify this
property only when **ValueType** is `DWord` or `QWord`. If **ValueType** is not `DWord` or `Qword`,
the resource ignores this property. The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### ValueData

Specify the registry key value as a string or, if **ValueType** is `MultiString`, an array of
strings. If **ValueType** is not `MultiString` and this property's value is mulitple strings, the
resource throws an invalid argument exception.

```
Type: System.String[]
Default Value: None
```

### ValueType

Specify the type for the specified registry key value's data.

```
Type: System.String
Accepted Values:
  - Binary
  - DWord
  - ExpandString
  - MultiString
  - QWord
  - String
Default Value: String
```

## Examples

- [Add a registry key][1]
- [Add or modify a registry key value][2]
- [Remove a registry key value][3]
- [Remove a registry key][4]

<!-- Reference Links -->

[1]: AddKey.md
[2]: AddOrModifyValue.md
[3]: RemoveKey.md
[4]: RemoveValue.md
