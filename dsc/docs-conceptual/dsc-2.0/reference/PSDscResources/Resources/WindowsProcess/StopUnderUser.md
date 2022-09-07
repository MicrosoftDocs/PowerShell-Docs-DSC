---
description: >
  Use the PSDscResources WindowsProcess resource to stop a process under a user.
ms.date: 08/08/2022
ms.topic: reference
title: Stop a process under a user
---

# Stop a process under a user

## Description

This example shows how you can use the `WindowsProcess` resource to ensure a process isn't running,
using a specified account to stop it if needed.

You are prompted for a credential if you don't pass one explicitly with the **Credential**
parameter. The **Credential** property of the resource is set to this value.

With **Ensure** set to `Absent`, **Path** set to `C:\Windows\System32\gpresult.exe`, and
**Arguments** set to an empty string, the resource stops any running `gpresult.exe` process. Because
the **Credential** property is set, the resource stops the process as that account.

## With Invoke-DscResource

This script shows how you can use the `WindowsProcess` resource with the `Invoke-DscResource` cmdlet
to ensure `gpresult.exe` isn't running, stopping it as a user-specified account.

:::code source="StopUnderUser.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsProcess` resource block to
ensure `gpresult.exe` isn't running, stopping it as a user-specified account.

:::code source="StopUnderUser.Config.ps1":::
