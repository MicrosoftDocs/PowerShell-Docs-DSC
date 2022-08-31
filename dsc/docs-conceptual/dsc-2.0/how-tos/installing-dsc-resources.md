---
ms.date: 08/15/2022
keywords:  dsc,powershell,resource,gallery,setup
title:  Installing DSC Resources
description: >
  This article covers how to find and install DSC Resources from the PowerShell Gallery.
---

# Installing DSC Resources

> Applies To: PowerShell 7.2

Before you write a DSC Resource to solve your problem, you should look through the DSC Resources
that have already been created by both Microsoft and the PowerShell community.

You can find DSC Resources on both the [PowerShell Gallery][1] and [GitHub][2]. You can also install
DSC Resources directly from the PowerShell console using [PowerShellGet][3].

## Installing PowerShellGet

To determine if you already have **PowerShellGet**, or to get help installing it, see the following
guide: [Installing PowerShellGet][4].

## Finding DSC resources using PowerShellGet

Once **PowerShellGet** is installed on your system, you can find and install DSC Resources hosted in
the [PowerShell Gallery][1].

First, use the [Find-DSCResource][5] cmdlet to find DSC Resources. When you run `Find-DSCResource`
for the first time, you may see the following prompt to install the NuGet provider.

```powershell
Find-DSCResource
```

```Output
NuGet provider is required to continue
PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based
repositories. The NuGet provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies'
or 'C:\Users\xAdministrator\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install
the NuGet provider by running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201
-Force'. Do you want PowerShellGet to install and import the NuGet provider now?
[Y] Yes  [N] No  [?] Help (default is "Y"):
```

After pressing <kbd>y</kbd>, the NuGet provider is installed and you see a list of DSC Resources
that you can install from the PowerShell Gallery.

> [!NOTE]
> The list isn't shown here because it's hundreds of items long.

You can also specify the **Name** parameter using wildcards, or the **Filter** parameter without
wildcards to narrow your search. This example attempts to find a `TimeZone` DSC Resource using
wildcards.

> [!IMPORTANT]
> There is a bug in the `Find-DSCResource` cmdlet that prevents using wildcards in both the **Name**
> and **Filter** parameters. The example below shows a workaround using `Where-Object`.

You can use `Where-Object` to find DSC Resources with granular filtering.

```powershell
Find-DSCResource | Where-Object Name -Like 'Time*'
```

```Output
Name                                Version    ModuleName                          Repository
----                                -------    ----------                          ----------
TimeZone                            8.5.0      ComputerManagementDsc               PSGallery
```

For more information on filtering, see [Where-Object][6].

## Installing DSC Resources using PowerShellGet

To install a DSC Resource, use the [Install-Module][7] cmdlet, specifying the name of the module
shown under the **Module** property in your search results.

The `TimeZone` DSC Resource exists in the **ComputerManagementDSC** module, so that's the module
this example installs.

> [!NOTE]
> If you haven't trusted the PowerShell gallery, you see the warning below asking for confirmation,
> and instructing you how to avoid future prompts on installs.

```powershell
Install-Module -Name ComputerManagementDSC
```

```Output
Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change
its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to
install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"):
```

Press <kbd>y</kbd> to continue installing the module. After install, you can verify that your new
DSC Resource is installed using [Get-DSCResource][8].

```powershell
Get-DSCResource -Name TimeZone -Module ComputerManagementDsc -Syntax
```

```Output
TimeZone [String] #ResourceName
{
    IsSingleInstance = [string]{ Yes }
    TimeZone = [string]
    [DependsOn = [string[]]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

Specify the **ModuleName** parameter alone to view other DSC Resources in your newly installed
module.

```powershell
Get-DSCResource -Module ComputerManagementDSC
```

```Output
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

- [DSC Resources][9]

<!-- Reference Links -->

[1]: https://www.powershellgallery.com/
[2]: https://github.com/
[3]: /powershell/module/powershellget/
[4]: /powershell/scripting/gallery/installing-psget
[5]: /powershell/module/powershellget/find-dscresource
[6]: /powershell/module/microsoft.powershell.core/where-object
[7]: /powershell/module/PowershellGet/Install-Module
[8]: /powershell/module/PSDesiredStateConfiguration/Get-DscResource
[9]: ../concepts/resources.md
