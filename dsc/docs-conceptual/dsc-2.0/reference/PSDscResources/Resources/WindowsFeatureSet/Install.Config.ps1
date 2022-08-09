Configuration Install {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsFeatureSet ExampleWindowsFeatureSet {
            Name                 = @(
                'Telnet-Client'
                'RSAT-File-Services'
            )
            Ensure               = 'Present'
            IncludeAllSubFeature = $true
            LogPath              = 'C:\LogPath\Log.log'
        }
    }
}
