[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Service'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name        = 'Service1'
            Ensure      = 'Present'
            StartupType = 'Manual'
            State       = 'Ignore'
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'StartupType'
        'State'
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
