---
ms.date: 12/01/2023
ms.topic: reference
title: DSC Script Resource
description: DSC Script Resource
---
# DSC Script Resource

> Applies To: Windows PowerShell 4.0, Windows PowerShell 5.x

The `Script` resource in Windows PowerShell Desired State Configuration (DSC) provides a mechanism
to run Windows PowerShell script blocks on target nodes. The `Script` resource uses `GetScript`
`SetScript`, and `TestScript` properties that contain script blocks you define to perform the
corresponding DSC state operations.

> [!TIP]
> Where possible, it's best practice to use a defined DSC resource instead of this one. The `Script`
> resource has drawbacks that make it more difficult to test, maintain, and predict.
>
> Unlike other DSC resources, every property for a `Script` resource is a key property and the
> **Get** method for this resource can only return a single string for the current state. There are
> no guarantees that this resource is implemented idempotently or that it'll work as expected on
> any system because it uses custom code. It can't be tested without being invoked on a target
> system.
>
> Before using the `Script` resource, consider whether you can [author a resource][01] instead.
> Using well-defined DSC resources makes your configurations more readable and maintainable.

[!INCLUDE [Updated DSC Resources](../../../../../includes/dsc-resources.md)]

## Syntax

```Syntax
Script [string] #ResourceName
{
    GetScript = [string]
    SetScript = [string]
    TestScript = [string]
    [ Credential = [PSCredential] ]
    [ DependsOn = [string[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```

> [!NOTE]
> `GetScript` `TestScript`, and `SetScript` blocks are stored as strings.

## Properties

|  Property  |                                          Description                                          |
| ---------- | --------------------------------------------------------------------------------------------- |
| GetScript  | A script block that returns the current state of the Node.                                    |
| SetScript  | A script block that DSC uses to enforce compliance when the Node isn't in the desired state.  |
| TestScript | A script block that determines if the Node is in the desired state.                           |
| Credential | Indicates the credentials to use for running this script, if credentials are required.        |

## Common properties

|       Property       |                                            Description                                            |
| -------------------- | ------------------------------------------------------------------------------------------------- |
| DependsOn            | Indicates that the configuration of another resource must run before this resource is configured. |
| PsDscRunAsCredential | Sets the credential for running the entire resource as.                                           |

> [!NOTE]
> The **PsDscRunAsCredential** common property was added in WMF 5.0 to allow running any DSC
> resource in the context of other credentials. For more information, see
> [Use Credentials with DSC Resources][02].

### Additional information

#### GetScript

DSC doesn't use the output from `GetScript` The [Get-DscConfiguration][03] cmdlet executes
`GetScript` to retrieve a node's current state. A return value isn't required from `GetScript` If
you specify a return value, it must be a hashtable containing a **Result** key whose value is a
String.

#### TestScript

DSC executes `TestScript` to determine if `SetScript` should be run. If `TestScript` returns
`$false`, DSC executes `SetScript` to bring the node back to the desired state. It must return a
boolean value. A result of `$true` indicates that the node is compliant and `SetScript` shouldn't
execute.

The [Test-DscConfiguration][04] cmdlet executes `TestScript` to retrieve the nodes compliance with
the `Script` resources. However, in this case, `SetScript` doesn't run, no matter what `TestScript`
block returns.

> [!NOTE]
> All output from your `TestScript` is part of its return value. PowerShell interprets unsuppressed
> output as non-zero, which means that your `TestScript` returns `$true` regardless of your node's
> state. This results in unpredictable results, false positives, and causes difficulty during
> troubleshooting.

#### SetScript

`SetScript` modifies the node to enforce the desired state. DSC calls `SetScript` if the
`TestScript` script block returns `$false`. The `SetScript` should have no return value.

## Examples

### Example 1: Write sample text using a Script resource

This example tests for the existence of `C:\TempFolder\TestFile.txt` on each node. If it doesn't
exist, it creates it using the `SetScript`. The `GetScript` returns the contents of the file, and
its return value isn't used.

```powershell
Configuration ScriptTest
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {
        Script ScriptExample
        {
            SetScript = {
                $sw = New-Object System.IO.StreamWriter("C:\TempFolder\TestFile.txt")
                $sw.WriteLine("Some sample string")
                $sw.Close()
            }
            TestScript = { Test-Path "C:\TempFolder\TestFile.txt" }
            GetScript = { @{ Result = (Get-Content C:\TempFolder\TestFile.txt) } }
        }
    }
}
```

### Example 2: Compare version information using a Script resource

This example retrieves the _compliant_ version information from a text file on the authoring
computer and stores it in the `$version` variable. When generating the node's MOF file, DSC
replaces the `$using:version` variables in each script block with the value of the `$version`
variable. During execution, the _compliant_ version is stored in a text file on each Node and
compared and updated on subsequent executions.

```powershell
$version = Get-Content 'version.txt'

Configuration ScriptTest
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {
        Script UpdateConfigurationVersion
        {
            GetScript = {
                $currentVersion = Get-Content (Join-Path -Path $env:SYSTEMDRIVE -ChildPath 'version.txt')
                return @{ 'Result' = "$currentVersion" }
            }
            TestScript = {
                # Create and invoke a scriptblock using the $GetScript automatic variable, which contains a string representation of the GetScript.
                $state = [scriptblock]::Create($GetScript).Invoke()

                if( $state.Result -eq $using:version )
                {
                    Write-Verbose -Message ('{0} -eq {1}' -f $state.Result,$using:version)
                    return $true
                }
                Write-Verbose -Message ('Version up-to-date: {0}' -f $using:version)
                return $false
            }
            SetScript = {
                $using:version | Set-Content -Path (Join-Path -Path $env:SYSTEMDRIVE -ChildPath 'version.txt')
            }
        }
    }
}
```

### Example 3: Utilizing parameters in a Script resource

This example accesses parameters from within the Script resource by making use of the `using`
scope. **ConfigurationData** can be accessed in a similar way. Like example 2, the implementation
expects a version to be stored inside a local file on the target node. Both the local path and the
version are configurable, decoupling code from configuration data.

```powershell
Configuration ScriptTest
{
    param
    (
        [Version]
        $Version,

        [string]
        $FilePath
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {
        Script UpdateConfigurationVersion
        {
            GetScript = {
                $currentVersion = Get-Content -Path $using:FilePath
                return @{ 'Result' = "$currentVersion" }
            }
            TestScript = {
                # Create and invoke a scriptblock using the $GetScript automatic variable,
                # which contains a string representation of the GetScript.
                $state = [scriptblock]::Create($GetScript).Invoke()

                if( $state['Result'] -eq $using:Version )
                {
                    Write-Verbose -Message ('{0} -eq {1}' -f $state['Result'],$using:version)
                    return $true
                }

                Write-Verbose -Message ('Version up-to-date: {0}' -f $using:version)
                return $false
            }
            SetScript = {
                Set-Content -Path $using:FilePath -Value $using:Version
            }
        }
    }
}
```

The resulting MOF file includes the variables and their values accessed through the `using` scope.
They're injected into each scriptblock, which uses the variables. Test and Set scripts are removed
for brevity:

```Output
instance of MSFT_ScriptResource as $MSFT_ScriptResource1ref
{
 GetScript = "$FilePath ='C:\\Config.ini'\n\n $currentVersion = Get-Content -Path $FilePath\n return @{ 'Result' = \"$currentVersion\" }\n";
 TestScript = ...;
 SetScript = ...;
};
```

### Known Limitations

- Credentials being passed within a script resource aren't always reliable when using a pull or
  push server model. Use a full resource rather than use a script resource in this case.

[01]: ../../../resources/authoringResource.md

[02]: ../../../configurations/runasuser.md
[03]: /powershell/module/PSDesiredStateConfiguration/Get-DscConfiguration
[04]: /powershell/module/PSDesiredStateConfiguration/Test-DscConfiguration