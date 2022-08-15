<#
.SYNOPSIS
.DESCRIPTION
    Removes the environment variable `TestEnvironmentVariable` from both the
    machine and the process.
#>

configuration Sample_Environment_Remove {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Environment ExampleEnvironment {
            Name   = 'TestEnvironmentVariable'
            Ensure = 'Absent'
            Path   = $false
            Target = @(
                'Process'
                'Machine'
            )
        }
    }
}
