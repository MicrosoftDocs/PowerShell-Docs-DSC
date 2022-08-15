---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,setup
title:  Authoring DSC Resources
description: >
  This article provides an overview of developing DSC Resources and links to articles with specific
  information and examples.
---

# Authoring DSC Resources

> Applies To: PowerShell 7.2

PowerShell Desired State Configuration (DSC) uses DSC Resources as standardized interfaces for
managing the settings of a system. This article provides an overview of developing DSC Resources and
links to articles with specific information and examples.

## DSC Resource components

A DSC Resource is a PowerShell module. The module contains both the schema (the definition of the
configurable properties) and the implementation (the code that does the actual work of managing
settings) for the DSC Resource. A DSC Resource schema can be defined in a MOF file with the
implementation in a script module or the schema and implementation can both be defined in a
PowerShell class. The following articles describe in more detail how to create DSC Resources.

- [Authoring a class-based DSC Resource][1]
- [Authoring a single-instance DSC Resource][2]
- [Authoring a MOF-based DSC Resource][3]
- [Authoring a composite DSC Resource][4]

Review the [DSC Resource authoring checklist][5] to ensure you're developing reliable high-quality
DSC Resources you and others can rely on.

<!-- Reference Links -->

[1]: class-based.md
[2]: single-instance.md
[3]: mof-based.md
[4]: composite.md
[5]: checklist.md
