---
ms.date: 08/08/2022
ms.topic: reference
title: Delete a service
description: >
  Use the PSDscResources Service resource to delete a service.
---

# Delete a service

## Description

This example shows how you can use the `Service` resource to ensure a service doesn't exist.

With **Ensure** set to `Absent` and **Name** set to `Service1`, the resource removes the `Service1`
service if it exists. If `Service1` is running, the resource stops `Service1` before removing it.

## With Invoke-DscResource

This script shows how you can use the `Service` resource with the `Invoke-DscResource` cmdlet to
ensure the `Service1` service doesn't exist.

:::code source="Delete.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Service` resource block to ensure
the `Service1` service doesn't exist.

:::code source="Delete.Config.ps1":::
