Configuration Uninstall {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsFeatureSet ExampleWindowsFeatureSet {
            Name                 = @(
                'Telnet-Client'
                'RSAT-File-Services'
            )
            Ensure               = 'Absent'
            LogPath              = 'C:\LogPath\Log.log'
        }
    }
}
