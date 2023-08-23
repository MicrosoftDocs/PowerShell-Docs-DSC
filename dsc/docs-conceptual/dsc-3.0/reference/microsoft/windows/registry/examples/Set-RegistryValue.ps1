[CmdletBinding()]
param()

begin {
    $Resource           = dsc resource list Microsoft.Windows/Registry
    $InstanceProperties = @{
        _ensure   = 'Present'
        _clobber  = $true
        keyPath   = 'HKCU\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyKey'
        valueName = 'MyValue'
        valueData = @{
            Binary = @(0x00)
        }
    } | ConvertTo-Json
}

process {
    $TestResult = $InstanceProperties | dsc resource test --resource $Resource |
        ConvertFrom-Json

    if ($TestResult.actualState._inDesiredState) {
        write-warning "config get"
        $InstanceProperties | dsc resource get --resource $Resource
    } else {
        write-warning "config set"
        $InstanceProperties | dsc resource set --resource $Resource
    }
}
