---
ms.date: 08/08/2022
ms.topic: reference
title: Install the MSI file with the given ID at the given HTTPS URL
description: >
  Use the PSDscResources MsiPackage resource to install the MSI file with the given ID at the given
  HTTPS URL.
---

# Install the MSI file with the given ID at the given HTTPS URL

## Description

This example shows how you can use the `MsiPackage` resource to ensure a package is installed.

With **Ensure** set to `Present`, **ProductID** set to `{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}`, and
**Path** set to `https://contoso.com/example.msi`, the resource installs the `example.msi` package
if it isn't already installed.

If the package isn't installed, the resource downloads it from `https://contoso.com/example.msi`
when the resource enforces the desired state. If the download fails, the resource throws an
exception.

## With Invoke-DscResource

This script shows how you can use the `MsiPackage` resource with the `Invoke-DscResource` cmdlet to
ensure a package on a web URI is installed.

:::code source="InstallFromHttps.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `MsiPackage` resource block to ensure
a package on a web URI is installed.

:::code source="InstallFromHttps.Config.ps1":::
