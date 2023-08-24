[CmdletBinding()]
param()

begin {
    $Resource           = dsc resource list Microsoft.Windows/Registry
    $InstanceProperties = @{
        _ensure = 'Present'
        keyPath = 'HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey'
    } | ConvertTo-Json
}

process {
    $TestResult = $InstanceProperties | dsc resource test --resource $Resource |
        ConvertFrom-Json

    if ($TestResult.actualState._inDesiredState) {
        $InstanceProperties | dsc resource get --resource $Resource
    } else {
        $InstanceProperties | dsc resource set --resource $Resource
    }
}
