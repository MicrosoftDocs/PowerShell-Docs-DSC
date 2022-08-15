---
ms.date: 08/08/2022
ms.topic: reference
title: Remove a registry key value
description: >
  Use the PSDscResources Registry resource to remove a registry key value.
---

# Remove a registry key value

## Description

This example shows how you can use the `Registry` resource to ensure a registry key value doesn't
exist.

With **Ensure** set to `Absent`, **ValueName** set to `MyValue`, and **Key** set to
`HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`, the resource removes the
`MyValue` registry key value under the `Environment` key if it exists.

## With Invoke-DscResource

This script shows how you can use the `Registry` resource with the `Invoke-DscResource` cmdlet to
ensure the `Environment` registry key doesn't have a value called `MyValue`.

:::code source="RemoveValue.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Registry` resource block to ensure
the `Environment` registry key doesn't have a value called `MyValue`.

:::code source="RemoveValue.Config.ps1":::
