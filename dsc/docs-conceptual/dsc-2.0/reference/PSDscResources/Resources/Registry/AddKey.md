---
description: >
  Use the PSDscResources Registry resource to add a registry key.
ms.date: 08/08/2022
ms.topic: reference
title: Add a registry key
---

# Add a registry key

## Description

This example shows how you can use the `Registry` resource to ensure a registry key exists.

With **Ensure** set to `Present`, **ValueName** set to an empty string, and **Key** set to
`HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey`, the resource adds the
`MyNewKey` registry key if it doesn't exist.

## With Invoke-DscResource

This script shows how you can use the `Registry` resource with the `Invoke-DscResource` cmdlet to
ensure the `MyNewKey` registry key exists.

:::code source="AddKey.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Registry` resource block to ensure
the `MyNewKey` registry key exists.

:::code source="AddKey.Config.ps1":::
