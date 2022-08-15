[CmdletBinding()]
param(
    [Parameter (Mandatory = $true)]
    [String]
    $FeatureName,

    [Parameter(Mandatory = $true)]
    [String]
    $LogPath
)

begin {
    $SharedParameters = @{
        Name       = 'WindowsOptionalFeature'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name    = $FeatureName
            Ensure  = 'Present'
            LogPath = $LogPath
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'LogPath'
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
