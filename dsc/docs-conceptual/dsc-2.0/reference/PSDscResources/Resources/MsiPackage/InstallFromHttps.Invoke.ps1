[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'MsiPackage'
        ModuleName = 'PSDscResource'
        Properties = @{
            ProductId = '{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}'
            Path      = 'https://contoso.com/example.msi'
            Ensure    = 'Present'
        }
    }

    $NonGetProperties = @(
        'Ensure'
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
