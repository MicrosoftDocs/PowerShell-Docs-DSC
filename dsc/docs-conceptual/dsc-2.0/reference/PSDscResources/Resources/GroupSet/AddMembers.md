---
description: >
  Use the PSDscResources GroupSet composite resource to add members to multiple groups.
ms.date: 08/08/2022
ms.topic: reference
title: Add members to multiple groups
---

# Add members to multiple groups

## Description

This example shows how you can use the `GroupSet` composite resource to ensure multiple groups exist
and include a specified list of members.

With **Ensure** set to `Present` and **GroupName** set to an array of `Administrators` and
`GroupName1`, the resource adds the `Administrators` and `GroupName1` local groups if they don't
exist.

With **MembersToInclude** set to an array of `Username1` and `Username2`, the resource adds
`Username1` and `Username2` as members to both `Administrators` and `GroupName1` if they're not
already members.

## With Invoke-DscResource

The `Invoke-DscResource` cmdlet doesn't support invoking composite resources. Instead, use the
[Group resource][1].

## With a Configuration

This snippet shows how you can define a `Configuration` with a `GroupSet` resource block to ensure
the local groups `Administrators` and `GroupName1` exist and include `Username1` and `Username2` as
members.

:::code source="AddMembers.Config.ps1":::

<!-- Reference Links -->

[1]: ../Group/Group.md
