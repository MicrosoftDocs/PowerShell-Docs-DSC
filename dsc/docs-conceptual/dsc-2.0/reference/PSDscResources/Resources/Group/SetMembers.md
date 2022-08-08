---
ms.date: 08/08/2022
ms.topic: reference
title: Set members of a group
description: >
  Use the PSDscResources Group resource to set members of a group.
---

# Set members of a group

## Description

This example shows how you can use the `Group` resource to ensure a group exists and includes only a
specified list of members.

With **Ensure** set to `Present` and **GroupName** set to `GroupName1`, the resource adds the
`GroupName1` local group if it doesn't exist.

With **Members** set to an array of `Username1` and `Username2`, the resource adds `Username1` and
`Username2` as members of `GroupName1` if they're not already members. If any other accounts are
members of `GroupName1`, the resource removes them from the group.

## With Invoke-DscResource

This script shows how you can use the `Group` resource with the `Invoke-DscResource` cmdlet to
ensure the local group `GroupName1` exists with only `Username1` and `Username2` as members.

:::code source="SetMembers.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Group` resource block to ensure the
local group `GroupName1` exists with only `Username1` and `Username2` as members.

:::code source="SetMembers.Config.ps1":::
