---
description: >
  Manage whether a registry key exists with the Microsoft.Windows/Registry DSC Resource.
ms.date: 08/08/2022
ms.topic: reference
title: Manage a registry key with Microsoft.Windows/Registry
---

# Manage a registry key with Microsoft.Windows/Registry

## Description

This example shows how you can use the `Microsoft.Windows/Registry` resource to manage whether a
registry key exists. These examples manage the
`SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey` in the current user hive.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Adding the key

This script shows how you can use the resource with the `dsc resource` commands to ensure the
`MyNewKey` registry key exists.

With `_ensure` set to `Present`, the resource adds the `MyNewKey` registry key if it doesn't exist.

:::code source="Add-RegistryKey.ps1":::

### Set result

When the resource creates the key with `dsc resource set`, it returns the following output:

```yaml
beforeState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: ''
afterState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey
changedProperties:
- keyPath
```

### Get result

When the resource is already in the desired state and is retrieved with `dsc resource get`, it
returns the following output:

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey
```

## Removing the key

This script shows how you can use the resource with the `dsc resource` commands to ensure the
`MyNewKey` registry key doesn't exist.

With `_ensure` set to `Absent`, the resource removes the `MyNewKey` registry key if it exists.

:::code source="Remove-RegistryKey.ps1":::

### Set result

When the resource creates the key with `dsc resource set`, it returns the following output:

```yaml
beforeState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey
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
  keyPath: ''
```
