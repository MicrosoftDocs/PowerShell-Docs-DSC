---
ms.date: 08/08/2022
ms.topic: reference
title: Group
description: PSDscResources Group resource
---

# Group

## Synopsis

Manage a local group.

## Syntax

```Syntax
Group [String] #ResourceName
{
    GroupName = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Members = [string[]]]
    [MembersToExclude = [string[]]]
    [MembersToInclude = [string[]]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

## Description

The `Group` resource enables you to manage local groups. It can create, update, and remove groups.
You can use this resource to enforce group membership and set the group's description.

### Requirements

None.

## Key properties

### GroupName

Specify the name of the group.

```
Type: System.String
```

## Optional properties

### Credential

Specify the credential for an account with permission to resolve non-local group members if needed.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Description

Specify the group's description.

```
Type: System.String
Default Value: None
```

### Ensure

Specify whether the group should exist. To create or modify a group, set this property to `Present`.
To remove a group, set this property to `Absent`. The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### Members

Specify the full list of the group's members as an array of strings. If you specify this property,
the resource sets the group's member list to this value. Format each member as one of the following:

- Domain qualified name: `<domain>\<username>`
- UPN: `<username>@<domain>`
- Distinguished name: `CN=<username>,DC=...`
- Username: `<username>`

Don't use this property with the **MembersToExclude** or **MembersToInclude** properties. If you
do, the resource throws an exception.

```
Type: System.String[]
Default Value: None
```

### MembersToExclude

Specify one or more members to exclude from the group as an array of strings. If you specify this
property, the resource removes these members from the group if it includes them. Format each member
as one of the following:

- Domain qualified name: `<domain>\<username>`
- UPN: `<username>@<domain>`
- Distinguished name: `CN=<username>,DC=...`
- Username: `<username>`

Don't use this property with the **Members** property. If you do, the resource throws an exception.

```
Type: System.String[]
Default Value: None
```

### MembersToInclude

Specify one or more members to include in the group as an array of strings. If you specify this
property, the resource adds these members from the group if it doesn't include them. Format each
member as one of the following:

- Domain qualified name: `<domain>\<username>`
- UPN: `<username>@<domain>`
- Distinguished name: `CN=<username>,DC=...`
- Username: `<username>`

Don't use this property with the **Members** property. If you do, the resource throws an exception.

```
Type: System.String[]
Default Value: None
```

## Examples

- [Set members of a group][1]
- [Remove members of a group][2]

[1]: SetMembers.md
[2]: RemoveMembers.md
