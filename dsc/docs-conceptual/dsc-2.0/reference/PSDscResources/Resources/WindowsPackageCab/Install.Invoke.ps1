[CmdletBinding()]
param(
    [Parameter (Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Name,

    [Parameter (Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SourcePath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $LogPath
)

begin {
    $SharedParameters = @{
        Name       = 'WindowsPackageCab'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name       = $Name
            Ensure     = 'Present'
            SourcePath = $SourcePath
            LogPath    = $LogPath
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'SourcePath'
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
