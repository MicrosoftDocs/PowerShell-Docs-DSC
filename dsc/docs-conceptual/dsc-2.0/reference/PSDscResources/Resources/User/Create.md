---
description: >
  Use the PSDscResources User resource to create a new user.
ms.date: 08/08/2022
ms.topic: reference
title: Create a new user
---

# Create a new user

This example shows how you can use the `User` resource to ensure a user exists.

With **Ensure** set to `Present` and **UserName** set to `SomeUserName`, the resource creates the
`SomeUserName` account if it doesn't exist.

With **Password** set to the user-provided value for the **PasswordCredential** parameter, if the
resource creates the `SomeUserName` account, it creates the account with the password set to the
value of **PasswordCredential**. The first time someone logs in as `SomeUserName`, the system
prompts them to change the password.

If `SomeUserName` exists, the resource doesn't set the password for that account.

## With Invoke-DscResource

This script shows how you can use the `User` resource with the `Invoke-DscResource` cmdlet to
ensure the `SomeUserName` account exists, creating it with a default password if needed.

:::code source="Create.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Service` resource block to ensure
the `SomeUserName` account exists, creating it with a default password if needed.

:::code source="Create.Config.ps1":::
