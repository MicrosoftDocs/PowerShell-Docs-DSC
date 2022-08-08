<#
.SYNOPSIS
.DESCRIPTION
    Removes the environment variable `TestEnvironmentVariable` from both the
    machine and the process.
#>

[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Environment'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name   = 'TestEnvironmentVariable'
            Ensure = 'Absent'
            Path   = $false
            Target = @(
                'Process'
                'Machine'
            )
        }
    }

    $NonGetProperties = @(
        'Path'
        'Ensure'
    )
}

process {
    $TestResult = Invoke-DscResource -Method Test @SharedParameters

    if ($TestResult.InDesiredState) {
        $QueryParameters = $SharedParameters.Clone()

        foreach ($Property in $NonGetProperties) {
            $QueryParameters.Properties.Remove($Property)
        }

        Invoke-DscResource -Method Get @QueryParameters
    } else {
        Invoke-DscResource -Method Set @SharedParameters
    }
}
