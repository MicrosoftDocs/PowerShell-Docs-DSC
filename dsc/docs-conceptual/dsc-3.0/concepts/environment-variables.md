---
description: >-
  Learn which environment variables Microsoft DSC reads and sets, how they change resource
  discovery, tracing, and configuration behavior, and how DSC passes them to resource processes.
ms.date: 09/13/2026
ms.topic: concept-article
title: Environment variables in DSC
---

# Environment variables in DSC

Microsoft DSC uses environment variables in three ways:

- DSC reads a small set of `DSC_*` variables that change how it discovers resources, how much
  tracing output it emits, where it resolves relative paths, and whether it honors its settings
  files.
- DSC sets variables in its own process before it invokes a resource. Because resource processes
  inherit the environment of the `dsc` process, resources and adapters can read those variables
  to behave consistently with the calling command.
- DSC reads platform variables such as `ProgramData`, `HOME`, and `PSModulePath` to locate
  well-known folders on each operating system.

This article describes each variable, what it does, and how it interacts with the command-line
options and settings files.

> [!NOTE]
> Environment variable names are case-sensitive on Linux and macOS. Always use the exact name shown
> in this article.

## Variables that control DSC

The following table summarizes the variables that DSC reads.

| Variable                   | Purpose                                                        |
| -------------------------- | -------------------------------------------------------------- |
| `DSC_RESOURCE_PATH`        | Replaces the folders DSC searches for resource manifests.      |
| `DSC_RESTRICTED_PATH`      | Isolates resource discovery and execution to specific folders. |
| `DSC_TRACE_LEVEL`          | Sets the default trace level for DSC and its child processes.  |
| `DSC_CONFIG_ROOT`          | Defines the folder DSC uses to resolve relative paths.         |
| `DSC_IGNORE_SETTINGS_FILE` | Disables the DSC settings and policy files.                    |

### DSC_RESOURCE_PATH

By default, DSC discovers resources, adapters, and extensions by searching the folders listed in
the `PATH` environment variable and any folders listed in the `resourcePath.directories` setting.
When you define `DSC_RESOURCE_PATH`, DSC searches _only_ the folders in that variable instead.

The value must follow the same conventions as `PATH` on your operating system. Separate folder
paths with a semicolon (`;`) on Windows and a colon (`:`) on Linux and macOS.

```powershell
$env:DSC_RESOURCE_PATH = 'C:\dsc\resources;C:\dsc\adapters'
dsc resource list
```

```bash
DSC_RESOURCE_PATH='/opt/dsc/resources:/opt/dsc/adapters' dsc resource list
```

When `DSC_RESOURCE_PATH` is defined, DSC still adds the folder that contains the `dsc` executable
to `PATH` if it isn't already there. This ensures that resource manifests that reference
executables shipped with DSC continue to work. DSC doesn't search that folder for manifests unless
you include it in `DSC_RESOURCE_PATH`.

DSC only honors `DSC_RESOURCE_PATH` when the `resourcePath.allowEnvOverride` setting is `true`.
The default value is `true`. For more information, see
[Settings and policy files](#settings-and-policy-files).

### DSC_RESTRICTED_PATH

`DSC_RESTRICTED_PATH` is a stricter form of `DSC_RESOURCE_PATH`. When you define it, DSC:

- Searches only the folders in `DSC_RESTRICTED_PATH` for resource manifests.
- Replaces the `PATH` environment variable of the `dsc` process with the value of
  `DSC_RESTRICTED_PATH`, so resource executables are only found in those folders.
- Doesn't add the folder that contains the `dsc` executable to `PATH`.

Use this variable when you need to isolate DSC to a known set of folders, for example in a test
environment or in a locked-down deployment. Because DSC doesn't add its own folder to the search
list, you must include the folder that contains any adapter or resource executable you intend to
use, including the executables that ship with DSC.

`DSC_RESTRICTED_PATH` uses the same syntax as `PATH`. If both `DSC_RESTRICTED_PATH` and
`DSC_RESOURCE_PATH` are defined, DSC uses `DSC_RESTRICTED_PATH` and ignores `DSC_RESOURCE_PATH`.
The `resourcePath.allowEnvOverride` setting controls this variable as well.

### DSC_TRACE_LEVEL

`DSC_TRACE_LEVEL` sets the default trace level for the `dsc` command. DSC emits messages at the
specified level and above. The valid values, from least to most verbose, are:

- `error`
- `warn`
- `info`
- `debug`
- `trace`

DSC reads the value without regard to case, so `WARN` and `warn` are equivalent. If the value
isn't one of the valid levels, DSC emits a warning and uses the `warn` level.

```powershell
$env:DSC_TRACE_LEVEL = 'debug'
dsc resource list
```

The [`--trace-level`][01] option overrides `DSC_TRACE_LEVEL` for a single command. For the full
order of precedence, see [Trace level precedence](#trace-level-precedence).

After DSC determines the effective trace level, it sets `DSC_TRACE_LEVEL` in its own process to
that level in lowercase. Every resource process that DSC starts inherits the variable. The
built-in command resources and the PowerShell adapters read `DSC_TRACE_LEVEL` so that they emit
messages at the same level as the calling `dsc` command. Resource authors should follow the same
pattern.

### DSC_CONFIG_ROOT

`DSC_CONFIG_ROOT` defines the folder that DSC uses as the base for relative paths in a
configuration document. The `dsc config` subcommands set this variable automatically:

- When you specify a configuration document with the [`--file`][02] option, DSC sets
  `DSC_CONFIG_ROOT` to the absolute path of the folder that contains the document.
- When you pass the configuration document with the `--input` option or from stdin, DSC keeps the
  existing value of `DSC_CONFIG_ROOT` if the variable is already defined. Otherwise, DSC sets the
  variable to the current working directory.

If `DSC_CONFIG_ROOT` is already defined when DSC needs to set it from the `--file` option, DSC
emits a warning before it overrides the value.

DSC uses `DSC_CONFIG_ROOT` to resolve the relative path in the `configurationFile` property of the
[Microsoft.DSC/Include][03] resource. Because DSC sets the variable in its own process, resource
processes inherit it. You can also reference it from a configuration document with the
[envvar()][04] configuration function:

```yaml
$schema: https://aka.ms/dsc/schemas/v3/bundled/config/document.json
resources:
  - name: Show the configuration root folder
    type: Microsoft.DSC.Debug/Echo
    properties:
      output: "[envvar('DSC_CONFIG_ROOT')]"
```

The `dsc resource` subcommands don't set `DSC_CONFIG_ROOT`.

### DSC_IGNORE_SETTINGS_FILE

When `DSC_IGNORE_SETTINGS_FILE` is defined with any value, DSC ignores its settings files and the
policy file and uses the built-in defaults instead. DSC emits a warning to indicate that it's
ignoring the settings.

```powershell
$env:DSC_IGNORE_SETTINGS_FILE = '1'
dsc resource list
```

The `--ignore-settings-file` option has the same effect. When you use the option, DSC sets
`DSC_IGNORE_SETTINGS_FILE` to `1` in its own process, so resource processes that invoke `dsc`
also ignore the settings files.

> [!IMPORTANT]
> This variable disables the policy file as well as the user-configurable settings file. Don't rely
> on the policy file alone to enforce settings for users who can define environment variables.

## Variables that DSC passes to resources

DSC starts each command resource as a child process. The child process inherits the complete
environment of the `dsc` process, including any variable that DSC set while it was running. The
following variables are relevant to resource authors.

| Variable                   | Value in the resource process                                 |
| -------------------------- | ------------------------------------------------------------- |
| `DSC_TRACE_LEVEL`          | The effective trace level of the `dsc` command, in lowercase. |
| `DSC_CONFIG_ROOT`          | The configuration root folder for `dsc config` commands.      |
| `DSC_IGNORE_SETTINGS_FILE` | Set to `1` when the `--ignore-settings-file` option is used.  |
| `PATH`                     | The value DSC computed during discovery.                      |

DSC modifies `PATH` in its own process in two cases. When `DSC_RESTRICTED_PATH` is defined, DSC
replaces `PATH` with that value. In every other case, DSC appends the folder that contains the
`dsc` executable to `PATH` if the folder isn't already listed. Resource processes see the modified
value.

### Resource input as environment variables

A command resource can choose to receive its input as environment variables instead of JSON on
stdin. When a resource manifest sets the `input` property of a command to `env`, DSC creates one
environment variable for each property in the input object. The variable name is the property
name and the value is the property value.

DSC converts the JSON values to strings as follows:

- Strings are passed as-is.
- Booleans and numbers are converted to their string representation.
- Arrays of strings or numbers are joined with a comma (`,`).
- Properties with a `null` value are omitted.
- Nested objects and arrays containing other types aren't supported and cause an error.

For more information, see the `input` property in the [resource manifest command definitions][05].

### Refreshing environment variables during a set operation

On Windows, a resource can indicate that it changed machine or user environment variables during
a set operation. When a resource returns `_refreshEnv` with a value of `true` in the `_metadata`
of its set output, DSC rebuilds the environment of its own process from the registry before it
invokes the next resource instance. DSC reads the machine variables from
`HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment` and overlays the user
variables from `HKCU\Environment`. For `PATH`, DSC prefixes the user value to the machine value
instead of replacing it.

This behavior enables a configuration document that installs software and then invokes that
software with a later resource instance. DSC ignores `_refreshEnv` for operations other than
set and on Linux and macOS.

## Reading environment variables in a configuration document

Use the [envvar()][04] configuration function to read an environment variable of the `dsc`
process while DSC processes a configuration document. The function returns the value as a string.
If the variable isn't defined, the function raises an error and the operation fails.

```yaml
$schema: https://aka.ms/dsc/schemas/v3/bundled/config/document.json
resources:
  - name: Show the user profile folder
    type: Microsoft.DSC.Debug/Echo
    properties:
      output: "[envvar('USERPROFILE')]"
```

## Platform variables DSC uses

DSC and its adapters read the following operating system variables to locate well-known folders.
You don't normally change these variables, but they determine where DSC looks for files.

| Variable       | Platform     | Usage                                                        |
| -------------- | ------------ | ------------------------------------------------------------ |
| `PATH`         | All          | Default search list for resource manifests and executables.  |
| `ProgramData`  | Windows      | Location of the policy file in `%ProgramData%\dsc`.          |
| `LocalAppData` | Windows      | Location of the adapter cache in `%LocalAppData%\dsc`.       |
| `HOME`         | Linux, macOS | Location of the adapter cache in `~/.dsc`.                   |
| `SYSTEMDRIVE`  | Windows      | Default value of the `systemRoot()` function, such as `C:\`. |
| `PSModulePath` | All          | Module search paths for the PowerShell adapters.             |

The adapter cache is the `AdaptedResourcesLookupTable.json` file that the
[Microsoft.DSC/PowerShell][06] and [Microsoft.Windows/WindowsPowerShell][07] adapters use to
speed up discovery. For more information, see [dsc resource list][08].

On Linux and macOS, the policy file is always `/etc/dsc/dsc.settings.json`. DSC doesn't use an
environment variable to locate it.

## Settings and policy files

Several environment variables interact with the DSC settings files. DSC reads settings from the
following locations, in order. Later locations override earlier ones.

1. `dsc_default.settings.json` in the folder that contains the `dsc` executable. This file
   defines the defaults for the installed version of DSC.
1. `dsc.settings.json` in the same folder. Use this file to change settings for the installation.
1. The policy file, `%ProgramData%\dsc\dsc.settings.json` on Windows or
   `/etc/dsc/dsc.settings.json` on Linux and macOS. Settings in the policy file override the other
   files and the command-line options.

DSC only uses the policy file when the folder that contains it is protected. On Windows, only the
`SYSTEM` account and members of the Administrators group can have write access to the folder. On
Linux and macOS, only `root` can have write access. If the folder isn't protected, DSC emits a
warning and ignores the policy file.

The default settings file defines the following settings that relate to environment variables:

```json
{
  "1": {
    "resourcePath": {
      "allowEnvOverride": true,
      "appendEnvPath": true,
      "directories": []
    },
    "tracing": {
      "level": "WARN",
      "format": "Default",
      "allowOverride": true
    }
  }
}
```

- `resourcePath.allowEnvOverride` controls whether DSC honors `DSC_RESOURCE_PATH` and
  `DSC_RESTRICTED_PATH`.
- `resourcePath.appendEnvPath` controls whether DSC appends the folders in `PATH` to the folders
  listed in `resourcePath.directories` when neither environment variable is defined.
- `tracing.allowOverride` controls whether DSC honors `DSC_TRACE_LEVEL`.

## Precedence

### Resource discovery precedence

DSC determines the folders to search for resource manifests in the following order. DSC uses the
first rule that applies.

1. If `DSC_RESTRICTED_PATH` is defined and `resourcePath.allowEnvOverride` is `true`, DSC searches
   only the folders in `DSC_RESTRICTED_PATH`.
1. If `DSC_RESOURCE_PATH` is defined and `resourcePath.allowEnvOverride` is `true`, DSC searches
   only the folders in `DSC_RESOURCE_PATH`.
1. Otherwise, DSC searches the folders in `resourcePath.directories`. If
   `resourcePath.appendEnvPath` is `true`, DSC also searches the folders in `PATH`.

### Trace level precedence

DSC determines the trace level in the following order. Higher entries win.

1. The `tracing.level` value in the policy file, when the policy file defines the `tracing`
   setting. When a policy is in use, DSC ignores the `--trace-level` option.
1. The `--trace-level` command-line option.
1. The `DSC_TRACE_LEVEL` environment variable, when `tracing.allowOverride` is `true`.
1. The `tracing.level` value in the settings file.
1. The built-in default, `warn`.

> [!NOTE]
> The `tracing.allowOverride` setting also applies when the policy file defines it. If the policy
> sets `allowOverride` to `true`, `DSC_TRACE_LEVEL` can still override the policy level. Set
> `allowOverride` to `false` in the policy file to enforce a fixed trace level.

## Related content

- [dsc command reference][09]
- [dsc config command reference][10]
- [envvar() configuration function][04]
- [Microsoft.DSC/Include resource][03]
- [Configuration document metadata][11]

<!-- Link reference definitions -->
[01]: ../reference/cli/index.md#--trace-level
[02]: ../reference/cli/config/get.md#--file
[03]: ../reference/resources/Microsoft/DSC/Include/index.md
[04]: ../reference/schemas/config/functions/envvar.md
[05]: ../reference/schemas/resource/manifest/get.md
[06]: ../reference/resources/Microsoft/DSC/PowerShell/index.md
[07]: ../reference/resources/Microsoft/Windows/WindowsPowerShell/index.md
[08]: ../reference/cli/resource/list.md
[09]: ../reference/cli/index.md
[10]: ../reference/cli/config/index.md
[11]: ../reference/schemas/config/metadata.md
