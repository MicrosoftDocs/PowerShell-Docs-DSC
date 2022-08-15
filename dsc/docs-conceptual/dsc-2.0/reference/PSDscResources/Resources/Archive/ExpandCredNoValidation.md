---
ms.date: 08/08/2022
ms.topic: reference
title: Expand an archive under a credential without file validation
description: >
  Use the PSDscResources Archive resource to expand an archive under a credential without file
  validation.
---

# Expand an archive under a credential without file validation

## Description

This example shows how you can use the `Archive` resource to ensure a `.zip` file is expanded to a
specific directory under a chosen account. This allows you to specify locations for the archive and
destination that require authorization for access and writing.

With **Ensure** set to `Present`, the **Path** set to `C:\ExampleArchivePath\Archive.zip`, and the
**Destination** set to `C:\ExampleDestinationPath\Destination`, the resource expands the contents of
`Archive.zip` to the `Destination` folder if they're not already there.

With the **Credential** property set to an account with permissions to the `Archive.zip` file and
the `Destination` folder, the resource expands the `.zip` file as that account. If the account
doesn't have permissions to either path, the resource throws an error.

Without the **Validate** or **Checksum** properties set, the resource doesn't verify the expanded
contents with the files in `Archive.zip`, only that they exist. The expanded content in the
`Destination` folder may not match the contents in `Archive.zip`.

## With Invoke-DscResource

This script shows how you can use the `Archive` resource with the `Invoke-DscResource` cmdlet to
ensure `Archive.zip` is expanded to the `Destination` folder, using a specified account's credential
for reading and writing the files.

:::code source="ExpandCredNoValidation.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with an `Archive` resource block to ensure
`Archive.zip` is expanded to the `Destination` folder, using a specified account's credential for
reading and writing the files.

:::code source="ExpandCredNoValidation.Config.ps1":::
