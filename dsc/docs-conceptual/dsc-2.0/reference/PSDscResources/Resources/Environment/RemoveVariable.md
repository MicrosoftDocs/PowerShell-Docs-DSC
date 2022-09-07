---
description: >
  Use the PSDscResources Environment resource to remove an environment variable.
ms.date: 08/08/2022
ms.topic: reference
title: Remove an environment variable
---

# Remove an environment variable

## Description

This example shows how you can use the `Environment` resource to ensure a non-path environment
variable doesn't exist.

With **Ensure** set to `Absent`, **Name** set to `TestEnvironmentVariable`, and **Path** set to
`$false`, the resource removes the environment variable called `TestEnvironmentVariable` if it
exists.

With **Target** set to an array with both `Process` and `Machine`, the resource removes the
environment variable from both the process and machine targets.

## With Invoke-DscResource

This script shows how you can use the `Environment` resource with the `Invoke-DscResource` cmdlet to
ensure `TestEnvironmentVariable` is removed from the process and machine targets.

:::code source="RemoveVariable.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Environment` resource block to
ensure `TestEnvironmentVariable` is removed from the process and machine targets.

:::code source="RemoveVariable.Config.ps1":::
