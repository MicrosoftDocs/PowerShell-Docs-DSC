---
description: Reference for the 'concat' DSC configuration document function
ms.date:     03/06/2024
ms.topic:    reference
title:       concat
---

# concat

## Synopsis

Returns a string of combined values.

## Syntax

```Syntax
concat(<inputValue>, <inputValue>[, <inputValue>...])
```

## Description

The `concat()` function combines multiple values and returns the concatenated values as a single
string. Separate each value with a comma. The `concat()` function is variadic. You must pass at
least two values to the function. The function can accept any number of arguments.

The function concatenates the input values without any joining character. It accepts only strings
or arrays of strings as input values. The input values must be of the same type. If you pass a
string and an array to the same function, the function raises an error.

## Examples

### Example 1 - Concatenate strings

The configuration uses the `concat()` function to join the strings `abc` and `def`

```yaml
# concat.example.1.dsc.config.yaml
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2023/10/config/document.json
resources:
  - name: Echo 'abcdef'
    type: Test/Echo
    properties:
      output: "[concat('abc', 'def')]"
```

```bash
dsc --input-file concat.example.1.dsc.config.yaml config get
```

```yaml
results:
- name: Echo 'abcdef'
  type: Test/Echo
  result:
    actualState:
      output: abcdef
messages: []
hadErrors: false
```

## Parameters

### inputValue

A value to concatenate. Each value must be either a string or an array of strings. The strings are
are added to the output string in the same order you pass them to the function.

```yaml
Type:         [string, array]
Required:     true
MinimumCount: 2
MaximumCount: 18446744073709551615
```

## Output

The output of the function is a single string with every **inputValue** concatenated together.

```yaml
Type: string
```

<!-- Link reference definitions -->
