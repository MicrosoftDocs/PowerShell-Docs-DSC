---
description: >
  Use the PSDscResources WindowsProcess resource to stop a process.
ms.date: 10/30/2026
ms.topic: reference
title: Stop a process
---

# Stop a process

## Description

This example shows how you can use the `WindowsProcess` resource to ensure a process isn't running.

[!INCLUDE [PSDscResources Unsupported](../../../../../../includes/psdscresources-unsupported.md)]

With **Ensure** set to `Absent`, **Path** set to `C:\Windows\System32\gpresult.exe`, and
**Arguments** set to an empty string, the resource stops any running `gpresult.exe` process.

## With Invoke-DscResource

This script shows how you can use the `WindowsProcess` resource with the `Invoke-DscResource` cmdlet
to ensure `gpresult.exe` isn't running.

:::code source="Stop.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsProcess` resource block to
ensure `gpresult.exe` isn't running.

:::code source="Stop.Config.ps1":::
