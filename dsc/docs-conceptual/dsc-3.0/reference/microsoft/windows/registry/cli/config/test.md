---
description: Command line reference for the 'registry config test' command
ms.date:     08/22/2023
ms.topic:    reference
title:       registry config test
---

# registry config test

## Synopsis

Validate registry configuration.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Syntax

```sh
registry config test [Options] --key-path <KEY_PATH>
```

## Description

The `test` command validates whether a registry key or value is in the desired state. It expects
input as a JSON instance of the `Microsoft.Windows/Registry` resource from stdin. It uses the
properties of the input resource as the desired state of the registry key or value.

The command returns an instance of the resource with the [_inDesiredState][01] set to a boolean
value indicating whether the registry key or value is in the desired state. The other properties
for the returned instance represent the current state of the instance.

The input instance must define the [keyPath][02] property. It uses the `keyPath` value to determine
which registry key to validate. If the input instance includes the [valueName][03] property, the
command validates the current state of that value instead of the registry key.

For more information about the available properties for configuring registry keys and values, see
[Microsoft.Windows/Registry][04].

## Examples

### Example 1 - Test whether a registry key exists

The command validates that the registry key exists.

```powershell
$InputInstance = @{
    keyPath = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
} | ConvertTo-Json

$InputInstance | registry config test
```

```Output
{"$id":"https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json","keyPath":"","_inDesiredState":true}
```

With the `_ensure` property explicitly set to `Absent`, the command validates that the registry key
doesn't exist.

```powershell
$InputInstance = @{
    _ensure = 'Absent'
    keyPath = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKLM\Software\Microsoft\Windows NT\CurrentVersion
_inDesiredState : False
```

### Example 2 - Test a registry value

The command validates whether the `SystemRoot` value exists. It doesn't validate the value's data.

```powershell
$InputInstance = @{
    keyPath   = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
    valueName = 'SystemRoot'
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKLM\Software\Microsoft\Windows NT\CurrentVersion
valueName       : SystemRoot
valueData       : @{String=C:\WINDOWS}
_inDesiredState : True
```

With the `valueData` property defined for the input instance, the command validates that the value
data is in the desired state.

```powershell
$InputInstance = @{
    keyPath   = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
    valueName = 'SystemRoot'
    valueData = @{
        String = 'D:\_windows'
    }
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKLM\Software\Microsoft\Windows NT\CurrentVersion
valueName       : SystemRoot
valueData       : @{String=C:\WINDOWS}
_inDesiredState : False
```

## Options

### -h, --help

Displays the help for the current command or subcommand. When you specify this option, the
application ignores all options and arguments after this one.

```yaml
Type:      boolean
Mandatory: false
```

<!-- Link references -->
[01]: ../../resource.md#_indesiredstate
[02]: ../../resource.md#keypath
[03]: ../../resource.md#valuename
[04]: ../../resource.md
