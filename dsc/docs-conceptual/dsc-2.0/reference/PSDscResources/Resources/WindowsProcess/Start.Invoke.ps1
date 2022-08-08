[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'WindowsProcess'
        ModuleName = 'PSDscResource'
        Properties = @{
            Path      = 'C:\Windows\System32\gpresult.exe'
            Arguments = '/h C:\gp2.htm'
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
