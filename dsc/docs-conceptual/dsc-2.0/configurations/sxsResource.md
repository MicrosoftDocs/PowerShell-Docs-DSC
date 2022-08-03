---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Import a specific version of an installed resource
description: >
  This article shows how to install and import specific versions of resource modules into your
  configurations.
---

# Import a specific version of an installed resource

> Applies To: PowerShell 7.2

Separate versions of DSC resources can be installed on a computer side by side. A resource module
can store separate versions of a resource in version-named folders.

## Installing separate resource versions side by side

You can use the **MinimumVersion**, **MaximumVersion**, and **RequiredVersion** parameters of the
[Install-Module][1] cmdlet to specify which version of a module to install. Calling `Install-Module`
without specifying a version installs the most recent version.

For example, there are multiple versions of the **xFailOverCluster** module, each of which contains
an `xCluster` resource. Calling `Install-Module` without specifying the version number installs
the most recent version of the module.

```powershell
Install-Module xFailOverCluster
Get-DscResource xCluster
```

```Output
ImplementedAs   Name          ModuleName           Version    Properties
-------------   ----          ----------           -------    ----------
PowerShell      xCluster      xFailOverCluster     1.2.0.0    {DomainAdministratorCredential, ...
```

To install a specific version of a module, specify a **RequiredVersion**. This installs the
specified version side by side with the installed version.

```powershell
Install-Module xFailOverCluster -RequiredVersion 1.1
```

Now, you see both version of the module listed when you use `Get-DSCResource`.

```powershell
Get-DscResource xCluster
```

```Output
ImplementedAs   Name          ModuleName            Version    Properties
-------------   ----          ----------            -------    ----------
PowerShell      xCluster      xFailOverCluster      1.1        {DomainAdministratorCredential, Name, ...
PowerShell      xCluster      xFailOverCluster      1.2.0.0    {DomainAdministratorCredential, Name, ...
```

## Specifying a resource version in a configuration

If you have separate resource versions installed on a computer, you must specify the version of that
resource when you use it in a Configuration. You do this by specifying the **ModuleVersion**
parameter of the `Import-DscResource` keyword. If you import a resource without specifying a version
and you have more than one version of that resource installed, the Configuration errors when
compiling.

The following Configuration shows how to specify the version of the resource to use:

```powershell
configuration VersionTest {
    Import-DscResource -ModuleName xFailOverCluster -ModuleVersion 1.1

    Node 'localhost' {
       xCluster ClusterTest {
            Name                          = 'TestCluster'
            StaticIPAddress               = '10.0.0.3'
            DomainAdministratorCredential = Get-Credential
        }
     }
}
```

## See also

- [DSC Configurations][2]
- [DSC Resources][3]

<!-- Reference Links -->

[1]: /powershell/module/PowershellGet/Install-Module
[2]: configurations.md
[3]: ../resources/resources.md
