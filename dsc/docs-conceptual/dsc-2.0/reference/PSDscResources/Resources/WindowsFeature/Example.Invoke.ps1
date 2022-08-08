[CmdletBinding()]
param(
    [System.String]
    $Name = 'Telnet-Client',

    [ValidateSet('Present', 'Absent')]
    [System.String]
    $Ensure = 'Present',

    [System.Boolean]
    $IncludeAllSubFeature = $false,

    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential,

    [ValidateNotNullOrEmpty()]
    [System.String]
    $LogPath
)

begin {
    $SharedParameters = @{
        Name       = 'WindowsFeature'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name                 = $Name
            Ensure               = $Ensure
            IncludeAllSubFeature = $IncludeAllSubFeature
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'IncludeAllSubFeature'
    )
}

process {
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $SharedParameters.Properties.Credential = $Credential
        $NonGetProperties += 'Credential'
    }

    if ($PSBoundParameters.ContainsKey('LogPath')) {
        $SharedParameters.Properties.LogPath = $LogPath
        $NonGetProperties += 'LogPath'
    }

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
