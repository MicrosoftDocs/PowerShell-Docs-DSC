---
description: Microsoft/OSInfo resource reference documentation
ms.date:     08/18/2023
ms.topic:    reference
title:       Microsoft/OSInfo
---

# Microsoft/OSInfo

## Synopsis

Returns information about the operating system.

> [!IMPORTANT]
> The `osinfo` command and `Microsoft/OSInfo` resource are a proof-of-concept example for use with
> DSCv3. Don't use it in production.

## Metadata

```yaml
Version: 0.1.0
Tags:    [os, linux, windows, macos]
```

## Instance definition syntax

```yaml
resources:
  - name: <instance name>
    type: Microsoft/OSInfo
    properties:
      # Instance Properties
      architecture:
      bitness:
      codename:
      edition:
      family:
      version:
```

## Description

The `Microsoft/OSInfo` resource enables you to assert whether a machine meets criteria related to
the operating system. The resource is only capable of assertions. It doesn't implement the set
operation and can't configure the operating system.

The resource doesn't implement the [test operation][01]. It relies on the synthetic testing feature
of DSC instead. The synthetic test uses a case-sensitive equivalency comparison between the actual
state of the instance properties and the desired state. If any property value isn't an exact match,
DSC considers the instance to be out of the desired state.

The instance properties returned by this resource depends on the operating system `family` as
listed in the following table:

| `family`  |                Returned instance properties                |
| :-------: | :--------------------------------------------------------- |
|  `Linux`  | `architecture`, `bitness`, `codename`, `family`, `version` |
|  `MacOS`  | `architecture`, `bitness`, `family`, `version`             |
| `Windows` | `bitness`, `edition`, `family`, `version`                  |

## Requirements

None.

## Examples

- [Validate operating system information with dsc resource][02]
- [Validate operating system information in a configuration][03]

## Instance properties

The following properties are optional. They define the desired state for an instance of the
resource.

### architecture

Defines the processor architecture as reported by `uname -m` on the operating system. The resource
doesn't return this property for Windows machines.

```yaml
Type:     string
Required: false
```

### bitness

Defines whether the operating system is a 32-bit or 64-bit operating system. When the resource
can't determine this information, it returns a value of `unknown`.

```yaml
Type:        string
Required:    false
ValidValues: ['32', '64', unknown]
```

### codename

Defines the codename for the operating system as returned from `lsb_release --codename`. The
resource only returns this property for Linux machines.

```yaml
Type:     string
Required: false
```

### edition

Defines the operating system edition, like `Windows 11` or `Windows Server 2016`. The resource only
returns this property for Windows machines.

```yaml
Type:     string
Required: false
```

### family

Defines whether the operating system is Linux, macOS, or Windows.

```yaml
Type:        string
Required:    false
ValidValues: [Linux, MacOS, Windows]
```

### version

Defines the version of the operating system as a string.

```yaml
Type:     string
Required: false
```

## Read-only properties

Don't include the following properties in an instance definition. If they're included in an
instance definition, the resource ignores them. The resource returns a value for these properties.

### $id

Returns the unique ID for the OSInfo instance data type.

```yaml
Type:          string
ConstantValue: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
```

## Exit Codes

The resource uses the following exit codes to report success and errors:

- `0` - Success
- `1` - Error

## See also

- [Command line reference for the osinfo command][04]

<!-- Link references -->
[01]: ../../../concepts/resources.md#test-operations
[02]: examples/validate-with-dsc-resource.md
[03]: examples/validate-in-a-configuration.md
[04]: cli/osinfo.md
