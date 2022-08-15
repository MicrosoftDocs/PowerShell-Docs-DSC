Configuration RemoveArchiveChecksum {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Archive ExampleArchive {
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate    = $true
            Checksum    = 'SHA-256'
            Ensure      = 'Absent'
        }
    }
}