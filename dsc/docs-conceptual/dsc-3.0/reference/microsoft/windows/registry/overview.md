---
description: >-
  Reference documentation for the registry command and the Microsoft.Windows/Registry DSC Resource
  provided by the command.
ms.date:     08/18/2023
ms.topic:    reference
title:       The registry command and Microsoft.Windows/Registry DSC Resource
---

# The registry command and Microsoft.Windows/Registry DSC Resource

DSCv3 includes an example command, `registry`, for managing keys and values in the Windows
registry. The command is also a [command-based DSC Resource][01].

> [!IMPORTANT]
> The `registry` command and `Microsoft.Windows/Registry` resource are a proof-of-concept example
> for use with DSCv3. Don't use it in production.

You can use `registry` to:

- Query the registry for keys and values
- Create, update, and delete registry keys and values
- Invoke the `Microsoft.Windows/Registry` resource with DSC to manage registry keys and values
  idempotently.
- Define instances of the `Microsoft.Windows/Registry` resource in DSC Configuration Documents.

For more information about using `registry` as a command, see [registry][02]. For more information
about using `registry` with DSC, see [Microsoft.Windows/Registry][03].

<!-- Link references -->
[01]: ../../../../resources/concepts/anatomy.md
[02]: cli/registry.md
[03]: resource.md
