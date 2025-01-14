---
ms.date:  06/12/2017
keywords:  dsc,powershell,configuration,setup
title:  Using DSC on Nano Server
description: DSC is an optional package that can be installed when you create a VHD for a Windows Nano Server.
---

# Using DSC on Nano Server

> Applies To: Windows PowerShell 5.0

**DSC on Nano Server** is an optional package in the `NanoServer\Packages` folder of the Windows
Server 2016 media. The package can be installed when you create a VHD for a Nano Server by
specifying **Microsoft-NanoServer-DSC-Package** as the value of the **Packages** parameter of the
**New-NanoServerImage** function. For example, if you are creating a VHD for a virtual machine, the
command would look like the following:

```powershell
New-NanoServerImage -Edition Standard -DeploymentType Guest -MediaPath f:\ -BasePath .\Base -TargetPath .\Nano1\Nano.vhd -ComputerName Nano1 -Packages Microsoft-NanoServer-DSC-Package
```

For information about installing and using Nano Server, as well as how to manage Nano Server with
PowerShell Remoting, see [Getting Started with Nano Server][N12].

## DSC features available on Nano Server

Because Nano Server supports only a limited set of APIs compared to a full version of Windows
Server, DSC on Nano Server does not have full functional parity with DSC running on full SKUs for
the time being. DSC on Nano Server is in active development and is not yet feature complete.

The following DSC features are currently available on Nano Server:

Both push and pull modes

- All DSC cmdlets that exist on a full version of Windows Server, including the following:
- [Get-DscLocalConfigurationManager][N18]
- [Set-DscLocalConfigurationManager][N25]
- [Enable-DscDebug][N15]
- [Disable-DscDebug][N14]
- [Start-DscConfiguration][N26]
- [Stop-DscConfiguration][N27]
- [Get-DscConfiguration][N16]
- [Test-DscConfiguration][N28]
- [Publish-DscConfiguration][N22]
- [Update-DscConfiguration][N29]
- [Restore-DscConfiguration][N24]
- [Remove-DscConfigurationDocument][N23]
- [Get-DscConfigurationStatus][N17]
- [Invoke-DscResource][N20]
- [Find-DscResource][N13]
- [Get-DscResource][N19]
- [New-DscChecksum][N21]

- Compiling configurations (see [DSC configurations][N01])

  **Issue:** Password encryption (see [Securing the MOF File][N09]) during configuration compilation
  doesn't work.

- Compiling metaconfigurations (see [Configuring the Local Configuration Manager][N05])

- Running a resource under user context (see [Running DSC with user credentials (RunAs)][N03])

- Class-based resources (see [Writing a custom DSC resource with PowerShell classes][N11]))

- Debugging of DSC resources (see [Debugging DSC resources][N10])

  **Issue:** Doesn't work if a resource is using PsDscRunAsCredential (see
  [Running DSC with user credentials][N03])

- [Specifying cross-node dependencies][N02]

- [Resource versioning][N04]

- Pull client (configurations & resources) (see
  [Setting up a pull client using configuration names][N07])

- [Partial configurations (pull & push)][N06]

- [Reporting to pull server][N08]

- MOF encryption

- Event logging

- Azure Automation DSC reporting

- Resources that are fully functional

  - **Archive**
  - **Environment**
  - **File**
  - **Log**
  - **ProcessSet**
  - **Registry**
  - **Script**
  - **WindowsPackageCab**
  - **WindowsProcess**
  - **WaitForAll** (see [Specifying cross-node dependencies][N02])
  - **WaitForAny** (see [Specifying cross-node dependencies][N02])
  - **WaitForSome** (see [Specifying cross-node dependencies][N02])

- Resources that are partially functional

  - **Group**
  - **GroupSet**

    **Issue:** Above resources fail if specific instance is called twice (running the same
    configuration twice)

  - **Service**
  - **ServiceSet**

    **Issue:** Only works for starting/stopping (status) service. Fails, if one tries to change
    other service attributes like startuptype, credentials, description etc.. The error thrown is
    similar to:

    ```Output
    Cannot find type [management.managementobject]: verify that the assembly containing
    this type is loaded.
    ```

- Resources that are not functional

  - **User**

## DSC features not available on Nano Server

The following DSC features are not currently available on Nano Server:

- Decrypting MOF document with encrypted password(s)
- Pull Server--you cannot currently set up a pull server on Nano Server
- Anything that is not in the list of feature works

## Using custom DSC resources on Nano Server

Due to a limited sets of Windows APIs and CLR libraries available on Nano Server, DSC resources that
work on the full CLR version of Windows do not necessarily work on Nano Server. Complete end-to-end
testing before deploying any DSC custom resources to a production environment.

## See Also

- [Getting Started with Nano Server][N12]

<!-- link references -->
[N01]: ../configurations/configurations.md
[N02]: ../configurations/crossNodeDependencies.md
[N03]: ../configurations/runAsUser.md
[N04]: ../configurations/sxsResource.md
[N05]: ../managing-nodes/metaConfig.md
[N06]: ../pull-server/partialConfigs.md
[N07]: ../pull-server/pullClientConfigNames.md
[N08]: ../pull-server/reportServer.md
[N09]: ../pull-server/secureMOF.md
[N10]: ../troubleshooting/debugResource.md
[N11]: ../resources/authoringresourceclass.md
[N12]: /windows-server/get-started/getting-started-with-nano-server
[N13]: xref:PowerShellGet.Find-DscResource
[N14]: xref:PSDesiredStateConfiguration.Disable-DscDebug
[N15]: xref:PSDesiredStateConfiguration.Enable-DscDebug
[N16]: xref:PSDesiredStateConfiguration.Get-DscConfiguration
[N17]: xref:PSDesiredStateConfiguration.Get-DscConfigurationStatus
[N18]: xref:PSDesiredStateConfiguration.Get-DscLocalConfigurationManager
[N19]: xref:PSDesiredStateConfiguration.Get-DscResource
[N20]: xref:PSDesiredStateConfiguration.Invoke-DscResource
[N21]: xref:PSDesiredStateConfiguration.New-DSCCheckSum
[N22]: xref:PSDesiredStateConfiguration.Publish-DscConfiguration
[N23]: xref:PSDesiredStateConfiguration.Remove-DscConfigurationDocument
[N24]: xref:PSDesiredStateConfiguration.Restore-DscConfiguration
[N25]: xref:PSDesiredStateConfiguration.Set-DscLocalConfigurationManager
[N26]: xref:PSDesiredStateConfiguration.Start-DscConfiguration
[N27]: xref:PSDesiredStateConfiguration.Stop-DscConfiguration
[N28]: xref:PSDesiredStateConfiguration.Test-DscConfiguration
[N29]: xref:PSDesiredStateConfiguration.Update-DscConfiguration
