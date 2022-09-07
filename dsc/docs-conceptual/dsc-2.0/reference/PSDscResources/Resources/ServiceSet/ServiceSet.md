---
description: PSDscResources ServiceSet composite resource
ms.date: 08/08/2022
ms.topic: reference
title: ServiceSet
---

# ServiceSet

## Synopsis

Manage multiple services with common settings.

## Syntax

```Syntax
ServiceSet [String] #ResourceName
{
    [DependsOn = [String[]]]
    [PsDscRunAsCredential = [PSCredential]]
    Name = [String[]]
    [Ensure = [String]]
    [StartupType = [String]]
    [BuiltInAccount = [String]]
    [State = [String]]
    [Credential = [PSCredential]]
}
```

## Description

`ServiceSet` is a composite resource that makes it simpler to manage multiple services at once with
shared but limited configurations. This resource can only update or remove existing services. It
can't create services. For more control over the configuration of your services, see the
[Service resource][1].

> [!IMPORTANT]
> Composite resources don't work with `Invoke-DscResource`. This resource is only usable inside a
>`Configuration` definition.

### Requirements

None.

## Properties

## Key properties

### Name

Specify the names of the services as an array of strings.

This may be different from the service's display name. To retrieve a list of all services with their
names and current states, use the `Get-Service` cmdlet.

```
Type: System.String[]
Behavior: Key
```

## Optional properties

### BuiltInAccount

Specify the name of the machine account to run the service as. The account must have access to each
service's executable to start the service.

Don't specify this property with the **Credential** property.

```
Type: System.String
Accepted Values:
  - LocalService
  - LocalSystem
  - NetworkService
Default Value: Null
```

### Credential

Specify the credential for an account to run the services as. The account must have access to each
service's executable to start that service. The resource automatically grants this account the "Log
on as a Service" right.

Don't specify this property with the **BuiltInAccount** property.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Ensure

Specify whether the services should exist. To add or update a service, set this property to
`Present`. To remove a service, set this property to `Absent`.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### StartupType

Specify how the services should behave on system start-up. The value must be one of the following:

- `Automatic` - The service is started by the operating system at system start-up. If an
  automatically started service depends on a manually started service, the manually started service
  is also started automatically at system start-up.
- `Disabled` - The service is disabled and can't be started by a user or application.
- `Manual` - The service is started only manually, by a user, using the Service Control Manager, or
  by an application.

If the service doesn't exist, the default value is `Automatic`.

```
Type: System.String
Behavior: Write
Accepted Values:
  - Automatic
  - Disabled
  - Manual
Default Value: None
```

### State

Specify whether the services should run. The value must be one of the following:

- `Running` - The resource starts the service if it's not already started.
- `Stopped` - The resource stops the service if it's running.
- `Ignore` - The resource doesn't start or stop the service.

The default value is `Running`.

```
Type: System.String
Accepted Values:
  - Running
  - Stopped
  - Ignore
Default Value: Running
```

## Examples

- [Ensure that multiple services are running][2]
- [Set multiple services to run under the built-in account LocalService][3]

<!-- Reference Links -->

[1]: ../Service/Service.md
[2]: BuiltInAccount.md
[3]: Start.md
