---
ms.date: 08/08/2022
ms.topic: reference
title: Expand an archive with SHA-256 file validation and file overwrite allowed
description: >
  Use the PSDscResources Archive resource to expand an archive with SHA-256 file validation and file
  overwrite allowed
---

# Expand an archive with SHA-256 file validation and file overwrite allowed

## Description

This example shows how you can use the `Archive` resource to ensure a `.zip` file is expanded to a
specific directory and the expanded contents match the contents in the `.zip` file.

With **Ensure** set to `Present`, the **Path** set to `C:\ExampleArchivePath\Archive.zip`, and the
**Destination** set to `C:\ExampleDestinationPath\Destination`, the resource expands the contents of
`Archive.zip` to the `Destination` folder if they're not already there.

With **Validate** set to `$true` and **Checksum** set to `SHA-256`, the resource compares the SHA256
checksum of every expanded file against the relevant file in `Archive.zip`. If the checksum for any
expanded file doesn't match the checksum of that file in `Archive.zip`, the resource is out of the
desired state.

With **Force** set to `$true`, the resource overwrites any expanded files with an incorrect
checksum. If **Force** was set to `$false`, the resource would throw an exception instead of
overwriting the files.

## With Invoke-DscResource

This script shows how you can use the `Archive` resource with the `Invoke-DscResource` cmdlet to
ensure `Archive.zip` is expanded to the `Destination` folder with SHA256 checksum validation.

:::code source="ExpandDefaultValidationForce.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Archive` resource block to ensure
`Archive.zip` is expanded to the `Destination` folder with SHA256 checksum validation.

:::code source="ExpandDefaultValidationForce.Config.ps1":::
