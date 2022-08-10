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

- `Configuration`: The keyword for defining a Configuration.
  - `Configuration` block: The definition of a Configuration.
  - The term _Configuration_, in its undecorated form, refers to the set of nodes and resources
    defined in the `Configuration` block.
    - To use a Configuration you execute it by name, which compiles the Configuration into a `.mof`
      file.
    - The resulting `.mof` file represents the desired state for a specific machine.
    - A composite Configuration is a Configuration that nests other `Configuration` definitions
      inside it for composability.
    - A dynamic Configuration is a Configuration that has parameters to pass values into the
      compiled `.mof`.
  - **ConfigurationData**: A common parameter of a `Configuration` that is used when you compile the
    Configuration.
    - The value of the parameter is a hashtable containing node-specific values to be included in
      the compiled `.mof`. This allows you to separate the structure of a Configuration from the
      values it uses.
  - `Import-DscResource`: A dynamic keyword that's only valid in a `Configuration` block. It makes
    Resources available to the Configuration. To use a Resource, it must be imported with this
    keyword.

- `Node`: The keyword for defining the desired state of a machine.
  - `Node` block: The definition of a machine's desired state. A `Node` block always has one or more
    names, such as `localhost`, and a scriptblock with Resource blocks.

- Resource: The DSC interface for managing the settings of a software component. Specific Resources
  are always backticked, like `Archive` or `Environment`. Resources have properties (the settings a
  user can manage with DSC).
  - Resource block: The definition of desired state for a specific Resource in the context of a
    `Node` block.
  - Resources have three methods: **Get**, **Set**, and **Test**.
    - **Get** retrieves the current state of the Resource.
    - **Set** enforces the desired state of the Resource.
    - **Test** returns `$true` if the current state of the Resource matches the desired state of the
      Resource and `$false` if it doesn't.
  - A MOF-based Resource is defined with a MOF file (`.mof`), a script module file (`.psm1`), and
    and optional module manifest file (`.psd1`). The MOF file is the schema for the Resource and
    defines the Resource's properties. The script module file defines the Resource's functions:
    `Get-TargetResource`, `Set-TargetResource`, and `Test-TargetResource`. These functions map to
    the **Get**, **Set**, and **Test** methods that all Resources have.
  - A class-based Resource is defined with a PowerShell class in a module. A class-based Resource's
    schema is defined by the members of the class. A class-based Resource must define the **Get**,
    **Set**, and **Test** methods.
  - A composite Resource is defined with a script module file (`.psm1`) and an optional module
    manifest file (`.psd1`). The script module file defines the Resource's schema and implementation
    as a Configuration.
  - Resource properties are always formatted in bold, like **Name** or **StartupType**.
  - Resource property values are always formatted in backticks, like `winrm` or `Running`.
