---
title: "Glossary: DSC"
description: >-
  A glossary of terms for PowerShell Desired State Configuration (DSC).
ms.date: 10/26/2022
---

# Glossary: DSC

PowerShell Desired State Configuration (DSC) uses several terms that may have different definitions
elsewhere. This document lists the terms, their meanings, and shows how they're formatted in the
documentation.

<!-- markdownlint-disable MD028 MD036 -->

## Configuration Terms

### `Configuration` keyword

The PowerShell keyword for defining a DSC Configuration.

**Guidelines**

1. Format this term as code.
1. Use title casing for this term.

**Examples**

> To define a DSC Configuration, use the PowerShell keyword `Configuration`.

### `Configuration` block

The PowerShell scriptblock that defines a DSC Configuration.

**Guidelines**

1. Format the word `Configuration` in this term as code.
1. Use lower casing for the word "block" in this term.

**Examples**

> When using this DSC Resource in a `Configuration` block, you can specify `MSFT_UserResource` or
> `User`.

### DSC Configuration

The named set of DSC Resource blocks defined in a `Configuration` block.

To use a DSC Configuration you execute it by name, which compiles the DSC Configuration into a
`.mof` file. The resulting `.mof` file represents the desired state for a system.

**Guidelines**

1. Capitalize the word "Configuration" in this term.
1. Don't add any formatting to this term.

**Examples**

> This is where the DSC Configuration defines the settings for the component it's configuring.

### `Import-DscResource`

A dynamic keyword that's only valid in a `Configuration` block. It makes DSC Resources available to
the DSC Configuration. To use a DSC Resource, it must be imported with this keyword.

**Guidelines**

1. Format this term as code.
1. Use Pascal casing for this term.

**Examples**

> `Import-DscResource` is a dynamic keyword that can only be recognized within a `Configuration`
> block.

## Resource Terms

### DSC Resource

The DSC interface for managing the settings of a component. Includes one or more properties and the
**Get**, **Set**, and **Test** methods.

**Guidelines**

1. Use title casing for this term.
1. Format the names of specific DSC Resources as code.

**Examples**

> They both use the `Environment` DSC Resource.

> You can inspect a DSC Resource with the `Get-DscResource` cmdlet to see the properties it manages.

### Class-based DSC Resource

A DSC Resource defined as a PowerShell class in a module.

A class-based DSC Resource's schema is defined by the members of the class. A class-based DSC
Resource must define the `Get()`, `Set()`, and `Test()` methods.

**Guidelines**

1. Use sentence casing for the word `class` in this term.
1. Don't add any formatting to this term.

**Examples**

> The class-based DSC Resource doesn't have special requirements for where it's defined.

> Class-based DSC Resources define their schema in the class definition.

### Composite DSC Resource

A DSC Resource defined with a script module file (`.psm1`) and an optional module manifest file
(`.psd1`).

The script module file defines the DSC Resource's schema and implementation as a DSC Configuration.

**Guidelines**

1. Use sentence casing for the word `composite` in this term.
1. Don't add any formatting to this term.

**Examples**

> A composite DSC Resource is a DSC Configuration that takes parameters.

> Composite DSC Resources don't work with `Invoke-DscResource`.

### MOF-based DSC Resource

A DSC Resource defined with a MOF file (`.mof`), a script module file (`.psm1`), and optional
module manifest file (`.psd1`).

The MOF file is the schema for the DSC Resource and defines the DSC Resource's properties. The
script module file defines the DSC Resource's functions: `Get-TargetResource`,
`Set-TargetResource`, and `Test-TargetResource`. These functions map to the **Get**, **Set**, and
**Test** methods that all DSC Resources have.

**Guidelines**

1. Always specify this term as "MOF-based DSC Resource"
1. Don't add any formatting to this term.

**Examples**

> MOF-based DSC Resources define their schema in a `schema.mof` file, using the Managed Object
> Format.

### Resource block

The definition of desired state for a specific DSC Resource in a `Configuration` block.

**Guidelines**

1. Use sentence casing for this term.
1. Don't add any formatting to this term.
1. When writing about a specific resource block in a DSC Configuration, write the correctly
   formatted name of the DSC Resource followed by "resource block."

**Examples**

> The following example adds a parameter block with a `-ServiceName` parameter and uses it to
> dynamically define the `Service` resource block.

### Methods

The operations a DSC Resource can take for the component it manages.

- **Get** - Retrieves the current state of an instance of the DSC Resource.
- **Set** - Enforces the desired state of an instance of the DSC Resource.
- **Test** - Compares the desired state of an instance of the DSC Resource against its current
  state. Returns `$true` if the instance is in the desired state and `$false` if it isn't.

**Guidelines**

1. Capitalize the methods.
1. When referring to the method in the context of calling `Invoke-DscResource`, format the method
   as **bold**.
1. When referring to the method as implemented in a PowerShell class, format the method as `code`
   with an empty set of parentheses (`()`) after the name.

**Examples**

> The implementation of the `Set()` method can't use any `return` statements.

> DSC is constructed around a **Get**, **Test**, and **Set** process.

### Property

A setting that a DSC Resource can manage for a component. DSC Resources always have at least one
property.

**Guidelines**

1. Format DSC Resource property names as bold.
1. Use Pascal casing for DSC Resource property names.
1. Format DSC Resource property values as code.

**Examples**

> The value of the **Format** property in this example is `JSON`.
