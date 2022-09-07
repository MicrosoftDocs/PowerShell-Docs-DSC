---
description: >
  Use the PSDscResources WindowsProcess resource to start a process under a user.
ms.date: 08/08/2022
ms.topic: reference
title: Start a process under a user
---

# Start a process under a user

## Description

This example shows how you can use the `WindowsProcess` resource to ensure a process is running
under a specific account.

You are prompted for a credential if you don't pass one explicitly with the **Credential**
parameter. The **Credential** property of the resource is set to this value.

With **Ensure** set to `Present`, **Path** set to `C:\Windows\System32\gpresult.exe`, and
**Arguments** set to `/h C:\gp2.htm`, the resource starts `gpresult.exe` with the specified
arguments if it isn't running. Because the **Credential** property is set, the resource starts the
process as that account.

## With Invoke-DscResource

This script shows how you can use the `WindowsProcess` resource with the `Invoke-DscResource` cmdlet
to ensure `gpresult.exe` is running with the arguments `/h C:\gp2.htm` as a user-specified account.

:::code source="StartUnderUser.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `WindowsProcess` resource block to
ensure `gpresult.exe` is running with the arguments `/h C:\gp2.htm` as a user-specified account.

:::code source="StartUnderUser.Config.ps1":::
