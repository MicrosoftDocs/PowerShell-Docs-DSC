---
description: >-
  Create a class-based DSC Resource for use with Azure Automanage's machine configuration feature
ms.topic: tutorial
ms.date: 03/08/2023
ms.custom: template-tutorial
title: Create a class-based DSC Resource for Machine Configuration
---

# Tutorial: Create a class-based DSC Resource for machine configuration

Get started authoring a class-based DSC Resource to manage a configuration file with
[Azure Automanage's machine configuration feature][01]. Completing this tutorial gives you a
machine-configuration compatible class-based DSC Resource in a module you can use for further
learning and customization.

In this tutorial, you learn how to:

> [!div class="checklist"]
>
> - Scaffold a DSC Resource module
> - Add a class-based DSC Resource
> - Define DSC Resource properties
> - Implement the DSC Resource methods
> - Export a DSC Resource in a module manifest
> - Manually test a DSC Resource

> [!NOTE]
> The example output in this tutorial matches PowerShell 7.2 on a Windows computer. The tutorial is
> valid with Windows PowerShell and with PowerShell on a Linux or macOS computer. Only the output is
> specific to running the commands in PowerShell on a Windows computer.

## Prerequisites

- PowerShell or Windows PowerShell 5.1
- VS Code with the PowerShell extension

## 1 - Scaffold a DSC Resource module

DSC Resources must be defined in a PowerShell module.

### Create the module folder

Create a new folder called `ExampleResources`. This folder is used as the root folder for the
module and all code in this tutorial.

```powershell
New-Item -Path './ExampleResources' -ItemType Directory
```

```Output
    Directory: C:\code\dsc

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            9/8/2022 12:54 PM                ExampleResources
```

### Use VS Code to author the module

Open the `ExampleResources` folder in VS Code. Open the integrated terminal in VS Code. Make sure
your terminal is running PowerShell or Windows PowerShell.

> [!IMPORTANT]
> For the rest of this tutorial, run the specified commands in the integrated terminal at the root
> of the module folder. This is the default working directory in VS Code.

### Create the module files

Create the module manifest with the `New-ModuleManifest` cmdlet. Use `./ExampleResources.psd1` as
the **Path**. Specify **RootModule** as `ExampleResources.psm1` and **DscResourcesToExport** as
`Tailspin`.

```powershell
$ModuleSettings = @{
    RootModule           = 'ExampleResources.psm1'
    DscResourcesToExport = 'Tailspin'
}

New-ModuleManifest -Path ./ExampleResources.psd1 @ModuleSettings
Get-Module -ListAvailable -Name ./ExampleResources.psd1 | Format-List
```

```Output
Name              : ExampleResources
Path              : C:\code\dsc\ExampleResources\ExampleResources.psd1
Description       :
ModuleType        : Script
Version           : 0.0.1
PreRelease        :
NestedModules     : {}
ExportedFunctions :
ExportedCmdlets   :
ExportedVariables :
ExportedAliases   :
```

Create the root module file as `ExampleResources.psm1`.

```powershell
New-Item -Path ./ExampleResources.psm1
```

```Output
    Directory: C:\code\dsc\ExampleResources

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            9/8/2022  1:57 PM              0 ExampleResources.psm1
```

Create a script file called `Helpers.ps1`.

```powershell
New-Item -Path ./Helpers.ps1
```

```Output
    Directory: C:\code\dsc\ExampleResources

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            9/8/2022  1:58 PM              0 Helpers.ps1
```

Open `Helpers.ps1` in VS Code. Add the following line.

```powershell
$env:PSModulePath += "$([System.IO.Path]::PathSeparator)$pwd"
```

Open `ExampleResources.psm1` in VS Code. The module is now scaffolded and ready for you to author a
DSC Resource.

## 2 - Add a class-based DSC Resource

To define a class-based DSC Resource, we write a PowerShell class in a module file and add the
**DscResource** attribute to it.

### Define the class

In `ExampleResources.psm1`, add the following code:

```powershell
[DscResource()]
class Tailspin {

}
```

This code adds `Tailspin` as a class-based DSC Resource to the **ExampleResources** module.

Hover on `[DscResource()]` and read the warnings.

:::image type="complex" source="media/create-class-based-resource/Empty-Class-Warnings.png" alt-text="Screenshot of the DSCResource attribute's warnings in VS Code.":::
Hovering on the DSCResource attribute displays four warnings. 1. The DSC Resource 'Tailspin' is missing a `Set()` method that returns `[void]` and accepts no parameters. 2. The DSC Resource 'Tailspin' is missing a `Get()` method that returns `[Tailspin]` and accepts no parameters. 3. The DSC Resource 'Tailspin' is missing a `Test()` method that returns `[bool]` and accepts no parameters. 4. The DSC Resource 'Tailspin' must have at least one key property (using the syntax `[DscProperty(Key)]`.)
:::image-end:::

These warnings list the requirements for the class to be valid DSC Resource.

### Minimally implement required methods

Add a minimal implementation of the `Get()`, `Test()`, and `Set()` methods to the class.

```powershell
class Tailspin {
    [Tailspin] Get() {
        $CurrentState = [Tailspin]::new()
        return $CurrentState
    }

    [bool] Test() {
        return $true
    }

    [void] Set() {}
}
```

With the methods added, the **DscResource** attribute only warns about the class not having a
**Key** property.

## 3 - Define DSC Resource properties

You should define the properties of the DSC Resource before the methods. The properties define the
manageable settings for the DSC Resource. They're used in the methods.

### Understand the TSToy application

Before you can define the properties of your DSC Resource, you need to understand what settings you
want to manage.

For this tutorial, we're defining a DSC Resource for managing the settings of the fictional TSToy
application through its configuration file. TSToy is an application that has configuration at the
user and machine levels. The DSC Resource should be able to configure either file.

The DSC Resource should enable users to define:

- The scope of the configuration they're managing, either `Machine` or `User`
- Whether the configuration file should exist
- Whether TSToy should update automatically
- How frequently TSToy should check for updates, between 1 and 90 days

### Add the ConfigurationScope property

To manage the `Machine` or `User` configuration file, you need to define a property of the DSC
Resource. To define the `$ConfigurationScope` property in the resource, add the following code in
the class before the methods:

```powershell
[DscProperty(Key)] [TailspinScope]
$ConfigurationScope
```

This code defines `$ConfigurationScope` as a **Key** property of the DSC Resource. A **Key**
property is used to uniquely identify an instance of the DSC Resource. Adding this property meets
one of the requirements the **DscResource** attribute warned about when you scaffolded the class.

It also specifies that `$ConfigurationScope`'s type is **TailspinScope**. To define the
**TailspinScope** type, add the following **TailspinScope** enum after the class definition in
`ExampleResources.psm1`:

```powershell
enum TailspinScope {
    Machine
    User
}
```

This enumeration makes `Machine` and `User` the only valid values for the `$ConfigurationScope`
property of the DSC Resource.

### Add the Ensure property

It's best practice to define an `$Ensure` property to control whether an instance of a DSC Resource
exists. An `$Ensure` property usually has two valid values, `Absent` and `Present`.

- If `$Ensure` is specified as `Present`, the DSC Resource creates the item if it doesn't exist.
- If `$Ensure` is `Absent`, the DSC Resource deletes the item if it exists.

For the **Tailspin** DSC Resource, the item to create or delete is the configuration file for the
specified `$ConfigurationScope`.

Define **TailspinEnsure** as an enum after **TailspinScope**. It should have the values `Absent` and
`Present`.

```powershell
enum TailspinEnsure {
    Absent
    Present
}
```

Next, add the `$Ensure` property in the class after the `$ConfigurationScope` property. It should
have an empty **DscProperty** attribute and its type should be **TailspinEnsure**. It should default
to `Present`.

```powershell
[DscProperty()] [TailspinEnsure]
$Ensure = [TailspinEnsure]::Present
```

### Add the UpdateAutomatically property

To manage automatic updates, define the `$UpdateAutomatically` property in the class after the
`$Ensure` property. Its **DscProperty** attribute should indicate that it's mandatory and its type
should be **boolean**.

```powershell
[DscProperty(Mandatory)] [bool]
$UpdateAutomatically
```

### Add the UpdateFrequency property

To manage how often TSToy should check for updates, add the `$UpdateFrequency` property in the
class after the `$UpdateAutomatically` property. It should have an empty **DscProperty** attribute
and its type should be **int**. Use the **ValidateRange** attribute to limit the valid values for
`$UpdateFrequency` to between 1 and 90.

```powershell
[DscProperty()] [int] [ValidateRange(1, 90)]
$UpdateFrequency
```

### Add the Reasons property

Because this DSC Resource is intended for use with Azure Automanage's machine configuration
feature, it must have **Reasons** property that meets the following requirements:

- It must be declared with the **NotConfigurable** property on the **DscProperty** attribute.
- It must be an array of objects that have a **String** property named **Code**, a **String**
  property named **Phrase**, and no other properties.

Machine configuration uses the **Reasons** property to standardize how compliance information is
presented. Each object returned by the `Get()` method for the **Reasons** property identifies how
and why an instance of the DSC Resource isn't compliant.

Machine configuration uses the **Reasons** property to standardize how compliance information is
presented. Each object returned by the `Get()` method for the **Reasons** property identifies one
of the DSC Resource's properties, its desired state, and its actual state.

To define the **Reasons** property, you need to define a class for it. Define the
**ExampleResourcesReason** class after the **TailspinEnsure** enum. It should have the **Code** and
**Phrase** properties as strings. Both properties should have the **DscProperty** attribute.

To make the reasons display more readably during manual testing, define the `ToString()` method on
the **ExampleResourcesReason** class as shown in the code snippet.

```powershell
class ExampleResourcesReason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase

    [string] ToString() {
        return "`n$($this.Code):`n`t$($this.Phrase)`n"
    }
}
```

Next, add the `$Reasons` property in the DSC Resource's class after the `$UpdateFrequency`
property. It should have the **DscProperty** attribute specified with the `NotConfigurable` option
and its type should be **ExampleResourcesReason[]**.

```powershell
[DscProperty(NotConfigurable)] [ExampleResourcesReason[]]
$Reasons
```

### Add hidden cache properties

Next, add two hidden properties for caching the current state of the resource: `$CachedCurrentState`
and `$CachedData`. Set the type of `$CachedCurrentState` to **Tailspin**, the same as the class and
the return type for the `Get()` method. Set they type of `$CachedData` to **PSCustomObject**. Prefix
both properties with the `hidden` keyword. Don't specify the **DscProperty** attribute for either.

```powershell
hidden [Tailspin] $CachedCurrentState
hidden [PSCustomObject] $CachedData
```

These hidden properties are used in the `Get()` and `Set()` methods that you define later.

### Review the module file

At this point, `ExampleResources.psm1` should define:

- The **Tailspin** class with the properties `$ConfigurationScope`, `$Ensure`,
  `$UpdateAutomatically`, and `$UpdateFrequency`
- The **TailspinScope** enum with the values `Machine` and `User`
- The **TailspinEnsure** enum with the values `Present` and `Absent`
- The minimal implementations of the `Get()`, `Test()`, and `Set()` methods.

```powershell
[DscResource()]
class Tailspin {
    [DscProperty(Key)] [TailspinScope]
    $ConfigurationScope

    [DscProperty()] [TailspinEnsure]
    $Ensure = [TailspinEnsure]::Present

    [DscProperty(Mandatory)] [bool]
    $UpdateAutomatically

    [DscProperty()] [int] [ValidateRange(1,90)]
    $UpdateFrequency

    [DscProperty(NotConfigurable)] [ExampleResourcesReason[]]
    $Reasons

    hidden [Tailspin] $CachedCurrentState
    hidden [PSCustomObject] $CachedData

    [Tailspin] Get() {
        $CurrentState = [Tailspin]::new()
        return $CurrentState
    }

    [bool] Test() {
        $InDesiredState = $true
        return $InDesiredState
    }

    [void] Set() {}
}

enum TailspinScope {
    Machine
    User
}

enum TailspinEnsure {
    Absent
    Present
}

class ExampleResourcesReason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase

    [string] ToString() {
        return "`n$($this.Code):`n`t$($this.Phrase)`n"
    }
}
```

Now that the DSC Resource meets the requirements, you can use `Get-DscResource` to see it. In VS
Code, open a new PowerShell terminal.

```powershell
. ./Helpers.ps1
Get-DscResource -Name Tailspin -Module ExampleResources | Format-List
Get-DscResource -Name Tailspin -Module ExampleResources -Syntax
```

```Output
ImplementationDetail : ClassBased
ResourceType         : Tailspin
Name                 : Tailspin
FriendlyName         :
Module               : ExampleResources
ModuleName           : ExampleResources
Version              : 0.0.1
Path                 : C:\code\dsc\ExampleResources\ExampleResources.psd1
ParentPath           : C:\code\dsc\ExampleResources
ImplementedAs        : PowerShell
CompanyName          : Unknown
Properties           : {ConfigurationScope, UpdateAutomatically, DependsOn, Ensure…}

Tailspin [String] #ResourceName
{
    ConfigurationScope = [string]{ Machine | User }
    UpdateAutomatically = [bool]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [PsDscRunAsCredential = [PSCredential]]
    [UpdateFrequency = [Int32]]
}
```

## 4 - Implement the DSC Resource methods

The methods of the DSC Resource define how to retrieve the current state of a DSC Resource, validate
it against the desired state, and enforce the desired state.

### The Get method

The `Get()` method retrieves the current state of the DSC Resource. It's used to inspect a DSC
Resource manually and is called by the `Test()` method.

The `Get()` method has no parameters and returns an instance of the class as its output. For the
`Tailspin` DSC Resource, the minimal implementation looks like this:

```powershell
[Tailspin] Get() {
    $CurrentState = [Tailspin]::new()
    return $CurrentState
}
```

The only thing this implementation does is create an instance of the **Tailspin** class and return
it. You can call the method with `Invoke-DscResource` to see this behavior.

```powershell
Invoke-DscResource -Name Tailspin -Module ExampleResources -Method Get -Property @{
    ConfigurationScope  = 'User'
    UpdateAutomatically = $true
}
```

```Output
ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
           Machine Present               False               0
```

The returned object's properties are all set to their default value. The value of
`$ConfigurationScope` should always be the value the user supplied. To make the `Get()` method
useful, it must return the actual state of the DSC Resource.

```powershell
[Tailspin] Get() {
    $CurrentState = [Tailspin]::new()

    $CurrentState.ConfigurationScope = $this.ConfigurationScope

    $this.CachedCurrentState = $CurrentState

    return $CurrentState
}
```

The `$this` variable references the working instance of the DSC Resource. Now, if you use
`Invoke-DscResource` again, `$ConfigurationScope` has the correct value.

```powershell
Invoke-DscResource -Name Tailspin -Module ExampleResources -Method Get -Property @{
    ConfigurationScope  = 'User'
    UpdateAutomatically = $true
}
```

```Output
ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
              User Present               False               0
```

Next, the DSC Resource needs to determine whether the configuration file exists. If it does,
`$Ensure` should be `Present`. If it doesn't, `$Ensure` should be `Absent`.

The location of TSToy's configuration files depends on the operating system and configuration scope:

- For Windows machines:
  - The `Machine` configuration file is `%PROGRAMDATA%\TailSpinToys\tstoy\tstoy.config.json`
  - The `User` configuration file is `%APPDATA%\TailSpinToys\tstoy\tstoy.config.json`
- For Linux machines:
  - The `Machine` configuration file is `/etc/xdg/TailSpinToys/tstoy/tstoy.config.json`
  - The `User` configuration file is `~/.config/TailSpinToys/tstoy/tstoy.config.json`
- For macOS machines:
  - The `Machine` configuration file is `/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json`
  - The `User` configuration file is `~/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json`

To handle these paths, you need to create a helper method, `GetConfigurationFile()`.

```powershell
[string] GetConfigurationFile() {
    $FilePaths = @{
        Linux = @{
            Machine   = '/etc/xdg/TailSpinToys/tstoy/tstoy.config.json'
            User      = '~/.config/TailSpinToys/tstoy/tstoy.config.json'
        }
        MacOS = @{
            Machine   = '/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json'
            User      = '~/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json'
        }
        Windows = @{
            Machine = "$env:ProgramData\TailSpinToys\tstoy\tstoy.config.json"
            User    = "$env:APPDATA\TailSpinToys\tstoy\tstoy.config.json"
        }
    }

    $Scope = $this.ConfigurationScope.ToString()

    if ($Global:PSVersionTable.PSVersion.Major -lt 6 -or $Global:IsWindows) {
        return $FilePaths.Windows.$Scope
    } elseif ($Global:IsLinux) {
        return $FilePaths.Linux.$Scope
    } else {
        return $FilePaths.MacOS.$Scope
    }
}
```

To test this new method, execute the `using` statement to load the **ExampleResources** module's
classes and enums into your current session.

```powershell
using module ./ExampleResources.psd1
$Example = [Tailspin]::new()
$Example
$Example.GetConfigurationFile()
$Example.ConfigurationScope = 'User'
$Example.GetConfigurationFile()
```

```Output
Ensure  ConfigurationScope UpdateAutomatically UpdateFrequency
------- ------------------ ------------------- ---------------
Present            Machine               False               0

C:\ProgramData\TailSpinToys\tstoy\tstoy.config.json

C:\Users\mikey\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json
```

Open `Helpers.ps1` in VS Code. Copy and paste the paths for the configuration files into the script,
assigning them to `$TSToyMachinePath` and `$TSToyUserPath`. The file should look like this:

```powershell
$env:PSModulePath += "<separator>$pwd"
$TSToyMachinePath = '<machine configuration file path>'
$TSToyUserPath = '<user configuration file path>'
```

Exit the terminal in VS Code and open a new terminal. Dot-source `Helpers.ps1`.

```powershell
. ./Helpers.ps1
```

Now you can write the rest of the `Get()` method.

```powershell
[Tailspin] Get() {
    $CurrentState = [Tailspin]::new()

    $CurrentState.ConfigurationScope = $this.ConfigurationScope

    $FilePath = $this.GetConfigurationFile()

    if (!(Test-Path -Path $FilePath)) {
        $CurrentState.Ensure = [TailspinEnsure]::Absent

        $this.CachedCurrentState = $CurrentState

        return $CurrentState
    }

    $Data = Get-Content -Raw -Path $FilePath |
        ConvertFrom-Json -ErrorAction Stop

    $this.CachedData = $Data

    if ($null -ne $Data.Updates.Automatic) {
        $CurrentState.UpdateAutomatically = $Data.Updates.Automatic
    }

    if ($null -ne $Data.Updates.CheckFrequency) {
        $CurrentState.UpdateFrequency = $Data.Updates.CheckFrequency
    }

    $this.CachedCurrentState = $CurrentState

    return $CurrentState
}
```

After setting the `$ConfigurationScope` and determining the configuration file's path, the method
checks to see if the file exists. If it doesn't exist, setting `$Ensure` to `Absent` and returning
the result is all that's needed.

If the file does exist, the method needs to convert the contents from JSON to create the current
state of the configuration. Next, the method checks to see if the keys have any value before
assigning them to the current state's properties. If they're not specified, the DSC Resource must
consider them unset and in their default state.

At this point, the DSC Resource caches the data. Caching the data allows you to inspect the data
during development and is useful when implementing the `Set()` method.

You can verify this behavior locally.

```powershell
$GetParameters = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Method   = 'Get'
    Property = @{
        ConfigurationScope = 'User'
    }
}

Invoke-DscResource @GetParameters
New-Item -Path $TSToyUserPath -Force
Invoke-DscResource @GetParameters
```

```Output
ConfigurationScope Ensure UpdateAutomatically UpdateFrequency
------------------ ------ ------------------- ---------------
              User Absent               False               0

    Directory: C:\Users\mikey\AppData\Roaming\TailSpinToys\tstoy

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           9/15/2022  3:43 PM              0 tstoy.config.json

ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
              User Present               False               0
```

Open the `User` scope configuration file in VS Code.

```powershell
code $TSToyUserPath
```

Copy this JSON configuration into the file and save it.

```json
{
    "unmanaged_key": true,
    "updates": {
        "automatic": true,
        "checkFrequency": 30
    }
}
```

Call `Invoke-DscResource` again and see the values reflected in the results.

```powershell
Invoke-DscResource @GetParameters
```

```Output
ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
              User Present                True              30
```

The `Get()` method now returns accurate information about the current state of the DSC Resource.

### Handling Reasons

For Machine Configuration compatible DSC Resources, the `Get()` method also needs to populate the
**Reasons** property. For this purpose, create the `GetReasons()` method. It should return an array
of **ExampleResourcesReason** objects and take a single **Tailspin** object as input.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    return $DefinedReasons
}
```

Next, the method needs to check the validity of each configurable setting. For every setting, the
method needs to return an **ExampleResourcesReason** identifying and describing the state.

The first setting to verify is the `$Ensure` property. If `$Ensure` is out of state, all other
properties will be incorrect since the configuration file exists when it shouldn't or doesn't exist
when it should.

The method needs to define a reason with the correct code and a sensible phrase. The code is always
in the format `<ResourceName>.<ResourceName>.<PropertyName>`. The **Phrase** is always a sentence
describing the check, followed by sentences describing the expected state and actual state.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    $FilePath = $this.GetConfigurationFile()

    if ($this.Ensure -eq [TailspinEnsure]::Present) {
        $Expected = "Expected configuration file to exist at '$FilePath'."
    } else {
        $Expected = "Expected configuration file not to exist at '$FilePath'."
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
        $Actual = "The configuration file exists at '$FilePath'."
    } else {
        $Actual = "The configuration file was not found at '$FilePath'."
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.Ensure"
        Phrase = @(
            "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
            $Expected
            $Actual
        ) -join "`n`t"
    }

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $DefinedReasons
    }

    return $DefinedReasons
}
```

If `$Ensure` isn't out of state, the method should check if the desired state is `Absent`. If it is,
there's no other properties that can be out of state because the configuration file doesn't exist
and shouldn't exist.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    $FilePath = $this.GetConfigurationFile()

    if ($this.Ensure -eq [TailspinEnsure]::Present) {
        $Expected = "Expected configuration file to exist at '$FilePath'."
    } else {
        $Expected = "Expected configuration file not to exist at '$FilePath'."
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
        $Actual = "The configuration file exists at '$FilePath'."
    } else {
        $Actual = "The configuration file was not found at '$FilePath'."
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.Ensure"
        Phrase = @(
            "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
            $Expected
            $Actual
        ) -join "`n`t"
    }

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $DefinedReasons
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $DefinedReasons
    }

    return $DefinedReasons
}
```

If `$Ensure` is `Present` and the file exists, the method needs to check the remaining configurable
properties.

Checking the `$UpdateAutomatically` property is straightforward, since it's a mandatory and boolean
value.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    $FilePath = $this.GetConfigurationFile()

    if ($this.Ensure -eq [TailspinEnsure]::Present) {
        $Expected = "Expected configuration file to exist at '$FilePath'."
    } else {
        $Expected = "Expected configuration file not to exist at '$FilePath'."
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
        $Actual = "The configuration file exists at '$FilePath'."
    } else {
        $Actual = "The configuration file was not found at '$FilePath'."
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.Ensure"
        Phrase = @(
            "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
            $Expected
            $Actual
        ) -join "`n`t"
    }

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $DefinedReasons
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $DefinedReasons
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.UpdateAutomatically"
        Phrase = (@(
                "Checked value of the 'updates.automatic' key in the TSToy configuration file."
                "Expected boolean value of '$($this.UpdateAutomatically)'"
                "Actual boolean value of '$($CurrentState.UpdateAutomatically)'"
            ) -join "`n`t")
    }

    return $DefinedReasons
}
```

The last property to check is `$UpdateFrequency`. This check can be short-circuited if the value of
the property is `0`. If the property is specified it will always be between 1 and 90, meaning a
value of `0` indicates the property isn't being managed.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    $FilePath = $this.GetConfigurationFile()

    if ($this.Ensure -eq [TailspinEnsure]::Present) {
        $Expected = "Expected configuration file to exist at '$FilePath'."
    } else {
        $Expected = "Expected configuration file not to exist at '$FilePath'."
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
        $Actual = "The configuration file exists at '$FilePath'."
    } else {
        $Actual = "The configuration file was not found at '$FilePath'."
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.Ensure"
        Phrase = @(
            "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
            $Expected
            $Actual
        ) -join "`n`t"
    }

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $DefinedReasons
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $DefinedReasons
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.UpdateAutomatically"
        Phrase = (@(
                "Checked value of the 'updates.automatic' key in the TSToy configuration file."
                "Expected boolean value of '$($this.UpdateAutomatically)'"
                "Actual boolean value of '$($CurrentState.UpdateAutomatically)'"
            ) -join "`n`t")
    }

    return $DefinedReasons

    # Short-circuit the check; UpdateFrequency isn't defined by caller
    if ($this.UpdateFrequency -eq 0) {
        return $DefinedReasons
    }
}
```

Finally, the method needs to compare the desired and current states of the `$UpdateFrequency`
property and define a reason if they're out of state.

```powershell
[ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
    [ExampleResourcesReason[]]$DefinedReasons = @()

    $FilePath = $this.GetConfigurationFile()

    if ($this.Ensure -eq [TailspinEnsure]::Present) {
        $Expected = "Expected configuration file to exist at '$FilePath'."
    } else {
        $Expected = "Expected configuration file not to exist at '$FilePath'."
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
        $Actual = "The configuration file exists at '$FilePath'."
    } else {
        $Actual = "The configuration file was not found at '$FilePath'."
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.Ensure"
        Phrase = @(
            "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
            $Expected
            $Actual
        ) -join "`n`t"
    }

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $DefinedReasons
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $DefinedReasons
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.UpdateAutomatically"
        Phrase = (@(
                "Checked value of the 'updates.automatic' key in the TSToy configuration file."
                "Expected boolean value of '$($this.UpdateAutomatically)'"
                "Actual boolean value of '$($CurrentState.UpdateAutomatically)'"
            ) -join "`n`t")
    }

    # Short-circuit the check; UpdateFrequency isn't defined by caller
    if ($this.UpdateFrequency -eq 0) {
        return $DefinedReasons
    }

    $DefinedReasons += [ExampleResourcesReason]@{
        Code   = "Tailspin.Tailspin.UpdateFrequency"
        Phrase = (@(
                "Checked value of the 'updates.checkFrequency' key in the TSToy configuration file."
                "Expected integer value of '$($this.UpdateFrequency)'."
                "Actual integer value of '$($CurrentState.UpdateFrequency)'."
            ) -join "`n`t")
    }

    return $DefinedReasons
}
```

With the `GetReasons()` method implemented, the `Get()` method needs to be updated to call it before
returning the current state.

```powershell
[Tailspin] Get() {
    $CurrentState = [Tailspin]::new()

    $CurrentState.ConfigurationScope = $this.ConfigurationScope

    $FilePath = $this.GetConfigurationFile()

    if (!(Test-Path -Path $FilePath)) {
        $CurrentState.Ensure = [TailspinEnsure]::Absent
        $CurrentState.Reasons = $this.GetReasons($CurrentState)

        $this.CachedCurrentState = $CurrentState

        return $CurrentState
    }

    $Data = Get-Content -Raw -Path $FilePath |
    ConvertFrom-Json -ErrorAction Stop

    $this.CachedData = $Data

    if ($null -ne $Data.Updates.Automatic) {
        $CurrentState.UpdateAutomatically = $Data.Updates.Automatic
    }

    if ($null -ne $Data.Updates.CheckFrequency) {
        $CurrentState.UpdateFrequency = $Data.Updates.CheckFrequency
    }

    $CurrentState.Reasons = $this.GetReasons($CurrentState)

    $this.CachedCurrentState = $CurrentState

    return $CurrentState
}
```

With the implementation updated, you can verify the behavior and see that the reasons are reported:

```powershell
$SharedParameters = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        Ensure              = 'Present'
        UpdateAutomatically = $false
    }
}

Invoke-DscResource -Method Get @SharedParameters

$SharedParameters.Property.UpdateAutomatically = $true
Invoke-DscResource -Method Get @SharedParameters

$SharedParameters.Property.UpdateFrequency = 1
Invoke-DscResource -Method Get @SharedParameters
```

```output
ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 1
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'False'
                        Actual boolean value of 'True'
                      }

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 1
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      }

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 1
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      ,
                      Tailspin.Tailspin.UpdateFrequency:
                        Checked value of the 'updates.checkFrequency' key in
                      the TSToy configuration file.
                        Expected integer value of '1'.
                        Actual integer value of '1'.
                      }
```

### The Test method

With the `Get()` method implemented, you can verify whether the current state is compliant with the
desired state.

The `Test()` methods minimal implementation always returns `$true`.

```powershell
[bool] Test() {
    return $true
}
```

You can verify that by running `Invoke-DscResource`.

```powershell
$SharedParameters = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope = 'User'
        UpdateAutomatically = $false
    }
}

Invoke-DscResource -Method Get @SharedParameters
Invoke-DscResource -Method Test @SharedParameters
```

```Output
ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
              User Present                True              30

InDesiredState
--------------
          True
```

You need to make the `Test()` method accurately reflect whether the DSC Resource is in the desired
state. The `Test()` method should always call the `Get()` method to have the current state to
compare against the desired state. Then check is whether the `$Ensure` property is correct. If it
isn't, return `$false` immediately. No further checks are required if the `$Ensure` property is out
of the desired state.

```powershell
[bool] Test() {
    $CurrentState = $this.Get()

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $false
    }

    return $true
}
```

Now you can verify the updated behavior.

```powershell
$TestParameters = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        UpdateAutomatically = $false
        Ensure              = 'Absent'
    }
}

Invoke-DscResource -Method Test @TestParameters

$TestParameters.Property.Ensure = 'Present'

Invoke-DscResource -Method Test @TestParameters
```

```Output
InDesiredState
--------------
         False

InDesiredState
--------------
          True
```

Next, check to see if the value of `$Ensure` is `Absent`. If the configuration file doesn't exist
and shouldn't exist, there's no reason to check the remaining properties.

```powershell
[bool] Test() {
    $CurrentState = $this.Get()

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $false
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $true
    }

    return $true
}
```

Next, the method needs to compare the current state of the properties that manage TSToy's update
behavior. First, check to see if the `$UpdateAutomatically` property is in the correct state. If it
isn't, return `$false`.

```powershell
[bool] Test() {
    $CurrentState = $this.Get()

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $false
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $true
    }

    if ($CurrentState.UpdateAutomatically -ne $this.UpdateAutomatically) {
        return $false
    }

    return $true
}
```

To compare `$UpdateFrequency`, we need to determine if the user specified the value. Because
`$UpdateFrequency` is initialized to `0` and the property's **ValidateRange** attribute specifies
that it must be between `1` and `90`, we know that a value of `0` indicates that the property wasn't
specified.

With that information, the `Test()` method should:

1. Return `$true` if the user didn't specify `$UpdateFrequency`
1. Return `$false` if the user did specify `$UpdateFrequency` and the value of the system doesn't
   equal the user-specified value
1. Return `$true` if neither of the prior conditions were met

```powershell
[bool] Test() {
    $CurrentState = $this.Get()

    if ($CurrentState.Ensure -ne $this.Ensure) {
        return $false
    }

    if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
        return $true
    }

    if ($CurrentState.UpdateAutomatically -ne $this.UpdateAutomatically) {
        return $false
    }

    if ($this.UpdateFrequency -eq 0) {
        return $true
    }

    if ($CurrentState.UpdateFrequency -ne $this.UpdateFrequency) {
        return $false
    }

    return $true
}
```

Now the `Test()` method uses the following order of operations:

1. Retrieve the current state of TSToy's configuration.
1. Return `$false` if the configuration exists when it should not or does not exist when it should.
1. Return `$true` if the configuration does not exist and should not exist.
1. Return `$false` if the configuration's automatic update setting doesn't match the desired one.
1. Return `$true` if the user didn't specify a value for the update frequency setting.
1. Return `$false` if the user's specified value for the update frequency setting doesn't match the
  configuration's setting.
1. Return `$true` if none of the prior conditions were met.

You can verify the `Test()` method locally:

```powershell
$SharedParameters = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        Ensure              = 'Present'
        UpdateAutomatically = $false
    }
}

Invoke-DscResource -Method Get @SharedParameters

Invoke-DscResource -Method Test @SharedParameters

$SharedParameters.Property.UpdateAutomatically = $true
Invoke-DscResource -Method Test @SharedParameters

$SharedParameters.Property.UpdateFrequency = 1
Invoke-DscResource -Method Test @SharedParameters
```

```Output
ConfigurationScope  Ensure UpdateAutomatically UpdateFrequency
------------------  ------ ------------------- ---------------
              User Present                True              30

InDesiredState
--------------
         False

InDesiredState
--------------
          True

InDesiredState
--------------
         False
```

With this code, the `Test()` method is able to accurately determine whether the configuration file
is in the desired state.

### The Set method

Now that the `Get()` and `Test()` methods reliably work, you can define the `Set()` method to
actually enforce the desired state.

In the minimal implementation, the `Set()` method does nothing.

```powershell
[void] Set() {}
```

First, `Set()` needs to determine whether the DSC Resource needs to be created, updated, or removed.

```powershell
[void] Set() {
    if ($this.Test()) {
            return
    }

    $CurrentState = $this.CachedCurrentState

    $IsAbsent = $CurrentState.Ensure -eq [TailspinEnsure]::Absent
    $ShouldBeAbsent = $this.Ensure -eq [TailspinEnsure]::Absent

    if ($IsAbsent) {
        # Create
    } elseif ($ShouldBeAbsent) {
        # Remove
    } else {
        # Update
    }
}
```

`Set()` first calls the `Test()` method to determine if anything actually needs to be done. Some
tools like, Azure Automanage's machine configuration feature, ensure that the `Set()` method is only
called after the `Test()` method. However, there's no such guarantee when you use the
`Invoke-DscResource` cmdlet.

Since the `Test()` method calls `Get()`, which caches the current state, the DSC Resource can access
the cached current state without having to call the `Get()` method again.

Next, the DSC Resource needs to distinguish between create, remove, and update behaviors for the
configuration file. If the configuration file doesn't exist, we know it should be created. If the
configuration file does exist and shouldn't, we know it needs to be removed. If the configuration
file does exist and should exist, we know it needs to be updated.

Create three new methods to handle these operations and call them in the `Set()` method as needed.
The return type for all three should be **void**.

```powershell
[void] Set() {
    if ($this.Test()) {
            return
    }

    $CurrentState = $this.CachedCurrentState

    $IsAbsent = $CurrentState.Ensure -eq [TailspinEnsure]::Absent
    $ShouldBeAbsent = $this.Ensure -eq [TailspinEnsure]::Absent

    if ($IsAbsent) {
        $this.Create()
    } elseif ($ShouldBeAbsent) {
        $this.Remove()
    } else {
        $this.Update()
    }
}

[void] Create() {}
[void] Remove() {}
[void] Update() {}
```

Also, create a new method called `ToConfigJson()`. Its return type should be **string**. This method
converts the DSC Resource into the JSON that the configuration file expects. You can start with the
following minimal implementation:

```powershell
[string] ToConfigJson() {
    $config = @{}

    return ($config | ConvertTo-Json)
}
```

#### The ToConfigJson method

The minimal implementation returns an empty JSON object as a string. To make it useful, it needs to
return the actual JSON representation of the settings in TSToy's configuration file.

First, prepopulate the `$config` hashtable with the mandatory automatic updates setting by
adding the `updates` key with its value as a **hashtable**. The hashtable should have the
`automatic` key. Assign the value of the class's `$UpdateAutomatically` property to the `automatic`
key.

```powershell
[string] ToConfigJson() {
    $config = @{
        updates = @{
            automatic = $this.UpdateAutomatically
        }
    }

    return ($config | ConvertTo-Json)
}
```

This code translates the DSC Resource representation of TSToy's settings to the structure that
TSToy's configuration file expects.

Next, the method needs to check whether the class has cached the data from an existing configuration
file. The cached data allows the DSC Resource to manage the defined settings without overwriting or
removing unmanaged settings.

```powershell
[string] ToConfigJson() {
    $config = @{
        updates = @{
            automatic = $this.UpdateAutomatically
        }
    }

    if ($this.CachedData) {
        # Copy unmanaged settings without changing the cached values
        $this.CachedData |
            Get-Member -MemberType NoteProperty |
            Where-Object -Property Name -NE -Value 'updates' |
            ForEach-Object -Process {
                $setting = $_.Name
                $config.$setting = $this.CachedData.$setting
            }

        # Add the checkFrequency to the hashtable if it is set in the cache
        if ($frequency = $this.CachedData.updates.checkFrequency) {
            $config.updates.checkFrequency = $frequency
        }
    }

    # If the user specified an UpdateFrequency, use that value
    if ($this.UpdateFrequency -ne 0) {
        $config.updates.checkFrequency = $this.UpdateFrequency
    }

    return ($config | ConvertTo-Json)
}
```

If the class has cached the settings from an existing configuration, it:

1. Inspects the cached data's properties, looking for any properties the DSC Resource doesn't
   manage. If it finds any, the method inserts those unmanaged properties into the `$config`
   hashtable.

   Because the DSC Resource only manages the update settings, every setting except for `updates` is
   inserted.
1. Checks to see if the `checkFrequency` setting in `updates` is set. If it's set, the method
   inserts this value into the `$config` hashtable.

   This operation allows the DSC Resource to ignore the `$UpdateFrequency` property if the user
   doesn't specify it.

1. Finally, the method needs to check if the user specified the `$UpdateFrequency` property and
   insert it into the `$config` hashtable if they did.

With this code, the `ToConfigJson()` method:

1. Returns an accurate JSON representation of the desired state that the TSToy application expects
   in its configuration file
1. Respects any of TSToy's settings that the DSC Resource doesn't explicitly manage
1. Respects the existing value for TSToy's update frequency if the user didn't specify one,
   including leaving it undefined in the configuration file

To test this new method, close your VS Code terminal and open a new one. Execute the `using`
statement to load the **ExampleResources** module's classes and enums into your current session and
dot-source the `helpers.ps1` script.

```powershell
using module ./ExampleResources.psd1
. ./Helpers.ps1
$Example = [Tailspin]::new()
Get-Content -Path $TSToyUserPath
$Example.ConfigurationScope = 'User'
$Example.ToConfigJson()
```

Before the `Get()` method is called, the only value in the output of the **ToJsonConfig** method is
the converted value for the `$UpdateAutomatically` property.

```Output
{
    "unmanaged_key": true,
    "updates": {
        "automatic": false,
        "checkFrequency": 30
    }
}

{
  "updates": {
    "automatic": false
  }
}
```

```powershell
$Example.Get()
$Example.ToConfigJson()
```

After you call `Get()`, the output includes an unmanaged top-level key, `unmanaged_key`. It also
includes the existing setting in the configuration file for `$UpdateFrequency` since it wasn't
explicitly set on the DSC Resource.

```Output
ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : False
UpdateFrequency     : 30
Reasons             : {}

{
  "unmanaged_key": true,
  "updates": {
    "automatic": false,
    "checkFrequency": 30
  }
}
```

```powershell
$Example.UpdateFrequency = 7
$Example.ToConfigJson()
```

After `$UpdateFrequency` is set, the output reflects the specified value.

```Output
{
  "unmanaged_key": true,
  "updates": {
    "automatic": false,
    "checkFrequency": 7
  }
}
```

#### The Create method

To implement the `Create()` method, we need to convert the user-specified properties for the DSC
Resource into the JSON that TSToy expects in its configuration file and write it to that file.

```powershell
[void] Create() {
    $ErrorActionPreference = 'Stop'

    $Json = $this.ToConfigJson()

    $FilePath   = $this.GetConfigurationFile()
    $FolderPath = Split-Path -Path $FilePath

    if (!(Test-Path -Path $FolderPath)) {
        New-Item -Path $FolderPath -ItemType Directory -Force
    }

    Set-Content -Path $FilePath -Value $Json -Encoding utf8 -Force
}
```

The method uses the `ToConfigJson()` method to get the JSON for the configuration file. It checks
whether the configuration file's folder exists and creates it if necessary. Finally, it creates the
configuration file and writes the JSON to it.

#### The Remove method

The `Remove()` method has the simplest behavior. If the configuration file exists, delete it.

```powershell
[void] Remove() {
    Remove-Item -Path $this.GetConfigurationFile() -Force -ErrorAction Stop
}
```

#### The Update method

The `Update()` method's implementation is similar to the **Create** method. It needs to convert the
user-specified properties for the DSC Resource into the JSON that TSToy expects in its configuration
file and replace the settings in that file.

```powershell
[void] Update() {
    $ErrorActionPreference = 'Stop'

    $Json = $this.ToConfigJson()
    $FilePath   = $this.GetConfigurationFile()

    Set-Content -Path $FilePath -Value $Json -Encoding utf8 -Force
}
```

## 5 - Manually test a DSC Resource

With the DSC Resource fully implemented, you can now test its behavior.

Before testing, close your VS Code terminal and open a new one. Dot-source the `Helpers.ps1` script.
For each test scenario, create the `$DesiredState` hashtable containing the shared parameters and
call the methods in the following order:

1. `Get()`, to retrieve the initial state of the DSC Resource
1. `Test()`, to see whether the DSC Resource considers it to be in the desired state
1. `Set()`, to enforce the desired state
1. `Test()`, to see whether the DSC Resource considers it to be set correctly
1. `Get()`, to confirm the final state of the DSC Resource

### Scenario: TSToy shouldn't update automatically in the user scope

In this scenario, the existing configuration in the user scope needs to be configured not to update
automatically. All other settings should be left untouched.

```powershell
. ./Helpers.ps1

$DesiredState = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        UpdateAutomatically = $false
        Ensure              = 'Present'
    }
}

Get-Content -Path $TSToyUserPath

Invoke-DscResource @DesiredState -Method Get
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Set
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Get

Get-Content -Path $TSToyUserPath
```

```Output
{
    "unmanaged_key": true,
    "updates": {
        "automatic": true,
        "checkFrequency": 30
    }
}

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 30
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'False'
                        Actual boolean value of 'True'
                      }

InDesiredState : False

RebootRequired : False

InDesiredState : True

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : False
UpdateFrequency     : 30
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'False'
                        Actual boolean value of 'False'
                      }

{
  "unmanaged_key": true,
  "updates": {
    "automatic": false,
    "checkFrequency": 30
  }
}
```

### Scenario: Tailspin should update automatically on any schedule in the user scope

In this scenario, the existing configuration in the user scope needs to be configured to update
automatically. All other settings should be left untouched.

```powershell
. ./Helpers.ps1

$DesiredState = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        UpdateAutomatically = $true
        Ensure              = 'Present'
    }
}

Get-Content -Path $TSToyUserPath

Invoke-DscResource @DesiredState -Method Get
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Set
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Get

Get-Content -Path $TSToyUserPath
```

```Output
{
  "unmanaged_key": true,
  "updates": {
    "automatic": false,
    "checkFrequency": 30
  }
}

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : False
UpdateFrequency     : 30
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'False'
                      }

InDesiredState : False

RebootRequired : False

InDesiredState : True

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 30
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      }

{
  "unmanaged_key": true,
  "updates": {
    "automatic": true,
    "checkFrequency": 30
  }
}
```

### Scenario: TSToy should update automatically every day in the user scope

In this scenario, the existing configuration in the user scope needs to be configured to update
automatically and daily. All other settings should be left untouched.

```powershell
. ./Helpers.ps1

$DesiredState = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        UpdateAutomatically = $true
        UpdateFrequency     = 1
        Ensure              = 'Present'
    }
}

Get-Content -Path $TSToyUserPath

Invoke-DscResource @DesiredState -Method Get
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Set
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Get

Get-Content -Path $TSToyUserPath
```

```Output
{
  "unmanaged_key": true,
  "updates": {
    "automatic": true,
    "checkFrequency": 30
  }
}

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 30
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      ,
                      Tailspin.Tailspin.UpdateFrequency:
                        Checked value of the 'updates.checkFrequency' key in
                      the TSToy configuration file.
                        Expected integer value of '1'.
                        Actual integer value of '30'.
                      }

InDesiredState : False

RebootRequired : False

InDesiredState : True

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 1
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file to exist at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      ,
                      Tailspin.Tailspin.UpdateFrequency:
                        Checked value of the 'updates.checkFrequency' key in
                      the TSToy configuration file.
                        Expected integer value of '1'.
                        Actual integer value of '1'.
                      }

{
  "unmanaged_key": true,
  "updates": {
    "checkFrequency": 1,
    "automatic": true
  }
}
```

### Scenario: TSToy shouldn't have a user scope configuration

In this scenario, the configuration file for TSToy in the user scope shouldn't exist. If it does,
the DSC Resource should delete the file.

```powershell
. ./Helpers.ps1

$DesiredState = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'User'
        UpdateAutomatically = $false
        Ensure              = 'Absent'
    }
}

Get-Content -Path $TSToyUserPath

Invoke-DscResource @DesiredState -Method Get
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Set
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Get

Test-Path -Path $TSToyUserPath
```

```Output
{
  "unmanaged_key": true,
  "updates": {
    "checkFrequency": 1,
    "automatic": true
  }
}

ConfigurationScope  : User
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 1
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file not to exist at 'C:\Users\ml
                      ombardi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.j
                      son'.
                        The configuration file exists at 'C:\Users\mlombardi\App
                      Data\Roaming\TailSpinToys\tstoy\tstoy.config.json'.
                      }

InDesiredState : False

RebootRequired : False

InDesiredState : True

ConfigurationScope  : User
Ensure              : Absent
UpdateAutomatically : False
UpdateFrequency     : 0
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the User scope.
                        Expected configuration file not to exist at 'C:\Users\ml
                      ombardi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.j
                      son'.
                        The configuration file was not found at 'C:\Users\mlomba
                      rdi\AppData\Roaming\TailSpinToys\tstoy\tstoy.config.json'
                      .
                      }

False
```

### Scenario: TSToy should update automatically every week in the machine scope

In this scenario, there's no defined configuration in the machine scope. The machine scope needs to
be configured to update automatically and daily. The DSC Resource should create the file and any
parent folders as required.

```powershell
. ./Helpers.ps1

$DesiredState = @{
    Name     = 'Tailspin'
    Module   = 'ExampleResources'
    Property = @{
        ConfigurationScope  = 'Machine'
        UpdateAutomatically = $true
        Ensure              = 'Present'
    }
}

Test-Path -Path $TSToyMachinePath, (Split-Path -Path $TSToyMachinePath)

Invoke-DscResource @DesiredState -Method Get
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Set
Invoke-DscResource @DesiredState -Method Test
Invoke-DscResource @DesiredState -Method Get

Get-Content -Path $TSToyMachinePath
```

```Output
False
False

ConfigurationScope  : Machine
Ensure              : Absent
UpdateAutomatically : False
UpdateFrequency     : 0
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the Machine scope.
                        Expected configuration file to exist at
                      'C:\ProgramData\TailSpinToys\tstoy\tstoy.config.json'.
                        The configuration file was not found at
                      'C:\ProgramData\TailSpinToys\tstoy\tstoy.config.json'.
                      }

InDesiredState : False

RebootRequired : False

InDesiredState : True

ConfigurationScope  : Machine
Ensure              : Present
UpdateAutomatically : True
UpdateFrequency     : 0
Reasons             : {
                      Tailspin.Tailspin.Ensure:
                        Checked existence of the TSToy configuration file in
                      the Machine scope.
                        Expected configuration file to exist at
                      'C:\ProgramData\TailSpinToys\tstoy\tstoy.config.json'.
                        The configuration file exists at
                      'C:\ProgramData\TailSpinToys\tstoy\tstoy.config.json'.
                      ,
                      Tailspin.Tailspin.UpdateAutomatically:
                        Checked value of the 'updates.automatic' key in the
                      TSToy configuration file.
                        Expected boolean value of 'True'
                        Actual boolean value of 'True'
                      }

{
  "updates": {
    "automatic": true
  }
}
```

## Review

In this tutorial, you:

1. Scaffolded a PowerShell module and implemented the `Tailspin` class-based DSC Resource
1. Defined the DSC Resource's properties to manage the TSToy application's update behavior in the
   machine and user scopes with validation for those properties
1. Implemented enums for the `$Ensure` and `$ConfigurationScope` properties
1. Implemented the `ExampleResourcesReason` class for reporting how a resource is out-of-state in
   machine configuration
1. Implemented the `GetConfigurationFile()` helper method to reliably discover the location of
   TSToy's application config in the machine and user scopes across platforms
1. Implemented the `Get()` method to retrieve the current state of the DSC Resource, caching it for
   use in the `Test()` and `Set()` methods
1. Implemented the `GetReasons()` helper method for validating whether the DSC Resource is in the
   desired state and, if it isn't, enumerating how it's out of state
1. Implemented the `Test()` method to validate the current state of TSToy's update behavior in a
   specific scope against the desired state
1. Implemented the **ToConfigJson** method to convert the desired state of the DSC Resource into
   the JSON object the TSToy application requires for its configuration file, respecting unmanaged
   settings
1. Implemented the `Set()` method and the **Create**, **Remove**, and **Update** helper methods to
   idempotently enforce the desired state for TSToy's update behavior in a specific scope, ensuring
   that the DSC Resource doesn't have undesirable side effects
1. Manually tested common usage scenarios for the DSC Resource

At the end of your implementation, your module definition looks like this:

```powershell
[DscResource()]
class Tailspin {
    [DscProperty(Key)] [TailspinScope]
    $ConfigurationScope

    [DscProperty()] [TailspinEnsure]
    $Ensure = [TailspinEnsure]::Present

    [DscProperty(Mandatory)] [bool]
    $UpdateAutomatically

    [DscProperty()] [int] [ValidateRange(1, 90)]
    $UpdateFrequency

    [DscProperty(NotConfigurable)] [ExampleResourcesReason[]]
    $Reasons

    hidden [Tailspin] $CachedCurrentState
    hidden [PSCustomObject] $CachedData

    [Tailspin] Get() {
        $CurrentState = [Tailspin]::new()

        $CurrentState.ConfigurationScope = $this.ConfigurationScope

        $FilePath = $this.GetConfigurationFile()

        if (!(Test-Path -Path $FilePath)) {
            $CurrentState.Ensure = [TailspinEnsure]::Absent
            $CurrentState.Reasons = $this.GetReasons($CurrentState)

            $this.CachedCurrentState = $CurrentState

            return $CurrentState
        }

        $Data = Get-Content -Raw -Path $FilePath |
        ConvertFrom-Json -ErrorAction Stop

        $this.CachedData = $Data

        if ($null -ne $Data.Updates.Automatic) {
            $CurrentState.UpdateAutomatically = $Data.Updates.Automatic
        }

        if ($null -ne $Data.Updates.CheckFrequency) {
            $CurrentState.UpdateFrequency = $Data.Updates.CheckFrequency
        }

        $CurrentState.Reasons = $this.GetReasons($CurrentState)

        $this.CachedCurrentState = $CurrentState

        return $CurrentState
    }

    [bool] Test() {
        $CurrentState = $this.Get()

        if ($CurrentState.Ensure -ne $this.Ensure) {
            return $false
        }

        if ($CurrentState.UpdateAutomatically -ne $this.UpdateAutomatically) {
            return $false
        }

        if ($this.UpdateFrequency -eq 0) {
            return $true
        }

        if ($CurrentState.UpdateFrequency -ne $this.UpdateFrequency) {
            return $false
        }

        return $true
    }

    [void] Set() {
        if ($this.Test()) {
            return
        }

        $CurrentState = $this.CachedCurrentState

        $IsAbsent = $CurrentState.Ensure -eq [TailspinEnsure]::Absent
        $ShouldBeAbsent = $this.Ensure -eq [TailspinEnsure]::Absent

        if ($IsAbsent) {
            $this.Create()
        }
        elseif ($ShouldBeAbsent) {
            $this.Remove()
        }
        else {
            $this.Update()
        }
    }

    [string] GetConfigurationFile() {
        $FilePaths = @{
            Linux   = @{
                Machine = '/etc/xdg/TailSpinToys/tstoy/tstoy.config.json'
                User    = '~/.config/TailSpinToys/tstoy/tstoy.config.json'
            }
            MacOS   = @{
                Machine = '/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json'
                User    = '~/Library/Preferences/TailSpinToys/tstoy/tstoy.config.json'
            }
            Windows = @{
                Machine = "$env:ProgramData\TailSpinToys\tstoy\tstoy.config.json"
                User    = "$env:APPDATA\TailSpinToys\tstoy\tstoy.config.json"
            }
        }

        $Scope = $this.ConfigurationScope.ToString()

        if ($Global:PSVersionTable.PSVersion.Major -lt 6 -or $Global:IsWindows) {
            return $FilePaths.Windows.$Scope
        }
        elseif ($Global:IsLinux) {
            return $FilePaths.Linux.$Scope
        }
        else {
            return $FilePaths.MacOS.$Scope
        }
    }

    [ExampleResourcesReason[]] GetReasons([Tailspin]$CurrentState) {
        [ExampleResourcesReason[]]$DefinedReasons = @()

        $FilePath = $this.GetConfigurationFile()

        if ($this.Ensure -eq [TailspinEnsure]::Present) {
            $Expected = "Expected configuration file to exist at '$FilePath'."
        } else {
            $Expected = "Expected configuration file not to exist at '$FilePath'."
        }

        if ($CurrentState.Ensure -eq [TailspinEnsure]::Present) {
            $Actual = "The configuration file exists at '$FilePath'."
        } else {
            $Actual = "The configuration file was not found at '$FilePath'."
        }

        $DefinedReasons += [ExampleResourcesReason]@{
            Code   = "Tailspin.Tailspin.Ensure"
            Phrase = @(
                "Checked existence of the TSToy configuration file in the $($this.ConfigurationScope) scope."
                $Expected
                $Actual
            ) -join "`n`t"
        }

        if ($CurrentState.Ensure -ne $this.Ensure) {
            return $DefinedReasons
        }

        if ($CurrentState.Ensure -eq [TailspinEnsure]::Absent) {
            return $DefinedReasons
        }

        $DefinedReasons += [ExampleResourcesReason]@{
            Code   = "Tailspin.Tailspin.UpdateAutomatically"
            Phrase = (@(
                    "Checked value of the 'updates.automatic' key in the TSToy configuration file."
                    "Expected boolean value of '$($this.UpdateAutomatically)'"
                    "Actual boolean value of '$($CurrentState.UpdateAutomatically)'"
                ) -join "`n`t")
        }

        # Short-circuit the check; UpdateFrequency isn't defined by caller
        if ($this.UpdateFrequency -eq 0) {
            return $DefinedReasons
        }

        $DefinedReasons += [ExampleResourcesReason]@{
            Code   = "Tailspin.Tailspin.UpdateFrequency"
            Phrase = (@(
                    "Checked value of the 'updates.checkFrequency' key in the TSToy configuration file."
                    "Expected integer value of '$($this.UpdateFrequency)'."
                    "Actual integer value of '$($CurrentState.UpdateFrequency)'."
                ) -join "`n`t")
        }

        return $DefinedReasons
    }

    [void] Create() {
        $ErrorActionPreference = 'Stop'

        $Json = $this.ToConfigJson()

        $FilePath = $this.GetConfigurationFile()

        $FolderPath = Split-Path -Path $FilePath

        if (!(Test-Path -Path $FolderPath)) {
            New-Item -Path $FolderPath -ItemType Directory -Force
        }

        Set-Content -Path $FilePath -Value $Json -Encoding utf8 -Force
    }

    [void] Remove() {
        Remove-Item -Path $this.GetConfigurationFile() -Force -ErrorAction Stop
    }

    [void] Update() {
        $ErrorActionPreference = 'Stop'

        $Json = $this.ToConfigJson()
        $FilePath = $this.GetConfigurationFile()

        Set-Content -Path $FilePath -Value $Json -Encoding utf8 -Force
    }

    [string] ToConfigJson() {
        $config = @{
            updates = @{
                automatic = $this.UpdateAutomatically
            }
        }

        if ($this.CachedData) {
            $this.CachedData |
                Get-Member -MemberType NoteProperty |
                Where-Object -Property Name -NE -Value 'updates' |
                ForEach-Object -Process {
                    $setting = $_.Name
                    $config.$setting = $this.CachedData.$setting
                }

            if ($frequency = $this.CachedData.updates.CheckFrequency) {
                $config.updates.checkFrequency = $frequency
            }
        }

        if ($this.UpdateFrequency -ne 0) {
            $config.updates.checkFrequency = $this.UpdateFrequency
        }

        return ($config | ConvertTo-Json)
    }
}

enum TailspinScope {
    Machine
    User
}

enum TailspinEnsure {
    Absent
    Present
}

class ExampleResourcesReason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase

    [string] ToString() {
        return "`n$($this.Code):`n`t$($this.Phrase)`n"
    }
}
```

## Clean up

If you're not going to continue to use this module, delete the `ExampleResources` folder and the
files in it.

## Next steps

1. Read about [class-based DSC Resources][02], learn about how they work, and consider why the DSC
   Resource in this tutorial is implemented this way.
1. Read about the [machine configuration feature of Azure Automanage][01] to understand how you can
   use it to audit and configure your systems.
1. Consider how this DSC Resource can be improved. Are there any edge cases or features it doesn't
   handle? Update the implementation to handle them.

<!--
> [!div class="nextstepaction"]
> [Next steps button](contribute-how-to-mvc-tutorial.md)
-->

<!-- link references -->
[01]: /azure/governance/machine-configuration/overview
[02]: ../concepts/class-based-resources.md
