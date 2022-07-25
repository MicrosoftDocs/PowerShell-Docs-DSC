---
ms.date: 07/08/2020
keywords:  dsc,powershell,configuration,setup
title:  Resource authoring checklist
description: This article contains a checklist of best practices that should be used when authoring a new DSC Resource.
---
# Resource authoring checklist

This checklist is a list of best practices when authoring a new DSC Resource.

## Resource module contains .psd1 file and schema.mof for every MOF resource

Check that your resource has correct structure and contains all required files. Every resource
module should contain a .psd1 file and every MOF resource should have schema.mof file.
MOF resources that do not contain schema will not be listed by `Get-DscResource` and users will not be
able to use the IntelliSense when writing code against those modules in VS Code. The directory structure
for xRemoteFile resource, which is part of the
[xPSDesiredStateConfiguration resource module](https://github.com/PowerShell/xPSDesiredStateConfiguration),
looks as follows:

```
xPSDesiredStateConfiguration
    DSCResources
        MSFT_xRemoteFile
            MSFT_xRemoteFile.psm1
            MSFT_xRemoteFile.schema.mof
    Examples
        xRemoteFile_DownloadFile.ps1
    ResourceDesignerScripts
        GenerateXRemoteFileSchema.ps1
    Tests
        ResourceDesignerTests.ps1
    xPSDesiredStateConfiguration.psd1
```

## Resource loads without errors

Check whether the resource module can be successfully loaded. This can be achieved manually, by
running `Import-Module <resource_module> -Force` and confirming that no errors occurred, or by
writing test automation. In case of the latter, you can follow this structure in your test case:

```powershell
$error = $null
Import-Module <resource_module> –Force
If ($error.count –ne 0) {
    Throw "Module was not imported correctly. Errors returned: $error"
}
```

## Resource is idempotent in the positive case

One of the fundamental characteristics of DSC resources is idempotence. It means that applying a DSC
configuration containing that resource multiple times will always achieve the same result. For
example, if we define a parameter hash for configuring the `Registry` resource:

```powershell
$DscParameters = @{
    Name       = 'Registry'
    ModuleName = 'PSDscResources'
    Property   = @{
        Key       = 'HKEY_CURRENT_USER\DscExample'
        Ensure    = 'Present'
        Force     = $true
        ValueName = 'Test'
        ValueData = 'Example'
        ValueType = 'String'
    }
}
$QueryParameters = @{
    Name       = 'Registry'
    ModuleName = 'PSDscResources'
    Property   = @{
        Key       = 'HKEY_CURRENT_USER\DscExample'
        ValueName = 'Test'
    }
}
```

After calling `Invoke-DscResource -Method Set` for the first time, the `DscExample` registry key
should appear in the `HKEY_CURRENT_USER` hive. Subsequent runs of the same configuration should not
change the state of the machine. To ensure a resource is idempotent you can repeatedly call
`Set-TargetResource` (for a MOF resource) or **Set** method (for a class-based resource)
when testing the resource directly, or call `Invoke-DscResource` multiple times when doing end to
end testing. The result should be the same after every run.

## Test user modification scenario

By changing the state of the machine and then rerunning DSC, you can verify that the **Set** and
**Test** methods function properly. Here are steps you should take:

1. Start with the resource not in the desired state.
1. Run `Invoke-DscResource -Method Set` with your resource
1. Verify `Invoke-DscResource -Method Test` returns True
1. Modify the configured item to be out of the desired state
1. Verify `Invoke-DscResource -Method Test` returns false

Here's a more concrete example using Registry resource:

1. Start with registry key not in the desired state.
1. Run `Invoke-DscResource -Method Test` with the desired state properties and ensure the result's
   **InDesiredState** property is false.
1. Run `Invoke-DscResource -Method Get` with the required properties and ensure the reported state
   does not match the desired state properties.
1. Run `Invoke-DscResource -Method Set` with the desired state properties and ensure it does not
   error.
1. Run `Invoke-DscResource -Method Test` again and ensure the result's **InDesiredState** property
   is now true.
1. Run `Invoke-DscResource -Method Get` again and ensure the reported state matches the desired
   state properties.
1. Modify the value of the key so that it is not in the desired state.
1. Run `Invoke-DscResource -Method Get` again verify the modified state.
1. Run `Invoke-DscResource -Method Test` again and verify it returns false.

`Get-TargetResource` should return details of the current state of the resource. Make sure to test
it by calling `Invoke-DscResource` with the **Get** method after you apply the configuration and
verifying that output correctly reflects the current state of the machine. It's important to test it
separately, since any issues in this area won't appear when calling `Invoke-DscResource` with the
**Set** method.

## Call resource functions and methods directly

Make sure you test the `*-TargetResource` functions (for MOF resources) and your **Get**,
**Set**, and **Test** methods (for class-based resources) by calling them directly and verifying
that they work as expected.

## Test compatibility on all DSC supported platforms

Resource should work on all DSC supported platforms. If your resource does not work on some of these
platforms by design, return a specific error message. Make sure your resource checks whether cmdlets
you are calling are present on particular machine.

## Verify on Windows Client (if applicable)

One very common test gap is verifying the resource only on server versions of Windows. Many
resources are also designed to work on Client SKUs, so if that's true in your case, don't forget to
test it on those platforms as well.

## Get-DSCResource lists the resource

After deploying the module, calling `Get-DscResource` should list your resource among others as a
result.

## Resource module contains examples

Creating quality examples which will help others understand how to use it. This is crucial,
especially since many users treat sample code as documentation.

First, you should determine the examples that will be included with the module. At minimum, you
should cover most important use cases for your resource.

If your module contains several resources that need to work together for an end-to-end scenario,
write the basic end-to-end example first.

The initial examples should be as simple as possible and show how to get started with your resources
in small manageable chunks, such as creating a new VHD. Later examples should build on earlier ones
(such as creating a VM from a VHD, removing VM, modifying VM), and show advanced functionality
(like creating a VM with dynamic memory).

For each example, write a short description which explains what it does, and the meaning of the
parameters.

Make sure examples cover most the important scenarios for your resource and if there's nothing
missing, verify that they all execute and put machine in the desired state.

## Error messages are easy to understand and help users solve problems

Good error messages should:

- Exist: Without an error message, a user won't even know something went wrong.
- Be human readable: No obscure error codes.
- Be precise: Describe the problem exactly.
- Be constructive: Provide advice how to fix the issue.
- Be polite: Don't blame user or make them feel bad.

Make sure you verify errors in end-to-end scenarios because they may differ from those returned when
running resource functions directly.

## Resource implementation does not contain hardcoded paths

Ensure there are no hardcoded paths in the resource implementation, particularly if they assume
language (en-us), or when there are system variables that can be used. If your resource needs to
access specific paths, use environment variables instead of hardcoding the path, as it may differ on
other machines.

Example:

Instead of:

```powershell
$tempPath = "C:\Users\kkaczma\AppData\Local\Temp\MyResource"
$programFilesPath = "C:\Program Files (x86)"
```

You can write:

```powershell
$tempPath = Join-Path $env:temp "MyResource"
$programFilesPath = ${env:ProgramFiles(x86)}
```

## Resource implementation does not contain user information

Make sure there are no email names, account information, or names of people in the code.

## Resource was tested with valid/invalid credentials

If your resource takes a credential as parameter:

- Verify the resource works when the account does not have access.
- Verify the resource works with a credential specified for Get, Set and Test
- If your resource accesses shares, test all the variants you need to support, such as:
  - Standard windows shares.
  - DFS shares.
  - SAMBA shares (if you want to support Linux.)

## Resource does not require interactive input

`*-TargetResource` functions and class-based resource methods should be executed automatically and
must not wait for user's input at any stage of execution (for example, you should not use
`Get-Credential` inside these definitions). If you need to provide a user's input, you should pass
it to the resource in the property hash when calling `Invoke-DscResource`.

## Resource functionality was thoroughly tested

This checklist contains items which are important to be tested and/or are often missed. There will
be numerous tests, mainly functional ones which will be specific to the resource you are testing and
are not mentioned here. Don't forget about negative test cases.
