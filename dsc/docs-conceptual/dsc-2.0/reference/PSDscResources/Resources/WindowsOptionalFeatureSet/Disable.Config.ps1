Configuration Disable {
    Import-DscResource -ModuleName 'PSDscResources'

    Node Localhost {
        WindowsOptionalFeatureSet ExampleWindowsOptionalFeatureSet {
            Name                 = @(
                'TelnetClient'
                'LegacyComponents'
            )
            Ensure               = 'Absent'
            RemoveFilesOnDisable = $true
        }
    }
}