[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
$Credential = (Get-Credential)
)

begin {
    $SharedParameters = @{
        Name       = 'WindowsFeatureSet'
        ModuleName = 'PSDscResource'
        Properties = @{
            Path       = 'C:\Windows\System32\gpresult.exe'
            Arguments  = ''
            Credential = $Credential
            Ensure     = 'Absent'
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
