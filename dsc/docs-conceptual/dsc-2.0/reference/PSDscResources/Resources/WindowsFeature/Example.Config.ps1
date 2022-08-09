Configuration Example {
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

    Import-DscResource -ModuleName 'PSDscResources'

    $HasCredential = $null -ne $Credential
    $HasLogPath = ![string]::IsNullOrEmpty($LogPath)

    Node Localhost {
        if ($HasCredential -and $HasLogPath) {
            WindowsFeature ExampleWindowsFeature {
                Name                 = $Name
                Ensure               = $Ensure
                IncludeAllSubFeature = $IncludeAllSubFeature
                Credential           = $Credential
                LogPath              = $LogPath
            }
        } elseif ($HasCredential) {
            WindowsFeature ExampleWindowsFeature {
                Name                 = $Name
                Ensure               = $Ensure
                IncludeAllSubFeature = $IncludeAllSubFeature
                Credential           = $Credential
            }
        } elseif ($HasLogPath) {
            WindowsFeature ExampleWindowsFeature {
                Name                 = $Name
                Ensure               = $Ensure
                IncludeAllSubFeature = $IncludeAllSubFeature
                LogPath              = $LogPath
            }
        } else {
            WindowsFeature ExampleWindowsFeature {
                Name                 = $Name
                Ensure               = $Ensure
                IncludeAllSubFeature = $IncludeAllSubFeature
            }
        }
    }
}
