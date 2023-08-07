---
title: "Glossary: Desired State Configuration"
description: >-
  A glossary of terms for PowerShell Desired State Configuration (DSC) v3.
ms.date: 08/07/2023
---

# Glossary: Desired State Configuration

Desired State Configuration (DSC) v3 uses several terms that may have different definitions
elsewhere. This document lists the terms, their meanings, and shows how they're formatted in the
documentation.

<!-- markdownlint-disable MD028 MD036 -->

## Configuration terms

### DSC Configuration document

The JSON or YAML file that defines a list of resource instances and their desired state.

#### Guidelines

- **First mention:** DSC Configuration Document
- **Subsequent mentions:** configuration document or document

#### Examples

> A DSC Configuration Document may be formatted as JSON or YAML.

> Define the `scope` variable in the document as `machine`.

## Resource terms

### DSC Resource

The DSC interface for managing the settings of a component. DSC v3 supports several kinds of
resources.

#### Guidelines

- **First mention:** DSC Resource
- **Subsequent mentions:** resource
- Format the names of specific resources as code.

#### Examples

> They both use the `Microsoft/OSInfo` DSC Resource.

> You can inspect a resource's definition with the `dsc resource list <resource_name>` command.

### Command-based DSC Resource

A resource defined with a resource manifest is a _command-based_ resource. DSC uses the manifest to
determine how to invoke the resource and how to validate the resource instance properties.

#### Guidelines

- Always specify the term with the hyphen.

#### Examples

> `Microsoft.Windows/Registry` is a command-based resource.

### DSC Resource group

A _resource group_ is a command-based resource with a `resources` property that takes an array of
resource instances and processes them. Resource groups may apply special handling to their nested
resource instances, like changing the user the resources run as.

#### Guidelines

- Always specify the term as resource group. Don't omit "group" from the term.

#### Examples

> To ensure resources are invoked in parallel, use the `DSC/ParallelGroup` resource group.

### Nested resource instance

A resource instance that's included in the `resources` property of a resource group or resource
provider.

#### Guidelines

- **First mention:** nested resource instance
- **Subsequent mentions:** nested instance
- If it's clear from context that the instance is a nested instance, you can omit the "nested"
  prefix.

#### Examples

> Add a nested resource instance to the `DSC/ParallelGroup` instance. Define the `type` of the
> nested instance as `Microsoft.Windows/Registry`.

### DSC Resource provider

A resource provider is a resource group that enables the use of non-command-based resources with
DSC v3. Every nested resource instance must be a resource type the provider supports.

#### Guidelines

- **First mention:** DSC Resource provider
- **Subsequent mentions:** provider

#### Examples

> To use PowerShell DSC Resources in your configuration document, add an instance of the
> `DSC/PowerShellGroup` resource provider and define the PowerShell resource instances as nested
> instances.

### PowerShell DSC Resources

A resource implemented in PowerShell. DSC v3 supports two types of PowerShell resources.

- Class-Based - A resource defined as a PowerShell class in a module is a _class-based_ resource.

  The class's members define a class-based resource's schema. A class-based resource must define
  the `Get()`, `Set()`, and `Test()` methods.
- MOF-based - A resource defined with a MOF file (`.mof`), a script module file (`.psm1`), and
  optional module manifest file (`.psd1`) is a _MOF-based_ resource. MOF-based resources are only
  supported through Windows PowerShell.

  The MOF file is the schema for the resource and defines the resource's properties. The script
  module file defines the resource's functions: `Get-TargetResource`, `Set-TargetResource`, and
  `Test-TargetResource`. These functions map to the **Get**, **Set**, and **Test** methods.

#### Guidelines

- **First mention:** PowerShell DSC Resources
- **Subsequent mentions:** PowerShell resources, class-based resources, or MOF-based resources
- When discussing a specific type of PowerShell resource, always specify the type prefix, like
  _class-based resources_.

#### Examples

> To use PowerShell DSC Resources in your configuration document, add an instance of the
> `DSC/PowerShellGroup` resource provider and define the PowerShell resource instances as nested
> instances.

> When developing PowerShell resources for cross-platform software, create class-based resources.
> MOF-based resources are only supported through Windows PowerShell.

### DSC Resource manifest

The JSON file that defines the metadata and implementation of a command-based resource.

#### Guidelines

- **First mention:** DSC Resource manifest
- **Subsequent mentions:** manifest

#### Examples

> Every command-based resource must define a DSC Resource manifest. The manifest's filename must
> end with `.dsc.resource.json`.

### DSC Resource type name

The identifying name of a resource. The fully qualified resource type name uses the following
syntax:

```text
`<owner>[.<group>][.<area>]/<name>`
```

#### Guidelines

- **First mention:** DSC Resource type name
- **Subsequent mentions:** resource type or type name.
- When discussing the syntax of a resource type name, always specify the term as
  _fully qualified resource type name_.

#### Examples

> DSC Resources are uniquely identified by their resource type name.

### Operations

The actions a resource can take for the component it manages.

- **Get** - Retrieves the current state of an instance of the resource.
- **Set** - Enforces the desired state of an instance of the resource.
- **Test** - Compares the desired state of an instance of the resource against its current state.

**Guidelines**

1. Capitalize the operations.
1. When referring to the operation specifically, format it as **bold**.
1. When referring to the operation's method as implemented in a PowerShell class, format the method
   as `code` with an empty set of parentheses (`()`) after the name.

**Examples**

> The implementation of the `Set()` method in a class-based resource can't use any `return`
> statements.

> DSC is constructed around a **Get**, **Test**, and **Set** process.

### Property

A setting that a resource can manage for a component. Resources always have at least one property.

**Guidelines**

1. Format property names as bold.
1. Format property values as code.

**Examples**

> The value of the **Format** property in this example is `JSON`.
