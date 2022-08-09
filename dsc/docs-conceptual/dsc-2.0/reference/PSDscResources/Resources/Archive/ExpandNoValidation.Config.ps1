Configuration ExpandArchiveNoValidation {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Archive ExampleArchive {
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Ensure      = 'Present'
        }
    }
}
