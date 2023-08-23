---
description: Command line reference for the 'registry config get' command
ms.date:     08/22/2023
ms.topic:    reference
title:       registry config get
---

# registry config get

## Synopsis

Retrieve registry configuration.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Syntax

```sh
registry config get [Options] --key-path <KEY_PATH>
```

## Description

The `get` command returns the current state of a registry key or value as an instance of the
`Microsoft.Windows/Registry` resource. It expects input as a JSON instance of the resource from
stdin.

The input instance must define the [keyPath][01] property. It uses the `keyPath` value to determine
which registry key to retrieve. If the input instance includes the [valueName][02] property, the
command retrieves the current state of that value instead of the registry key.

## Examples

### Example 1 - Get a registry key

The command returns the current state of the specified registry key as a single line of compressed
JSON without any whitespace.

```powershell
$InputInstance = @{
    keyPath = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
} | ConvertTo-Json

$InputInstance | registry config get
```

```Output
{"$id":"https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json","keyPath":"HKLM\\Software\\Microsoft\\Windows NT\\CurrentVersion"}
```

When the specified key doesn't exist, the `keyPath` property is an empty string.

```powershell
$InputInstance = @{
    keyPath = 'HKCU\Example\Nested\Key'
} | ConvertTo-Json

$InputInstance | registry config get
```

```Output
{"$id":"https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json","keyPath":""}
```

### Example 2 - Get a registry value

The command returns the current state of the specified registry value as a single line of compressed
JSON without any whitespace.

```powershell
$InputInstance = @{
    keyPath   = 'HKLM\Software\Microsoft\Windows NT\CurrentVersion'
    valueName = 'SystemRoot'
} | ConvertTo-Json

$InputInstance | registry config get | ConvertFrom-Json | Format-List
```

```Output
$id       : https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
keyPath   : HKLM\Software\Microsoft\Windows NT\CurrentVersion
valueName : SystemRoot
valueData : @{String=C:\WINDOWS}
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
