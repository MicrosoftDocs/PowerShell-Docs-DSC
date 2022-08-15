---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Authoring a MOF-based DSC Resource
description: >
  This article shows how you can write a MOF-based DSC Resource with a script module and a schema
  file.
---

# Authoring a MOF-based DSC Resource

> Applies To: PowerShell 7.2

This article shows how you can create a MOF-based DSC Resource by writing a schema and developing
a script module  to manage an IIS website.

## Creating the MOF schema

A MOF-based DSC Resource must have a schema (`.mof`) file that defines the manageable settings for a
software component.

### Create the required folder structure

Create the following folder structure. The schema is defined in the file
`Demo_IISWebsite.schema.mof`, and the required functions are defined in `Demo_IISWebsite.psm1`.
Optionally, you can create a module manifest (`.psd1`) file.

```text
$env:ProgramFiles\WindowsPowerShell\Modules (folder)
    |- MyDscResources (folder)
        |- DSCResources (folder)
            |- Demo_IISWebsite (folder)
                |- Demo_IISWebsite.psd1 (file, optional)
                |- Demo_IISWebsite.psm1 (file, required)
                |- Demo_IISWebsite.schema.mof (file, required)
```

> [!NOTE]
> You must create a folder named `DSCResources` under the top-level folder of your module. The
> folder for each DSC Resource must have the same name as the DSC Resource.

### The contents of the MOF file

Following is an example MOF file that describes the properties of a website for the DSC Resource. To
follow this example, save this schema to a file called `Demo_IISWebsite.schema.mof`.

```mof
[ClassVersion("1.0.0"), FriendlyName("Website")]
class Demo_IISWebsite : OMI_BaseResource
{
  [Key] string Name;
  [Required] string PhysicalPath;
  [write,ValueMap{"Present", "Absent"},Values{"Present", "Absent"}] string Ensure;
  [write,ValueMap{"Started","Stopped"},Values{"Started", "Stopped"}] string State;
  [write] string Protocol[];
  [write] string BindingInfo[];
  [write] string ApplicationPool;
  [read] string ID;
};
```

Note the following about the previous code:

- **FriendlyName** defines the name you can use to refer to this DSC Resource. In this example, the
  **FriendlyName** is `Website`.
- Your DSC Resource's class must derive from `OMI_BaseResource`.
- The type qualifier, `[Key]`, on a property indicates that this property uniquely identifies the
  resource instance. Every DSC Resource must have at least one `[Key]` property.
- The `[Required]` qualifier indicates that the property is mandatory when using this DSC Resource.
- The `[write]` qualifier indicates that this property is optional.
- The `[read]` qualifier indicates that a property can't be set by the DSC Resource, and is for
  reporting purposes only.
- **Values** restricts the values that can be assigned to the property to the list of values defined
  in the **ValueMap**. For more information, see [ValueMap and Value Qualifiers][1].
- Including a property called **Ensure** with the values `Present` and `Absent` in your DSC Resource
  is recommended for DSC Resources that a user can add and remove from a system.
- Name the schema file for your DSC Resource as follows: `<classname>.schema.mof`, where
  `<classname>` is the identifier that follows the `class` keyword in your schema definition.

### Writing the script module

A MOF-based DSC Resource's script module implements the logic of the DSC Resource. In this module,
you must include three functions called `Get-TargetResource`, `Set-TargetResource`, and
`Test-TargetResource`. All three functions must take a parameter set that's identical to the set of
properties defined in the DSC Resource's schema. Save these three functions in a file called
`<ResourceName>.psm1`. In the following example, the functions are saved in a file called
`Demo_IISWebsite.psm1`.

> [!NOTE]
> When you use `Invoke-DscResource` to set the desired state with the same properties more than
> once, you should receive no errors and the system should remain in the same state as after the
> first time you used it. To do this, ensure that your `Get-TargetResource` and
> `Test-TargetResource` functions leave the system unchanged, and that invoking the
> `Set-TargetResource` function more than once in a sequence with the same parameter values is
> always the same as invoking it once.

In the `Get-TargetResource` function implementation, use the **Key** property values that are
provided as parameters to verify the state of the specified instance of the DSC Resource. This
function must return a hash table that lists all the DSC Resource properties as keys and the actual
values of these properties as the corresponding values. The following code provides an example.

```powershell
# The Get-TargetResource function is used to retrieve the current state of a
# website on the system.
function Get-TargetResource {
    param(
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PhysicalPath,

        [ValidateSet("Started", "Stopped")]
        [string]$State = "Started",

        [string]$ApplicationPool,

        [string[]]$BindingInfo,

        [string[]]$Protocol
    )

        $getTargetResourceResult = $null;

        <#
          Insert logic that uses the mandatory parameter values to get the
          website and assign it to a variable called $Website Set $ensureResult
          to "Present" if the requested website exists and to "Absent" otherwise
        #>

        # Add all Website properties to the hashtable
        # This example assumes that $Website is not null
        $getTargetResourceResult = @{
            Name            = $Website.Name
            Ensure          = $ensureResult
            PhysicalPath    = $Website.physicalPath
            State           = $Website.state
            ID              = $Website.id
            ApplicationPool = $Website.applicationPool
            Protocol        = $Website.bindings.Collection.protocol
            Binding         = $Website.bindings.Collection.bindingInformation
        }

        $getTargetResourceResult
}
```

Depending on the values a user specifies for the DSC Resource's properties, `Set-TargetResource`
must do one of the following:

- Add a new website
- Update an existing website
- Remove an existing website

The following example illustrates this.

```powershell
# The Set-TargetResource function is used to add, update, or remove a website
# on the system.
function Set-TargetResource {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PhysicalPath,

        [ValidateSet("Started", "Stopped")]
        [string]$State = "Started",

        [string]$ApplicationPool,

        [string[]]$BindingInfo,

        [string[]]$Protocol
    )

    <#
        If Ensure is set to "Present" and the website specified in the mandatory
          input parameters doesn't exist, then add it using the specified
          parameter values
        Else, if Ensure is set to "Present" and the website does exist, then
          update its properties to match the values provided in the
          non-mandatory parameter values
        Else, if Ensure is set to "Absent" and the website does not exist, then
          do nothing
        Else, if Ensure is set to "Absent" and the website does exist, then
          delete the website
    #>
}
```

Finally, the `Test-TargetResource` function must take the same parameter set as `Get-TargetResource`
and `Set-TargetResource`. In your implementation of `Test-TargetResource`, verify the current state
of the system against the values specified in the parameter set. If the current state doesn't match
the desired state, return `$false`. Otherwise, return `$true`.

The following code implements the `Test-TargetResource` function.

```powershell
function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [parameter(Mandatory = $true)]
        [System.String]
        $PhysicalPath,

        [ValidateSet("Started","Stopped")]
        [System.String]
        $State,

        [System.String[]]
        $Protocol,

        [System.String[]]
        $BindingData,

        [System.String]
        $ApplicationPool
    )

    # Get the current state
    $getParameters = @{
        Ensure          = $Ensure 
        Name            = $Name 
        PhysicalPath    = $PhysicalPath 
        State           = $State 
        ApplicationPool = $ApplicationPool 
        BindingInfo     = $BindingInfo 
        Protocol        = $Protocol
    }
    $currentState = Get-TargetResource @getParameters

    # Write-Verbose "Use this cmdlet to deliver information about command processing."

    # Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    # Include logic to
    $result = [System.Boolean]
    # Add logic to test whether the website is present and its status matches the supplied
    # parameter values. If it does, return true. If it does not, return false.
    $result
}
```

> [!NOTE]
> For easier debugging, use the `Write-Verbose` cmdlet in your implementation of the previous three
> functions. This cmdlet writes text to the verbose message stream. By default, the verbose message
> stream isn't displayed, but you can display it by changing the value of the `$VerbosePreference`
> variable or using the **Verbose** parameter with `Invoke-DscResource`.

### Creating the module manifest

Finally, use the `New-ModuleManifest` cmdlet to define a `<ResourceName>.psd1` file for your DSC
Resource module. Use the script module (`.psm1`) file described in the previous section as the value
of the **NestedModules** parameter. Include `Get-TargetResource`, `Set-TargetResource`, and
`Test-TargetResource` as values for the **FunctionsToExport** parameter.

```powershell
$ManifestParameters = @{
    Path              = 'Demo_IISWebsite.psd1'
    NestedModules     = 'Demo_IISWebsite.psm1'
    FunctionsToExport = @(
        'Get-TargetResource'
        'Set-TargetResource'
        'Test-TargetResource'
    )
}
New-ModuleManifest @ManifestParameters
```

```powershell
@{

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '6AB5ED33-E923-41d8-A3A4-5ADDA2B301DE'

# Author of this module
Author = 'Contoso'

# Company or vendor of this module
CompanyName = 'Contoso'

# Copyright statement for this module
Copyright = 'Contoso. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Create and configure IIS websites with DSC.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '7.2'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
    'WebAdministration'
)

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    'Demo_IISWebsite.psm1'
)

# Functions to export from this module
FunctionsToExport = @(
    'Get-TargetResource'
    'Set-TargetResource'
    'Test-TargetResource'
)

}
```

## Rebooting the System

If the actions taken in your `Set-TargetResource` function require a reboot, you can use a global
flag to tell the caller to reboot the system.

Inside your `Set-TargetResource` function, add the following line of code.

```powershell
# Include this line if the system requires a reboot.
$global:DSCMachineStatus = 1
```

<!-- Reference Links -->

[1]: /windows/desktop/WmiSdk/value-map
