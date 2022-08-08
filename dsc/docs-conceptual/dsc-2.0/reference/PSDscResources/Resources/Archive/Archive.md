---
ms.date: 08/08/2022
ms.topic: reference
title: Archive
description: PSDscResources Archive resource
---

# Archive

## Synopsis

Expand or remove the contents of an archive (`.zip`) file.

## Syntax

```text
Archive [String] #ResourceName
{
    Destination = [string]
    Path = [string]
    [Checksum = [string]{ CreatedDate | ModifiedDate | SHA-1 | SHA-256 | SHA-512 }]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [Force = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
    [Validate = [bool]]
}
```

## Description

The `Archive` resource enables you to idempotently manage the expanded contents of an archive
(`.zip`) file. It can ensure that an archive's expanded contents are up to date or removed from a
system.

### Requirements

- The **System.IO.Compression** type assembly must be available on the machine.
- The **System.IO.Compression.FileSystem** type assembly must be available on the machine.

## Key properties

### Destination

Specify the path to the folder the expanded content should be written to or removed from.

```yaml
Type: System.String
```

### Path

Specify the path to the archive file.

```yaml
Type: System.String
```

## Optional properties

### Checksum

Specify the checksum method to use when validating expanded content against the archive. If you
specify a value for **Checksum** and **Validate** as `$false`, the resource throws an invalid
argument exception.

If you specify **Validate** as `$true`, the default for **Checksum** is `ModifiedDate`.

> [!NOTE]
> Using either **Checksum** or **Validate** implies the other. Even though you can specify
> **Validate** without **Checksum**, it is best practice to specify both together.

The specified method determines how the resource validates the expanded content against the archive:

- With `ModifiedDate`, the resource checks that the **LastWriteTime** property of each expanded file
  matches the **LastWriteTime** property of that file in the archive.
- With `CreatedDate`, the resource checks that the **CreationTime** property of each expanded file
  matches the **CreationTime** property of that file in the archive.
- With `SHA-1`, `SHA-256`, or `SHA-512`, the resource uses the specified SHA method to check the
  hash of each expanded file against the hash of that file in the archive.

```yaml
Type: System.String
Accepted Values:
  - ModifiedDate
  - CreatedDate
  - SHA-1
  - SHA-256
  - SHA-512
Default Value: ModifiedDate
```

### Credential

Specify the credential of a user account with permissions to access the specified **Path** and
**Destination** if needed.

```yaml
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the expanded content of the archive file should exist. To expand the archive,
specify this property as `Present`. To remove the expanded content of the archive, specify this
property as `Absent`. The default value is `Present`.

```yaml
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### Force

Specify whether to overwrite existing content in the **Destination**. When **Force** is `$false`,
the resource errors if an item at the destination needs to be overwritten. The default value is
`$false`.

```yaml
Type: System.Boolean
Default Value: false
```

### Validate

Specify whether to validate expanded content by the specified checksum method. The default value
is `$false`.

When **Validate** is `$true` and the file at the destination does not match the file in the archive:

- If **Ensure** is `Present` and **Force** is `$false`, the resource errors with a message that the
  file at the destination can't be overwritten.
- If **Ensure** is `Present` and **Force** is `$true`, the resource overwrites the file.
- If **Ensure** is `Absent`, the resource doesn't remove the file.

```yaml
Type: System.Boolean
Default Value: false
```

## Examples

- [Expand an archive without validation][1]
- [Expand an archive under a different account without validation][2]
- [Expand an archive with default validation and overwrite if needed][3]
- [Expand an archive with SHA-256 validation and overwrite if needed][4]
- [Remove an archive without validation][5]
- [Remove an archive with SHA-256 validation][6]

<!-- Reference Links -->

[1]: ExpandNoValidation.md
[2]: ExpandCredNoValidation.md
[3]: ExpandDefaultValidationForce.md
[4]: ExpandChecksumForce.md
[5]: RemoveNoValidation.md
[6]: RemoveChecksum.md
