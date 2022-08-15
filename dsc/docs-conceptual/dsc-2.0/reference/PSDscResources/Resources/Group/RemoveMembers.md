---
ms.date: 08/08/2022
ms.topic: reference
title: Remove members of a group
description: >
  Use the PSDscResources Group resource to remove members of a group.
---

# Remove members of a group

## Description

This example shows how you can use the `Group` resource to ensure a group exists and excludes a
specified list of members.

With **Ensure** set to `Present` and **GroupName** set to `GroupName1`, the resource adds the
`GroupName1` local group if it doesn't exist.

With **MembersToExclude** set to an array of `Username1` and `Username2`, the resource removes
`Username1` and `Username2` from `GroupName1` if they're members. It ignores the group membership of
all other accounts.

## With Invoke-DscResource

This script shows how you can use the `Group` resource with the `Invoke-DscResource` cmdlet to
ensure the local group `GroupName1` exists and doesn't include `Username1` or `Username2` as
members.

:::code source="RemoveMembers.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Group` resource block to ensure the
local group `GroupName1` exists and doesn't include `Username1` or `Username2` as members.

:::code source="RemoveMembers.Config.ps1":::
