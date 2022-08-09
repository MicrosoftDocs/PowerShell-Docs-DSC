Configuration ExpandArchiveNoValidationCredential {
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Archive ExampleArchive {
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Credential  = $Credential
            Ensure      = 'Present'
        }
    }
}
