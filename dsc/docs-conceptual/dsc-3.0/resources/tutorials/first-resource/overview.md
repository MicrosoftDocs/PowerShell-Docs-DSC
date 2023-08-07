---
description: >-
  Explains the How to write your first DSC Resource samples at a high level.
ms.date: 08/04/2023
title:   Write your first DSC Resource samples overview
---

# Write your first DSC Resource samples overview

Each of the samples in this section are the completed DSC Resource from one of the implementations
of the [Write your first DSC Resource][01] tutorial.

The resources manage the fictional [TSToy application][02]'s configuration files. While the
TSToy application isn't a real production application, managing configuration files is a common
use-case for resources.

The sample resources support:

- Passing input to the resource command with command line arguments or JSON over stdin.
- Getting the current state of the TSToy application's configuration files without DSC.
- Enforcing the state of the configuration files without DSC.
- Invoking the **Get**, **Test**, and **Set** operations with DSC.
- Declaring instances of the resource in a DSC Configuration document.

The sample code is hosted in the [DSC Samples repository][03]. For more information about the
specification for the sample code's implementation, see
[Write your first DSC Resource Specification][04].

We welcome contributions to the samples repository. For more information, see
[Contributing to the DSC Samples][05].

[01]: ../../tutorials/first-resource/overview.md
[02]: https://powershell.github.io/DSC-Samples/tstoy/about
[03]: https://github.com/PowerShell/DSC-Samples
[04]: https://powershell.github.io/DSC-Samples/contributing/tutorials/resource-specs/first-resource/
[05]: https://powershell.github.io/DSC-Samples/contributing
