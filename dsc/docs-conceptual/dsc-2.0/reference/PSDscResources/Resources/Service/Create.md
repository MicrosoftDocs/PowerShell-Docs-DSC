---
description: >
  Use the PSDscResources Service resource to create a service.
ms.date: 08/08/2022
ms.topic: reference
title: Create a service
---

# Create a service

## Description

This example shows how you can use the `Service` resource to ensure a service exists and is running.

With **Ensure** set to `Present`, **Name** set to `Service1`, and **Path** set to
`C:\FilePath\MyServiceExecutable.exe`, the resource creates `Service1` if it doesn't exist with
`MyServiceExecutable.exe` as the executable file and starts it.

If `Service1` exists but isn't running, the resource starts it.

## With Invoke-DscResource

This script shows how you can use the `Service` resource with the `Invoke-DscResource` cmdlet to
ensure the `Service1` service exists with `MyServiceExecutable.exe` as the executable and is
running.

:::code source="Create.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Service` resource block to ensure
the `Service1` service exists with `MyServiceExecutable.exe` as the executable and is running.

:::code source="Create.Config.ps1":::
