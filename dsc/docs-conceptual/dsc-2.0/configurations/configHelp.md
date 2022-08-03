---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Writing help for DSC Configurations
description: >
  You can use comment-based help in DSC configurations. Users can access the help by calling the
  Configuration with `-?` parameter or by using the Get-Help cmdlet.
---

# Writing help for DSC configurations

> Applies To: PowerShell 7.2

You can use comment-based help with Configurations. Access the help by calling the
Configuration with `-?`, or by using the
[Get-Help][1] cmdlet. Place your comment-based
help directly above the `configuration` keyword. You can place parameter help in-line with your
comment block, directly above the parameter declaration, or both as in the example below.

For more information about comment-based help, see [about_Comment_Based_Help][2].

> [!NOTE]
> PowerShell development environments, like VS Code, also have snippets to
> automatically insert comment block templates.

The following example shows a script that contains a configuration and comment-based help for it.
This example shows a Configuration with parameters. To learn more about using parameters in your
Configurations, see [Add Parameters to your Configurations][3].

```powershell
<#
.SYNOPSIS
A brief description of the configuration.

.DESCRIPTION
A detailed description of the configuration.

.PARAMETER ComputerName

The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or
script syntax.

Type the parameter name on the same line as the .PARAMETER keyword. Type the parameter description
on the lines following the .PARAMETER keyword. PowerShell interprets all text between the .PARAMETER
line and the next keyword or the end of the comment block as part of the parameter description. The
description can include paragraph breaks.

The Parameter keywords can appear in any order in the comment block, but the configuration syntax
determines the order in which the parameters (and their descriptions) appear in help topic. To
change the order, change the syntax.

.EXAMPLE
HelpSample -ComputerName localhost

A sample command that uses the configuration, optionally followed by sample output and a
description. Repeat this keyword for each example. PowerShell automatically prefaces the first line
with a PowerShell prompt. Additional lines are treated as output and description. The example can
contain spaces, newlines and PowerShell code.

If you have multiple examples, there is no need to number them. PowerShell will number the examples
in help text.

.EXAMPLE
HelpSample -FilePath "C:\output.txt"

This example will be labeled "EXAMPLE 2" when help is displayed to the user.
#>
configuration HelpSample1 {
    param (
        [string]$ComputerName = 'localhost',
        # Provide a PARAMETER section for each parameter that your script or function accepts.
        [string]$FilePath = 'C:\Destination.txt'
    )

    Node $ComputerName {
        File HelloWorld
        {
            Contents="Hello World"
            DestinationPath = $FilePath
        }
    }
}
```

## Viewing configuration help

To view the help for a Configuration, use the `Get-Help` cmdlet with the name of the Configuration,
or type the name of the Configuration followed by `-?`. The following is the output of the previous
Configuration passed to `Get-Help`.

```powershell
Get-Help HelpSample1 -Detailed
```

```Output
NAME
    HelpSample1

SYNOPSIS
    A brief description of the configuration.

SYNTAX
    HelpSample1 [[-InstanceName] <String>] [[-DependsOn] <String[]>] [[-PsDscRunAsCredential] <PSCredential>] [[-OutputPath] <String>] [[-ConfigurationData] <Hashtable>] [[-ComputerName] <String>] [[-FilePath] <String>] [<CommonParameters>]

DESCRIPTION
    A detailed description of the configuration.

PARAMETERS
    -InstanceName <String>

    -DependsOn <String[]>

    -PsDscRunAsCredential <PSCredential>

    -OutputPath <String>

    -ConfigurationData <Hashtable>

    -ComputerName <String>
        The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or
        script syntax.

        Type the parameter name on the same line as the .PARAMETER keyword. Type the parameter description
        on the lines following the .PARAMETER keyword. PowerShell interprets all text between the .PARAMETER
        line and the next keyword or the end of the comment block as part of the parameter description. The
        description can include paragraph breaks.

        The Parameter keywords can appear in any order in the comment block, but the configuration syntax
        determines the order in which the parameters (and their descriptions) appear in help topic. To
        change the order, change the syntax.

    -FilePath <String>
        Provide a PARAMETER section for each parameter that your script or function accepts.

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------

    PS > HelpSample -ComputerName localhost

    A sample command that uses the configuration, optionally followed by sample output and a
    description. Repeat this keyword for each example. PowerShell automatically prefaces the first line
    with a PowerShell prompt. Additional lines are treated as output and description. The example can
    contain spaces, newlines and PowerShell code.

    If you have multiple examples, there is no need to number them. PowerShell will number the examples
    in help text.

    -------------------------- EXAMPLE 2 --------------------------

    PS > HelpSample -FilePath "C:\output.txt"

    This example will be labeled "EXAMPLE 2" when help is displayed to the user.

REMARKS
    To see the examples, type: "Get-Help HelpSample1 -Examples"
    For more information, type: "Get-Help HelpSample1 -Detailed"
    For technical information, type: "Get-Help HelpSample1 -Full"
```

> [!NOTE]
> Syntax fields and parameter attributes are automatically generated for you by PowerShell.

## See Also

- [DSC Configurations][4]
- [Write and compile a Configuration][5]
- [Add parameters to a Configuration][3]

<!-- Reference Links -->

[1]: /powershell/module/Microsoft.PowerShell.Core/Get-Help
[2]: /powershell/module/microsoft.powershell.core/about/about_comment_based_help
[3]: add-parameters-to-a-configuration.md
[4]: configurations.md
[5]: write-compile-configuration.md
