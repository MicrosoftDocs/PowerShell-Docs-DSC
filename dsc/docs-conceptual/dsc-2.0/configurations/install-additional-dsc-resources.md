---
ms.date:  12/12/2018
keywords:  dsc,powershell,resource,gallery,setup
title:  Install Additional DSC Resources
description: This article covers how to find and install DSC resources from the PowerShell Gallery.
---

# Install Additional DSC Resources

Before you write a custom resource to solve your problem, you should look through the vast number of
DSC resources that have already been created by both Microsoft and the PowerShell community.

You can find DSC resources in both the [PowerShell Gallery](https://www.powershellgallery.com/) and
[GitHub](https://github.com/). You can also install DSC resources directly from the PowerShell
console using [PowerShellGet](/powershell/module/powershellget/).

## Installing PowerShellGet

To determine if you already have **PowerShell** get, or to get help installing it, see the following
guide: [Installing PowerShellGet](/powershell/scripting/gallery/installing-psget).

## Finding DSC resources using PowerShellGet

Once **PowerShellGet** is installed on your system, you can find and install DSC resources hosted in
the [PowerShell Gallery](https://www.powershellgallery.com/).

First, use the [Find-DSCResource](/powershell/module/powershellget/find-dscresource) cmdlet to find
DSC resources. When you run `Find-DSCResource` for the first time, you see the following prompt to
install the "NuGet provider".

```
PS> Find-DSCResource

NuGet provider is required to continue
PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based
repositories. The NuGet provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies'
or 'C:\Users\xAdministrator\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install
the NuGet provider by running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201
-Force'. Do you want PowerShellGet to install and import the NuGet provider now?
[Y] Yes  [N] No  [?] Help (default is "Y"):
```

After pressing 'y', the "NuGet" provider is installed, you see a list of DSC resources that you can
install from the PowerShell Gallery.

> [!NOTE]
> List is not shown because it is very large.

You can also specify the `-Name` parameter using wildcards, or `-Filter` parameter without wildcards
to narrow down your search. This example attempts to find a "TimeZone" DSC resource using the
wildcards.

> [!IMPORTANT]
> Currently there is a bug in the `Find-DSCResource` cmdlet that prevents using wildcards in both
> the `-Name` and `-Filter` parameters. The example below shows a workaround using
> `Where-Object`.

You can use `Where-Object` to find DSC resources with granular filtering.

```
PS> Find-DSCResource | Where-Object {$_.Name -like "Time*"}

Name                                Version    ModuleName                          Repository
----                                -------    ----------                          ----------
TimeZone                            8.5.0      ComputerManagementDsc               PSGallery
```

For more information on filtering, see
[Where-Object](/powershell/module/microsoft.powershell.core/where-object).

## Installing DSC Resources using PowerShellGet

To install a DSC resource, use the
[Install-Module](/powershell/module/PowershellGet/Install-Module) cmdlet, specifying the name of the
module shown under **Module** name in your search results.

The "TimeZone" resource exists in the "ComputerManagementDSC" module, so that is the module this
example installs.

> [!NOTE]
> If you have not trusted the PowerShell gallery, you see the warning below asking for confirmation,
> and instructing you how to avoid subsequent prompts on installs.

```
PS> Install-Module -Name ComputerManagementDSC

Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change
its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to
install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"):
```

Press 'y' to continue installing the module. After install, you can verify that your new resource is
installed using [Get-DSCResource](/powershell/module/PSDesiredStateConfiguration/Get-DscResource).

```
PS> Get-DSCResource -Name TimeZone -Module ComputerManagementDsc -Syntax

TimeZone [String] #ResourceName
{
    IsSingleInstance = [string]{ Yes }
    TimeZone = [string]
    [DependsOn = [string[]]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

You can also view other resources in your newly installed module, by specifying only the
**ModuleName** parameter.

```
PS> Get-DSCResource -Module ComputerManagementDSC

ImplementedAs Name                            Properties
------------- ----                            ----------
   PowerShell Computer                        {Name, Credential, DependsOn, Description…}
   PowerShell IEEnhancedSecurityConfiguration {Enabled, Role, DependsOn, PsDscRunAsCredential…}
   PowerShell OfflineDomainJoin               {IsSingleInstance, RequestFile, DependsOn, PsDscRun…
   PowerShell PendingReboot                   {Name, DependsOn, PsDscRunAsCredential, SkipCcmClie…
   PowerShell PowerPlan                       {IsSingleInstance, Name, DependsOn, PsDscRunAsCrede…
   PowerShell PowerShellExecutionPolicy       {ExecutionPolicy, ExecutionPolicyScope, DependsOn, …
   PowerShell RemoteDesktopAdmin              {IsSingleInstance, DependsOn, Ensure, PsDscRunAsCre…
   PowerShell ScheduledTask                   {TaskName, ActionArguments, ActionExecutable, Actio…
   PowerShell SmbServerConfiguration          {IsSingleInstance, AnnounceComment, AnnounceServer,…
   PowerShell SmbShare                        {Name, Path, CachingMode, ChangeAccess…}
   PowerShell SystemLocale                    {IsSingleInstance, SystemLocale, DependsOn, PsDscRu…
   PowerShell TimeZone                        {IsSingleInstance, TimeZone, DependsOn, PsDscRunAsC…
   PowerShell UserAccountControl              {IsSingleInstance, ConsentPromptBehaviorAdmin, Cons…
   PowerShell VirtualMemory                   {Drive, Type, DependsOn, InitialSize…}
   PowerShell WindowsCapability               {Name, DependsOn, Ensure, LogLevel…}
   PowerShell WindowsEventLog                 {LogName, CategoryResourceFile, DependsOn, IsEnable…
```

## See also

- [What are Resources?](../resources/resources.md)
