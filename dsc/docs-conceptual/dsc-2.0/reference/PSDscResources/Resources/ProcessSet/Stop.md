---
description: >
  Use the PSDscResources ProcessSet composite resource to stop multiple processes.
ms.date: 08/08/2022
ms.topic: reference
title: Stop multiple processes
---

# Stop multiple processes

## Description

This example shows how you can use the `ProcessSet` composite resource to ensure multiple processes
are stopped.

With **Ensure** set to `Absent` and **Path** set to the array of `C:\Windows\System32\cmd.exe` and
`C:\TestPath\TestProcess.exe`, the resource stops any running instances of `cmd.exe` and
`TestProcess.exe`.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[WindowsProcess resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `ProcessSet` resource block to ensure
the `cmd.exe` and `TestProcess.exe` processes are stopped.

:::code source="Stop.Config.ps1":::

<!-- Reference Links -->

[1]: ../WindowsProcess/WindowsProcess.md
