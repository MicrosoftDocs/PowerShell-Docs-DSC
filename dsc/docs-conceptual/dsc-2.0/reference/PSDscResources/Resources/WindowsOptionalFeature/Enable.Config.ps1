Configuration Enable {
    param(
        [Parameter (Mandatory = $true)]
        [String]
        $FeatureName,

        [Parameter(Mandatory = $true)]
        [String]
        $LogPath
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node Localhost {
        WindowsOptionalFeature TelnetClient {
            Name    = $FeatureName
            Ensure  = 'Present'
            LogPath = $LogPath
        }
    }
}
