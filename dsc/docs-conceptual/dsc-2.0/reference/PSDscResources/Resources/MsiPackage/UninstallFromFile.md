---
description: >
  Use the PSDscResources MsiPackage resource to Uninstall the MSI file with the given ID at the
  given path.
ms.date: 08/08/2022
ms.topic: reference
title: Uninstall the MSI file with the given ID at the given path
---

# Uninstall the MSI file with the given ID at the given path

## Description

This example shows how you can use the `MsiPackage` resource to ensure a package isn't installed.

With **Ensure** set to `Absent`, **ProductID** set to `{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}`, and
**Path** set to `file://Examples/example.msi`, the resource uninstalls the `example.msi` package if
it's installed.

If the package is installed and the `example.msi` file doesn't exist, the resource throws an
exception when it enforces the desired state.

## With Invoke-DscResource

This script shows how you can use the `MsiPackage` resource with the `Invoke-DscResource` cmdlet to
ensure a package on the local file system isn't installed.

:::code source="UninstallFromFile.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `MsiPackage` resource block to ensure
a package on the local file system isn't installed.

:::code source="UninstallFromFile.Config.ps1":::
