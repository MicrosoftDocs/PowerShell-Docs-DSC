---
ms.date: 08/08/2022
ms.topic: reference
title: Expand an archive without file validation
description: >
  Use the PSDscResources Archive resource to expand an archive without file validation.
---

# Expand an archive without file validation

## Description

This example shows how you can use the `Archive` resource to ensure a `.zip` file is expanded to a
specific directory.

With **Ensure** set to `Present`, the **Path** set to `C:\ExampleArchivePath\Archive.zip`, and the
**Destination** set to `C:\ExampleDestinationPath\Destination`, the resource will expand the
contents of `Archive.zip` to the `Destination` folder if they're not already there.

Without the **Validate** or **Checksum** properties set, the resource does not validate the expanded
contents with the files in `Archive.zip`, only that they exist. The expanded content in the
`Destination` folder may not match the contents in `Archive.zip`.

## With Invoke-DscResource

This script shows how you can use the `Archive` resource with the `Invoke-DscResource` cmdlet to
ensure `Archive.zip` is expanded to the `Destination` folder.

:::code source="ExpandNoValidation.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Archive` resource block to ensure
`Archive.zip` is expanded to the `Destination` folder.

:::code source="ExpandNoValidation.Config.ps1":::
