---
description: Learn about the Desired State Configuration feature of PowerShell including the purpose and when it should be used.
ms.date: 12/24/2021
title:  PowerShell Desired State Configuration overview
---

# PowerShell Desired State Configuration overview

Desired State Configuration (DSC) is a feature of PowerShell
where modules are structure in a specific way
to simplify configuration management in Linux and Windows machines.

DSC is a declarative abstraction used for deployment and management of anything
that can be automated from PowerShell.
There are two primary components:

- **Configurations** are declarative PowerShell scripts that
  define instances of resources. Typically configurations define what to automate.
  Example scenarios include requirements for an application environment
  or operational/security standards.
- **Resources** contain the script functions that define how to automate.
  Resources always contain three methods, "Get", "Test", and "Set".
  Example scenarios include how to update the contents of a file,
  how to run a utility that changes the state of a machine,
  or how to configure settings of an application.

As of version 7.2-preview7, releases of the PowerShell script language
do not contain DSC. The module `PSDesiredStateConfiguration` contains the DSC
feature and must be installed as an independent component.
Separating DSC into an independent module reduces the size of the PowerShell
release package, and allows DSC to be upgraded on machines without
also planning an upgrade of the PowerShell 7 installation.

## Installation

To install `PSDesiredStateConfiguration` version `3.0.0`
from the PowerShell Gallery:

```powershell
Install-Module -Name PSDesiredStateConfiguration -allowprerelease
```

## See Also

- [DSC Configurations](/concepts/configurations.md)
- [DSC Resources](/concepts/resources.md)
