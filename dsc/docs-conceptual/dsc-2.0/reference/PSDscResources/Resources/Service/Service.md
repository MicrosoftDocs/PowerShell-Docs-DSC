---
description: PSDscResources Service resource
ms.date: 08/08/2022
ms.topic: reference
title: Service
---

# Service

## Synopsis

Manage a Windows service.

## Syntax

```Syntax
Service [String] #ResourceName
{
    Name = [string]
    [BuiltInAccount = [string]{ LocalService | LocalSystem | NetworkService }]
    [Credential = [PSCredential]]
    [Dependencies = [string[]]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [DesktopInteract = [bool]]
    [DisplayName = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Path = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [StartupTimeout = [UInt32]]
    [StartupType = [string]{ Automatic | Disabled | Manual }]
    [State = [string]{ Ignore | Running | Stopped }]
    [TerminateTimeout = [UInt32]]
}
```

## Description

The `Service` resource enables you to add, update, and remove services.

### Requirements

None.

## Key properties

### Name

Specify the service name as a string.

> [!NOTE]
> Sometimes this value is different from the display name. You can get a list of the services and
> their current state with the `Get-Service` cmdlet.

```
Type: System.String
```

## Optional properties

### BuiltInAccount

Specify the name of the machine account to run the service as. The account must have access to the
executable specified by **Path** in order to start the service.

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

Specify the credential for an account to run the service as. The account must have access to the
executable specified by **Path** to start the service. The resource automatically grants this
account the "Log on as a Service" right.

Don't specify this property with the **BuiltInAccount** property.

```
Type: System.Management.Automation.PSCredential
Default Value: None
```

### Dependencies

Specify the names of services that this service requires to be running as an array of strings.

```
Type: System.String[]
Default Value: None
```

### Description

Specify the description of the service as a string. The service description appears in
**Computer Management, Services**.

```
Type: System.String
Default Value: None
```

### DesktopInteract

Specify whether the service can create or communicate with a window on the desktop. This property
must be `$false` if **BuiltInAccount** isn't specified as `LocalSystem`.

The default value is `$false`.

```
Type: System.Boolean
Default Value: false
```

### DisplayName

Specify the human-friendly display name of the service as a string.

```
Type: System.String
Default Value: None
```

### Ensure

Specify whether the service should exist. To add or update a service, set this property to
`Present`. To remove a service, set this property to `Absent`.

The default value is `Present`.

```
Type: System.String
Accepted Values:
  - Absent
  - Present
Default Value: Present
```

### Path

Specify the path to the service's executable file as a string. This property is required if the
service doesn't exist.

```
Type: System.String
Default Value: None
```

### StartupTimeout

Specify the time to wait for the service to start in milliseconds.

The default value is `30000`.

```
Type: System.UInt32
Default Value: 30000
```

### StartupType

Specify how the service should behave on system start-up. The value must be one of the following:

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

Specify whether the service should run. The value must be one of the following:

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

### TerminateTimeout

Specify the time to wait for the service to stop in milliseconds. The default value is `30000`.

```
Type: System.UInt32
Default Value: 30000
```

## Examples

- [Create a service][1]
- [Delete a service][2]
- [Update a service's StartupType][3]

<!-- Reference Links -->

[1]: Create.md
[2]: Delete.md
[3]: UpdateStartupType.md
