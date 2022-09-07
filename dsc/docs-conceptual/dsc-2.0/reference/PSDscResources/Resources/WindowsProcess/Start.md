---
description: >
  Use the PSDscResources WindowsProcess resource to start a process.
ms.date: 08/08/2022
ms.topic: reference
title: Start a process
---

# Start a process

## Description

This example shows how you can use the `WindowsProcess` resource to ensure a process is running.

With **Ensure** set to `Present`, **Path** set to `C:\Windows\System32\gpresult.exe`, and
**Arguments** set to `/h C:\gp2.htm`, the resource starts `gpresult.exe` with the specified
arguments if it isn't running.

## With Invoke-DscResource

This script shows how you can use the `WindowsProcess` resource with the `Invoke-DscResource` cmdlet
to ensure `gpresult.exe` is running with the arguments `/h C:\gp2.htm`.

:::code source="Start.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsProcess` resource block to
ensure `gpresult.exe` is running with the arguments `/h C:\gp2.htm`.

:::code source="Start.Config.ps1":::
