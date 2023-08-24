---
description: Microsoft.Windows/Registry resource reference documentation
ms.date:     08/18/2023
ms.topic:    reference
title:       Microsoft.Windows/Registry
---

# Microsoft.Windows/Registry

## Synopsis

Registry configuration provider for the Windows Registry.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Metadata

```yaml
Version: 0.1.0
Tags:    [Windows, NT]
```

## Instance definition syntax

```yaml
resources:
  - name: <instance name>
    type: Microsoft.Windows/Registry
    properties:
      # Required properties
      keyPath: string
      # Instance properties
      _ensure:
      valueData:
      valueName:
      # Write-only properties
      _clobber:
```

## Description

The `Microsoft.Windows/Registry` resource enables you to idempotently manage registry keys and
values. The resource can:

- Add and remove registry keys.
- Add, update, and remove registry values.

## Requirements

- The resource is only usable on a Windows system.
- The resource must run in a process context that has permissions to manage the keys in the hive
  specified by the value of the **keyPath** property. For more information, see
  [Registry key Security and Access Rights][01].

## Examples

- [Manage a registry key][02]
- [Manage a registry value][03]
- [Configure a set of registry keys and values][04]

## Required properties

The following properties are required for specifying an instance of the resource:

- [keyPath](#keypath)

### keyPath

Defines the path to the registry key for the instance. The path must start with a valid hive
identifier. Each segment of the path must be separated by a backslash (`\`).

The following table describes the valid hive identifiers for the key path.

| Short Name |       Long Name       |                                 NT Path                                 |
| :--------: | :-------------------: | :---------------------------------------------------------------------- |
|   `HKCR`   |  `HKEY_CLASSES_ROOT`  | `\Registry\Machine\Software\Classes\`                                   |
|   `HKCU`   |  `HKEY_CURRENT_USER`  | `\Registry\User\<User SID>\`                                            |
|   `HKLM`   | `HKEY_LOCAL_MACHINE`  | `\Registry\Machine\`                                                    |
|   `HKU`    |     `HKEY_USERS`      | `\Registry\User\`                                                       |
|   `HKCC`   | `HKEY_CURRENT_CONFIG` | `\Registry\Machine\System\CurrentControlSet\Hardware Profiles\Current\` |

```yaml
Type:     string
Required: true
```

## Instance properties

The following properties are optional. They define the desired state for an instance of the
resource.

### _ensure

Defines whether the registry key or value should exist. The default value is `Present`.

When `_ensure` is `Present`, the instance should exist. If it doesn't exist, the resource creates
the instance during the set operation.

When `_ensure` is `Absent`, the instance shouldn't exist. If it does exist, the resource removes
the instance during the set operation.

```yaml
Type:        string
Required:    false
Default:     Present
ValidValues: [Present, Absent]
```

### valueData

Defines the data for the registry value. If specified, this property must be an object with a
single property. The property name defines the data type. The property value defines the data
value. When the instance defines this property, the `valueName` property must also be defined.

For more information on registry value data types, see [Registry value types][05].

```yaml
Type:     object
Required: false
```

#### String valueData

Defines the registry value data as a null-terminated UTF-16 string. The resource handles
terminating the string.

```yaml
PropertyName: String
ValueType:    string
```

#### ExpandString valueData

Defines the registry value data as a null-terminated UTF-16 that contains unexpanded references to
environment variables, like `%PATH%`. The resource handles terminating the string.

```yaml
PropertyName: ExpandString
ValueType:    string
```

#### MultiString valueData

Defines the registry value data as a sequence of null-terminated UTF-16 strings. The resource
handles terminating the strings.

```yaml
PropertyName:           MultiString
ValueType:              array
ValueItemsMustBeUnique: false
ValueItemsType:         string
```

#### Binary valueData

Defines the registry value data as binary data in any form. The value must be an array
of 8-bit unsigned integers.

```yaml
PropertyName:           Binary
ValueType:              array
ValueItemsMustBeUnique: false
ValueItemsType:         integer
ValueItemsMinimum:      0
ValueItemsMaximum:      255
```

#### DWord valueData

Defines the registry value data as a 32-bit unsigned integer.

```yaml
PropertyName: DWord
ValueType:    integer
ValueMinimum: 0
ValueMaximum: 4294967295
```

#### QWord valueData

Defines the registry value data as a 64-bit unsigned integer.

```yaml
PropertyName: QWord
ValueType:    integer
ValueMinimum: 0
ValueMaximum: 18446744073709551615
```

### valueName

Defines the name of the value to manage for the registry key. This property is required when
specifying the `valueData` property.

```yaml
Type:     string
Required: false
```

## Write-only properties

The following properties are optional. When included in an instance definition, they change how the
resource processes the instance. The resource never returns a value for these properties from an
operation.

### _clobber

Indicates whether the registry value should be overwritten if it already exists.

> [!NOTE]
> The resource instance schema defines this property but it isn't implemented yet.

```yaml
Type:     boolean
Required: false
```

## Read-only properties

Don't include the following properties in an instance definition. If they're included in an
instance definition, the resource ignores them. The resource returns a value for these properties.

### $id

Returns the unique ID for the registry instance data type.

```yaml
Type:          string
ConstantValue: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
```

### _inDesiredState

When the resource is invoked for the test method, the `_inDesiredState` property indicates whether
the current state of the instance is the same as the desired state. If the value is `true`, the
instance is in the desired state. If the value is `false`, the instance isn't in the desired state.

For all other operations, the resource returns this property set to `null`.

```yaml
Type: [boolean, 'null']
```

## Exit Codes

The resource uses the following exit codes to report success and errors:

- `0` - Success
- `1` - Invalid parameter
- `2` - Invalid input
- `3` - Registry error
- `4` - JSON serialization failed

## See also

- [Command line reference for the registry command][06]
- [About the Registry][07]

<!-- Link references -->
[01]: /windows/win32/sysinfo/registry-key-security-and-access-rights
[02]: examples/manage-a-registry-key.md
[03]: examples/manage-a-registry-value.md
[04]: examples/configure-registry-keys-and-values.md
[05]: /windows/win32/sysinfo/registry-value-types
[06]: cli/registry.md
[07]: /windows/win32/sysinfo/about-the-registry
