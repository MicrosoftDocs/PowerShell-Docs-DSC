Configuration Enable {
    Import-DscResource -ModuleName 'PSDscResources'

    Node Localhost {
        WindowsOptionalFeatureSet ExampleWindowsOptionalFeatureSet {
            Name    = @(
                'MicrosoftWindowsPowerShellV2'
                'Internet-Explorer-Optional-amd64'
            )
            Ensure  = 'Present'
            LogPath = 'C:\LogPath\Log.txt'
        }
    }
}