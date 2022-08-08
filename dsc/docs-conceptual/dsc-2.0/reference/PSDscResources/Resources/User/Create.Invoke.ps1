[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $PasswordCredential
)

begin {
    $SharedParameters = @{
        Name       = 'User'
        ModuleName = 'PSDscResource'
        Properties = @{
            Ensure   = 'Present'
            UserName = 'SomeUserName'
            Password = $PasswordCredential
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'Password'
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
