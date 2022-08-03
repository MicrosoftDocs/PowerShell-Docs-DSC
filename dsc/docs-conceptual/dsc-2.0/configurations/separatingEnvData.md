---
ms.date: 08/01/2022
keywords:  dsc,powershell,configuration,setup
title:  Separating configuration and environment data
description: >
  It can be useful to separate the data used in a DSC configuration from the configuration itself by
  using configuration data. By doing this, you can use a single configuration for multiple
  environments.
---

# Separating configuration and environment data

> Applies To: PowerShell 7.2

It can be useful to separate the data used in a Configuration from the Configuration itself by using
**ConfigurationData**. By doing this, you can use a single Configuration for multiple environments.

For example, if you are developing an application, you can use one Configuration for both
development and production environments, and use **ConfigurationData** to specify settings for each
environment.

## What is ConfigurationData?

**ConfigurationData** is a hashtable passed to a Configuration when you compile that Configuration.

For a detailed description of **ConfigurationData**, see [Using configuration data][1].

## A basic example

Let's look at a basic example to see how this works. We'll create a single configuration that
ensures IIS is present on some nodes and Hyper-V is present on others:

```powershell
configuration MyDscConfiguration {
    # It's best practice to explicitly import required resources and modules.
    Import-DSCResource -Module PSDscResources

    Node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName {
        WindowsFeature IISInstall {
            Ensure = 'Present'
            Name   = 'Web-Server'
        }
    }
    Node $AllNodes.Where{$_.Role -eq "VMHost"}.NodeName {
        WindowsFeature HyperVInstall {
            Ensure = 'Present'
            Name   = 'Hyper-V'
        }
    }
}

$MyData = @{
    AllNodes = @(
        @{
            NodeName    = 'VM-1'
            Role        = 'WebServer'
        }

        @{
            NodeName    = 'VM-2'
            Role        = 'VMHost'
        }
    )
}

MyDscConfiguration -ConfigurationData $MyData
```

The last line in this script compiles the configuration, passing `$MyData` as the value for the
**ConfigurationData** parameter.

The result is that two MOF files are created:

```Output
    Directory: C:\DscTests\MyDscConfiguration


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        3/31/2017   5:09 PM           1968 VM-1.mof
-a----        3/31/2017   5:09 PM           1970 VM-2.mof
```

`$MyData` specifies two different nodes, each with its own `NodeName` and `Role`. The Configuration
dynamically creates **Node** blocks by taking the collection of nodes it gets from `$MyData`
(specifically, `$AllNodes`) and filters that collection against the `Role` property.

## Using configuration data to define development and production environments

Let's look at a complete example that uses a single Configuration to set up both development and
production environments of a website. In the development environment, both IIS and SQL Server are
installed on a single node. In the production environment, IIS and SQL Server are installed on
separate nodes. We'll use a configuration data `.psd1` file to specify the data for the two
different environments.

### Configuration data file

We'll define the development and production environment data in a file named `DevProdEnvData.psd1`
as follows:

```powershell
@{

    AllNodes = @(
        @{
            NodeName        = '*'
            SQLServerName   = 'MySQLServer'
            SqlSource       = 'C:\Software\Sql'
            DotNetSrc       = 'C:\Software\sxs'
            WebSiteName     = 'New website'
        }

        @{
            NodeName        = 'Prod-SQL'
            Role            = 'MSSQL'
        }

        @{
            NodeName        = 'Prod-IIS'
            Role            = 'Web'
            SiteContents    = 'C:\Website\Prod\SiteContents\'
            SitePath        = '\\Prod-IIS\Website\'
        }

        @{
            NodeName         = 'Dev'
            Role             = 'MSSQL', 'Web'
            SiteContents     = 'C:\Website\Dev\SiteContents\'
            SitePath         = '\\Dev\Website\'
        }
    )
}
```

### Configuration script file

Now, in the Configuration, which is defined in a `.ps1` file, we filter the nodes we defined in
`DevProdEnvData.psd1` by their role (`MSSQL`, `Dev`, or both), and configure them accordingly. The
development environment has both the SQL Server and IIS on one node, while the production
environment has them on two different nodes. The site contents is also different, as specified by
the `SiteContents` properties.

At the end of the configuration script, we call the Configuration (compile it into a MOF document),
passing `DevProdEnvData.psd1` as the **ConfigurationData** parameter.

> [!NOTE]
> This Configuration requires the modules **SqlServerDsc** and **WebAdministrationDsc** to be
> installed on the target node.

Let's define the Configuration in a file named `MyWebApp.ps1`:

```powershell
configuration MyWebApp {
    Import-DscResource -Module PSDscResources
    Import-DscResource -Module SqlServerDsc
    Import-DscResource -Module WebAdministrationDsc

    Node $AllNodes.Where{$_.Role -contains 'MSSQL'}.NodeName {
        # Install prerequisites
        WindowsFeature InstallDotNet35 {
            Ensure      = 'Present'
            Name        = 'Net-Framework-Core'
            Source      = 'c:\software\sxs'
        }

        # Install SQL Server
        xSqlServerInstall InstallSqlServer {
            InstanceName = $Node.SQLServerName
            SourcePath   = $Node.SqlSource
            Features     = 'SQLEngine,SSMS'
            DependsOn    = '[WindowsFeature]InstallDotNet35'

        }
   }

   Node $AllNodes.Where{$_.Role -contains "Web"}.NodeName
   {
        # Install the IIS role
        WindowsFeature IIS {
            Ensure       = 'Present'
            Name         = 'Web-Server'
        }

        # Install the ASP .NET 4.5 role
        WindowsFeature AspNet45 {
            Ensure       = 'Present'
            Name         = 'Web-Asp-Net45'

        }

        # Stop the default website
        xWebsite DefaultSite {
            Ensure       = 'Present'
            Name         = 'Default Web Site'
            State        = 'Stopped'
            PhysicalPath = 'C:\inetpub\wwwroot'
            DependsOn    = '[WindowsFeature]IIS'
        }

        # Copy the website content
        File WebContent {
            Ensure          = 'Present'
            SourcePath      = $Node.SiteContents
            DestinationPath = $Node.SitePath
            Recurse         = $true
            Type            = 'Directory'
            DependsOn       = '[WindowsFeature]AspNet45'
        }


        # Create the new Website
        xWebsite NewWebsite {
            Ensure          = 'Present'
            Name            = $Node.WebSiteName
            State           = 'Started'
            PhysicalPath    = $Node.SitePath
            DependsOn       = '[File]WebContent'
        }
    }
}

MyWebApp -ConfigurationData DevProdEnvData.psd1
```

When you run this configuration, three MOF files are created (one for each named entry in the
**AllNodes** array):

```Output
    Directory: C:\DscTests\MyWebApp


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        3/31/2017   5:47 PM           2944 Prod-SQL.mof
-a----        3/31/2017   5:47 PM           6994 Dev.mof
-a----        3/31/2017   5:47 PM           5338 Prod-IIS.mof
```

## Using non-node data

You can add additional keys to **ConfigurationData** for data that is not specific to a node. The
following configuration ensures the presence of two websites. Data for each website is defined in
the **AllNodes** array. The file `Config.xml` is used for both websites, so we define it in an
additional key with the name `NonNodeData`. Note that you can have as many additional keys as you
want, and you can name them anything you want. `NonNodeData` is not a reserved word, it is just the
name used for this example.

You access additional keys by using the special variable `$ConfigurationData`. In this example,
`ConfigFileContents` is accessed with the following line in the `File` Resource block:

```powershell
Contents = $ConfigurationData.NonNodeData.ConfigFileContents
```

```powershell
$MyData = @{
    AllNodes = @(
        @{
            NodeName           = '*'
            LogPath            = 'C:\Logs'
        }

        @{
            NodeName     = 'VM-1'
            SiteContents = 'C:\Site1'
            SiteName     = 'Website1'
        }

        @{
            NodeName     = 'VM-2'
            SiteContents = 'C:\Site2'
            SiteName     = 'Website2'
        }
    )

    NonNodeData = @{
        ConfigFileContents = (Get-Content C:\Template\Config.xml)
    }
}

configuration WebsiteConfig
{
    Import-DscResource -ModuleName xWebAdministration -Name MSFT_xWebsite

    node $AllNodes.NodeName {
        xWebsite Site {
            Name         = $Node.SiteName
            PhysicalPath = $Node.SiteContents
            Ensure       = 'Present'
        }

        File ConfigFile {
            DestinationPath = $Node.SiteContents + '\\config.xml'
            Contents        = $ConfigurationData.NonNodeData.ConfigFileContents
        }
    }
}
```

## See Also

- [Using configuration data][1]
- [Credentials Options in Configuration Data][2]
- [DSC Configurations][3]

<!-- Reference Links -->

[1]: configData.md
[2]: configDataCredentials.md
[3]: configurations.md
