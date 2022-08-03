---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title: Composite resources - Using a DSC Configuration as a resource
description: >
  This article describes how to create and use a composite resource.
---

# Composite resources: Using a DSC configuration as a resource

> Applies To: PowerShell 7.2

In real-world situations, configurations can become long and complex, calling many different
resources and setting a vast number of properties. To help address this complexity, you can use a
Windows PowerShell Desired State Configuration (DSC) configuration as a resource for other
configurations. This is called a composite resource. A composite resource is a DSC configuration
that takes parameters. The parameters of the configuration act as the properties of the resource.
The configuration is saved as a file with a `.schema.psm1` extension. It takes the place of both the
MOF schema, and the resource script in a typical DSC resource. For more information about DSC
resources, see [Windows PowerShell Desired State Configuration Resources][1].

## Creating the composite resource

In our example, we create a configuration that invokes a number of existing resources to configure
virtual machines. Instead of specifying the values to be set in configuration blocks, the
configuration takes in parameters that are then used in the configuration blocks.

```powershell
configuration xVirtualMachine {
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
> DSC doesn't support placing composite resources or nested configurations within a composite
> resource.

### Saving the configuration as a composite resource

To use the parameterized configuration as a DSC resource, save it in a directory structure like that
of any other MOF-based resource, and name it with a `.schema.psm1` extension. For this example,
we'll name the file `xVirtualMachine.schema.psm1`. You also need to create a manifest named
`xVirtualMachine.psd1` that contains the following line.

```powershell
RootModule = 'xVirtualMachine.schema.psm1'
```

> [!NOTE]
> This is in addition to `MyDscResources.psd1`, the module manifest for all resources under the
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

The resource is now discoverable by using the `Get-DscResource` cmdlet, and its properties are
discoverable by either that cmdlet or by using <kbd>Ctrl</kbd>+<kbd>Space</kbd> autocomplete in VS
Code.

## Using the composite resource

Next we create a configuration that calls the composite resource. This configuration calls the
`xVirtualMachine` composite resource to create a virtual machine, and then calls the `xComputer`
resource to rename it.

```powershell
configuration RenameVM {
    Import-DscResource -Module xVirtualMachine
    Node localhost {
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

    Node "192.168.10.1" {
        xComputer Name {
            Name       = "SQL01"
            DomainName = "fourthcoffee.com"
        }
    }
}
```

You can also use this resource to create multiple VMs by passing in an array of VM names to the
`xVirtualMachine` resource.

```PowerShell
configuration MultipleVms {
    Import-DscResource -Module xVirtualMachine
    Node localhost {
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
}
```

### See also

- [Writing a custom DSC resource with MOF][2]
- [Get Started with Windows PowerShell Desired State Configuration][3]

<!-- Reference Links -->

[1]: resources.md
[2]: authoringResourceMOF.md
[3]: ../overview.md
