---
description: >
  Use the Microsoft.Windows/Registry resource to configure a set of registry keys and values in
  a DSC Configuration Document.
ms.date: 08/08/2022
ms.topic: reference
title: Configure keys and values with Microsoft.Windows/Registry
---

# Configure keys and values with Microsoft.Windows/Registry

This example shows how you can use the `Microsoft.Windows/Registry` resource to manage several
registry keys and values in a DSC Configuration Document.

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Definition

The configuration document defines three instances of the resource:

- The instance named `Tailspin Key` ensures that the key `tailspin` exists in the current user
  hive.
- The instance named `Tailspin - Update automatically` ensures that the `updates` sub-key exists
  under the `tailspin` key and has the `automatic` value set to the string `enable`.
<!-- Commented out for now - can't display output due to a bug in the resource -->
<!--
- The instance named `Tailspin - Update every 30 days` ensures that the `updates` sub-key exists
  under the `tailspin` key and has the `frequency` value set to `30` as a DWORD.
-->

:::code language="yaml" source="registry.config.dsc.yaml" range="1,15":::

## Enforcing state

### First apply

The first time the configuration applies to the machine, it creates the registry keys and value.

```powershell
$Configuration = Get-Content -Path ./registry.config.dsc.yaml
$Configuration | dsc config set
```

```yaml
results:
- name: Tailspin Key
  type: Microsoft.Windows/Registry
  result:
    beforeState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: ''
    afterState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin
    changedProperties:
    - keyPath
- name: Tailspin - Update automatically
  type: Microsoft.Windows/Registry
  result:
    beforeState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: ''
    afterState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin\updates
      valueName: automatic
      valueData:
        String: enable
    changedProperties:
    - keyPath
    - valueName
    - valueData
messages: []
hadErrors: false
```

The operation changed the `keyPath` property for the `Tailspin Key` instance. It changed the
`keyPath`, `valueName`, and `valueData` properties for the `Tailspin - Update automatically`
instance.

### Second apply

The first time the configuration applies to the machine, it makes no changes. The instances are
already in the desired state.

```powershell
$Configuration | dsc config set
```

```yaml
results:
- name: Tailspin Key
  type: Microsoft.Windows/Registry
  result:
    beforeState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin
    afterState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin
    changedProperties: []
- name: Tailspin - Update automatically
  type: Microsoft.Windows/Registry
  result:
    beforeState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin\updates
      valueName: automatic
      valueData:
        String: enable
    afterState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\tailspin\updates
      valueName: automatic
      valueData:
        String: enable
    changedProperties: []
messages: []
hadErrors: false
```
