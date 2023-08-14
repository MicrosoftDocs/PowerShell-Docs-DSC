---
description: >-
  DSC configuration documents are YAML or JSON data files that define the desired state of a system
  declaratively. They are used to retrieve, validate, and enforce the state of multiple resource
  instances.
ms.date: 08/07/2023
title: DSC Configuration Documents
---

# DSC Configuration Documents

<!-- markdownlint-disable MD013 -->

In Microsoft's Desired State Configuration (DSC) platform, DSC configuration documents declare the
desired state of a system as data files. Configuration documents define a collection of
[DSC Resource][01] instances to describe what the desired state should be, not how to put the
system into that state. The DSC Resources handle the "how" for the configuration document's
instances.

DSCv3 can process configuration documents to:

- Retrieve the current state of the defined resource instances with the `dsc config get` command.
- Validate whether the instances are in the desired state with the `dsc config test` command.
- Enforce the desired state for the instances with the `dsc config set` command.

Configuration documents are YAML or JSON files that contain a single object. The object's
properties define how DSCv3 processes the document. The top-level properties for a document are:

- `$schema` (required) - Defines the canonical URI for the JSON Schema the document adheres to. DSC
  uses this to know how to validate and interpret the document.
- `resources` (required) - Defines the collection of resource instances the document manages.
- `metadata` (optional) - Defines an arbitrary set of annotations for the document. DSC doesn't
  validate this data or use it directly. The annotations can include notes like who authored the
  document, the last time someone updated it, or any other information. DSC doesn't use the
  annotations. The metadata is for documentation or other tools to use.
- `parameters` (optional) - Defines a set of runtime options for the configuration. Parameters can
  be referenced by resource instances to reduce duplicate definitions or enable dynamic values.
  Parameters can have default values and can be set on any configuration operation.
- `variables` (optional) - Defines a set of reusable values for the configuration. Variables can be
  referenced by resource instances to reduce duplicate definitions.

> [!NOTE]
> DSC isn't implemented to process the `parameters` and `variables` properties yet. They can be
> defined in a document, but not referenced.

## Defining a configuration document

Minimally, a configuration document defines the `$schema` and `resources` properties. The
`$schema` property must be a valid URI for DSC's configuration document schema. The `resources`
property must define at least one DSC Resource instance.

For example:

```yaml
# example.dsc.config.yaml
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2023/08/config/document.json
resources:
  - name: example key value
    type: Microsoft.Windows/Registry
    properties:
      keyPath:   HKCU\example\key
      valueName: Example
      valueData:
        String: This is an example.
```

The example document declares a single resource instance called `example key value`. The instance
uses the `Microsoft.Windows/Registry` resource to declare that:

- The `example\key` registry key should exist in the system's current user hive.
- The `example\key` registry key should have a value called `Example`.
- The `Example` value should be the string `This is an example`.

The example document is _declarative_. It describes the desired state, not how to put the system
into that state. It relies on the `Microsoft.Windows/Registry` resource to handle getting, testing,
and setting the state of the registry key and value.

### Defining resource instances

As shown in the prior example, configuration documents include a collection of resource instances.
Together, the instances describe a system's desired state. A configuration document can include any
number of resource instances. The instances can be of any available DSC Resource.

A resource instance declaration always includes:

- `name` - A short, human-readable name for the instance that's unique in the document. This name
  is used for logging and it helps to document an instance's purpose in the document.
- `type` - The [fully qualified type name][02] for the resource to identify the resource DSC should
  use to manage the instance.
- `properties` - The desired state for the instance. DSC validates the values against the
  resource's instance schema.

Configuration documents can't include the same instance more than once. Declaring the same instance
with different properties leads to enforcement cycling, where each declaration enforces an
incompatible state for the instance on every run.

## Getting the current state of a configuration

The `dsc config get` command retrieves the current state of the resource instances defined in a
configuration document. DSC also collects any message emitted by the resources during the operation
and indicates whether any of the resources raised an error.

```sh
cat ./example.config.dsc.yaml | dsc config get
```

```yaml
results:
- name: example key value
  type: Microsoft.Windows/Registry
  result:
    actualState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: ''
messages: []
hadErrors: false
```

## Testing a configuration

The `dsc config test` command compares the current state of the resource instances defined in a
configuration document to their desired state. The result for each instance includes:

- The desired state for the instance.
- The actual state of the instance.
- Whether the instance is in the desired state.
- The list of properties that are out of the desired state, if any.

DSC also collects any message emitted by the resources during the operation and indicates whether
any of the resources raised an error.

```sh
cat ./example.config.dsc.yaml | dsc config test
```

```yaml
results:
- name: example key value
  type: Microsoft.Windows/Registry
  result:
    desiredState:
      valueData:
        String: This is an example.
      keyPath: HKCU\example\key
      valueName: Example
    actualState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: ''
      _inDesiredState: false
    inDesiredState: false
    differingProperties:
    - valueData
    - keyPath
    - valueName
messages: []
hadErrors: false
```

## Enforcing a configuration

The `dsc config set` command enforces the resource instances defined in a configuration document to
their desired state. The result for each instance includes:

- The state of the instance before the operation.
- The state of the instance after the operation.
- Which properties the operation changed, if any.

DSC also collects any message emitted by the resources during the operation and indicates whether
any of the resources raised an error.

```sh
cat ./example.config.dsc.yaml | dsc config set
```

```yaml
results:
- name: example key value
  type: Microsoft.Windows/Registry
  result:
    beforeState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: ''
    afterState:
      $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
      keyPath: HKCU\example\key
      valueName: Example
      valueData:
        String: This is an example.
    changedProperties:
    - keyPath
    - valueName
    - valueData
messages: []
hadErrors: false
```

## See also

- [DSC Resources][01] to learn about resources.
- [DSC Configuration document schema reference][03]
- [Command line reference for the 'dsc config' command][04]

[01]: ./resources.md
[02]: ./resources.md#resource-type-names
[03]: ../reference/schemas/config/document.md
[04]: ../reference/cli/config/command.md
