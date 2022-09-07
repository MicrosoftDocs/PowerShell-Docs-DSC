---
description: >
  Use the PSDscResources Script resource to create a file with content.
ms.date: 08/08/2022
ms.topic: reference
title: Create a file with content
---

# Create a file with content

## Description

This example shows how you can use the `Script` resource to create a file.

To use the `Script` resource, you need to specify three code blocks. The **GetScript**,
**TestScript**, and **SetScript**.

This example uses two parameters of user input. **FilePath** sets the path the file should exist at
and **FileContent** sets the contents of the file. These values are referenced in the scriptblocks
with the `using` directive.

### GetScript

```powershell
$fileContent = $null

if (Test-Path -Path $using:FilePath) {
    $fileContent = Get-Content -Path $using:filePath -Raw
}

return @{
    Result = $fileContent
}
```

In the **GetScript** scriptblock, the code checks to see if the file specified by **FilePath**
exists. If it does, the scriptblock returns that file's current contents for the result. If it
doesn't, the scriptblock returns `$null` for the result.

### TestScript

```powershell
if (Test-Path -Path $using:FilePath) {
    $fileContent = Get-Content -Path $using:filePath -Raw
    return ($fileContent -eq $using:FileContent)
} else {
    return $false
}
```

In the **TestScript** scriptblock, the code checks to see if the file specified by **FilePath**
exists. If it doesn't, the scriptblock returns `$false`. If it does exist, the code compares the
current contents of the file to the contents specified by **FileContent**. If the contents match,
the scriptblock returns `$true`. If they don't, the scriptblock returns `$false`.

### SetScript

```powershell
$streamWriter = New-Object -TypeName 'System.IO.StreamWriter' -ArgumentList @(
    $using:FilePath
)
$streamWriter.WriteLine($using:FileContent)
$streamWriter.Close()
```

In the **SetScript** scriptblock, the code creates a **System.IO.StreamWriter** object to write to
the file specified by **FilePath**. It writes the content specified by **FileContent** and then
closes the **StreamWriter** object.

## With Invoke-DscResource

This script shows how you can use the `Script` resource with the `Invoke-DscResource` cmdlet to
ensure a file exists with specific content.

:::code source="Example.Invoke.ps1":::

## With a Configuration

This snippet shows how you can define a `Configuration` with a `Script` resource block to ensure a
file exists with specific content.

:::code source="Example.Config.ps1":::
