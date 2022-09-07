---
description: >
  Use the PSDscResources Environment resource to create or update a path environment variable.
ms.date: 08/08/2022
ms.topic: reference
title: Create or update a path environment variable
---

# Create or update a path environment variable

## Description

This example shows how you can use the `Environment` resource to ensure a path environment
variable exists with a specific value.

With **Ensure** set to `Present`, **Name** set to `TestEnvironmentVariable`, and **Value** set to
`TestValue`, the resource adds an environment variable called `TestEnvironmentVariable` with the
value `TestValue` if it doesn't exist.

With **Path** set to `$true`, if `TestEnvironmentVariable` exists and doesn't include `TestValue`,
the resource appends `TestValue` to the current value.

With **Target** set to an array with both `Process` and `Machine`, the resource creates or sets the
environment variable in both the process and machine targets.

## With Invoke-DscResource

This script shows how you can use the `Environment` resource with the `Invoke-DscResource` cmdlet to
ensure `TestEnvironmentVariable` is set in the process and machine targets to include `TestValue`.

:::code source="CreatePathVariable.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Environment` resource block to
ensure `TestEnvironmentVariable` is set in the process and machine targets to include `TestValue`.

:::code source="CreatePathVariable.Config.ps1":::
