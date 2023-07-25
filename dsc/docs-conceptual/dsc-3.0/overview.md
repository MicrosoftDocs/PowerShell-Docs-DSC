---
description: Learn about the Desired State Configuration feature of PowerShell including the purpose and when it should be used.
ms.date: 06/28/2023
title:  PowerShell Desired State Configuration overview
---

# PowerShell Desired State Configuration overview

Desired State Configuration (DSC) is a feature of PowerShell where modules are structured in a
specific way to simplify configuration management in Linux and Windows machines.

DSC is a declarative language, where the state of a machine is described using a format that should
be clear to understand even if the reader isn't a subject matter expert. DSC is unique compared to
imperative PowerShell script format, because the definition of an application environment is
separate from the script logic that implements how it's delivered.

There are two primary components:

- **Configurations** are declarative PowerShell scripts that define instances of resources.
  Typically configurations define what to automate. Example scenarios include requirements for an
  application environment or operational/security standards.
- **Resources** contain the script functions that define how to automate. Resources always contain
  three methods, "Get", "Test", and "Set". Example scenarios include how to update the contents of a
  file, how to run a utility that changes the state of a machine, or how to configure settings of an
  application.

As of version 7.2, the module `PSDesiredStateConfiguration` containing the DSC feature and must be
installed as an independent component after you install PowerShell. Separating DSC into an
independent module reduces the size of the PowerShell release package, and allows DSC to be upgraded
on machines without also planning an upgrade of the PowerShell 7 installation.

## Installation

To install the `PSDesiredStateConfiguration` version 3 from the PowerShell Gallery:

```powershell
@InstallParameters = @{
    Name            = 'PSDesiredStateConfiguration'
    RequiredVersion = '3.0.0-beta1'
    AllowPreRelease = $true
    Force           = $true
}
Install-Module @InstallParameters
```

## See Also

- [DSC Configurations][01]
- [DSC Resources][02]

<!-- link references -->
[01]: concepts/configurations.md
[02]: concepts/resources.md
