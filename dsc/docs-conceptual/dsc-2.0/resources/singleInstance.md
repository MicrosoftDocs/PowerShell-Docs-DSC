---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Writing a single-instance DSC Resource
description: >
  This article describes a best practice for defining a DSC Resource that allows only a single
  instance in a DSC Configuration.
---

# Writing a single-instance DSC Resource

> [!NOTE]
> This article describes a best practice for defining a DSC resource that allows only a single
> instance in a DSC Configuration. There is no built-in DSC feature to do this. That might change in
> the future.

There are situations where you don't want to allow a DSC Resource to be used multiple times in a
DSC Configuration. For example, in a previous implementation of the [xTimeZone][1] DSC Resource, a
DSC Configuration could call the DSC Resource multiple times, setting the timezone to a different
setting in each DSC Resource block:

```powershell
Configuration SetTimeZone {
    param (
        [String[]]$NodeName = $env:COMPUTERNAME
    )

    Import-DSCResource -ModuleName xTimeZone

    Node $NodeName {
         xTimeZone TimeZoneExample {
            TimeZone = 'Eastern Standard Time'
         }

         xTimeZone TimeZoneExample2 {
            TimeZone = 'Pacific Standard Time'
         }
    }
}
```

This is because of how DSC Resource **Key** properties work. A DSC Resource must have at least one
**Key** property. A DSC Resource instance is considered unique if the combination of all its **Key**
properties' values is unique.

In its previous implementation, the [xTimeZone][1] DSC Resource had only one property--**TimeZone**,
which was a **Key**. Because of this, the example DSC Configuration compiled and ran without
warning. Each of the `xTimeZone` DSC Resource blocks was considered unique. This caused the DSC
Configuration to repeatedly apply to the system, cycling the timezone back and forth.

To ensure that a DSC Configuration could set the timezone for a system only once, the DSC Resource
was updated to add a second property, **IsSingleInstance**, that became the **Key** property. The
**IsSingleInstance** was limited to a single value, `Yes`. The old MOF schema for the DSC Resource
was:

```powershell
[ClassVersion("1.0.0.0"), FriendlyName("xTimeZone")]
class xTimeZone : OMI_BaseResource
{
    [Key, Description("Specifies the TimeZone.")] String TimeZone;
};
```

The updated MOF schema for the DSC Resource is:

```powershell
[ClassVersion("1.0.0.0"), FriendlyName("xTimeZone")]
class xTimeZone : OMI_BaseResource
{
    [Key, Description("Specifies the resource is a single instance, the value must be 'Yes'"), ValueMap{"Yes"}, Values{"Yes"}] String IsSingleInstance;
    [Required, Description("Specifies the TimeZone.")] String TimeZone;
};
```

The DSC Resource's implementation was updated to use the new parameter. Here's how it changed:

```powershell
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    #Get the current TimeZone
    $CurrentTimeZone = Get-TimeZone

    $returnValue = @{
        TimeZone = $CurrentTimeZone
        IsSingleInstance = 'Yes'
    }

    #Output the target resource
    $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    #Output the result of Get-TargetResource function.
    $CurrentTimeZone = Get-TimeZone

    Write-Verbose -Message "Replace the System Time Zone to $TimeZone"

    try
    {
        if($CurrentTimeZone -ne $TimeZone)
        {
            Write-Verbose -Verbose "Setting the TimeZone"
            Set-TimeZone -TimeZone $TimeZone
        }
        else
        {
            Write-Verbose -Verbose "TimeZone already set to $TimeZone"
        }
    }
    catch
    {
        $ErrorMsg = $_.Exception.Message
        Write-Verbose -Verbose $ErrorMsg
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    #Output from Get-TargetResource
    $CurrentTimeZone = Get-TimeZone

    if($TimeZone -eq $CurrentTimeZone)
    {
        return $true
    }
    else
    {
        return $false
    }
}

Function Get-TimeZone {
    [CmdletBinding()]
    param()

    & tzutil.exe /g
}

Function Set-TimeZone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $TimeZone
    )

    try
    {
        & tzutil.exe /s $TimeZone
    }
    catch
    {
        $ErrorMsg = $_.Exception.Message
        Write-Verbose $ErrorMsg
    }
}

Export-ModuleMember -Function *-TargetResource
```

Notice that the **TimeZone** property is no longer a **Key** property. Now, if a DSC Configuration
attempts to set the timezone twice (with two different `xTimeZone` blocks with different
**TimeZone** values), attempting to compile the DSC Configuration causes an error:

```Output
Write-Error:
Line |
 289 |          Test-ConflictingResources $keywordName $canonicalizedValue $k …
     |          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | A conflict was detected between resources '[xTimeZone]TimeZoneExample (C:\code\dsc\DscExample.ps1::9::10::xTimeZone)' and '[xTimeZone]TimeZoneExample2 (C:\code\dsc\DscExample.ps1::14::10::xTimeZone)' in node 'DESKTOP-KFLGVVP'. Resources have identical key properties but there are differences in the following non-key properties: 'TimeZone'. Values 'Eastern Standard Time' don't match values 'Pacific Standard Time'. Please update these property values so that they are identical in both cases.
InvalidOperation: Errors occurred while processing configuration 'SetTimeZone'.
```

<!-- Reference Links -->

[1]: https://github.com/PowerShell/xTimeZone
