---
description: PSDscResources Script resource
ms.date: 08/08/2022
ms.topic: reference
title: Script
---

# Script

## Synopsis

Run PowerShell script blocks.

## Syntax

```Syntax
Script [String] #ResourceName
{
    GetScript = [string]
    SetScript = [string]
    TestScript = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [PsDscRunAsCredential = [PSCredential]]
}
```

## Description

The `Script` resource enables you to write PowerShell code to get, test, and set a resource when a
specific DSC resource isn't available. You must provide the code for these methods, handle all
dependencies, and ensure your code is idempotent.

> [!TIP]

> Where possible, it's best practice to use a defined DSC resource instead of this one. The `Script`
> resource has drawbacks that make it more difficult to test, maintain, and predict.
>
> Unlike other DSC resources, every property for a `Script` resource is a key property and the
> **Get** method for this resource can only return a single string for the current state. There are
> no guarantees that this resource is implemented idempotently or that it'll work as expected on
> any system because it uses custom code. It can't be tested without being invoked on a target
> system.

### Requirements

None.

#### Properties

## Key properties

### GetScript

Specify a PowerShell scriptblock that retrieves the current state of the resource. This scriptblock
runs when the **Get** method for this resource is invoked.

This scriptblock should return a hash table containing one key named `Result` with a string value.

```
Type: System.String
```

### SetScript

Specify a PowerShell scriptblock that configures the resource to the desired state. This script
block runs when the **Set** method for this resource is invoked.

This script block shouldn't output any objects. This script block should be written idempotently,
so that invoking the **Set** method twice leaves the target in the same state as invoking it once.

```
Type: System.String
```

### TestScript

Specify a PowerShell scriptblock that validates whether the resource is in the desired state. This
script block runs when the **Test** mothod for this resource is invoked.

This script block should return `$true` if the resource is in the desired state and `$false` if it
isn't in the desired state.

```
Type: System.String
```

## Optional properties

### Credential

Specify the credential of an account to run the scriptblocks under if needed.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

## Read-only properties

### Result

The result from the **GetScript** script block.

```
Type: System.String
```

## Examples

- [Create a file with content][1]

<!-- Reference Links -->

[1]: Example.md
