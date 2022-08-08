---
ms.date: 08/08/2022
ms.topic: reference
title: Update a service's StartupType
description: >
  Use the PSDscResources Service resource to update a service's StartupType.
---

# Update a service's StartupType

## Description

This example shows how you can use the `Service` resource to ensure a service exists with the
correct startup type.

With **Ensure** set to `Present`, **Name** set to `Service1`, and **Path** not set, the resource throws an exception if the service doesn't exist.

With **StartupType** set to `Manual`, the resource sets the startup type to `Manual` if the
`Service1` service exists and has any other startup type.

With **State** set to `Ignore`, the resource does not start or stop the `Service1` service.

## With Invoke-DscResource

This script shows how you can use the `Service` resource with the `Invoke-DscResource` cmdlet to
ensure the `Service1` service exists and has the `Manual` startup type.

:::code source="UpdateStartupType.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Service` resource block to ensure
the `Service1` service exists and has the `Manual` startup type.

:::code source="UpdateStartupType.Config.ps1":::
