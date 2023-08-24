---
description: Command line reference for the 'registry remove' command
ms.date:     08/22/2023
ms.topic:    reference
title:       registry remove
---

# registry remove

## Synopsis

Remove a registry key or value.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Syntax

```sh
registry remove [Options] --key-path <KEY_PATH>
```

## Description

The `remove` command isn't implemented yet. It returns a string that echoes the specified options.

## Examples

### Example 1 - Echo the options

The options are returned as a string on a single line.

```powershell
registry remove --key-path HKCU\example --recurse
```

```Output
Remove key_path: HKCU\example, value_name: None, recurse: true
```

## Options

### -k, --key-path

Specifies the registry key path to remove. The path must start with a valid hive identifier. Each
segment of the path must be separated by a backslash (`\`).

The following table describes the valid hive identifiers for the key path.

| Short Name |       Long Name       |                                 NT Path                                 |
| :--------: | :-------------------: | :---------------------------------------------------------------------- |
|   `HKCR`   |  `HKEY_CLASSES_ROOT`  | `\Registry\Machine\Software\Classes\`                                   |
|   `HKCU`   |  `HKEY_CURRENT_USER`  | `\Registry\User\<User SID>\`                                            |
|   `HKLM`   | `HKEY_LOCAL_MACHINE`  | `\Registry\Machine\`                                                    |
|   `HKU`    |     `HKEY_USERS`      | `\Registry\User\`                                                       |
|   `HKCC`   | `HKEY_CURRENT_CONFIG` | `\Registry\Machine\System\CurrentControlSet\Hardware Profiles\Current\` |

```yaml
Type:      String
Mandatory: true
```

### -v, --value-name

Defines the name of the value to remove for in the specified registry key path.

```yaml
Type:      String
Mandatory: false
```

### -r, --recurse

Indicates whether the command should recursively remove subkeys. By default, the command isn't
recursive.

```yaml
Type:      boolean
Mandatory: false
```

### -h, --help

Displays the help for the current command or subcommand. When you specify this option, the
application ignores all options and arguments after this one.

```yaml
Type:      boolean
Mandatory: false
```
