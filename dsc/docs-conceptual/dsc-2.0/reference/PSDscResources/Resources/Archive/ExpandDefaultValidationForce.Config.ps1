Configuration ExpandArchiveDefaultValidationAndForce {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Archive ExampleArchive {
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate    = $true
            Force       = $true
            Ensure      = 'Present'
        }
    }
}
