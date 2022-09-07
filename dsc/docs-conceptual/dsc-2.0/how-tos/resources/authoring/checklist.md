---
description: >
  This article contains a checklist of best practices that should be used when authoring a new DSC
  Resource.
ms.date: 08/15/2022
title:  DSC Resource authoring checklist
---
# DSC Resource authoring checklist

This checklist is a list of best practices when authoring a new DSC Resource.

## Module contains a manifest

Your module containing DSC Resources should have a module manifest (`.psd1`) file. The manifest's
**DscResourcesToExport** setting should list the name of every DSC Resource.

Any class-based DSC Resources you don't include in the **DscResourcesToExport** setting won't be
discoverable with the `Get-DscResource` cmdlet, can't be used with the `Invoke-DscResource` cmdlet,
and DSC Configuration authors won't get IntelliSense for those DSC Resources when authoring a DSC
Configuration in VS Code.

## Every MOF-based DSC Resource has a schema file

Check that your DSC Resource has the correct structure and contains all required files. Every
MOF-based DSC Resource should have a `schema.mof` file. MOF-based DSC Resourcess that don't have a
schema file won't be listed by `Get-DscResource` and DSC Configuration authors won't get
IntelliSense for those DSC Resources when authoring a DSC Configuration in VS Code.

The directory structure for the `xRemoteFile` DSC Resource, which is part of the
[xPSDesiredStateConfiguration][1] module, looks like this:

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

## DSC Resource loads without errors

DSC Resources should load without errors. To verify, run `Import-Module <resource_module> -Force`
and confirm that the command raises no errors.

## DSC Resource is idempotent

DSC Resources should be idempotent. A DSC Resource is idempotent when you can invoke the **Set**
method of a DSC Resource multiple times with the same properties and always achieve the same result.

For example, with this parameter hash defining the desired state of a registry key value with the
`Registry` DSC Resource from the **PSDscResources** module:

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
```

The first time you call `Invoke-DscResource -Method Set @DscParameters`, the `DscExample` registry
key should appear in the `HKEY_CURRENT_USER` hive with the **Test** value set to `Example`. Future
invocations shouldn't change the state of the system.

To ensure a resource is idempotent, you can test the resource directly or with `Invoke-DscResource`.

To test a MOF-based DSC Resource directly:

1. Run the DSC Resource's `Set-TargetResource` function.
1. Inspect the system state to verify that it's in the desired state without unwanted settings.
1. Run the DSC Resource's `Set-TargetResource function again. It shouldn't raise any errors.
1. Repeat steps 2-3 until you're satisfied that calling `Set-TargetResource` only sets the desired
   state as expected and without any errors.

To test a class-based DSC Resource directly:

1. Create a new instance of the DSC Resource's class and save it to a variable as an object.
1. Set each property's value to the desired state on the object.
1. Call the **Set** method on the object.
1. Inspect the system state to verify that it's in the desired state without unwanted settings.
1. Call the **Set** method on the object again. It shouldn't raise any errors.
1. Repeat steps 4-5 until you're satisfied that calling the **Set** method only sets the desired
   state as expected and without any errors.

To test a DSC Resource with `Invoke-DscResource`:

1. Run `Invoke-DscResource` with the **Set** method.
1. Inspect the system state to verify that it's in the desired state without unwanted settings.
1. Run `Invoke-DscResource` with the **Set** method.
1. Repeat steps 2-3 until you're satisfied that calling `Invoke-DscResource` with the **Set** method
   only sets the desired state as expected and without any errors.

## Test user modification scenario

DSC Resources should behave predictably even when users change the state of a system manually
outside of DSC. Here are steps you should take to verify your DSC Resource's behavior when a user
modifies the system:

1. Start with the system not in the desired state.
1. Run `Invoke-DscResource -Method Set` with your resource
1. Verify `Invoke-DscResource -Method Test` returns `$true`
1. Set the configured item to be out of the desired state
1. Verify `Invoke-DscResource -Method Test` returns `$false`

Here's a more concrete example using the `Registry` DSC Resource:

1. Start with registry key not in the desired state.
1. Run `Invoke-DscResource -Method Test` with the desired state properties and ensure the result's
   **InDesiredState** property is `$false`.
1. Run `Invoke-DscResource -Method Get` with the required properties and ensure the reported state
   doesn't match the desired state properties.
1. Run `Invoke-DscResource -Method Set` with the desired state properties and ensure it doesn't
   error.
1. Run `Invoke-DscResource -Method Test` again and ensure the result's **InDesiredState** property
   is now true.
1. Run `Invoke-DscResource -Method Get` again and ensure the reported state matches the desired
   state properties.
1. Set the value of the key so that it's not in the desired state.
1. Run `Invoke-DscResource -Method Get` again to verify the modified state.
1. Run `Invoke-DscResource -Method Test` again and verify it returns false.

## Call DSC Resource functions and methods directly

Make sure you test the `*-TargetResource` functions (for MOF-base DSC Resources) and the **Get**,
**Set**, and **Test** methods (for class-based DSC Resources) by calling them directly and verifying
that they work as expected.

## Test compatibility on every supported platform

DSC Resources should work on any platform DSC is supported on. If your DSC Resource doesn't work on
some of these platforms by design, return a specific error message. Make sure your DSC Resource
checks whether cmdlets you are calling are present on particular machine.

> [!NOTE]
> One common test gap is verifying the DSC Resource only on server versions of Windows. Often, DSC
> Resources are also designed to work on client SKUs. Make sure you test behavior for client SKUs or
> error if they're not supported by your DSC Resource.

## Get-DSCResource lists the DSC Resource

When your module is installed, `Get-DscResource` should include your DSC Resource in the cmdlet
output.

## Module contains examples

Create quality examples to help users understand how to use your DSC Resources. This is crucial, as
users often treat sample code as documentation.

First, determine what examples to include with your module. You should at least cover the most
important use cases for your DSC Resources.

If your module contains several DSC Resources that need to work together for an end-to-end scenario,
write the basic end-to-end example first.

Write your initial examples as basic and short as possible. Show how to get started with your
DSC Resources in small manageable chunks, such as creating a new VHD. Write later examples to build on
earlier ones (such as creating a VM from a VHD), and show advanced functionality (like creating a VM
with dynamic memory).

For every example:

- Write a short description explaining its purpose and how to use any parameters.
- Verify every example runs without unintentional errors or warnings and enforces the desired state.

## Error messages are understandable and help users solve problems

Good error messages should:

- Exist: Without an error message, a user won't even know something went wrong.
- Be human readable: No obscure error codes.
- Be precise: Describe the problem exactly.
- Be constructive: Provide advice how to fix the issue.
- Be polite: Don't blame user or make them feel bad.

Make sure you verify errors in end-to-end scenarios because they may differ from those returned when
running the functions (for MOF-based DSC Resources) or methods (for class-based DSC Resources)
directly.

## DSC Resource implementation doesn't contain hardcoded paths

Ensure there are no hardcoded paths in any DSC Resource implementation, especially if they assume a
language, like `en-US`. Use system environment variables when possible.

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

## DSC Resource implementation doesn't contain user information

DSC Resources should never include personally identifiable information in the code. Make sure there
are no email names, account information, or names of people in the code.

## Tested with valid and invalid credentials

If your DSC Resource takes a credential as parameter:

- Verify the DSC Resource behaves as expected when the account doesn't have access.
- Verify the DSC Resource works with a credential specified for **Get**, **Set** and **Test**.
- If your DSC Resource accesses shares, test all the variants you need to support, such as:
  - Standard windows shares
  - DFS shares
  - SAMBA shares (if you want to support Linux)

## DSC Resource doesn't require interactive input

DSC Resources should never prompt for input. Instead, all required values should be properties of
the DSC Resource. For example, instead of prompting the user with `Get-Credential`, add a
**Credential** property to your DSC Resource.

## Test thoroughly

This checklist contains items that are important to be tested and are often missed. You should also
write functional and end-to-end test cases for your DSC Resource to ensure expected behaviors. Make
sure to use negative test cases and test for invalid input.

<!-- Reference Links -->

[1]: https://github.com/PowerShell/xPSDesiredStateConfiguration
