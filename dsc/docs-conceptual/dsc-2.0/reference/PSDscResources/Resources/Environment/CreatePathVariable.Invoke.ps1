[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Environment'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name   = 'TestPathEnvironmentVariable'
            Value  = 'TestValue'
            Ensure = 'Present'
            Path   = $true
            Target = @(
                'Process'
                'Machine'
            )
        }
    }

    $NonGetProperties = @(
        'Value'
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
