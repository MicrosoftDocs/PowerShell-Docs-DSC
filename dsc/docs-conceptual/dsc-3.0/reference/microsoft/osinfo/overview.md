---
description: >-
  Reference documentation for the osinfo command and the Microsoft/OSInfo DSC Resource provided by
  the command.
ms.date:     08/18/2023
ms.topic:    reference
title:       The osinfo command and Microsoft/OSInfo DSC Resource
---

# The osinfo command and Microsoft/OSInfo DSC Resource

DSCv3 includes an example command, `registry`, for managing keys and values in the Windows
registry. The command is also a [command-based DSC Resource][01].

> [!IMPORTANT]
> The `osinfo` command and `Microsoft/OSInfo` resource are a proof-of-concept example for use with
> DSCv3. Don't use it in production.

You can use `osinfo` to:

- Get information about the operating system.
- Invoke the `Microsoft/OSInfo` resource with DSC to validate operating system information.
- Define instances of the `Microsoft/OSInfo` resource in DSC Configuration Documents.

For more information about using `osinfo` as a command, see [osinfo][02]. For more information
about using `osinfo` with DSC, see [Microsoft/OSInfo][03].

<!-- Link references -->
[01]: ../../../resources/concepts/anatomy.md
[02]: cli/osinfo.md
[03]: resource.md
