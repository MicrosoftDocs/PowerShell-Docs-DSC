---
description: >-
  DSC Resources provide a standardized interface for idempotently managing the settings of a
  system. They use a declarative syntax to define what the desired state should be.
ms.date: 08/07/2023
title: DSC Resources
---

# DSC Resources

<!-- markdownlint-disable MD013 -->

In Microsoft's Desired State Configuration (DSC) platform, DSC Resources represent a standardized
interface for managing the settings of a system. Resources can model components as generic as a
file or as specific as an IIS server setting. Resources use a declarative syntax rather than
imperative. Instead of specifying _how_ to set a system to the desired state, with DSC you specify
_what_ the desired state is. Resources handle the "how" for you.

Resources manage _instances_ of a configurable component. For example, the
`PSDscResources/Environment` resource manages environment variables. Each environment variable is a
different instance of the resource. Every resource defines a schema that describes how to validate
and manage an instance of the resource.

DSCv3 supports several kinds of resources:

- A resource defined with a resource manifest is a _command-based_ resource. DSC uses the manifest
  to determine how to invoke the resource and how to validate the resource instance properties.
- A _resource group_ is a command-based resource with a `resources` property that takes an array of
  resource instances and processes them. Resource groups may apply special handling to their nested
  resource instances, like changing the user the resources run as.
- A _resource provider_ is a resource group that enables the use of non-command-based resources
  with DSCv3. For example, the `DSC/PowerShellGroup` resource provider enables the use of DSC
  Resources implemented in PowerShell modules.

## Resource type names

Resources are identified by their fully qualified type name. The type name is used to specify a
resource in configuration documents and as the value of the `--resource` flag when using the
`dsc resource *` commands.

The fully qualified type name of a resource uses the following syntax:

```Syntax
<owner>[.<group>][.<area>]/<name>
```

Every resource must define an `owner` and a `name`. The `group` and `area` components enable
organizing resources into related namespaces, like `Microsoft.SqlServer/Database` and
`Microsoft.SqlServer.Database/Role`.

For more information about type names and how DSC validates them, see
[DSC Resource fully qualified type name schema reference][01].

## Resource properties

The properties of a resource are the settings and options a user can declare for managing an
instance. Resources always have at least one property. Resources define their properties in their
schema.

Properties are optional by default. Resources can be invoked directly or declared in a
configuration with only the properties that are relevant to the current task or purpose. You don't
need to declare every property for an instance. Properties may have default values for their
desired state.

Most properties are one of the basic types:

- String properties require the property value to be a set of characters, like `machine`.
- Integer properties require the property value to be a number without a fractional part, like `5`.
- Boolean properties require the property value to be either `true` or `false`.
- Array properties require the property value to be a list of items. Usually, array properties
  specify that the values must be of a particular type, like a list of exit code integers or a list
  of file paths.

Complex properties require the property value to be an object with defined subproperties. The
subproperties can be basic or complex, but they're usually a basic type.

## Listing resources

You can use DSC to list the available resources with the `dsc resource list` command. DSC searches
the `PATH` for command-based resources and invokes available resource providers to list their
resources.

By default, the command returns every discovered DSC Resource.

```sh
dsc resource list
```

```Output
type                       version tags                        description
----                       ------- ----                        -----------
Test/TestGroup             0.1.0
Microsoft/OSInfo           0.1.0   {os, linux, windows, macos} Returns information about the operating system.
Microsoft.Windows/Registry 0.1.0   {Windows, NT}               Registry configuration provider for the Windows Registry
                                                               This is a test resource.
DSC/PowerShellGroup        0.1.0   {PowerShell}                Resource provider to classic DSC Powershell resources.
DSC/AssertionGroup         0.1.0                               `test` will be invoked for all resources in the supplied configuration.
DSC/ParallelGroup          0.1.0                               All resources in the supplied configuration run concurrently.
                                                               This is a test resource.
DSC/Group                  0.1.0                               All resources in the supplied configuration is treated as a group.
```

You can filter the results by a resource's type name, description, and tags. For more information,
see [dsc resource list][02]

## Invoking resources

You can invoke resources directly with the `dsc resource *` commands to manage a single instance
through the three DSC operations **Get**, **Test**, and **Set**.

### Get operations

Every resource implements the **Get** operation, which retrieves the actual state of a resource
instance. Use the `dsc resource get` command to invoke the operation.

For example, you can use the `Microsoft.Windows/Registry` resource to get the actual state for a
registry key value:

```powershell
'{
    "keyPath": "HKLM\\Software\\Microsoft\\Windows NT\\CurrentVersion",
    "valueName": "SystemRoot"
}' | dsc resource get --resource Microsoft.Windows/Registry
```

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: HKLM\Software\Microsoft\Windows NT\CurrentVersion
  valueName: SystemRoot
  valueData:
    String: C:\WINDOWS
```

### Test operations

Some resources implement the **Test** operation. For resources that don't implement the **Test**
operation, DSCv3 can validate an instance's state with a synthetic test. The synthetic test is a
strict case-insensitive comparison of the desired and actual values for the instance's properties.
Only resources that have advanced or complex validation requirements need to implement the **Test**
operation themselves.

Use the `dsc resource test` command to invoke the operation. DSC returns data that includes:

- The desired state for the instance.
- The actual state of the instance.
- Whether the instance is in the desired state.
- The list of properties that aren't in the desired state.

For example, you can test whether a specific registry key exists:

```powershell
'{
    "keyPath": "HKCU\\key\\that\\does\\not\\exist",
}' | dsc resource test --resource Microsoft.Windows/Registry
```

```yaml
desiredState:
  keyPath: HKCU\key\that\does\not\exist
actualState:
  $id: https://developer.microsoft.com/json-schemas/windows/registry/20230303/Microsoft.Windows.Registry.schema.json
  keyPath: ''
  _inDesiredState: false
inDesiredState: false
differingProperties:
- keyPath
```

### Set operations

<!-- vale Microsoft.Adverbs = NO -->

Most resources implement the **Set** operation, which enforces the desired state for an
instance. When used with DSCv3, the **Set** operation is _idempotent_, which means that the
resource only invokes the operation when an instance isn't in the desired state. Because the
operation is idempotent, invoking it repeatedly is the same as invoking it once. The idempotent
model prevents side effects from unnecessarily executing code.

<!-- vale Microsoft.Adverbs = YES -->

Resources that don't implement the **Set** operation are _assertion_ resources. You can use
assertion resources to retrieve and validate the state of an instance, but you can't use them to
enforce a desired state.

Use the `dsc resource set` command to invoke the operation. DSC returns data that includes:

- The state of the instance before the operation.
- The state of the instance after the operation.
- The list of properties the operation changed.

For example, you can create a registry key by setting the desired state for a key that doesn't
exist.

```powershell
'{
    "keyPath":   "HKCU\\example\\key",
    "valueName": "Example",
    "valueData": { "String": "This is an example." }
}' | dsc resource set --resource Microsoft.Windows/Registry
```

```yaml
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
```

## Declaring resource instances

DSC Configuration documents enable managing more than one resource or resource instance at a time.
Configuration documents declare a collection of resource instances and their desired state. This
makes it possible to model complex desired states by composing different resources and instances
together, like defining a security baseline for compliance or the settings for a web farm.

A resource instance declaration always includes:

- `name` - A short, human-readable name for the instance that's unique in the document. This name
  is used for logging and it helps to document an instance's purpose in the document.
- `type` - The fully qualified type name for the resource to identify the resource DSC should use
  to manage the instance.
- `properties` - The desired state for the instance. DSC validates the values against the
  resource's instance schema.

This example configuration document snippet declares an instance of the
`Microsoft.Windows/Registry` resource.

```yaml
$schema: https://schemas.microsoft.com/dsc/2023/08/configuration.schema.json
resources:
  - name: example key value
    type: Microsoft.Windows/Registry
    properties:
      keyPath: HKCU\example\key
      valueName: Example
      valueData:
        String: This is an example.
```

## See also

- [Anatomy of a command-based DSC Resource][03] to learn about authoring resources in your language
  of choice.
- [Configuration Documents][04] to learn about using resources in a configuration document.
- [Command line reference for the 'dsc resource' command][05]

[01]: ../reference/schemas/definitions/resourceType.md
[02]: ../reference/cli/resource/list.md
[03]: ../resources/concepts/anatomy.md
[04]: configurations.md
[05]: ../reference/cli/resource/command.md
