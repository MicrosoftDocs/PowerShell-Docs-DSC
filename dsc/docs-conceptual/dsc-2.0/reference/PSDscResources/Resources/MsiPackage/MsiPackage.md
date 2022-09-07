---
description: PSDscResources MsiPackage resource
ms.date: 08/08/2022
ms.topic: reference
title: MsiPackage
---

# MsiPackage

## Synopsis

Install or uninstall an MSI package.

## Syntax

```Syntax
MsiPackage [String] #ResourceName
{
    Path = [string]
    ProductId = [string]
    [Arguments = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [FileHash = [string]]
    [HashAlgorithm = [string]{ MD5 | RIPEMD160 | SHA1 | SHA256 | SHA384 | SHA512 }]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [RunAsCredential = [PSCredential]]
    [ServerCertificateValidationCallback = [string]]
    [SignerSubject = [string]]
    [SignerThumbprint = [string]]
}
```

## Description

The `MsiPackage` resource installs or uninstalls an MSI package. The package can be local, on a UNC
drive, or downloaded from a web URI. You can install the package as an alternate account. You can
specify additional arguments to the package for installation or uninstallation as needed.

### Requirements

None.

## Key properties

### ProductId

Specify the identifying number used to find the package as a string. This value is usually a GUID.

```
Type: System.String
```

## Mandatory Properties

### Path

Specify the path to the MSI package as a string. This property's value can be the path to an MSI
file on the local machine, the path to an MSI package on a UNC drive, or a web URI where the MSI
package can be downloaded from. If this property's value isn't a web URI, it must end with `.msi`.

This property is only used with the resource's **Set** method. If the value is a web URI, the
resource downloads the package to a local cache before installing or uninstalling. If the value is a
UNC path, the resource mounts the UNC drive before installing or uninstalling.

```
Type: System.String
```

## Optional properties

### Arguments

Specify the additional arguments to pass to the package during installation or uninstallation as a
string. The following arguments are always passed:

- When installing, `/i <Path to the MSI package>` is the first argument.
- When uninstalling, `/x <Product Entry Guid>` is the first argument.
- If **LogPath** is specified, the resource appends `/log "<LogPath>"` to the argument list. See
  [LogPath][1] for more information.
- `/quiet` and `/norestart` are always appended.

The value of this property is appended after the default arguments.

```
Type: System.String
Default Value: None
```

### Credential

Specify the credential of an account with permission to mount a UNC path if needed.

```
Type: System.Management.Automation.PSCredential
Behavior: Write
Default Value: None
```

### Ensure

Specifies whether to install or uninstall the package. To install the package, specify this property
as `Present`. To uninstall the package, specify this property as `Absent`. The default value is
`Present`.

```
Type: System.String
Behavior: Write
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### FileHash

Specify the expected hash value of the MSI file as a string. If specified, the resource checks the
package against this value before installing or uninstalling the package. If the values don't match,
the resource throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

### HashAlgorithm

Specify the algorithm used to generate the value for **FileHash**. The default value is `SHA256`.

```
Type: System.String
Accepted Values:
  - MD5
  - RIPEMD160
  - SHA1
  - SHA256
  - SHA384
  - SHA512
Default Value: SHA256
```

### LogPath

Specify the path a file for logging the output from MSI execution as a string. By default, the
output isn't logged.

```
Type: System.String
Default Value: None
```

### RunAsCredential

Specify the credential of an alternate account to run the installation or uninstallation of the
package as.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### ServerCertificateValidationCallback

Specify a PowerShell scriptblock to validate SSL certificates when **Path** is an HTTPS URI. If the
scriptblock doesn't return `$true`, the resource's **Set** method throws an invalid operation
exception and doesn't download the package.

```
Type: System.String
Default Value: None
```

### SignerSubject

Specify the subject as a string that should match the signer certificate of the MSI file's digital
signature. If specified, the resource checks the package against this value before installing or
uninstalling the package. If the values don't match, the resource's **Set** method throws an invalid
argument exception.

```
Type: System.String
Default Value: None
```

### SignerThumbprint

Specify the certificate thumbprint as a string that should match the signer certificate of the MSI
file's digital signature. If specified, the resource checks the package against this value before
installing or uninstalling the package. If the values don't match, the resource's **Set** method
throws an invalid argument exception.

```
Type: System.String
Default Value: None
```

## Read-only properties

### InstalledOn

The date that the MSI package was installed on or serviced on, whichever is later. This property is
not configurable.

```
Type: System.String
```

### InstallSource

The path to the MSI package.

```
Type: System.String
```

### Name

The display name of the MSI package.

```
Type: System.String
```

### PackageDescription

The description of the MSI package.

```
Type: System.String
```

### Publisher

The publisher of the MSI package.

```
Type: System.String
```

### Size

The size of the MSI package in MB.

```
Type: System.UInt32
```

### Version

The version number of the MSI package.

```
Type: System.String
```

## Examples

- [Install the MSI file with the given ID at the given Path][2]
- [Uninstall the MSI file with the given ID at the given Path][3]
- [Install the MSI file with the given ID at the given HTTPS URL][4]
- [Uninstall the MSI file with the given ID at the given HTTPS URL][5]

<!-- Reference Links -->

[1]: #logpath
[2]: InstallFromFile.md
[3]: UninstallFromFile.md
[4]: InstallFromHttps.md
[5]: UninstallFromHttps.md
