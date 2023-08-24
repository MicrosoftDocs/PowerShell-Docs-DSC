---
description: Command line reference for the 'registry config set' command
ms.date:     08/22/2023
ms.topic:    reference
title:       registry config set
---

# registry config set

## Synopsis

Apply registry configuration.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Syntax

```sh
registry config set [Options] --key-path <KEY_PATH>
```

## Description

The `set` command returns the current state of a registry key or value as an instance of the
`Microsoft.Windows/Registry` resource. It expects input as a JSON instance of the resource from
stdin.

The input instance must define the [keyPath][01] property. It uses the `keyPath` value to determine
which registry key to configure. If the input instance includes the [valueName][02] property, the
command configures the current state of that value instead of the registry key.

For more information about the available properties for configuring registry keys and values, see
[Microsoft.Windows/Registry][03].

## Examples

### Example 1 - Ensure a registry key exists

Because the input instance defines the `_ensure` property as `Present`,the command creates the
`HKCU\Example\Key` if it doesn't exist.

```powershell
$InputInstance = @{
    _ensure = 'Present'
    keyPath = 'HKCU\Example\Key'
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
$InputInstance | registry config set  | ConvertFrom-Json | Format-List
$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : 
_inDesiredState : False

$id     : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath : HKCU\Example\Key

$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : 
_inDesiredState : True
```

### Example 2 - Ensure a registry key doesn't exist

Because the input instance defines the `_ensure` property as `Absent`,the command deletes the
`HKCU\Example\Key` if it exists.

```powershell
$InputInstance = @{
    _ensure = 'Absent'
    keyPath = 'HKCU\Example\Key'
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
$InputInstance | registry config set  | ConvertFrom-Json | Format-List
$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKCU\Example\Key
_inDesiredState : False

$id     : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath : 

$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : 
_inDesiredState : True
```

### Example 3 - Ensure a registry value exists

The instance combines the values of the `keyPath`, `valueName`, and `valueData` properties to
ensure that the `Example\Key` registry key in the current user hive has a value named
`ExampleValue`. If the value doesn't already exist, the command creates the value with the string
`SomeValue` as its data.

```powershell
$InputInstance = @{
    _ensure   = 'Present'
    keyPath   = 'HKCU\Example\Key'
    valueName = 'ExampleValue'
    valueData = @{
        String = 'SomeValue'
    }
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
$InputInstance | registry config set  | ConvertFrom-Json | Format-List
$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : 
_inDesiredState : False

$id       : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath   : HKCU\Example\Key
valueName : ExampleValue
valueData : @{String=SomeValue}

$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKCU\Example\Key
valueName       : ExampleValue
valueData       : @{String=SomeValue}
_inDesiredState : True
```

### Example 4 - Ensure a registry value has specific data

When setting a registry value that already exists, the `_clobber` property indicates that the
command should override the existing value data if it isn't the desired data.

```powershell
$InputInstance = @{
    _ensure   = 'Present'
    _clobber  = $true
    keyPath   = 'HKCU\Example\Key'
    valueName = 'ExampleValue'
    valueData = @{
        String = 'NewValue'
    }
} | ConvertTo-Json

$InputInstance | registry config test | ConvertFrom-Json | Format-List
$InputInstance | registry config set  | ConvertFrom-Json | Format-List
$InputInstance | registry config test | ConvertFrom-Json | Format-List
```

```Output
$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKCU\Example\Key
_inDesiredState : False

$id       : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath   : HKCU\Example\Key
valueName : ExampleValue
valueData : @{String=NewValue}

$id             : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath         : HKCU\Example\Key
valueName       : ExampleValue
valueData       : @{String=NewValue}
_inDesiredState : True
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
[01]: ../../resource.md#keypath
[02]: ../../resource.md#valuename
[03]: ../../resource.md
