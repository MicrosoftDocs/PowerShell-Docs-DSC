---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Resource dependencies using DependsOn
description: >
  As your DSC Configuration grows larger and more complex, you can use the `DependsOn` meta-property
  to change the applied order of your DSC Resources by specifying that one DSC Resource depends on
  another DSC Resource.
---

# Resource dependencies using DependsOn

When you write [DSC Configurations][1], you add [Resource blocks][2] to configure aspects of a
system. As you continue to add DSC Resource blocks, your DSC Configurations can grow large and
cumbersome to manage. One such challenge is the applied order of your DSC Resource blocks. By
default, DSC Resources are applied in the order they're defined within the `Configuration` block. As
your DSC Configuration grows larger and more complex, you can use the **DependsOn** meta-property to
change the applied order of your DSC Resources by specifying that one DSC Resource depends on
another DSC Resource.

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

<!--
    TODO: This can't be tested with DSC, it requires machine configuration; should we have an example
    here? Is it enough to just document what this is and how it works? Should we have a graph of the
    dependency relations? Can we get an actual example of this as it relates to machine configuration?
-->

<!-- Reference Links -->

[1]: configurations.md
[2]: ../resources/resources.md
