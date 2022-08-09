[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Group'
        ModuleName = 'PSDscResource'
        Properties = @{
            GroupName = 'GroupName1'
            Ensure    = 'Present'
            Members   = @(
                'Username1'
                'Username2'
            )
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'Members'
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
