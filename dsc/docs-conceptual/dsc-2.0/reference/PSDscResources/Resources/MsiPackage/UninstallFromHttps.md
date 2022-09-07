---
description: >
  Use the PSDscResources MsiPackage resource to Uninstall the MSI file with the given ID at the
  given HTTPS URL.
ms.date: 08/08/2022
ms.topic: reference
title: Uninstall the MSI file with the given ID at the given HTTPS URL
---

# Uninstall the MSI file with the given ID at the given HTTPS URL

## Description

This example shows how you can use the `MsiPackage` resource to ensure a package isn't installed.

With **Ensure** set to `Absent`, **ProductID** set to `{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}`, and
**Path** set to `file://contoso.com/example.msi`, the resource uninstalls the `example.msi` package
if it's installed.

If the package is installed, the resource downloads it from `https://contoso.com/example.msi` when
the resource enforces the desired state. If the download fails, the resource throws an exception.

## With Invoke-DscResource

This script shows how you can use the `MsiPackage` resource with the `Invoke-DscResource` cmdlet to
ensure a package on a web URI isn't installed.

:::code source="UninstallFromHttps.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `MsiPackage` resource block to ensure
a package on a web URI isn't installed.

:::code source="UninstallFromHttps.Config.ps1":::
