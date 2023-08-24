---
description: >
  Manage the value of a registry key with the Microsoft.Windows/Registry DSC Resource.
ms.date: 08/08/2022
ms.topic: reference
title: Manage a registry key value with Microsoft.Windows/Registry
---

# Manage a registry key value with Microsoft.Windows/Registry

## Description

This example shows how you can use the `Microsoft.Windows/Registry` resource to manage whether a
registry key exists. These examples manage the
`SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey` in the current user hive.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Adding the key and value

This script shows how you can use the resource with the `dsc resource` commands to ensure the
`MyKey` registry key exists with the `MyValue` value set to binary data `0x00`.

With `_ensure` set to `Present`, the resource adds the registry key and value if they don't exist.

:::code source="Set-RegistryValue.ps1":::

### Set result

When the resource creates the key with `dsc resource set`, it returns the following output:

```yaml
beforeState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: ''
afterState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
  valueName: MyValue
  valueData:
    Binary:
    - 0
changedProperties:
- keyPath
- valueName
- valueData
```

### Get result

When the resource is already in the desired state and is retrieved with `dsc resource get`, it
returns the following output:

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
  valueName: MyValue
  valueData:
    Binary:
    - 0
```

## Updating the value

This script shows how you can update an existing registry value to a new value and data type. It
sets `MyValue` for the `MyKey` registry key to the string `New Value`.

:::code source="Update-RegistryValue.ps1":::

### Set result

When the resource updates the value with `dsc resource set`, it returns the following output:

```yaml
beforeState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
  valueName: MyValue
  valueData:
    Binary:
    - 0
afterState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
  valueName: MyValue
  valueData:
    String: New Value
changedProperties:
- valueData
```

### Get result

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
  valueName: MyValue
  valueData:
    String: New Value
```

## Removing the key and value

This script shows how you can use the resource with the `dsc resource` commands to ensure the
`MyKey` registry key doesn't exist.

With `_ensure` set to `Absent`, the resource removes the `MyKey` registry key if it exists. It also
deletes any values the key had.

:::code source="Remove-RegistryValue.ps1":::

### Set result

When the resource removes the key and value with `dsc resource set`, it returns the following
output:

```yaml
beforeState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey
afterState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: ''
changedProperties:
- keyPath
```

### Get result

When the resource is already in the desired state and is retrieved with `dsc resource get`, it
returns the following output:

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: '
```
