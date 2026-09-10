---
description: >-
  Learn how to install DSC v3 on supported platforms.
ms.date: 09/10/2026
ms.topic: overview
title:  Install Microsoft DSC v3
---

# Install Microsoft DSC v3

There are multiple ways to install DSC v3.

- On Windows, you can install using WinGet or manually install the `.zip` file
- On Linux you can install using the DEB or RPM package or manually install the `.tar.gz` file
- On macOS you must manually install the `.tar.gz`

Select the tab for the desired platform to see the detailed installation instructions.

<!-- start of tab group -->
## [Windows](#tab/windows)

### Install DSC using WinGet

The following commands can be used to install DSC using the published `winget` packages.

Search for the latest version of DSC:

```powershell
winget search DesiredStateConfiguration --source msstore
```

```Output
Name                              Id           Version Source
---------------------------------------------------------------
DesiredStateConfiguration         9NVTPZWRC6KQ Unknown msstore
DesiredStateConfiguration-Preview 9PCX3HX4HZ0Z Unknown msstore
```

Install DSC using the `id` parameter:

```powershell
# Install latest stable
winget install --id 9NVTPZWRC6KQ --source msstore
```

```powershell
# Install latest preview
winget install --id 9PCX3HX4HZ0Z --source msstore
```

### Install DSC from the `.zip` file

1. Download the latest release from the DSC repository for your processor type:

   - Arm64 - [DSC-3.3.0-rc.2-aarch64-pc-windows-msvc.zip][04]
   - x64 - [DSC-3.3.0-rc.2-x86_64-pc-windows-msvc.zip][06]

1. Unzip the package to a folder:

   ```powershell
   Expand-Archive -Path .\DSC-3.3.0-rc.2-x86_64-pc-windows-msvc.zip -DestinationPath C:\DSC
   ```

1. Add the DSC folder to your system `PATH` environment variable.

## [Debian](#tab/debian)

### Install DSC from the Microsoft package repository

> [!NOTE]
> This script only works for supported versions of Debian that have a package published to the
> Microsoft package repository. For other versions of Debian, use the manual installation method.

```sh
#!/bin/bash
###################################
# Prerequisites

# Update and install the pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Download the Microsoft repository keys for your version of Ubuntu
source /etc/os-release
wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Update the list of packages and install DSC
sudo apt-get update
sudo apt-get install -y dsc
```

### Manually install DSC from the DEB package

Download the universal package from the GitHub releases page for your processor architecture.

- Arm64 - [DSC-3.3.0-rc.2-arm64.deb][02]
- x64 - [DSC-3.3.0-rc.2-amd64.deb][01]

The following shell script downloads and installs the current release of DSC. You can change the URL
to download the version of DSC that you want to install.

```sh
#!/bin/bash
###################################
# Prerequisites

# Update and install the pre-requisite packages.
sudo apt-get update
sudo apt-get install -y wget

# Download the DSC package file
wget https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc_3.3.0-rc.2-1_amd64.deb

# Install the DSC package
sudo dpkg -i dsc_3.3.0-rc.2-1_amd64.deb
rm dsc_3.3.0-rc.2-1_amd64.deb
```

## [Ubuntu](#tab/ubuntu)

### Install DSC from the Microsoft package repository

> [!NOTE]
> This script only works for supported versions of Ubuntu that have a package published to the
> Microsoft package repository. For other versions of Ubuntu, use the manual installation method.

```sh
#!/bin/bash
###################################
# Prerequisites

# Update and install the pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Download the Microsoft repository keys for your version of Debian
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Update the list of packages and install DSC
sudo apt-get update
sudo apt-get install -y dsc
```

### Manually install DSC from the DEB package

Download the universal package from the GitHub releases page for your processor architecture.

- Arm64 - [DSC-3.3.0-rc.2-arm64.deb][02]
- x64 - [DSC-3.3.0-rc.2-amd64.deb][01]

The following shell script downloads and installs the current release of DSC. You can change the URL
to download the version of DSC that you want to install.

```sh
#!/bin/bash
###################################
# Prerequisites

# Update and install the pre-requisite packages.
sudo apt-get update
sudo apt-get install -y wget

# Download the DSC package file
wget https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc_3.3.0-rc.2-1_amd64.deb

# Install the DSC package
sudo dpkg -i dsc_3.3.0-rc.2-1_amd64.deb
rm dsc_3.3.0-rc.2-1_amd64.deb
```

## [RedHat](#tab/redhat)

### Install DSC from the Microsoft package repository

> [!NOTE]
> This script only works for supported versions of RHEL that have a package published to the
> Microsoft package repository. For other supported versions of RHEL, use the manual installation
> method.

```sh
#!/bin/bash
###################################
# Get version of RHEL
source /etc/os-release
majorver=${VERSION_ID%.*}

# Download and register the Microsoft Red Hat repository package
curl -sSL -O https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm
sudo rpm -i packages-microsoft-prod.rpm
rm packages-microsoft-prod.rpm

# Update package index files
sudo dnf update

# Install DSC
sudo dnf install dsc -y
```

### Manually install DSC from the RPM package

Download the universal package from the GitHub releases page for your processor architecture.

- Arm64 - [DSC-3.3.0-rc.2-arm64.rpm][07]
- x64 - [dsc-3.3.0.rc.2-1.x86_64.rpm)][08]

The following shell script downloads and installs the current release of DSC. You can change the URL
to download the version of DSC that you want to install.

```sh
sudo dnf install https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc-3.3.0.rc.2-1.x86_64.rpm
```

## [macOS](#tab/macos)

### Manually install DSC from the `.tar.gz` package

Download the macOS package from the GitHub releases page for your processor architecture.

- Arm64 - [DSC-3.3.0-rc.2-aarch64-apple-darwin.tar.gz][03]
- x64 - [DSC-3.3.0-rc.2-x86_64-apple-darwin.tar.gz][05]

The following shell script downloads and installs the current release of DSC. You can change the URL
to download the version of DSC that you want to install.

```zsh
curl -sSL -O https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/DSC-3.3.0-rc.2-aarch64-apple-darwin.tar.gz
```

Create a new folder and extract files to that folder:

```zsh
mkdir -p ~/.local/share/dsc
tar -xzf ./dsc-3.3.0-rc.2-aarch64-apple-darwin.tar.gz -C ~/.local/share/dsc
```

Add the new folder to your PATH environment variable.

---
<!-- end of tab group -->

<!-- updated link references -->
[01]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc_3.3.0-rc.2-1_amd64.deb
[02]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc_3.3.0-rc.2-1_arm64.deb
[03]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/DSC-3.3.0-rc.2-aarch64-apple-darwin.tar.gz
[04]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/DSC-3.3.0-rc.2-aarch64-pc-windows-msvc.zip
[05]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/DSC-3.3.0-rc.2-x86_64-apple-darwin.tar.gz
[06]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/DSC-3.3.0-rc.2-x86_64-pc-windows-msvc.zip
[07]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc-3.3.0.rc.2-1.aarch64.rpm
[08]: https://github.com/PowerShell/DSC/releases/download/v3.3.0-rc.2/dsc-3.3.0.rc.2-1.x86_64.rpm
