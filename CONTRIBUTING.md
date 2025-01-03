# Contributor Guide

Thank you for your interest in contributing to quality documentations. As an open source project, we
welcome input and updates from the community.

The process for contributing to this project is documented in our
[Contributor's Guide](https://aka.ms/PSDocsContributor).

## PowerShell-Docs-DSC structure

There are three categories of content in this repository:

- reference content
- conceptual content
- metadata and configuration files

### Reference content

The reference content is the PowerShell cmdlet reference for the DSC cmdlets. The cmdlet reference
is collected in versioned folders (like dsc-1.1, dsc-2.0, and dsc-3.0). This content is also used to
create the help information displayed by the `Get-Help` cmdlet.

### Conceptual content

The conceptual documentation is also organized by version.

> [!NOTE]
> Anytime a conceptual article is added, removed, or renamed, the TOC must be updated and deleted or
> renamed files must be redirected.

### Metadata files

This project contains several types of metadata files. The metadata files control the behavior of
our build tools and the publishing system. Only PowerShell-Docs maintainers and approved
contributors are allowed to change these files. If you think that a meta file should be changed,
open an issue to discuss the needed changes.

Meta files in the root of the repository

- `.*` - configuration files in the root of the repository
- `*.md` - Project documentation in the root of the repository
- `*.yml` - build automation files
- `.devcontainer/*` - devcontainer configuration files
- `.github/**/*` - GitHub templates, actions, and other meta files
- `.vscode/**/*` - VS Code extension configurations

Meta files in the documentation set

- `dsc/**/*.json` - docset configuration files
- `dsc/**/*.yml` - TOC and other structured content files
- `dsc/**/*.ps1` - Example DSC resources and configurations
- `dsc/breadcrumb/*` - breadcrumb navigation configuration
- `dsc/includes/*` - markdown include files
- `dsc/mapping/*` - version mapping configuration
- `dsc/**/media/**` - image files used in documentation
