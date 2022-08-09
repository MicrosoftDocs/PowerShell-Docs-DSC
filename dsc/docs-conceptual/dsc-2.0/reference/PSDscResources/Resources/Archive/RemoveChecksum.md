---
ms.date: 08/08/2022
ms.topic: reference
title: Remove an archive with SHA-256 file validation
description: >
  Use the PSDscResources Archive resource to remove an archive with SHA-256 file validation.
---

# Remove an archive with SHA-256 file validation

## Description

This example shows how you can use the `Archive` resource to ensure no contents of a `.zip` file are
expanded to a specific directory.

With **Ensure** set to `Absent`, the **Path** set to `C:\ExampleArchivePath\Archive.zip`. and the
**Destination** set to `C:\ExampleDestinationPath\Destination`, the resource will remove the
contents of `Archive.zip` from the `Destination` folder if they exist.

With **Validate** set to `$true` and **Checksum** set to `SHA-256`, the resource compares the SHA256
checksum of every that exists in both the `Destination` folder and `Archive.zip`. If the checksum
for any file in the `Destination` folder matches the checksum of that file in `Archive.zip`, the
resource is out of the desired state. The resource removes those matching files when its **Set**
method runs. It won't remove any other files.

## With Invoke-DscResource

This script shows how you can use the `Archive` resource with the `Invoke-DscResource` cmdlet to
ensure no contents in `Archive.zip` exist in the `Destination` folder with SHA256 checksum
validation.

:::code source="RemoveChecksum.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Archive` resource block to ensure
no contents in `Archive.zip` exist in the `Destination` folder with SHA256 checksum validation.

:::code source="RemoveChecksum.Config.ps1":::
