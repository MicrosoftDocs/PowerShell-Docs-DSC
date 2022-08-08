---
ms.date: 08/08/2022
ms.topic: reference
title: Set multiple services to run under the built-in account LocalService
description: >
  Use the PSDscResources ServiceSet composite resource to set multiple services to run under the
  built-in account LocalService.
---

# Set multiple services to run under the built-in account LocalService

## Description

This example shows how you can use the `ServiceSet` composite resource to ensure multiple services
exist and will run under the `LocalService` built-in account.

With **Ensure** set to `Present`, **BuiltInAccount** set to `LocalService`, and **Name** set tthe
array of `Dhcp` and `SstpSvc`, the resource configures the `Dhcp` and `SstpSvc` services to run
under the `LocalService` account if they are configured to run under any other account.

With **State** set to `Ignore`, the resource doesn't start or stop the services.

If either service doesn't exist, the resource raises an exception. The `ServiceSet` composite
resource can't create services, only manage or remove existing ones. To create a service if it
doesn't exist, use the [Service resource][1].

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet does not support invoking composite resources. Instead, use the
[Service resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `ServiceSet` resource block to ensure
that the `Dhcp` and `SstpSvc` services will run under the `LocalService` built-in account.

:::code source="BuiltInAccount.Config.ps1":::

<!-- Reference Links -->

[1]: ../Service/Service.md
