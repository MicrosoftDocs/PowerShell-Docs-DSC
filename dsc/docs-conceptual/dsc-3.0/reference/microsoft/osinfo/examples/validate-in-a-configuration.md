---
description: >
  Use the Microsoft/OSInfo resource to Use the Microsoft/OSInfo resource to validate operating
  system in a DSC Configuration Document.
ms.date: 08/08/2022
ms.topic: reference
title: Validate operating system information in a configuration
---

# Validate operating system information in a configuration

This example shows how you can use the `Microsoft/OSInfo` resource to assert that a configuration
document applies to a specific operating system.

> [!IMPORTANT]
> The `osinfo` command and `Microsoft/OSInfo` resource are a proof-of-concept example for use with
> DSCv3. Don't use it in production.

## Definition

The configuration document defines a resource group called `Operating System Assertion` with an
instance of the `Microsoft/OSInfo` resource.

The resource group uses the `DSC/AssertionGroup` resource to ensure that the test method is called
for every instance in the group, regardless of the actual configuration operation being applied.
When DSC processes the resource group, it calls the test operation for the nested instances instead
of the get and set operations. Instances in the group never change the state of the system.

The instance of the `Microsoft/OSInfo` resource defines the `bitness` property to validate that the
configuration is applied on a 64-bit operating system.

:::code language="yaml" source="osinfo.config.dsc.yaml":::

## Getting the current state

To get the current state of the instances in the configuration document, pass the contents of the
document to the `dsc config get` command.

# [Linux](#tab/linux)

```bash
configuration=$(cat ./osinfo.config.dsc.yaml)
echo configuration | dsc config get
```

# [macOS](#tab/macos)

```zsh
configuration=$(cat ./osinfo.config.dsc.yaml)
echo configuration | dsc config get
```

# [Windows](#tab/windows)

```powershell
$Configuration = Get-Content -Path ./osinfo.config.dsc.yaml -Raw
$Configuration | dsc config get
```

---

The output depends on whether the operating system is 32-bit or 64-bit.

# [32-bit Linux](#tab/32bit/linux)

Applied to a 32-bit Linux operating system, the get result shows that the `Is64BitOS` instance is
out of the desired state because the `bitness` property is `32`.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Linux
            version: '20.04'
            codename: focal
            bitness: '32'
            architecture: i386
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

# [64-bit Linux](#tab/64bit/linux)

Applied to a 64-bit Linux operating system, the get result shows that the `Is64BitOS` instance is
in the desired state.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
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
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

# [32-bit macOS](#tab/32bit/macos)

Applied to a 32-bit macOS operating system, the get result shows that the `Is64BitOS` instance is
out of the desired state because the `bitness` property is `32`.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '32'
            architecture: arm
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

# [64-bit macOS](#tab/64bit/macos)

Applied to a 64-bit macOS operating system, the get result shows that the `Is64BitOS` instance is
in the desired state.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '64'
            architecture: arm64
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

# [32-bit Windows](#tab/32bit/windows)

Applied to a 32-bit Windows operating system, the get result shows that the `Is64BitOS` instance is
out of the desired state because the `bitness` property is `32`.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '32'
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

# [64-bit Windows](#tab/64bit/windows)

Applied to a 64-bit Windows operating system, the get result shows that the `Is64BitOS` instance is
in the desired state.

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    actualState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '64'
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
messages: []
hadErrors: false
```

---

## Enforcing the desired state

To enforce the desired state of the instances in the configuration document, pass the contents of
the document to the `dsc config set` command.

# [Linux](#tab/linux)

```bash
echo configuration | dsc config set
```

# [macOS](#tab/macos)

```zsh
echo configuration | dsc config set
```

# [Windows](#tab/windows)

```powershell
$Configuration | dsc config set
```

---

The output depends on whether the operating system is 32-bit or 64-bit. In all cases, the
`changedProperties` field for the result is an empty list. The `DSC/AssertionGroup` resource group
never changes system state and the `Microsoft/OSInfo` resource doesn't implement the set operation.

# [32-bit Linux](#tab/32bit/linux)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Linux
            version: '20.04'
            codename: focal
            bitness: '32'
            architecture: i386
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Linux
            version: '20.04'
            codename: focal
            bitness: '32'
            architecture: i386
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

# [64-bit Linux](#tab/64bit/linux)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
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
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
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
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

# [32-bit macOS](#tab/32bit/macos)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '32'
            architecture: arm
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '32'
            architecture: arm
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

# [64-bit macOS](#tab/64bit/macos)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '64'
            architecture: arm64
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: MacOS
            version: 13.5.0
            bitness: '64'
            architecture: arm64
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

# [32-bit Windows](#tab/32bit/windows)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '32'
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '32'
          inDesiredState: false
          differingProperties:
          - bitness
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

# [64-bit Windows](#tab/64bit/windows)

```yaml
results:
- name: Operating System Assertion
  type: DSC/AssertionGroup
  result:
    beforeState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '64'
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
    afterState:
      results:
      - name: Is64BitOS
        type: Microsoft/OSInfo
        result:
          desiredState:
            bitness: '64'
          actualState:
            $id: https://developer.microsoft.com/json-schemas/dsc/os_info/20230303/Microsoft.Dsc.OS_Info.schema.json
            family: Windows
            version: 10.0.22621
            edition: Windows 11 Enterprise
            bitness: '64'
          inDesiredState: true
          differingProperties: []
      messages: []
      hadErrors: false
    changedProperties: []
messages: []
hadErrors: false
```

---
