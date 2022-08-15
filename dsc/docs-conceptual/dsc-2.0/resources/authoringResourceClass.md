---
ms.date: 08/01/2022
title:  Authoring a class-based DSC Resource
description: >
  This article shows how to create a DSC Resource that manages a file in a specified path with
  PowerShell classes.
---

# Authoring a class-based DSC Resource

> Applies To: PowerShell 7.2

You can define a DSC Resource by creating a PowerShell class. In a class-based DSC Resource, the
schema is defined as properties of the class that can be modified with attributes to specify the
property type. The Resource is implemented with **Get**, **Set**, and **Test** methods (equal to
the `Get-TargetResource`, `Set-TargetResource`, and `Test-TargetResource` functions in a script
Resource).

In this article, we create a minimal Resource named `NewFile` that manages a file in a specified
path.

For more information about DSC Resources, see [DSC Resources][1].

> [!NOTE]
> Generic collections aren't supported in class-based Resources.

## Folder structure for a class Resource

To implement a DSC Resource with a PowerShell class, create the following folder structure. The
class is defined in `MyDscResource.psm1` and the module manifest is defined in `MyDscResource.psd1`.

```text
$env:ProgramFiles\WindowsPowerShell\Modules (folder)
    |- MyDscResource (folder)
        MyDscResource.psm1
        MyDscResource.psd1
```

## Create the class

You use the `class` keyword to create a PowerShell class. To specify that a class is a DSC Resource,
use the `DscResource()` attribute. The name of the class is the name of the DSC Resource.

```powershell
[DscResource()]
class NewFile {
}
```

### Declare properties

The DSC Resource schema is defined as properties of the class. We declare three properties as
follows.

```powershell
[DscProperty(Key)]
[string] $path

[DscProperty(Mandatory)]
[ensure] $ensure

[DscProperty()]
[string] $content

[DscProperty(NotConfigurable)]
[Reason[]] $Reasons
```

Notice that the properties are modified by attributes. The meaning of the attributes is as follows:

- **DscProperty(Key)**: The property is required. The property is a key. The values of all
  properties marked as keys must combine to uniquely identify a Resource instance within a
  configuration.
- **DscProperty(Mandatory)**: The property is required.
- **DscProperty(NotConfigurable)**: The property is read-only. Properties marked with this attribute
  can't be set by a configuration, but are populated by the **Get** method.
- **DscProperty()**: The property is configurable, but it's not required.

The **Path** and **SourcePath** properties are both strings. The **CreationTime** is a
[DateTime][2] property. The **Ensure** property is an enumeration type, defined as follows.

```powershell
enum Ensure {
    Absent
    Present
}
```

### Embedding classes

If you would like to include a new type with defined properties that you can use within your
DSC Resource, create a class with property types as described before.

```powershell
class Reason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase
}
```

### Public and Private functions

You can create PowerShell functions within the same module file and use them inside the methods of
your DSC Resource's class. The functions must be exported as module members in the module manifest's
**FunctionsToExport** setting. The script blocks within those functions may call unexported
functions.

```powershell
<#
   Public Functions
#>

function Get-File {
    param(
        [ensure]$ensure,
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    $fileContent        = [reason]::new()
    $fileContent.code   = 'file:file:content'

    $filePresent        = [reason]::new()
    $filePresent.code   = 'file:file:path'

    $ensureReturn = 'Absent'

    $fileExists = Test-Path -Path $path -ErrorAction SilentlyContinue

    if ($fileExists) {
        $filePresent.phrase     = @(
            "The file was expected to be: $ensure"
            "The file exists at path: $path"
        ) -join "`n"
        
        $existingFileContent    = Get-Content $path -Raw
        if ([string]::IsNullOrEmpty($existingFileContent)) {
            $existingFileContent = ''
        }

        if (![string]::IsNullOrEmpty($content)) {
            $content = $content | ConvertTo-SpecialChars
        }

        $fileContent.phrase = @(
            "The file was expected to contain: $content"
            "The file contained: $existingFileContent"
        ) -join "`n"

        if ($content -eq $existingFileContent) {
            $ensureReturn = 'Present'
        }
    } else {
        $filePresent.phrase = @(
            "The file was expected to be: $ensure"
            "The file does not exist at path: $path"
        ) -join "`n"
        $path = 'file not found'
    }

    @{
        Ensure  = $ensureReturn
        Path    = $path
        Content = $existingFileContent
        Reasons = @($filePresent,$fileContent)
    }
}

function Set-File {
    param(
        [ensure]$ensure = "Present",
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    Remove-Item $path -Force -ErrorAction SilentlyContinue

    if ($ensure -eq "Present") {
        New-Item $path -ItemType File -Force
        if ([ValidateNotNullOrEmpty()]$content) {
            $content | ConvertTo-SpecialChars | Set-Content $path -NoNewline -Force
        }
    }
}

function Test-File {
    param(
        [ensure]$ensure = "Present",
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    $test = $false
    $get = Get-File @PSBoundParameters
    
    if ($get.ensure -eq $ensure) {
        $test = $true
    }

    $test
}

<#
   Private Functions
#>

function ConvertTo-SpecialChars {
    param(
        [parameter(Mandatory = $true,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$string
    )

    $specialChars = @{
        '`n'  = "`n"
        '\\n' = "`n"
        '`r'  = "`r"
        '\\r' = "`r"
        '`t'  = "`t"
        '\\t' = "`t"
    }

    foreach ($char in $specialChars.Keys) {
        $string = $string -replace ($char,$specialChars[$char])
    }

    $string
}
```

### Implementing the methods

The **Get**, **Set**, and **Test** methods are analogous to the `Get-TargetResource`,
`Set-TargetResource`, and `Test-TargetResource` functions in a script Resource.

It's best practice to limit the amount of code within the class implementation. Move the majority of
your code into exported module functions, which you can test independantly.

```powershell
<#
    This method is equivalent of the Get-TargetResource script function.
    The implementation should use the keys to find appropriate
    Resources. This method returns an instance of this class with the
    updated key properties.
#>
[NewFile] Get() {
    $get = Get-File -ensure $this.ensure -path $this.path -content $this.content
    return $get
}

<#
    This method is equivalent of the Set-TargetResource script function.
    It sets the Resource to the desired state.
#>
[void] Set() {
    $set = Set-File -ensure $this.ensure -path $this.path -content $this.content
}

<#
    This method is equivalent of the Test-TargetResource script
    function. It should return True or False, showing whether the
    Resource is in a desired state.
#>
[bool] Test() {
    $test = Test-File -ensure $this.ensure -path $this.path -content $this.content
    return $test
}
```

### The complete file

The complete class file follows.

```powershell
enum ensure {
    Absent
    Present
}

<#
    This class is used within the DSC Resource to standardize how data
    is returned about the compliance details of the machine.
#>
class Reason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase
}

<#
   Public Functions
#>

function Get-File {
    param(
        [ensure]$ensure,
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    $fileContent        = [reason]::new()
    $fileContent.code   = 'file:file:content'

    $filePresent        = [reason]::new()
    $filePresent.code   = 'file:file:path'

    $ensureReturn = 'Absent'

    $fileExists = Test-Path -Path $path -ErrorAction SilentlyContinue

    if ($fileExists) {
        $filePresent.phrase     = @(
            "The file was expected to be: $ensure"
            "The file exists at path: $path"
        ) -join "`n"
        
        $existingFileContent    = Get-Content $path -Raw

        if ([string]::IsNullOrEmpty($existingFileContent)) {
            $existingFileContent = ''
        }

        if (![string]::IsNullOrEmpty($content)) {
            $content = $content | ConvertTo-SpecialChars
        }

        $fileContent.phrase     = @(
            "The file was expected to contain: $content"
            "The file contained: $existingFileContent"
        ) -join "`n"

        if ($content -eq $existingFileContent) {
            $ensureReturn = 'Present'
        }
    } else {
        $filePresent.phrase     = @(
            "The file was expected to be: $ensure"
            "The file does not exist at path: $path"
        ) -join "`n"
        $path = 'file not found'
    }

    @{
        ensure  = $ensureReturn
        path    = $path
        content = $existingFileContent
        Reasons = @($filePresent,$fileContent)
    }
}

function Set-File {
    param(
        [ensure]$ensure = "Present",
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    Remove-Item $path -Force -ErrorAction SilentlyContinue

    if ($ensure -eq "Present") {
        New-Item $path -ItemType File -Force
        if ([ValidateNotNullOrEmpty()]$content) {
            $content | ConvertTo-SpecialChars | Set-Content $path -NoNewline -Force
        }
    }
}

function Test-File {
    param(
        [ensure]$ensure = "Present",
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$path,

        [String]$content
    )

    $test = $false
    $get = Get-File @PSBoundParameters
    
    if ($get.ensure -eq $ensure) {
        $test = $true
    }

    return $test
}

<#
   Private Functions
#>

function ConvertTo-SpecialChars {
    param(
        [parameter(Mandatory = $true,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$string
    )
    $specialChars = @{
        '`n'  = "`n"
        '\\n' = "`n"
        '`r'  = "`r"
        '\\r' = "`r"
        '`t'  = "`t"
        '\\t' = "`t"
    }
    foreach ($char in $specialChars.Keys) {
        $string = $string -replace ($char,$specialChars[$char])
    }
    return $string
}

<#
    This Resource manages the file in a specific path.
    [DscResource()] indicates the class is a DSC Resource
#>

[DscResource()]
class NewFile {
    
    <#
        This property is the fully qualified path to the file that is
        expected to be present or absent.

        The [DscProperty(Key)] attribute indicates the property is a
        key and its value uniquely identifies a Resource instance.
        Defining this attribute also means the property is required
        and DSC will ensure a value is set before calling the Resource.

        A DSC Resource must define at least one key property.
    #>
    [DscProperty(Key)]
    [string] $path

    <#
        This property indicates if the settings should be present or absent
        on the system. For present, the Resource ensures the file pointed
        to by $Path exists. For absent, it ensures the file point to by
        $Path does not exist.

        The [DscProperty(Mandatory)] attribute indicates the property is
        required and DSC will guarantee it is set.

        If Mandatory is not specified or if it is defined as
        Mandatory=$false, the value is not guaranteed to be set when DSC
        calls the Resource.  This is appropriate for optional properties.
    #>
    [DscProperty(Mandatory)]
    [ensure] $ensure

    <#
        This property is optional. When provided, the content of the file
        will be overwridden by this value.
    #>
    [DscProperty()]
    [string] $content

    <#
        This property reports the reasons the machine is or is not compliant.

        [DscProperty(NotConfigurable)] attribute indicates the property is
        not configurable in DSC configuration.  Properties marked this way
        are populated by the Get() method to report additional details
        about the Resource when it is present.
    #>
    [DscProperty(NotConfigurable)]
    [Reason[]] $Reasons

    <#
        This method is equivalent of the Get-TargetResource script function.
        The implementation should use the keys to find appropriate
        Resources. This method returns an instance of this class with the
        updated key properties.
    #>
    [NewFile] Get() {
        $get = Get-File -ensure $this.ensure -path $this.path -content $this.content
        return $get
    }
    
    <#
        This method is equivalent of the Set-TargetResource script function.
        It sets the Resource to the desired state.
    #>
    [void] Set() {
        $set = Set-File -ensure $this.ensure -path $this.path -content $this.content
    }
    
    <#
        This method is equivalent of the Test-TargetResource script
        function. It should return True or False, showing whether the
        Resource is in a desired state.
    #>
    [bool] Test() {
        $test = Test-File -ensure $this.ensure -path $this.path -content $this.content
        return $test
    }
}
```

## Create a manifest

To make a class-based DSC Resource available, you must include a `DscResourcesToExport` statement in
the manifest file that instructs the module to export the DSC Resource. Our manifest looks like
this:

```powershell
@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'NewFile.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = 'fad0d04e-65d9-4e87-aa17-39de1d008ee4'
    
    # Author of this module
    Author = 'Microsoft Corporation'
    
    # Company or vendor of this module
    CompanyName = 'Microsoft Corporation'
    
    # Copyright statement for this module
    Copyright = ''
    
    # Description of the functionality provided by this module
    Description = 'Create and set content of a file'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
    
    # Functions to export from this module
    FunctionsToExport = @('Get-File','Set-File','Test-File')
    
    # DSC Resources to export from this module
    DscResourcesToExport = @('NewFile')
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess.
    # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @(Power Plan, Energy, Battery)
    
            # A URL to the license for this module.
            # LicenseUri = ''
    
            # A URL to the main website for this project.
            # ProjectUri = ''
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
        } # End of PSData hashtable
    
    } 
}
```

## Test the Resource

After saving the class and manifest files in the folder structure described earlier, you can create
a DSC Configuration that uses the new DSC Resource. The following `Configuration` checks to see
whether the file at `/tmp/test.txt` exists and if the contents match the string provided by the
property **Content**. If not, the entire file is written.

```powershell
configuration MyConfig {
    Import-DSCResource -module NewFile
    NewFile testFile {
        Path = "/tmp/test.txt"
        Content = "DSC Rocks!"
        Ensure = "Present"
    }
}

MyConfig
```

### Declaring multiple class-based DSC Resources in a module

A module can define multiple class-based DSC Resources. You need to declare all classes in the same
`.psm1` file and include each name in the `.psd1` manifest.

```text
$env:ProgramFiles\PowerShell\Modules (folder)
    |- MyDscResource (folder)
        |- MyDscResource.psm1
            MyDscResource.psd1
```

## See Also

- [DSC Resources][1]

<!-- Reference Links -->

[1]: resources.md
[2]: /dotnet/api/system.datetime
