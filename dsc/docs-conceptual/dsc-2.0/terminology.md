---
ms.date: 08/09/2022
title:  Terminology
description: >
  A list of terms and concepts for PowerShell Desired State Configuration (DSC).
---

# Terminology

PowerShell Desired State Configuration (DSC) uses several terms that may have different definitions
elsewhere. This document lists the terms, their meanings, and shows how they're formatted in the
documentation.

- `Configuration`: The keyword for defining a DSC Configuration.
  - `Configuration` block: The definition of a DSC Configuration.
  - The term _DSC Configuration_, in its undecorated form, refers to the set of DSC Resource blocks
    defined in the `Configuration` block.
    - To use a DSC Configuration you execute it by name, which compiles the DSC Configuration into a
      `.mof` file.
    - The resulting `.mof` file represents the desired state for a system.
  - `Import-DscResource`: A dynamic keyword that's only valid in a `Configuration` block. It makes
    DSC Resources available to the DSC Configuration. To use a DSC Resource, it must be imported
    with this keyword.

- DSC Resource: The DSC interface for managing the settings of a software component. Specific DSC
  Resources are always backticked, like `Archive` or `Environment`. DSC Resources have properties
  (the settings a user can manage with DSC).
  - DSC Resource block: The definition of desired state for a specific DSC Resource in a
    `Configuration` block.
  - DSC Resources have three methods: **Get**, **Set**, and **Test**.
    - **Get** retrieves the current state of the DSC Resource.
    - **Set** enforces the desired state of the DSC Resource.
    - **Test** returns `$true` if the current state of the DSC Resource matches the desired state of
      the DSC Resource and `$false` if it doesn't.
  - A MOF-based DSC Resource is defined with a MOF file (`.mof`), a script module file (`.psm1`),
    and optional module manifest file (`.psd1`). The MOF file is the schema for the DSC Resource and
    defines the DSC Resource's properties. The script module file defines the DSC Resource's
    functions: `Get-TargetResource`, `Set-TargetResource`, and `Test-TargetResource`. These
    functions map to the **Get**, **Set**, and **Test** methods that all DSC Resources have.
  - A class-based DSC Resource is defined with a PowerShell class in a module. A class-based DSC
    Resource's schema is defined by the members of the class. A class-based DSC Resource must define
    the **Get**, **Set**, and **Test** methods.
  - A composite DSC Resource is defined with a script module file (`.psm1`) and an optional module
    manifest file (`.psd1`). The script module file defines the DSC Resource's schema and
    implementation as a DSC Configuration.
  - DSC Resource properties are always formatted in bold, like **Name** or **StartupType**.
  - DSC Resource property values are always formatted in backticks, like `winrm` or `Running`.
