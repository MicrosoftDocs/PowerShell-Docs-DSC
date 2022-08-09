[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Archive'
        ModuleName = 'PSDscResource'
        Properties = @{
            Path        = 'C:\ExampleArchivePath\Archive.zip'
            Destination = 'C:\ExampleDestinationPath\Destination'
            Validate    = $true
            Checksum    = 'SHA-256'
            Ensure      = 'Absent'
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'Validate'
        'Checksum'
    )
}

process {
    $TestResult = Invoke-DscResource -Method Test @SharedParameters

    if ($TestResult.InDesiredState) {
        $QueryParameters = $SharedParameters.Clone()

        foreach ($Property in $NonGetProperties) {
            $QueryParameters.Properties.Remove($Property)
        }

        Invoke-DscResource -Method Get @QueryParameters
    } else {
        Invoke-DscResource -Method Set @SharedParameters
    }
}
