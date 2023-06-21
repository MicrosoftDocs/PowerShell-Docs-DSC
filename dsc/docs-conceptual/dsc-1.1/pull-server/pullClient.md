---
ms.date: 06/21/2023
keywords:  dsc,powershell,configuration,setup
title:  Setting up a DSC pull client
description: This article is an overview of the information available for setting up the DSC pull client.
---
# Setting up a DSC pull client

> Applies To: Windows PowerShell 4.0, Windows PowerShell 5.0

> [!IMPORTANT]
> The Pull Server (Windows Feature _DSC-Service_) is a supported component of Windows Server however
> there are no plans to offer new features or capabilities. we would like you to know that a newer
> version of DSC is now generally available, managed by a feature of Azure Policy named
> [guest configuration](/azure/governance/machine-configuration/overview). The guest configuration
> service combines features of DSC Extension, Azure Automation State Configuration, and the most
> commonly requested features from customer feedback. Guest configuration also includes hybrid
> machine support through [Arc-enabled servers](/azure/azure-arc/servers/overview).

Each target node has to be told to use pull mode and given the URL or file location where it can
contact the pull server to get configurations and resources, and where it should send report data.

The following topics explain how to set up pull clients:

- [Setting up a pull client using configuration names](pullClientConfigNames.md)
- [Setting up a pull client using configuration ID](pullClientConfigID.md)

> [!NOTE]
> These topics apply to PowerShell 5.0. To set up a pull client in PowerShell 4.0, see
> [Setting up a pull client using configuration ID in PowerShell 4.0](pullClientConfigID4.md).
