---
ms.date: 08/08/2022
ms.topic: reference
title: Remove an archive without file validation
description: >
  Use the PSDscResources Archive resource to remove an archive without file validation.
---

# Remove an archive without file validation

## Description

This example shows how you can use the `Archive` resource to ensure no contents of a `.zip` file are
expanded to a specific directory.

With **Ensure** set to `Absent`, the **Path** set to `C:\ExampleArchivePath\Archive.zip`. and the
**Destination** set to `C:\ExampleDestinationPath\Destination`, the resource will remove the
contents of `Archive.zip` from the `Destination` folder if they exist.

Without **Validate** or **Checksum** set, the resource removes any files in the `Destination` folder
that exist in `Archive.zip`.

## With Invoke-DscResource

This script shows how you can use the `Archive` resource with the `Invoke-DscResource` cmdlet to
ensure no contents in `Archive.zip` exist in the `Destination` folder.

:::code source="RemoveNoValidation.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Archive` resource block to ensure
no contents in `Archive.zip` exist in the `Destination` folder.

:::code source="RemoveNoValidation.Config.ps1":::
