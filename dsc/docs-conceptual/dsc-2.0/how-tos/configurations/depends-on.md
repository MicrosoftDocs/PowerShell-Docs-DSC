---
ms.date: 08/15/2022
keywords:  dsc,powershell,configuration,setup
title: Managing dependencies in DSC Configurations
description: >
  As your DSC Configuration grows larger and more complex, you can use the `DependsOn` meta-property
  to change the applied order of your DSC Resources by specifying that one DSC Resource depends on
  another DSC Resource.
---

# Managing dependencies in DSC Configurations

When you write [DSC Configurations][1] for [Azure Policy's machine configuration feature][2], you
add [Resource blocks][3] to configure aspects of a system. As you continue to add DSC Resource
blocks, your DSC Configurations can grow large and cumbersome to manage. One such challenge is the
applied order of your DSC Resource blocks. By default, DSC Resources are applied in the order
they're defined within the `Configuration` block. As your DSC Configuration grows larger and more
complex, you can use the **DependsOn** meta-property to change the applied order of your DSC
Resources by specifying that one DSC Resource depends on another DSC Resource.

The **DependsOn** meta-property can be used in any DSC Resource block. It's defined with the same
key/value mechanism as other DSC Resource properties. The **DependsOn** meta-property expects an
array of strings with the following syntax.

```text
DependsOn = '[<Resource Type>]<Resource Name>', '[<Resource Type>]<Resource Name>'
```

The following example configures a firewall rule after enabling and configuring the public profile.

```powershell
# Install the NetworkingDSC module to configure firewall rules and profiles.
Install-Module -Name NetworkingDSC

Configuration ConfigureFirewall {
    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Name Firewall, FirewallProfile -Module NetworkingDsc

    Firewall Firewall {
        Name                  = 'IIS-WebServerRole-HTTP-In-TCP'
        Ensure                = 'Present'
        Enabled               = 'True'
        DependsOn             = '[FirewallProfile]FirewallProfilePublic'
    }

    FirewallProfile FirewallProfilePublic {
        Name                    = 'Public'
        Enabled                 = 'True'
        DefaultInboundAction    = 'Block'
        DefaultOutboundAction   = 'Allow'
        AllowInboundRules       = 'True'
        AllowLocalFirewallRules = 'False'
        AllowLocalIPsecRules    = 'False'
        NotifyOnListen          = 'True'
        LogFileName             = '%systemroot%\system32\LogFiles\Firewall\pfirewall.log'
        LogMaxSizeKilobytes     = 16384
        LogAllowed              = 'False'
        LogBlocked              = 'True'
        LogIgnored              = 'NotConfigured'
    }
}

ConfigureFirewall -OutputPath C:\Temp\
```

<!-- Reference Links -->

[1]: ../../concepts/configurations.md
[2]: /azure/governance/machine-configuration/overview
[3]: ../../concepts/resources.md
