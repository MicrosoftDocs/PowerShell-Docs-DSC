---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Resource dependencies using DependsOn
description: >
  As your Configuration grows larger and more complex, you can use the `DependsOn` key to change the
  applied order of your resources by specifying that a resource depends on another resource.
---

# Resource dependencies using DependsOn

When you write [Configurations][1], you add [Resource blocks][2] to configure aspects
of a target Node. As you continue to add Resource blocks, your Configurations can grow quite large
and cumbersome to manage. One such challenge is the applied order of your Resource blocks. Normally,
Resources are applied in the order they are defined within the Configuration. As your Configuration
grows larger and more complex, you can use the `DependsOn` key to change the applied order of your
Resources by specifying that a Resource depends on another Resource.

The `DependsOn` key can be used in any Resource block. It is defined with the same key/value
mechanism as other Resource keys. The `DependsOn` key expects an array of strings with the following
syntax.

```text
DependsOn = '[<Resource Type>]<Resource Name>', '[<Resource Type>]<Resource Name>'
```

The following example configures a firewall rule after enabling and configuring the public profile.

```powershell
# Install the NetworkingDSC module to configure firewall rules and profiles.
Install-Module -Name NetworkingDSC

configuration ConfigureFirewall {
    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Name Firewall, FirewallProfile -Module NetworkingDsc

    Node localhost {
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
}

ConfigureFirewall -OutputPath C:\Temp\
```

<!--
    TODO: This can't be tested with DSC, it requires Guest Configuration; should we have an example
    here? Is it enough to just document what this is and how it works? Should we have a graph of the
    dependency relations? Can we get an actual example of this as it relates to Guest Configuration?
-->

<!-- Reference Links -->

[1]: configurations.md
[2]: ../resources/resources.md
