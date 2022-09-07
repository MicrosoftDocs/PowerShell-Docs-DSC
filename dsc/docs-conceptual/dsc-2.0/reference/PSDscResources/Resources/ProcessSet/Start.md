---
description: >
  Use the PSDscResources ProcessSet composite resource to start multiple processes.
ms.date: 08/08/2022
ms.topic: reference
title: Start multiple processes
---

# Start multiple processes

## Description

This example shows how you can use the `ProcessSet` composite resource to ensure multiple processes
are running.

With **Ensure** set to `Present` and **Path** set to the array of `C:\Windows\System32\cmd.exe` and
`C:\TestPath\TestProcess.exe`, the resource starts `cmd.exe` and `TestProcess.exe` without any
arguments if they're not already running.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[WindowsProcess resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `ProcessSet` resource block to ensure
the `cmd.exe` and `TestProcess.exe` processes are running.

:::code source="Start.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsProcess/WindowsProcess.md
