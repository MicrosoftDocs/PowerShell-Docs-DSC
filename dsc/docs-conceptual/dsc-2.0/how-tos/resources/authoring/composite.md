---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,setup
title: Authoring a composite DSC Resource
description: >
  This article describes how to develop a DSC Resource composed of other DSC Resources
---

# Authoring a composite DSC Resource

> Applies To: PowerShell 7.2

In real-world situations, DSC Configurations can become long and complex, calling several different
DSC Resources and setting dozens of properties. To help address this complexity, you can use a DSC
Configuration as a DSC Resource for other DSC Configurations. This is called a composite DSC
Resource. A composite DSC Resource is a DSC Configuration that takes parameters. The parameters of
the DSC Configuration act as the properties of the DSC Resource. The DSC Configuration is saved as a
file with a `.schema.psm1` extension. For more information about DSC Resources, see
[DSC Resources][1].

> [!IMPORTANT]
> Composite DSC Resources don't work with `Invoke-DscResource`. In DSC 2.0 and later, they're only
> supported for use with [Azure Policy's machine configuration feature][2].

## Creating the composite resource

In our example, we create a configuration that invokes several existing resources to configure
virtual machines. Instead of specifying the values to be set in configuration blocks, the
configuration takes in parameters that are then used in the configuration blocks.

```powershell
Configuration xVirtualMachine {
    param(
        # Name of VMs
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]] $VMName,

        # Name of Switch to create
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $SwitchName,

        # Type of Switch to create
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $SwitchType,

        # Source Path for VHD
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $VHDParentPath,

        # Destination path for diff VHD
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $VHDPath,

        # Startup Memory for VM
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $VMStartupMemory,

        # State of the VM
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $VMState
    )

    # Import the module that defines custom resources
    Import-DscResource -Module xComputerManagement, xHyper-V

    # Install the Hyper-V role
    WindowsFeature HyperV {
        Ensure = 'Present'
        Name   = 'Hyper-V'
    }

    # Create the virtual switch
    xVMSwitch $SwitchName {
        Ensure    = 'Present'
        Name      = $SwitchName
        Type      = $SwitchType
        DependsOn = '[WindowsFeature]HyperV'
    }

    # Check for Parent VHD file
    File ParentVHDFile {
        Ensure          = 'Present'
        DestinationPath = $VHDParentPath
        Type            = 'File'
        DependsOn       = '[WindowsFeature]HyperV'
    }

    # Check the destination VHD folder
    File VHDFolder {
        Ensure          = 'Present'
        DestinationPath = $VHDPath
        Type            = 'Directory'
        DependsOn       = '[File]ParentVHDFile'
    }

    # Create VM specific diff VHD
    foreach ($Name in $VMName) {
        xVHD "VHD$Name" {
            Ensure     = 'Present'
            Name       = $Name
            Path       = $VHDPath
            ParentPath = $VHDParentPath
            DependsOn  = @(
                '[WindowsFeature]HyperV'
                '[File]VHDFolder'
            )
        }
    }

    # Create VM using the above VHD
    foreach($Name in $VMName) {
        xVMHyperV "VMachine$Name" {
            Ensure        = 'Present'
            Name          = $Name
            VhdPath       = (Join-Path -Path $VHDPath -ChildPath $Name)
            SwitchName    = $SwitchName
            StartupMemory = $VMStartupMemory
            State         = $VMState
            MACAddress    = $MACAddress
            WaitForIP     = $true
            DependsOn     = @(
                "[WindowsFeature]HyperV"
                "[xVHD]VHD$Name"
            )
        }
    }
}
```

> [!NOTE]
> DSC doesn't support placing composite DSC Resource blocks within a composite DSC Resource
> definition.

### Saving the DSC Configuration as a composite DSC Resource

To use the parameterized DSC Configuration as a DSC Resource, save it in a directory structure like
that of a [MOF-based DSC Resource][3], and name it with a `.schema.psm1` extension. For this
example, we'll name the file `xVirtualMachine.schema.psm1`. You also need to create a manifest named
`xVirtualMachine.psd1` that contains the following line.

```powershell
RootModule = 'xVirtualMachine.schema.psm1'
```

> [!NOTE]
> This is separate from `MyDscResources.psd1`, the module manifest for all DSC Resources under the
> `MyDscResources` folder.

When you are done, the folder structure should be as follows.

```text
$env: psmodulepath
    |- MyDscResources
        |- MyDscResources.psd1
        |- DSCResources
            |- xVirtualMachine
                |- xVirtualMachine.psd1
                |- xVirtualMachine.schema.psm1
```

The DSC Resource is now discoverable with the `Get-DscResource` cmdlet, and its properties are
discoverable by either that cmdlet or with <kbd>Ctrl</kbd>+<kbd>Space</kbd> autocomplete in VS
Code.

## Using the composite resource

Next we create a DSC Configuration that calls the composite DSC Resource. This DSC Configuration
calls the `xVirtualMachine` composite DSC Resource to create a virtual machine.

```powershell
Configuration CreateVM {
    Import-DscResource -Module xVirtualMachine

    xVirtualMachine VM {
        VMName          = "Test"
        SwitchName      = "Internal"
        SwitchType      = "Internal"
        VhdParentPath   = "C:\Demo\VHD\RTM.vhd"
        VHDPath         = "C:\Demo\VHD"
        VMStartupMemory = 1024MB
        VMState         = "Running"
    }
}
```

You can also use this composite DSC Resource to create multiple VMs by passing in an array of VM
names for the **VMName** property of the composite DSC Resource.

```PowerShell
Configuration MultipleVms {
    Import-DscResource -Module xVirtualMachine

    xVirtualMachine VMs {
        VMName          = @(
            "IIS01"
            "SQL01"
            "SQL02"
        )
        SwitchName      = "Internal"
        SwitchType      = "Internal"
        VhdParentPath   = "C:\Demo\VHD\RTM.vhd"
        VHDPath         = "C:\Demo\VHD"
        VMStartupMemory = 1024MB
        VMState         = "Running"
    }
}
```

### See also

- [Authoring a MOF-based DSC Resource][4]
- [Authoring a class-based DSC Resource][5]

<!-- Reference Links -->

[1]: ../../../concepts/resources.md
[2]: /azure/governance/machine-configuration/overview
[3]: mof-based.md#create-the-required-folder-structure
[4]: mof-based.md
[5]: class-based.md
