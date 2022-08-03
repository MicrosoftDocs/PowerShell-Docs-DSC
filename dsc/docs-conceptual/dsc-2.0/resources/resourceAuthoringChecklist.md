---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Resource authoring checklist
description: >
  This article contains a checklist of best practices that should be used when authoring a new DSC
  Resource.
---
# Resource authoring checklist

This checklist is a list of best practices when authoring a new DSC Resource.

## Resource module contains .psd1 file and schema.mof for every MOF resource

Check that your resource has correct structure and contains all required files. Every resource
module should contain a `.psd1` file and every MOF resource should have `schema.mof` file. MOF
resources that do not contain schema will not be listed by `Get-DscResource` and users will not be
able to use IntelliSense for them when authoring Configurations in VS Code.

The directory structure for the `xRemoteFile` resource, which is part of the
[xPSDesiredStateConfiguration][1] resource module, looks like this:

```text
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

Resources should load without errors. To verify, run `Import-Module <resource_module> -Force` and
confirm that the command raises no errors.

## Resource is idempotent

Resources should be idempotent. A resource is idempotent when you can invoke the **Set** method of a
DSC resource multiple times with the same properties and always achieve the same result.

For example, with these parameter hashes defining a configuration of the `Registry` resource:

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

The first time you call `Invoke-DscResource -Method Set`, the `DscExample` registry key should
appear in the `HKEY_CURRENT_USER` hive. Subsequent invocations should not change the state of the
machine.

To ensure a resource is idempotent, you can repeatedly call `Set-TargetResource` (for a MOF
resource) or the **Set** method (for a class-based resource) when testing the resource directly. You
can also call `Invoke-DscResource` multiple times when doing end to end testing. The result should
be the same after every run.

## Test user modification scenario

Resources should behave predictably even when users change the state of a node manually outside of
DSC. Here are steps you should take to verify your resource's functionality when a user modifies the
node:

1. Start with the resource not in the desired state.
1. Run `Invoke-DscResource -Method Set` with your resource
1. Verify `Invoke-DscResource -Method Test` returns True
1. Modify the configured item to be out of the desired state
1. Verify `Invoke-DscResource -Method Test` returns false

Here's a more concrete example using `Registry` resource:

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

`Invoke-DscResource` with the **Get** method should return details of the current state of the
resource. Make sure to test it by calling `Invoke-DscResource` with the **Get** method after you set
the configuration and verifying that the output correctly reflects the current state of the machine.
It's important to test this separately, since any issues in this area won't appear when calling
`Invoke-DscResource` with the **Set** method.

## Call resource functions and methods directly

Make sure you test the `*-TargetResource` functions (for MOF resources) and the **Get**, **Set**,
and **Test** methods (for class-based resources) by calling them directly and verifying that they
work as expected.

## Test compatibility on every supported platform

Resources should work on platform DSC is supported on. If your resource does not work on some of
these platforms by design, return a specific error message. Make sure your resource checks whether
cmdlets you are calling are present on particular machine.

> [!NOTE]
> One common test gap is verifying the resource only on server versions of Windows. Many resources
> are also designed to work on client SKUs. Make sure you test functionality for client SKUs or
> error if they are not supported by your resource.

## Get-DSCResource lists the resource

When your module is installed, `Get-DscResource` should include your resource in the cmdlet output.

## Resource module contains examples

Create quality examples to help users understand how to use your resource. This is crucial, as many
users treat sample code as documentation.

First, determine what examples to include with your module. You should at least cover the most
important use cases for your resource.

If your module contains several resources that need to work together for an end-to-end scenario,
write the basic end-to-end example first.

Write your initial examples as basic and short as possible. Show how to get started with your
resources in small manageable chunks, such as creating a new VHD. Write later examples to build on
earlier ones (such as creating a VM from a VHD), and show advanced functionality (like creating a VM
with dynamic memory).

For every example:

- Write a short description explaining its purpose and how to use the parameters.
- Verify every example runs without unintentional errors or warnings and enforces configuration.

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
language (en-us). Use system environment variables when possible.

For example, instead of:

```powershell
$tempPath = "C:\Users\kkaczma\AppData\Local\Temp\MyResource"
$programFilesPath = "C:\Program Files (x86)"
```

Write:

```powershell
$tempPath = Join-Path $env:temp "MyResource"
$programFilesPath = ${env:ProgramFiles(x86)}
```

## Resource implementation does not contain user information

Resources should never include personally identifiable information in the code. Make sure there are
no email names, account information, or names of people in the code.

## Resource was tested with valid/invalid credentials

If your resource takes a credential as parameter:

- Verify the resource behaves as expected when the account does not have access.
- Verify the resource works with a credential specified for Get, Set and Test.
- If your resource accesses shares, test all the variants you need to support, such as:
  - Standard windows shares
  - DFS shares
  - SAMBA shares (if you want to support Linux)

## Resource does not require interactive input

Resource functions and methods should never prompt for input. Instead, all required values should be
properties of the resource. For example, instead of prompting the user with `Get-Credential`, add a
**Credential** property to the resource.

## Resource functionality was thoroughly tested

This checklist contains items which are important to be tested and/or are often missed. You should
also write functional and end-to-end test cases for your resource to ensure expected behaviors. Make
sure to use negative test cases and test for invalid input.

<!-- Reference Links -->

[1]: https://github.com/PowerShell/xPSDesiredStateConfiguration
