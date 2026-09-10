---
description: >-
  Learn about Microsoft's Desired State Configuration platform, including what it does and when
  it should be used.
ms.date: 09/10/2026
ms.topic: overview
title:  Microsoft Desired State Configuration overview
---

# Microsoft Desired State Configuration overview

Microsoft's Desired State Configuration (DSC) is a declarative configuration platform. With DSC,
the state of a machine is described using a format that should be clear to understand even if the
reader isn't a subject matter expert. Unlike imperative tools, with DSC the definition of an
application environment is separate from programming logic that enforces that definition.

The DSC command line application (`dsc`) abstracts the management of software components
declaratively and idempotently. DSC runs on Linux, macOS, and Windows without any external
dependencies.

With DSC, you can:

- Author DSC Resources to manage your systems in any language.
- Invoke individual resources directly.
- Create configuration documents that define the desired state of a system.

## Configuration Documents

DSC Configuration Documents are declarative data files that define instances of resources.
Typically, configuration documents define what state to enforce. DSC supports writing configuration
documents in both JSON and YAML.

Example scenarios include requirements for an application environment or operational/security
standards.

## DSC Resources

DSC Resources define how to manage state for a particular system or application component.
Resources describe a schema for the manageable settings of the component. Every resource can be
used with the **Get** and **Test** operations to retrieve the current state of a resource instance
and validate whether it's in the desired state. Most resources also support enforcing the desired
state with the **Set** operation.

Example scenarios include:

- How to update the contents of a file.
- How to run a utility that changes the state of a machine.
- How to configure settings of an application.

### Differences from PowerShell DSC

DSC differs from PowerShell Desired State Configuration (PSDSC) in a few important ways:

- DSC doesn't _depend_ on PowerShell, Windows PowerShell, or the [PSDesiredStateConfiguration][06]
  PowerShell module. DSC provides full compatibility with PSDSC resources through the
  `Microsoft.DSC/PowerShell` and `Microsoft.Windows/WindowsPowerShell` _adapter resources_.

  With the `Microsoft.DSC/PowerShell` adapter resource, you can use any PSDSC resource implemented
  as a PowerShell class. The resource handles discovering, validating, and invoking PSDSC
  resources in PowerShell. The resource is included in the DSC install package for every platform.

  With the `Microsoft.Windows/WindowsPowerShell` adapter resource, you can use any PSDSC resource
  compatible with Windows PowerShell. The resource handles discovering, validating, and invoking
  PSDSC resources in Windows PowerShell. The resource is included in the DSC install packages for
  Windows only.
- Because DSC doesn't depend on PowerShell, you can use DSC without PowerShell installed and manage
  resources written in bash, Python, C#, Rust, or any other language.
- DSC doesn't include a local configuration manager. DSC is invoked as a command. It doesn't
  run as a service.
- New DSC resources define their schemas with JSON or YAML files, not MOF files. Self-contained
  resources define a _resource manifest_ that indicates how DSC should invoke the resource and what
  properties the resource can manage. For adapted resources, like those implemented in PowerShell,
  the adapter resource tells DSC what the available properties are for the resource and handles
  invoking the adapted resources.
- Configuration documents are defined in JSON or YAML files, not PowerShell script files.
  Configuration documents support a subset of functionality in ARM templates, including parameters,
  variables, metadata, and expression functions to dynamically resolve data in the configuration.

## Installation

DSC v3 installation instructions are covered in [Install DSC v3][07].

## Integrating with DSC
DSC is a platform tool that abstracts the concerns for defining and invoking resources. Higher
order tools, like [WinGet][04], [Microsoft Dev Box][01], and [Azure Machine Configuration][02] are
early partners for DSC as orchestration agents.

DSC uses JSON schemas to define the structure of resources, configuration documents, and the
outputs that DSC returns. These schemas make it easier to integrate DSC with other tools, because
they standardize and document how to interface with DSC.

For more information, see [DSC JSON Schema reference overview][09].

## Next steps

- [Install DSC v3][07]
- [Anatomy of a command-based DSC Resource][05] to learn about authoring a resource in your
  language of choice.
- [Command line reference for the 'dsc' command][08]
- [DSC JSON Schema reference overview][09]
- [WinGet Configuration][03]

<!-- link references -->
[01]: /azure/dev-box/overview-what-is-microsoft-dev-box
[02]: /azure/governance/machine-configuration/overview
[03]: /windows/package-manager/configuration/
[04]: /windows/package-manager/winget
[05]: concepts/resources/anatomy.md
[06]: https://github.com/powershell/psdesiredstateconfiguration
[07]: install.md
[08]: reference/cli/index.md
[09]: reference/schemas/overview.md
