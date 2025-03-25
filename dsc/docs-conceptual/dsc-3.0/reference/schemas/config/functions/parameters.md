---
description: Reference for the 'parameters' DSC configuration document function
ms.date:     05/09/2024
ms.topic:    reference
title:       parameters
---

# parameters

## Synopsis

Returns the value of a configuration parameter.

## Syntax

```Syntax
parameters('<name>')
```

## Description

The `parameters()` function returns the value of a specific parameter. You must pass the name of
a valid parameter. When using this function for a resource instance, DSC validates the instance
properties after this function runs and before calling the resource for the current operation. If
the referenced parameter value is invalid for the property, DSC raises a validation error.

For more information about defining parameters in a configuration document, see
[DSC Configuration document parameter schema][01].

## Examples

### Example 1 - Use a parameter as a resource instance property value

The configuration uses the `parameters()` function to echo the value of the `message` parameter.

```yaml
# parameters.example.1.dsc.config.yaml
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
parameters:
  message:
    type:         string
    defaultValue: Hello, world!
resources:
  - name: Echo message parameter
    type: Test/Echo
    properties:
      text: "[parameters('message')]"
```

First, get the current state of the configuration without overriding the parameters with the
[--parameters][02] or [`--parameters-file`][03] options. The output shows the default value for the
`message` parameter.

```bash
config_file=parameters.example.1.dsc.config.yaml
cat $config_file | dsc config get --file -
```

```yaml
results:
- name: Echo message parameter
  type: Test/Echo
  result:
    actualState:
      text: Hello, world!
messages: []
hadErrors: false
```

Next, override the `message` parameter with the `--parameters` option.

```bash
params='{"parameters": {"message": "Hi, override."}}'
cat $config_file | dsc config --parameters $params get --file -
```

```yaml
results:
- name: Echo message parameter
  type: Test/Echo
  result:
    actualState:
      text: Hi, override.
messages: []
hadErrors: false
```

## Parameters

### name

The `parameters()` function expects a single string as input, representing the name of the
parameter to return. If no parameter with the specified name is defined in the configuration
document, DSC raises an error during validation.

```yaml
Type:         string
Required:     true
MinimumCount: 1
MaximumCount: 1
```

## Output

The `parameters()` function returns the value of the specified parameter.

```yaml
Type: [string, int, bool, object, array]
```

<!-- Link reference definitions -->
[01]: ../parameter.md
[02]: ../../../cli/config/index.md#--parameters
[03]: ../../../cli/config/index.md#--parameters-file
