---
description: >
  Class-based DSC Resources are a simplified implementation of DSC Resources.
ms.date: 09/07/2022
title:  Class-based DSC Resources
---

# Class-based DSC Resources

Class-based DSC Resources provide a simplified implementation of DSC Resources for managing the
settings of a system. This article explains their structure and requirements.

## Structure of a class-based DSC Resource

A class-based DSC Resource is defined as a [PowerShell class][01] in a module file (`.psm1`). The
class-based DSC Resource doesn't have special requirements for where it's defined. You can define
it:

- In the [root module][02], like `MyModule.psm1`
- In a [nested module][03], like `MyDscResource.psm1`

Regardless where the DSC Resource is defined, the DSC Resource must be listed in the
[DscResourcesToExport][04] property of a module manifest (`.psd1`) file. The [Get-DscResource][05]
cmdlet, the [Import-DSCResource] dynamic keyword, and DSC itself, when compiling a DSC
Configuration, will fail if the DSC Resource isn't listed a manifest.

For more information on creating a module manifest, see [New-ModuleManifest][06]. For more
information on the settings of a module manifest, see [about_Module_Manifests][07].

A class-based DSC Resource must:

1. Use the **DscResource** attribute.
1. Declare one or more properties with the **DscProperty** attribute. At least one of the properties
   must be a **Key** property.
1. Implement the **Get**, **Test**, and **Set** methods.
1. Define a default constructor if it defines any alternate constructors.

## The DscResource attribute

The definition of the class must have the [DscResource][08] attribute. This attribute indicates that
the class defines a DSC Resource.

To add the **DscResource** attribute to a class, declare it on the line immediately before the class
definition.

```powershell
[DscResource()]
class MyDscResource {
}
```

As well as identifying the class as a DSC Resource, the **DscResource** attribute applies parse-time
validation to the class-based DSC Resource. PowerShell raises a parse error for the definition of
a class-based DSC Resource when:

- One or more of the **Get**, **Test**, and **Set** methods is incorrectly defined or missing
- The class doesn't have at least one **Key** property
- The class defines a non-default constructor without defining a default constructor

The **DscResource** attribute can also be specified with the [RunAsCredential][09] property to
specify the class-based DSC Resource's behavior when using the [PsDscRunAsCredential][10] property:

- `Optional` - A user may use the **PsDscRunAsCredential** property with this DSC Resource. This is
  the default behavior. This behavior can also be specified as `Default` instead of `Optional`.
- `NotSupported` - A user can't use the **PsDscRunAsCredential** property with this DSC Resource.
- `Mandatory` - A user must use the **PsDscRunAsCredential** property with this DSC Resource.

> [!NOTE]
> While you can set the **RunAsCredential** property for a class-based DSC Resource, it has no
> effect when used with DSC v2.0 and later. The **PsDscRunAsCredential** property is only supported
> in DSC v1.1 and earlier. If you're writing a class-based DSC Resource and supporting it in DSC
> v1.1, specifying this property in the **DscResource** attribute provides some clarity and an
> improved user experience for that scenario.

## Class-based DSC Resource properties

The schema of a class-based DSC Resource is defined by the properties of the class. For a property
to be recognized as part of the schema, it must have the [DscProperty][11] attribute.

The definition of the **DscProperty** determines how DSC treats that property:

- `[DscProperty(Key)]` - Indicates that this property uniquely identifies an instance of this DSC
  Resource. Every DSC Resource must have at least one **Key** property. If a DSC Resource has more
  than one **Key** property, those properties are used together to uniquely identify an instance of
  the DSC Resource. If any **Key** properties of a DSC Resource aren't specified when using
  `Invoke-DscResource`, the cmdlet raises an error. If any **Key** properties aren't specified when
  authoring a DSC Configuration, compiling the configuration raises an error.
- `[DscProperty(Mandatory)]` - Indicates that the property must be specified when using this DSC
  Resource. If any **Mandatory** properties of a DSC Resource aren't specified when using
  `Invoke-DscResource`, the cmdlet raises an error. If any **Mandatory** properties aren't specified
  when authoring a DSC Configuration, compiling the configuration raises an error.
- `[DscProperty(NotConfigurable)]` - Indicates that the property is **ReadOnly**. It isn't a
  manageable setting of this DSC Resource, but will contain a value after the **Get** method of the
  DSC Resource is called.
- `[DscProperty()]` - Indicates that the property is a configurable setting of this DSC Resource.
  Specifying this property is optional when using `Invoke-DscResource` or authoring a DSC
  Configuration.

Like all PowerShell class properties, the properties of a class-based DSC Resource must specify a
type. This type is used to validate the specified setting when calling `Invoke-DscResource` or
compiling a DSC Configuration.

Consider this definition snippet of the `MyDscResource` class-based DSC Resource:

```powershell
[DscResource()]
class MyDscResource {
    [DscProperty(Key)]
    [string] $Path

    [DscProperty(Mandatory)]
    [hashtable]$Settings

    [DscProperty(NotConfigurable)]
    [datetime] $LastModified

    [DscProperty()]
    [string] $Format = 'YAML'
}
```

It defines four properties:

- **Path** is a **Key** property for the DSC Resource and expects to get a **String** for its value.
- **Settings** is a **Mandatory** property for the DSC Resource and expects to get a **Hashtable**
  for its value.
- **LastModified** is a **ReadOnly** property for the DSC Resource and expects to get a **DateTime**
  for its value from the **Get** method.
- **Format** is an optional property for the DSC Resource and expects to get a **String** for its
  value.

### Validation property attributes

The properties of a class-based DSC Resource may also use [validation attributes][12] to constrain
the user-specified values for a property. The validation is applied when you compile a DSC
Configuration or call `Invoke-DSCResource`. VS Code doesn't currently validate the values specified
in your DSC Configuration while you're editing it.

> [!CAUTION]
> When using `Invoke-DscResource`, validation failures for the properties don't stop the cmdlet from
> invoking the **Get**, **Test**, or **Set** method. To prevent the cmdlet from invoking a method
> when the input fails a property's validation attribute, specify your [ErrorActionPreference][13]
> as `Stop`.

Defining validation attributes for properties is simpler than implementing the same logic in a
method and is discoverable metadata about the class that defines your DSC Resource. Where possible,
it's better to be explicit about the values your DSC Resource's properties accept. This clarifies
usage and provides a safer and more reliable experience.

Consider this definition snippet of the `MyDscResource` class-based DSC Resource:

```powershell
[DscResource()]
class MyDscResource {
    [DscProperty()]
    [string]
    [ValidateSet('JSON', 'YAML')]
    $Format
}
```

It uses the **ValidateSet** attribute to limit the valid values of the **Format** property to `JSON`
and `YAML`. If you use `Invoke-DscResource` with an invalid value for **Format**, the cmdlet errors:

```powershell
$Parameters = @{
    Name       = 'MyDscResource'
    ModuleName = 'MyDscResources'
    Method     = 'Get'
    Property   = @{
        Path     = '/Dsc/Example/config.yaml'
        Format   = 'Incorrect'
        Settings = @{
            Foo = 'Bar'
        }
    }
}
Invoke-DscResource @Parameters -ErrorAction Stop
```

```Output
Invoke-DscClassBasedResource: Exception setting "Format": "The argument
"Incorrect" does not belong to the set "YAML,JSON" specified by the
ValidateSet attribute. Supply an argument that is in the set and then
try the command again."
```

For more information about the validation attributes, see [about_Functions_Advanced_Parameters][12].

### Enum properties

For a better authoring and user experience than using the **ValidateSet** attribute, you can define
an [Enum][14] that specifies a set of valid values.

For example, you could define a **FormatOption** enum and use it as the type for the **Format**
property of a class-based DSC Resource:

```powershell
enum FormatOption {
    JSON
    YAML
}

[DscResource()]
class MyDscResource {
    [DscProperty()]
    [FormatOption]
    $Format
}
```

The error message for an invalid enum value is shorter and clearer than for **ValidateSet**:

```powershell
$Parameters = @{
    Name       = 'MyDscResource'
    ModuleName = 'MyDscResources'
    Method     = 'Get'
    Property   = @{
        Path     = '/Dsc/Example/config.yaml'
        Format   = 'Incorrect'
        Settings = @{}
    }
}
Invoke-DscResource @Parameters -ErrorAction Stop
```

```Output
Invoke-DscClassBasedResource: Exception setting "Format": "Cannot
convert value "Incorrect" to type "FormatOption". Error: "Unable to
match the identifier name Incorrect to a valid enumerator name. Specify
one of the following enumerator names and try again: JSON, YAML""
```

Enums are also useful for when you need to use the same property across several class-based DSC
Resources. You can define the enum once and use it everywhere you need to, whereas with a
**ValidateSet** attribute, you need to update every DSC Resource that shares the property.

For more information on enums in PowerShell, see [about_Enum][14].

### The Ensure property

Many DSC Resources have an **Ensure** property, which controls the state of an instance of a DSC
Resource. For example, the `User` DSC Resource in the **PSDscResources** module has an **Ensure**
property that takes the values `Present` (indicating the user should exist) and `Absent` (indicating
the user shouldn't exist).

For class-based DSC Resources, the suggested practice is to create an **Ensure** enum and use it for
any ensurable DSC Resources as the type for a property named `Ensure`. For example:

```powershell
enum Ensure {
    Absent
    Present
}

[DscResource()]
class MyDscResource {
    [DscProperty()]
    [Ensure]
    $Ensure
}
```

While it's common for the **Ensure** enum to define the values `Absent` and `Present`, it can define
any values that make sense for the DSC Resource.

Using this article's `SimpleConfig` DSC Resource as an example, instead of only having `Absent` (the
config file shouldn't exist) and `Present`, you could define **Ensure** to have these values:

- `Absent` - The configuration shouldn't exist at the specified **Path**. If it does, the DSC
  Resource should remove it from the system.
- `Exactly` - The configuration should exist at the specified **Path** with the settings defined in
  the **Settings** property only. If any settings have the wrong value, the DSC Resource should
  correct them. If the configuration file has any settings not specified in the **Settings**
  property, it should remove them.
- `Include` - The configuration should exist at the specified **Path** with the settings defined in
  the **Settings** property. If any settings have the wrong value, the DSC Resource should correct
  them. If the configuration file has any settings not specified in the **Settings** property, it
  should ignore them.
- `Present` - The configuration should exist at the specified **Path**. If it doesn't, the DSC
  Resource should create it with the settings defined in the **Settings** property. If it does, the
  DSC Resource should report the instance as being in the desired state even if the settings don't
  match those specified in the **Settings** property.

That enum could be defined like this:

```powershell
enum Ensure {
    Absent
    Exactly
    Include
    Present
}
```

### Complex properties

Some properties of your DSC Resource might have subproperties. For example, the **Settings**
property of this article's `SimpleConfig` DSC Resource has been specified earlier in this article
with the **Hashtable** type. That allows a user to specify any key names and any value types for
every key.

Instead, to control the valid options, you can write a class that represents a complex property. For
the properties of this class to be recognized by DSC as subproperties, they must have the
**DscProperty** attribute.

```powershell
class SimpleConfigSettings {
    [DscProperty()] [string]
    $ProfileName

    [DscProperty()] [string]
    $Description

    [DscProperty()] [int]
    [ValidateRange(0,90)]
    $CheckForUpdates
}
```

The **SimpleConfigSettings** class defines three settings: **ProfileName** as a **String**,
**Description** as a **String**, and **CheckForUpdates** as an **Int** whose value must be between 0
and 90.

> [!NOTE]
> Even though complex properties are defined as classes and their subproperties must have the
> **DscProperty** attribute, the property attribute on the DSC Resource is the only one that applies
> any behavioral changes to the properties. Marking the subproperties as **Key**, **Mandatory**, or
> **NotConfigurable** has no effect on the behavior of DSC when compiling a DSC Configuration or
> using `Invoke-DscResource`.

With the class defined, it can be used as a property of the DSC Resource:

```powershell
[DscResource()]
class SimpleConfig {
    [DscProperty(Mandatory)] [SimpleConfigSettings]
    $Settings
}
```

With **Settings** defined as the **SimpleConfigSettings** type, users get clear information about
the value they need to supply.

```powershell
$Parameters = @{
    Name       = 'MyDscResource'
    ModuleName = 'MyDscResources'
    Method     = 'Get'
    Property   = @{
        Path   = '/Dsc/Example/config.yaml'
        Format = 'YAML'
        Settings  = @{ Name = 'Foo' }
    }
}

Invoke-DscResource @Parameters -ErrorAction Stop
```

```Output
Invoke-DscClassBasedResource: Exception setting "Settings": "Cannot
create object of type "SimpleConfigSettings". The Name property was not
found for the SimpleConfigSettings object. The available property is:
[ProfileName <System.String>] , [Description <System.String>] ,
[CheckForUpdates <System.Int32>]"
```

Complex properties can have properties that are also complex properties. There is no
limit to the level of nesting you can use. For the best user experience, limit the depth
of complex properties to three levels.

```powershell
class SimpleConfigUpdateSettings {
    [DscProperty()] [int]
    [ValidateRange(0,90)]
    $Interval

    [DscProperty()] [string]
    $Url
}

class SimpleConfigSettings {
    [DscProperty()] [string]
    $ProfileName

    [DscProperty()] [string]
    $Description

    [DscProperty()] [SimpleConfigUpdateSettings]
    $Updates
}

[DscResource()]
class SimpleConfig {
    [DscProperty(Mandatory)] [SimpleConfigSettings]
    $Settings
}
```

This example shows how defining nested complex properties provides validation. This validation
provides useful error messages when you call `Invoke-DscResource`.

```powershell
$Parameters = @{
    Name       = 'MyDscResource'
    ModuleName = 'MyDscResources'
    Method     = 'Get'
    Property   = @{
        Path     = '/Dsc/Example/config.yaml'
        Format   = 'YAML'
        Settings = @{
            ProfileName = 'Foo'
            Updates = @{
                Interval = 30
                Oops = 'Invalid property'
            }
        }
    }
}

Invoke-DscResource @Parameters -ErrorAction Stop
```

```Output
Invoke-DscClassBasedResource: Exception setting "Settings": "Cannot
create object of type "SimpleConfigSettings". Cannot create object of
type "SimpleConfigUpdateSettings". The Interval property was not found
for the SimpleConfigUpdateSettings object. The available property is:
[UpdateInterval <System.Int32>] , [UpdateUrl <System.String>]"
```

### Non-resource properties

When defining a class-based DSC Resource, you can add properties that don't have the **DscProperty**
attribute. These properties can't be used directly with `Invoke-DscResource` or in a DSC
Configuration. They can be used internally by the class or directly be a user creating an instance
of the class themselves.

For more information on class properties, see [about_Classes][15].

## Class-based DSC Resource methods

Class-based DSC Resources must implement three [methods][16]:

- **Get** to retrieve the current state of the DSC Resource
- **Test** to validate whether the DSC Resource is in the desired state
- **Set** to enforce the desired state of the DSC Resource

A method's _signature_ is defined by it's expected output type and parameters. The class won't be
recognized as a valid DSC Resource if it doesn't contain the correct signatures for these methods.

PowerShell class methods are different from functions in a few important ways. For the purposes of
writing a class-based DSC Resource, these are the most important:

- In class methods, no objects get sent to the pipeline except those mentioned in the `return`
  statement. There's no accidental output to the pipeline from the code. If the method has an output
  type other than **Void**, you must specify the `return` statement to emit an object of that type.
- Non-terminating errors written to the error stream from inside a class method aren't passed
  through. You must use `throw` to surface a terminating error.
- To access the value of a property of the class instance, use `$this.<PropertyName>`. Don't set or
  update any properties of the class that have the **DscProperty** attribute. Those are set when the
  user specifies the **Property** parameter with `Invoke-DscResource` or when defining the DSC
  Resource block in a DSC Configuration.

For more information on class methods, see [about_Classes][16].

The methods can call cmdlets and native commands, including ones defined in the same module as
the class-based DSC Resource.

### Get

The **Get** method is used to retrieve the current state of the DSC Resource and return it as an
object. It must define it's output as the class itself and take no parameters.

For example, a class-based DSC Resource called `MyDscResource` must have this signature:

```powershell
[MyDscResource] Get() {
    # Implementation here
}
```

To make the **Get** method return the correct object, you need to create an instance of the class.
Then you can populate that instance's properties with the current values from the system. Finally,
use the `return` keyword to output the current state.

```powershell
[MyDscResource] Get() {
    $CurrentState = [MyDscResource]::new()

    if (Test-Path -Path $this.Path) {
        $CurrentState.Ensure = [Ensure]::Present
        $CurrentState.Path   = $this.Path
    } else {
        $CurrentState.Ensure = [Ensure]::Absent
    }

    return $CurrentState
}
```

In the example implementation, the **Get** method initializes the `$CurrentState` variable with the
default constructor for the `MyDscResource` class. It checks to see if the file specified in the
**Path** property exists. If it does, the method sets the **Ensure** and **Path** properties on
`$CurrentState` to `Present` and the appropriate path. If it doesn't, the method sets **Ensure** to
`Absent`. Finally, the method uses a `return` statement to send the current state as output.

### Test

The **Test** method is used to validate whether the DSC Resource is in the desired state and returns
`$true` if it is or `$false` if it isn't. It must define boolean output and take no parameters.

The **Test** method's signature should always match this:

```powershell
[bool] Test() {
    # Implementation here
}
```

Instead of reimplementing the logic from the **Get** method, call the **Get** method and assign its
output to a variable.

```powershell
[bool] Test() {
    $InDesiredState = $true

    $CurrentState = $this.Get()

    if ($CurrentState.Ensure -ne $this.Ensure) {
        $InDesiredState = $false
    }

    # Check remaining properties as needed.

    return $InDesiredState
}
```

In the example implementation, the **Test** method initializes a variable, `$InDesiredState`, as
`$true` before setting `$CurrentState` to the output of the **Get** method for the class-based DSC
Resource.

It then checks the values of the properties of `$CurrentState` against those specified on the DSC
Resource instance, setting `$InDesiredState` to `$false` if any properties aren't in the desired
state.

Finally, it outputs whether the DSC Resource instance is in the desired state with a `return`
statement.

### Set

The **Set** method is used to enforce the desired state of the DSC Resource. It doesn't have any
output and takes no parameters.

The **Set** method's signature should always match this:

```powershell
[void] Set() {
    # Implementation here
}
```

The implementation of the **Set** method can't use any `return` statements. It should be written to
idempotently enforce the desired state.

> [!NOTE]
> You may need to retrieve the current state with the **Get** method if you need to enforce the
> desired state depending on the current state of the system.
>
> For example, you might have logic for creating a service when it doesn't exist instead of
> correcting an incorrect property value.
>
> This is also why it's important when using `Invoke-DscResource` to call the **Test** method and
> only call the **Set** method if **Test** returns `$false`. While all DSC Resources should be
> idempotent, you have no guarantee that any DSC Resource is truly idempotent without reviewing its
> implementation.

### Optional methods

Beyond the required **Get**, **Test**, and **Set** methods, a class-based DSC Resource can define
any number of additional methods. One use case for this is to define helper methods, such as for
code used in more than one of the required methods.

This is also useful when defining a class that represents a software component for more than just
configuration. For example, you might define a class that's both a DSC Resource enabling idempotent
configuration of an application and calling the application itself to perform tasks. That would
enable you to define the class once and use it both with DSC and functions exported from your module
for using the application.

## Constructors

A constructor is a method that creates a new instance of a class. The name of the method is always
the same as the name of the class and doesn't define an output type.

It isn't mandatory to define any constructors for a class-based DSC Resource. If you don't define a
constructor, a default parameterless constructor is used. This constructor initializes all members
to their default values. Object types and strings are given null values.

When you define a constructor, no default parameterless constructor is created. A class-based DSC
Resource must have a parameterless constructor, so if you define any custom constructors, at least
one of them must be defined without any parameters.

When you use `Invoke-DscResource` or compile a DSC Configuration, the DSC Resource is created with
the parameterless constructor and then each specified property is set on the instance.

> [!NOTE]
> When you define a constructor, it should only throw an exception if the DSC Resource isn't valid
> on the system for some reason. For example a class-based DSC Resource that only works on Windows
> might throw an exception if created on a non-Windows system.

For more information about constructors, see [about_Classes][17]

### Defining a default constructor

Class-based DSC Resources require that the class implements either no constructors or one with this
signature:

```powershell
<DscResourceClassName>() {
    # Implementation here
}
```

If there's no required logic to perform, like setting defaults based on the operating system, you
don't need to write any code in the constructor. The following example shows a minimal definition
for the default constructor:

```powershell
MyDscResource() {}
```

You can add code to the constructor to set default values for properties of your class. For example,
you may want to set a value based on the target operating system:

```powershell
MyDscResource() {
    if ($IsWindows) {
        $this.Format = 'JSON'
    } else {
        $this.Format = 'YAML'
    }
}
```

> [!NOTE]
> Remember, property validation in DSC happens after the constructor is used, not during. Don't try
> to validate any properties in the constructor.

### Defining a custom constructor

DSC only calls the parameterless constructor. However, you can define other constructors with
parameters if the class is used in other circumstances, such as by functions in your module.

For more information on defining constructors, see [about_Classes][17]

## Best practices

This is a non-exhaustive list of best practices for authoring high quality class-based DSC Resources
that are idempotent, safe, and maintainable. It supplements the
[DSC Resource authoring checklist][18], which defines more general guidance for authoring DSC
Resources. The practices in this section are specific to class-based DSC Resources.

### Use validation attributes

If you can validate a property with on or more of the [validation attributes][12] do so. This
validation is checked before any method is called with `Invoke-DscResource` and when you compile a
DSC Configuration. Raising an error earlier reduces the chances that the DSC Resource will fail in
an unpredictable way when enforcing state.

The errors raised by the built-in validation attributes are also clear about which property had
an invalid value and how the value was invalid.

> [!NOTE]
> Only use validation attributes to ensure the user input for a property is valid, not to see
> whether the property is in the correct state. That's what the **Test** method is for.
>
> For example, don't validate that a **Path** value exists already unless it's required to exist for
> the rest of the DSC Resource's logic to work. If the DSC Resource creates a file at that location,
> don't validate its existence on the property declaration.

If you're using any [complex properties][19], be sure to apply validation attributes to those
subproperties as well. Those subproperties are validated at the same time as their parent property.

### Use enums instead of ValidateSet

If a property of the class-based DSC Resource has a list of valid values it accepts, define it as an
[enum property][20] instead of using the **ValidateSet** attribute.

This gives users a better error message and makes maintenance easier if you use those values
anywhere else in your module. Instead of having to update every cmdlet or check for that property,
you can update the enum definition.

### Use a custom validation attribute instead of ValidateScript

For properties that require more complex validation, consider defining your own attribute that
inherits from the [ValidateArgumentsAttribute][21] class or one of its derivatives.

This gives you much more control over the validation of the property and the messaging for when a
specified value fails validation.

For example, this definition of the **ValidateHttpsUrl** attribute ensures that a specified value is
a valid HTTPS URL.

```powershell
using namespace System.Management.Automation

class ValidateHttps : ValidateArgumentsAttribute {
    [void]  Validate([object]$Url, [EngineIntrinsics]$engineIntrinsics) {
        [uri]$Uri = $Url

        if($Uri.Scheme -ne 'https') {
            $Message = @(
                "Specified value '$Url' is not a valid HTTPS URL."
                "Specify an absolute URL that begins with 'https://'."
            ) -join ' '

            throw [System.ArgumentException]::new($Message)
        }
    }
}
```

When applied to a property, the DSC Resource raises a useful error message:

```powershell
$Parameters = @{
    Name       = 'MyDscResource'
    ModuleName = 'MyDscResources'
    Method     = 'Get'
    Property   = @{
      Url = 'http://contoso.com/updater'
    }
}

Invoke-DscResource @Parameters -ErrorAction Stop
```

```Output
Invoke-DscClassBasedResource: Exception setting "Url": "Specified value
'http://contoso.com/updater'  is not a valid HTTPS URL. Specify an absolute
URL that begins with 'https://'."
```

> [!NOTE]
> Due to limitations in DSC, you can't define and use a custom validation attribute in the same
> module as the class-based DSC Resource. Instead, you need to define your custom validation
> attribute in a separate `.psm1` file, add it to the main module's manifest in the
> **NestedModules** setting, and specify a `using` statement in the file your class-based DSC
> Resource is defined in.
>
> For example, if you defined the **ValidateHttps** attribute in `Validators.psm1`, you would need
> to have it in your module manifest:
>
> ```powershell
> {
>     NestedModules = @(
>         'Validators.psm1'
>     )
> }
> ```
>
> And at the top of your module file where you define your class-based DSC Resource:
>
> ```powershell
> using module ./Validators.psm1
> ```
>
> In this example `Validators.psm1` is in the same folder as the module where the class-based DSC
> Resource is defined. If the files are in different folders, you need to specify the relative path
> to the module that defines the validation attribute.

### Use complex properties instead of hashtables

If your DSC Resource has a property with known subproperties, create a class for it and define those
subproperties on that class. This provides a more discoverable surface for the settings and allows
you to apply validation on subproperties. For more information, see [Complex properties][19].

### Add a Validation method if properties are interdependent

You may have a DSC Resource that has properties that must be combined to be validated. These
properties can't be validated by a validation attribute. Add a validation method to your class-based
DSC Resource and call it at the beginning of your **Get**, **Test**, and **Set** methods.

For example, if your DSC Resource for managing a configuration file has the **Path** and
**Extension** properties you might need to validate:

- That the extension of a file specified as the **Path** either matches the value of **Extension**
  or **Extension** isn't specified
- That **Extension** is specified if the value of **Path** is a folder instead of a file

Your validation method should have an unambiguous name, not return any output, and throw if the
instance fails validation.

```powershell
[void] ValidatePath() {
    $ExtensionSpecified = ![string]::IsNullOrEmpty($this.Extension)
    $PathExtension = Split-Path -Path $this.Path -Extension

    if (
        $PathExtension -and
        $ExtensionSpecified -and
        ($PathExtension -ne $this.Extension)
    ) {
        $Message = @(
            "Specified Path '$($this.Path)' has an extension ('$PathExtension')"
            "which doesn't match the value of the Extension property"
            "'$($this.Extension)'. When specifying the Extension property with"
            "the Path property as a specific file, the extension of Path's"
            "value must be the same as the value of Extension or Extension must"
            "not be specified."
        ) -join ' '

        throw [System.ArgumentException]::new($Message)
    } elseif (!$ExtensionSpecified) {
        $Message = @(
            "Specified Path '$($this.Path)' has no extension and the Extension"
            "property wasn't specified. When the value of Path is a folder, the"
            "Extension property is mandatory. Specify a value for Extension."
        ) -join ' '

        throw [System.ArgumentException]::new($Message)
    }
}
```

If you need to validate several different parameters or groups of parameters in this way, define a
generic validation method that calls the others. Use that method in **Get**, **Test**, and **Set**.

### Extract shared code into methods or functions

If your methods are lengthy with complex logic or reuse the same code between them, create a helper
method or function and move the code there instead. This makes testing and maintaining your DSC
Resource easier. It also makes your DSC Resource's methods easier to read and understand.

<!-- Reference Links -->

[01]: /powershell/module/microsoft.powershell.core/about/about_classes
[02]: /powershell/module/microsoft.powershell.core/about/about_module_manifests#rootmodule
[03]: /powershell/module/microsoft.powershell.core/about/about_module_manifests#nestedmodules
[04]: /powershell/module/microsoft.powershell.core/about/about_module_manifests#dscresourcestoexport
[05]: /powershell/module/psdesiredstateconfiguration/get-dscresource
[06]: /powershell/module/microsoft.powershell.core/new-modulemanifest
[07]: /powershell/module/microsoft.powershell.core/about/about_module_manifests
[08]: /dotnet/api/system.management.automation.dscresourceattribute
[09]: /dotnet/api/system.management.automation.dscresourceattribute.runascredential
[10]: /powershell/dsc/configurations/runasuser?view=dsc-1.1&preserve-view=true
[11]: /dotnet/api/system.management.automation.dscpropertyattribute
[12]: /powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters#parameter-and-variable-validation-attributes
[13]: /powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference
[14]: /powershell/module/microsoft.powershell.core/about/about_enum
[15]: /powershell/module/microsoft.powershell.core/about/about_classes#class-properties
[16]: /powershell/module/microsoft.powershell.core/about/about_classes#class-methods
[17]: /powershell/module/microsoft.powershell.core/about/about_classes#constructor
[18]: ../how-tos/resources/authoring/checklist.md
[19]: #complex-properties
[20]: #enum-properties
[21]: /dotnet/api/system.management.automation.validateargumentsattribute
