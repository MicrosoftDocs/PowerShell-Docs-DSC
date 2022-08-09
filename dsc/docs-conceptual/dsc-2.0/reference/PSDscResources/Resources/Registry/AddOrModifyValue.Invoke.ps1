[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Registry'
        ModuleName = 'PSDscResource'
        Properties = @{
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
            Ensure    = 'Present'
            ValueName = 'MyValue'
            ValueType = 'Binary'
            ValueData = '0x00'
            Force     = $true
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'ValueType'
        'ValueData'
        'Force'
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
