---
description: Overview for the JSON Schemas defining expected stdout for DSC Resource operations.
ms.date:     08/21/2025
ms.topic:    reference
title:       Overview of DSC resource operation stdout schemas
---

# Overview of DSC resource operation stdout schemas

DSC is designed around strong contracts and data models to define how resources integrate into DSC
and the wider ecosystem. As part of this contract, DSC defines JSON Schemas for the expected text
resources emit to stdout for each resource operation.

The following schemas describe the expected output for each operation and how DSC validates the
data a resource emits:

- [DSC resource delete operation stdout schema reference](./delete.md)
- [DSC resource export operation stdout schema reference](./export.md)
- [DSC resource get operation stdout schema reference](./get.md)
- [DSC resource list operation stdout schema reference](./list.md)
- [DSC resource resolve operation stdout schema reference](./resolve.md)
- [DSC resource schema operation stdout schema reference](./schema.md)
- [DSC resource test operation stdout schema reference](./test.md)
- [DSC resource validate operation stdout schema reference](./validate.md)
- [DSC resource what-if operation stdout schema reference](./whatIf.md)
