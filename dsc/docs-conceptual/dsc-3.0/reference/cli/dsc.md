---
description: Command line reference for the 'dsc' command
ms.date:     09/06/2023
ms.topic:    reference
title:       dsc
---

# dsc

## Synopsis

Apply configuration or invoke specific resources to manage software components.

## Syntax

```sh
dsc [Options] <COMMAND>
```

## Commands

### config

The `config` command manages a DSC Configuration document. You can use it to:

- Get the current state of the configuration.
- Test whether a configuration is in the desired state.
- Set a configuration to the desired state.

For more information, see [config][01].

### resource

The `resource` command manages a DSC Resource. You can use it to:

- List the available resources.
- Get the JSON schema for a resource's instances.
- Get the current state of a resource instance.
- Test whether a resource instance is in the desired state.
- Set a resource instance to the desired state.

For more information, see [resource][02]

### schema

The `schema` command returns the JSON schema for a specific DSC type. For more information, see
[schema][03].

### help

The `help` command returns help information for dsc, a command, or a subcommand.

To get the help for a command or subcommand, use the syntax:

```sh
dsc help <COMMAND> [<SUBCOMMAND>]
```

For example, `dsc help config` gets the help for the `config` subcommand. `dsc help config set`
gets the help for the `config set` subcommand.

You can also use the [--help](#-h---help) option on a command to display the help information. For
example, `dsc config --help` or `dsc config set --help`.

## Options

### -f, --format

The `--format` option controls the console output format for the command. If the command output is
redirected or captured as a variable, the output is always JSON.

To set the output format for a command or subcommand, specify this option before the command, like
`dsc --format pretty-json resource list`.

```yaml
Type:         String
Mandatory:    false
DefaultValue: yaml
ValidValues:  [json, pretty-json, yaml]
```

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

## Environment Variables

By default, the `dsc` command searches for command-based DSC Resource manifests in the folders
defined by the `PATH` environment variable. If the `DSC_RESOURCE_PATH` environment variable is
defined, `dsc` searches the folders in `DSC_RESOURCE_PATH` instead of `PATH`.

The `DSC_RESOURCE_PATH` environment must be an environment variable that follows the same
conventions as the `PATH` environment variable for the operating system. Separate folder paths with
a semicolon (`;`) on Windows and a colon (`:`) on other platforms.

## Exit Codes

The `dsc` command uses semantic exit codes. Each exit code represents a different result for the
execution of the command.

| Exit Code |                                                 Meaning                                                 |
| :-------: | :------------------------------------------------------------------------------------------------------ |
|    `0`    | The command executed successfully without any errors.                                                   |
|    `1`    | The command failed because it received invalid arguments.                                               |
|    `2`    | The command failed because a resource raised an error.                                                  |
|    `3`    | The command failed because a value couldn't be serialized to or deserialized from JSON.                 |
|    `4`    | The command failed because input for the command wasn't valid YAML or JSON.                             |
|    `5`    | The command failed because a resource definition or instance value was invalid against its JSON schema. |
|    `6`    | The command was cancelled by a <kbd>Ctrl</kbd>+<kbd>C</kbd> interruption.                               |

[01]: config/command.md
[02]: resource/command.md
[03]: schema/command.md
