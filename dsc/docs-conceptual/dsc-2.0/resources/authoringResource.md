---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Build custom PowerShell Desired State Configuration resources
description: >
  This article provides an overview of developing resources and links to articles with specific
  information and examples.
---

# Build Custom PowerShell Desired State Configuration resources

> Applies To: PowerShell 7.2

PowerShell Desired State Configuration (DSC) has built-in resources that you can use to
configure your environment. This article provides an overview of developing resources and links to
articles with specific information and examples.

## DSC resource components

A DSC resource is a PowerShell module. The module contains both the schema (the definition of the
configurable properties) and the implementation (the code that does the actual work specified by a
Configuration) for the resource. A DSC resource schema can be defined in a MOF file with the
implementation in a script module or the schema and implementation can both be defined in a
PowerShell class. The following articles describe in more detail how to create DSC resources.

- [Writing a custom DSC resource with MOF][1]
- [Writing a custom DSC resource with PowerShell classes][2]
- [Composite resources: Using a DSC configuration as a resource][3]

<!-- Reference Links -->

[1]: authoringResourceMOF.md
[2]: authoringResourceClass.md
[3]: authoringResourceComposite.md
