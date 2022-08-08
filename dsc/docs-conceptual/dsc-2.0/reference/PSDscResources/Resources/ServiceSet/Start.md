---
ms.date: 08/08/2022
ms.topic: reference
title: Ensure that multiple services are running
description: >
  Use the PSDscResources ServiceSet composite resource to ensure that multiple services are running.
---

# Ensure that multiple services are running

## Description

This example shows how you can use the `ServiceSet` composite resource to ensure multiple services
exist and are running.

With **Ensure** set to `Present`, **State** set to `Running`, and **Name** set tthe array of `Dhcp`
and `MpsSvc`, the resource starts the `Dhcp` and `MpsSvc` services if they aren't running.

If either service doesn't exist, the resource raises an exception. The `ServiceSet` composite
resource can't create services, only manage or remove existing ones. To create a service if it
doesn't exist, use the [Service resource][1].

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet does not support invoking composite resources. Instead, use the
[Service resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `ServiceSet` resource block to ensure
that the `Dhcp` and `MpsSvc` services are running.

:::code source="Start.Config.ps1":::

<!-- Reference Links -->

[1]: ../Service/Service.md
