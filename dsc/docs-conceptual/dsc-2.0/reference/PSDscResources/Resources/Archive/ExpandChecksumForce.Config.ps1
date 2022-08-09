Configuration ExpandArchiveChecksumAndForce {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Archive ExpandArchive {
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate    = $true
            Checksum    = 'SHA-256'
            Force       = $true
            Ensure      = 'Present'
        }
    }
}
