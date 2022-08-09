---
ms.date: 08/08/2022
ms.topic: reference
title: Add or modify a registry key value
description: >
  Use the PSDscResources Registry resource to add or modify a registry key value.
---

# Add or modify a registry key value

## Description

This example shows how you can use the `Registry` resource to ensure a registry key value is set.

With **Ensure** set to `Present`, **ValueName** set to `MyValue`, and **Key** set to
`HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`, the resource adds the
`MyValue` registry key value under the `Environment` key if it doesn't exist.

With **ValueType** set to `Binary`, **ValueData** set to `0x00`, and **Force** set to `$true`, the
resource sets the registry key value to `0` even if it exists with a different value.

## With Invoke-DscResource

This script shows how you can use the `Registry` resource with the `Invoke-DscResource` cmdlet to
ensure the `Environment` registry key has the `MyValue` value set to `0`.

:::code source="AddOrModifyValue.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Registry` resource block to ensure
the `Environment` registry key has the `MyValue` value set to `0`.

:::code source="AddOrModifyValue.Config.ps1":::
