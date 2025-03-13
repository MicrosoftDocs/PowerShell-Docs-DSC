---
description: >
  Validate operating system information with the Microsoft/OSInfo DSC Resource
  and the dsc resource commands.
ms.date: 08/08/2022
ms.topic: reference
title: Validate operating system information with dsc resource
---

# Validate operating system information with dsc resource

## Description

This example shows how you can use the `Microsoft/OSInfo` DSC Resource to retrieve and validate
information about an operating system with the `dsc resource` commands.

> [!IMPORTANT]
> The `osinfo` command and `Microsoft/OSInfo` resource are a proof-of-concept example for use with
> DSCv3. Don't use it in production.

## Getting the operating system information

The `dsc resource get` command returns an instance of the resource. The `Microsoft/OSInfo` resource
doesn't require any instance properties to return the instance. The resource returns the available
information for the operating system.

> [!IMPORTANT]
> The `osinfo` command and `Microsoft/OSInfo` resource require `pwsh` command on the host system.
> For information on installing PowerShell,
> see https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell

# [Linux](#tab/linux)

```bash
resource=$(dsc resource list Microsoft/OSInfo)
dsc resource get -r "${resource}"
```

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Linux
  version: '20.04'
  codename: focal
  bitness: '64'
  architecture: x86_64
```

# [macOS](#tab/macos)

```zsh
resource=$(dsc resource list Microsoft/OSInfo)
dsc resource get -r "${resource}"
```

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: MacOS
  version: 13.5.0
  bitness: '64'
  architecture: arm64
```

# [Windows](#tab/windows)

```powershell
$Resource = dsc resource list Microsoft/OSInfo
dsc resource get -r $Resource
```

```yaml
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Windows
  version: 10.0.22621
  edition: Windows 11 Enterprise
  bitness: '64'
```

---

## Testing the operating system information

DSC can use the resource to validate the operating system information. When using the
`dsc resource test` command, input JSON representing the desired state of the instance is required.
The JSON must define at least one instance property to validate.

The resource doesn't implement the [test operation][01]. It relies on the synthetic testing feature
of DSC instead. The synthetic test uses a case-sensitive equivalency comparison between the actual
state of the instance properties and the desired state. If any property value isn't an exact match,
DSC considers the instance to be out of the desired state.

# [Linux](#tab/linux)

This test checks whether the `family` property for the instance is `linux`.

```bash
invalid_instance='{"family": "linux"}'
echo $invalid_instance | dsc resource test -r "${resource}"
```

```yaml
desiredState:
  family: linux
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Linux
  version: '20.04'
  codename: focal
  bitness: '64'
  architecture: x86_64
inDesiredState: false
differingProperties:
- family
```

The result shows that the resource is out of the desired state because the actual state of the
`family` property wasn't case-sensitively equal to the desired state.

The next test validates that the operating system is a 64-bit Linux operating system.

```bash
valid_instance='{ "family": "Linux", "bitness": "64" }'
echo $valid_instance | dsc resource test -r "${resource}"
```

```yaml
desiredState:
  family: Linux
  bitness: '64'
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Linux
  version: '20.04'
  codename: focal
  bitness: '64'
  architecture: x86_64
inDesiredState: true
differingProperties: []
```

# [macOS](#tab/macos)

This test checks whether the `family` property for the instance is `linux`.

```zsh
invalid_instance='{"family": "macOS"}'
echo $invalid_instance | dsc resource test -r "${resource}"
```

```yaml
desiredState:
  family: macOS
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: MacOS
  version: 13.5.0
  bitness: '64'
  architecture: arm64
inDesiredState: false
differingProperties:
- family
```

The result shows that the resource is out of the desired state because the actual state of the
`family` property wasn't case-sensitively equal to the desired state.

The next test validates that the operating system is a 64-bit macOS operating system.

```zsh
valid_instance='{ "family": "MacOS", "bitness": "64" }'
echo $valid_instance | dsc resource test -r "${resource}"
```

```yaml
desiredState:
  family: MacOS
  bitness: '64'
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: MacOS
  version: 13.5.0
  bitness: '64'
  architecture: arm64
inDesiredState: true
differingProperties: []
```

# [Windows](#tab/windows)

This test checks whether the `family` property for the instance is `windows`.

```powershell
$InvalidInstance = @{ family = 'windows' } | ConvertTo-JSON
$InvalidInstance | dsc resource test -r $Resource
```

```yaml
desiredState:
  family: windows
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Windows
  version: 10.0.22621
  edition: Windows 11 Enterprise
  bitness: "64"
inDesiredState: false
differingProperties:
- family
```

The result shows that the resource is out of the desired state because the actual state of the
`family` property wasn't case-sensitively equal to the desired state.

The next test validates that the operating system is a 64-bit Windows operating system.

```powershell
$ValidInstance = @{
    family  = 'Windows'
    bitness = '64'
} | ConvertTo-JSON

$ValidInstance | dsc resource test -r $Resource
```

```yaml
desiredState:
  family: Windows
  bitness: '64'
actualState:
  $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
  family: Windows
  version: 10.0.22621
  edition: Windows 11 Enterprise
  bitness: "64"
inDesiredState: true
differingProperties: []
```

---

<!-- Link references -->
[01]: ../../../../concepts/resources.md#test-operations
