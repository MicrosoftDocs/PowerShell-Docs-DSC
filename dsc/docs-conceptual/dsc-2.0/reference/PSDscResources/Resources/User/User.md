---
description: PSDscResources User resource
ms.date: 08/08/2022
ms.topic: reference
title: User
---

# User

## Synopsis

Manage a local user.

## Syntax

```Syntax
User [String] #ResourceName
{
    UserName = [string]
    [DependsOn = [string[]]]
    [Description = [string]]
    [Disabled = [bool]]
    [Ensure = [string]{ Absent | Present }]
    [FullName = [string]]
    [Password = [PSCredential]]
    [PasswordChangeNotAllowed = [bool]]
    [PasswordChangeRequired = [bool]]
    [PasswordNeverExpires = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

## Description

The `User` resource enables you to add, update, and remove local user accounts. To manage an
account's membership in local groups, see the [Group resource][1].

### Requirements

None

## Properties

## Key properties

### UserName

Specify the account's name as a string.

```
Type: System.String
```

## Optional properties

### Description

Specify a description for the account as a string.

```
Type: System.String
Default Value: None
```

### Disabled

Specify whether to disable the account. Set this property to `$true` to disable the account if it's
enabled. Set it to `$false` to enable the account if it's disabled.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### Ensure

Specify whether the user should exist. Set this property to `Present` to add or update the account.
Set this property to `Absent` to remove the account.

The default value is `Present`.

```
Type: System.String
Behavior: Write
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### FullName

Specify the full name of the account as a string.

```
Type: System.String
Default Value: None
```

### Password

Specify a credential with the password to use for this account. The **UserName** of the credential
object isn't used, only the **Password**.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### PasswordChangeNotAllowed

Specify whether the user can change their password. Set this property to `$true` to prevent the user
from changing their password. Set this property to `$false` to allow the user to change their
password.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### PasswordChangeRequired

Specify whether the user must change their password. Set this property to `$true` to force the user
to change their password the next time they sign in. Set this property to `$false` to not require
the user to change their password.

The default value is `$true`.

```
Type: System.Boolean
Default Value: true
```

### PasswordNeverExpires

Specify whether the password expires. Set this property to `$true` to prevent the account's password
from expiring. Set this property to `$false` to have the account's password expire per system
security settings.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

## Examples

- [Create a new user][2]

<!-- Reference Links -->

[1]: ../Group/Group.md
[2]: Create.md
