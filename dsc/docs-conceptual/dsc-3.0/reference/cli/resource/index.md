---
description: Command line reference for the 'dsc resource' command
ms.date:     03/25/2025
ms.topic:    reference
title:       dsc resource
---

# dsc resource

## Synopsis

Invoke a specific DSC Resource.

## Syntax

```sh
dsc resource [Options] <COMMAND>
```

## Description

The `dsc resource` command contains subcommands for listing DSC Resources and invoking them
directly. To manage resource instances in a configuration, see the [dsc config][01] command.

## Commands

### list

The `list` command returns the list of available DSC Resources with an optional filter. For more
information, see [dsc resource list][02].

### export

The `export` command generates a configuration document that defines the current state of every
instance for a specified resource. For more information, see [dsc resource export][03].

### get

The `get` command invokes the get operation for a resource, returning the current state of a
resource instance. For more information, see [dsc resource get][04].

### set

The `set` command invokes the set operation for a resource, enforcing the desired state of a
resource instance and returning the final state. For more information, see [dsc resource set][05].

### test

The `test` command invokes the test operation for a resource, returning the expected and actual
state of an instance and an array of properties that are out of the desired state. For more
information, see [dsc resource test][06].

### schema

The `schema` command returns the JSON Schema for instances of a resource. This schema validates an
instance before any operations are sent to the resource. For more information, see
[dsc resource schema][07].

### help

The `help` command returns help information for this command or a subcommand.

To get the help for a command or subcommand, use the syntax:

```sh
dsc resource help [<SUBCOMMAND>]
```

For example, `dsc resource help` gets the help for this command. `dsc resource help list`
gets the help for the `list` subcommand.

You can also use the [--help](#--help) option on the command or subcommand to display the help
information. For example, `dsc resource --help` or `dsc resource set --help`.

## Options

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

[01]: ../config/index.md
[02]: ./list.md
[03]: ./export.md
[04]: ./get.md
[05]: ./set.md
[06]: ./test.md
[07]: ./schema.md
