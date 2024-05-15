---
external help file: PSDesiredStateConfiguration-help.xml
Locale: en-US
Module Name: PSDesiredStateConfiguration
ms.date: 05/15/2024
online version: https://learn.microsoft.com/powershell/module/psdesiredstateconfiguration/invoke-dscresource?view=dsc-2.0&WT.mc_id=ps-gethelp
schema: 2.0.0
title: Invoke-DscResource
---

# Invoke-DscResource

## SYNOPSIS
Runs a method of a specified PowerShell Desired State Configuration (DSC) resource.

## SYNTAX

```
Invoke-DscResource [-Name] <String> [[-ModuleName] <ModuleSpecification>]
 [-Method] <String> [-Property] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION

The `Invoke-DscResource` cmdlet runs a method of a specified PowerShell Desired State Configuration
(DSC) resource.

This cmdlet invokes a DSC resource directly, without creating a configuration document. Using this
cmdlet, configuration management products can manage windows or Linux with DSC resources.

This cmdlet doesn't work with composite resources. Composite resources are parameterized
configurations. Using composite resources requires the LCM.

> [!NOTE]
> Before PSDesiredStateConfiguration 2.0.6, using `Invoke-DscResource` in PowerShell 7 requires
> enabling a PowerShell experimental feature. To use the cmdlet in versions 2.0.0 through 2.0.5,
> you must enable it with the following command.
>
> `Enable-ExperimentalFeature PSDesiredStateConfiguration.InvokeDscResource`

## EXAMPLES

### Example 1: Invoke the Set method of a resource by specifying its mandatory properties

This example invokes the **Set** method of a resource named **WindowsProcess** and provides the
mandatory **Path** and **Arguments** properties to start the specified Windows process.

```powershell
Invoke-DscResource -Name WindowsProcess -Method Set -ModuleName PSDesiredStateConfiguration -Property @{
  Path      = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
  Arguments = ''
}
```

### Example 2: Invoke the Test method of a resource for a specified module

This example invokes the **Test** method of a resource named **WindowsProcess**, which is in the
module named **PSDesiredStateConfiguration**.

```powershell
$SplatParam = @{
    Name       = 'WindowsProcess'
    ModuleName = 'PSDesiredStateConfiguration'
    Method     = 'Test'
    Property   = @{
        Path      = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
        Arguments = ''
    }
}

Invoke-DscResource @SplatParam
```

## PARAMETERS

### -Method

Specifies the method of the resource that this cmdlet invokes. The acceptable values for this
parameter are: **Get**, **Set**, and **Test**.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:
Accepted values: Get, Set, Test

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModuleName

Specifies the name of the module providing the specified DSC Resource to invoke.

```yaml
Type: Microsoft.PowerShell.Commands.ModuleSpecification
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name

Specifies the name of the DSC resource to invoke.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Property

Specifies the resource property name and its value in a hash table as key and value, respectively.

```yaml
Type: System.Collections.Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### Microsoft.PowerShell.Commands.ModuleSpecification

## OUTPUTS

### System.Object

## NOTES

- In Windows PowerShell 5.1 resources ran under the System context unless specified with user
  context using the key **PsDscRunAsCredential**. In PowerShell 7.0, Resources run in the user's
  context, and **PsDscRunAsCredential** is no longer supported. Using this key causes the cmdlet to
  throw an exception.

- As of PowerShell 7, `Invoke-DscResource` no longer supports invoking WMI DSC resources. This
  includes the **File** and **Log** resources in **PSDesiredStateConfiguration**.

## RELATED LINKS

[Windows PowerShell Desired State Configuration Overview](/powershell/scripting/dsc/overview/dscforengineers)

[Get-DscResource](Get-DscResource.md)
