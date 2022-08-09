---
ms.date: 08/08/2022
ms.topic: reference
title: GroupSet
description: PSDscResources GroupSet composite resource
---

# GroupSet

## Synopsis

Manage multiple Group resources with common settings.

## Syntax

```Syntax
GroupSet [String] #ResourceName
{
    [DependsOn = [String[]]]
    [PsDscRunAsCredential = [PSCredential]]
    GroupName = [String[]]
    [Ensure = [String]]
    [MembersToInclude = [String[]]]
    [MembersToExclude = [String[]]]
    [Credential = [PSCredential]]
}
```

## Description

> [!IMPORTANT]
> Write a description.

### Requirements

None.

## Key properties

### GroupName

Specify the names of one or more groups as an array of strings. The resource applies the same
configuration to every group in this property.

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

### Ensure

Specify whether the groups should exist. To create or modify the groups, set this property to
`Present`. To remove the groups, set this property to `Absent`. The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### MembersToExclude

Specify one or more members to exclude from the groups as an array of strings. If you specify this
property, the resource removes these members from every group if it includes them. Format each
member as one of the following:

- Domain qualified name: `<domain>\<username>`
- UPN: `<username>@<domain>`
- Distinguished name: `CN=<username>,DC=...`
- Username: `<username>`

```
Type: System.String[]
Default Value: None
```

### MembersToInclude

Specify one or more members to include in the groups as an array of strings. If you specify this
property, the resource adds these members to every group if it doesn't include them. Format each
member as one of the following:

- Domain qualified name: `<domain>\<username>`
- UPN: `<username>@<domain>`
- Distinguished name: `CN=<username>,DC=...`
- Username: `<username>`

```
Type: System.String[]
Default Value: None
```

## Examples

- [Add members to multiple groups][1]

<!-- Reference Links -->

[1]: AddMembers.md
