---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Writing a single-instance DSC resource (best practice)
description: >
  This article describes a best practice for defining a DSC resource that allows only a single
  instance in a configuration.
---

# Writing a single-instance DSC resource (best practice)

> [!NOTE]
> This article describes a best practice for defining a DSC resource that allows only a single
> instance in a configuration. Currently, there is no built-in DSC feature to do this. That might
> change in the future.

There are situations where you don't want to allow a resource to be used multiple times in a
configuration. For example, in a previous implementation of the [xTimeZone][1] resource, a
configuration could call the resource multiple times, setting the time zone to a different setting
in each resource block:

```powershell
configuration SetTimeZone {
    Param (
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

This is because of the way DSC resource keys work. A resource must have at least one **Key**
property. A resource instance is considered unique if the combination of the values of all of its
**Key** properties is unique. In its previous implementation, the [xTimeZone][1] resource had only
one property--**TimeZone**, which was a **Key**. Because of this, a configuration such as the one
above compiled and ran without warning. Each of the **xTimeZone** resource blocks is considered
unique. This caused the configuration to repeatedly apply to the node, cycling the timezone back and
forth.

To ensure that a Configuration could set the time zone for a target node only once, the resource was
updated to add a second property, **IsSingleInstance**, that became the **Key** property. The
**IsSingleInstance** was limited to a single value, `Yes`. The old MOF schema for the resource was:

```powershell
[ClassVersion("1.0.0.0"), FriendlyName("xTimeZone")]
class xTimeZone : OMI_BaseResource
{
    [Key, Description("Specifies the TimeZone.")] String TimeZone;
};
```

The updated MOF schema for the resource is:

```powershell
[ClassVersion("1.0.0.0"), FriendlyName("xTimeZone")]
class xTimeZone : OMI_BaseResource
{
    [Key, Description("Specifies the resource is a single instance, the value must be 'Yes'"), ValueMap{"Yes"}, Values{"Yes"}] String IsSingleInstance;
    [Required, Description("Specifies the TimeZone.")] String TimeZone;
};
```

The resource script was updated to use the new parameter. Here's how the resource script changed:

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

Notice that the **TimeZone** property is no longer a key. Now, if a configuration attempts to set
the time zone twice (by using two different **xTimeZone** blocks with different **TimeZone**
values), attempting to compile the configuration causes an error:

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
