---
description: >-
  Learn about Microsoft's Desired State Configuration platform, including what it does and when
  it should be used.
ms.date: 01/29/2024
ms.topic: overview
title:  Microsoft Desired State Configuration v3 overview
---

# Microsoft Desired State Configuration v3 overview

Microsoft's Desired State Configuration (DSC) is a declarative configuration platform. With DSC,
the state of a machine is described using a format that should be clear to understand even if the
reader isn't a subject matter expert. Unlike imperative tools, with DSC the definition of an
application environment is separate from the script logic that implements how it's delivered.

The DSCv3 command line application abstracts the management of software components declaratively
and idempotently. DSCv3 runs on Linux, macOS, and Windows without any external dependencies.

With DSCv3, you can:

- Author DSC Resources to manage your systems in any language.
- Invoke individual resources.
- Create configuration documents that define the desired state of a system.

## Configuration Documents

DSC Configuration Documents are declarative YAML files that define instances of resources.
Typically, configuration documents define what state to enforce.

Example scenarios include requirements for an application environment or operational/security
standards.

## DSC Resources

DSC Resources define how to manage state for a particular system or application component.
Resources describe a schema for the manageable settings of the component. Every resource can be
used with the **Get** and **Test** operations to retrieve the current state of a resource instance
and validate whether it's in the desired state. Most resources also support enforcing the desired
state with the **Set** operation.

Example scenarios include how to update the contents of a file, how to run a utility that changes
the state of a machine, or how to configure settings of an application.

### Differences from PowerShell DSC

DSCv3 leverages the [PSDesiredStateConfiguration module][00] to support compatibility with
existing PowerShell based resources.

DSCv3 differs from PowerShell Desired State Configuration (PSDSC) in a few important ways:

- DSCv3 doesn't depend on PowerShell. You can use DSCv3 without PowerShell installed and manage
  resources written in bash, python, C#, Go, or any other language.
- DSCv3 doesn't include a local configuration manager. DSCv3 is invoked as a command. It doesn't
  run as a service.
- Non-PowerShell resources define their schemas with JSON files, not MOF files.
- Configuration documents are defined in JSON or YAML files, not PowerShell script files.

Importantly, while DSCv3 represents a major change to the DSC platform, DSCv3 is able to invoke
PSDSC Resources, including script-based and class-based DSC Resources, as they exist today. The
configuration documents aren't compatible, but all published PSDSC Resources are. You can use PSDSC
resources in DSCv3 with both Windows PowerShell and PowerShell.

## Installation

To install DSCv3:

1. Download the [latest release from the PowerShell/DSC repository][01].
1. Expand the release archive.
1. Add the folder containing the expanded archive contents to the `PATH`.

To install the `PSDesiredStateConfiguration` version 3 beta from the PowerShell Gallery:

```powershell
# Using PSResourceGet
Install-PSResource -Name PSDesiredStateConfiguration -Version 3.0.0-beta1 -Prerelease
# Using PowerShellGet
Install-Module -Name PSDesiredStateConfiguration -RequiredVersion 3.0.0-beta1 -AllowPrerelease
```

## Integrating with DSCv3

DSCv3 is a platform tool that abstracts the concerns for defining and invoking resources. Higher
order tools, like Azure Machine Configuration, Azure Automanaged VM, and WinGet are early partners
for DSCv3 as orchestration agents.

DSCv3 uses JSON schemas to define the structure of resources, configuration documents, and the
outputs that DSCv3 returns. These schemas make it easier to integrate DSCv3 with other tools,
because they standardize and document how to interface with DSCv3.

## See Also

- [Anatomy of a command-based DSC Resource][02] to learn about authoring a resource in your
  language of choice.
- [Command line reference for the 'dsc' command][03]

<!-- link references -->
[00]: https://github.com/powershell/psdesiredstateconfiguration
[01]: https://github.com/PowerShell/DSC/releases/latest
[02]: resources/concepts/anatomy.md
[03]: reference/cli/dsc.md
