---
description: Command line reference for the 'dsc resource export' command
ms.date:     07/03/2025
ms.topic:    reference
title:       dsc resource export
---

# dsc resource export

## Synopsis

Generates a configuration document that defines the existing instances of a specific resource.

## Syntax

### Without instance properties

```sh
dsc resource export [Options] --resource <RESOURCE>
```

### Instance properties from input option

```sh
dsc resource export --input <INPUT> --resource <RESOURCE>
```

### Instance properties from file

```sh
dsc resource export --file <FILE> --resource <RESOURCE>
```

### Instance properties from stdin

```sh
cat <FILE> | dsc resource get [Options] --resource <RESOURCE> --file -
```

## Description

The `export` subcommand generates a configuration document that includes every instance of a
specific resource. The resource must be specified with the `--resource` option.

Starting with DSC 3.1.0, You can use the `--input` or `--file` option to specify a resource
instance to use as a filter for the exported resources. When you do, the specified instance is
passed to the resource for use in filtering. The implementation for filtering depends on each
resource, not DSC itself.

Only specify exportable resources with a resource manifest that defines the [export][01] section in
the input configuration. If the specified resource type isn't exportable, DSC raises an error.

## Options

### -r, --resource

<a id="-r"></a>
<a id="--resource"></a>

Specifies the fully qualified type name of the DSC Resource to export, like
`Microsoft.Windows/Registry`.

The fully qualified type name syntax is: `<owner>[.<group>][.<area>]/<name>`, where:

- The `owner` is the maintaining author or organization for the resource.
- The `group` and `area` are optional name components that enable namespacing for a resource.
- The `name` identifies the component the resource manages.

```yaml
Type        : string
Mandatory   : true
LongSyntax  : --resource <RESOURCE>
ShortSyntax : -r <RESOURCE>
```

### -i, --input

<a id="-i"></a>
<a id="--input"></a>

Specifies the resource instance to use as a filter for exported resource instances.

The instance must be a string containing a JSON or YAML object. DSC validates the object against
the resource's instance schema. If the validation fails, DSC raises an error.

This option is mutually exclusive with the `--file` option.

```yaml
Type        : string
Mandatory   : false
LongSyntax  : --input <INPUT>
ShortSyntax : -i <INPUT>
```

### -f, --file

<a id="-f"></a>
<a id="--file"></a>

Defines the path to a file defining the resource instance to use as a filter for exported resource
instances.

The specified file must contain a JSON or YAML object that represents valid properties for the
resource. DSC validates the object against the resource's instance schema. If the validation fails,
or if the specified file doesn't exist, DSC raises an error.

This option is mutually exclusive with the `--input` option.

```yaml
Type        : string
Mandatory   : false
LongSyntax  : --file <FILE>
ShortSyntax : -f <FILE>
```

### -o, --output-format

<a id="-o"></a>
<a id="--output-format"></a>

The `--output-format` option controls which format DSC uses for the data the command returns. The
available formats are:

- `json` to emit the data as a [JSON Line][02].
- `pretty-json` to emit the data as JSON with newlines, indentation, and spaces for readability.
- `yaml` to emit the data as YAML.

The default output format depends on whether DSC detects that the output is being redirected or
captured as a variable:

- If the command isn't being redirected or captured, DSC displays the output as the `yaml` format
  in the console.
- If the command output is redirected or captured, DSC emits the data as the `json` format to
  stdout.

When you use this option, DSC uses the specified format regardless of whether the command is being
redirected or captured.

When the command isn't redirected or captured, the output in the console is formatted for improved
readability. When the command isn't redirected or captured, the output include terminal sequences
for formatting.

```yaml
Type        : string
Mandatory   : false
ValidValues : [json, pretty-json, yaml]
LongSyntax  : --output-format <OUTPUT_FORMAT>
ShortSyntax : -o <OUTPUT_FORMAT>
```

### -h, --help

<a id="-h"></a>
<a id="--help"></a>

Displays the help for the current command or subcommand. When you specify this option, the
application ignores all other options and arguments.

```yaml
Type        : boolean
Mandatory   : false
LongSyntax  : --help
ShortSyntax : -h
```

## Output

This command returns formatted data that defines a configuration document including every instance of
the resources declared in the input configuration. For more information, see
[DSC Configuration document schema reference][03].

For more information about the formatting of the output data, see the
[--output-format option](#--output-format).

<!-- Link reference definitions -->
[01]: ../../schemas/resource/manifest/export.md
[02]: https://jsonlines.org/
[03]: ../../schemas/config/document.md
