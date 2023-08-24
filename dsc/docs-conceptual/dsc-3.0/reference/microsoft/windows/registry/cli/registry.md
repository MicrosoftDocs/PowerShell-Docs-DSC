---
description: Command line reference for the 'registry' command
ms.date:     08/22/2023
ms.topic:    reference
title:       registry
---

# registry

## Synopsis

Manage state of Windows registry

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

## Syntax

```sh
registry [Options] <COMMAND>
```

## Commands

### query

The `query` command isn't implemented yet. It returns a string that echoes the specified options.
For more information, see [query][01].

### set

The `set` command isn't implemented yet. It returns a string that echoes the specified options. For
more information, see [set][02].

### test

The `test` command isn't implemented yet. It returns the string `Test`. For more information, see
[test][03].

### remove

The `remove` command isn't implemented yet. It returns a string that echoes the specified options.
For more information, see [remove][04].

### find

The `find` command isn't implemented yet. It returns a string that echoes the specified options.
For more information, see [find][05].

### config

The `config` command manages registry keys and values as instances of a [DSC Resource][06]. You can
use it to:

- Get the current state of a registry key or value
- Test whether a registry key or value is in the desired state
- Set a registry key or value to the desired state.

For more information, see [config][07].

### schema

The `schema` command returns the JSON schema for an instance of the `Microsoft.Windows/Registry`
DSC Resource. For more information, see [schema][08].

### help

The `help` command returns help information for `registry`, a command, or a subcommand.

To get the help for a command or subcommand, use the syntax:

```sh
registry help <COMMAND> [<SUBCOMMAND>]
```

For example, `registry help config` gets the help for the `config` subcommand.
`registry help config set` gets the help for the `config set` subcommand.

You can also use the [--help](#-h---help) option on a command to display the help information. For
example, `registry config --help` or `registry config set --help`.

## Options

### -h, --help

Displays the help for the current command or subcommand. When you specify this option, the
application ignores all options and arguments after this one.

```yaml
Type:      Boolean
Mandatory: false
```

### -V, --version

Displays the version of the application. When you specify this option, the application ignores all
options and arguments after this one.

```yaml
Type:      Boolean
Mandatory: false
```

<!-- Link references -->
[01]: query/command.md
[02]: set/command.md
[03]: test/command.md
[04]: remove/command.md
[05]: find/command.md
[06]: ../../../../../concepts/resources.md
[07]: config/command.md
[08]: schema/command.md
