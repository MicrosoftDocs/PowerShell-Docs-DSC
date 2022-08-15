---
ms.date: 08/08/2022
ms.topic: reference
title: Remove a registry key
description: >
  Use the PSDscResources Registry resource to remove a registry key.
---

# Remove a registry key

## Description

This example shows how you can use the `Registry` resource to ensure a registry key doesn't exist.

With **Ensure** set to `Absent`, **ValueName** set to an empty string, and **Key** set to
`HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey`, the resource removes
the `MyNewKey` registry key if it exists.

## With Invoke-DscResource

This script shows how you can use the `Registry` resource with the `Invoke-DscResource` cmdlet to
ensure the `MyNewKey` registry key doesn't exist.

:::code source="RemoveKey.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Registry` resource block to ensure
the `MyNewKey` registry key doesn't exist.

:::code source="RemoveKey.Config.ps1":::
