Configuration AddOrModifyValue {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Registry ExampleRegistry {
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
            Ensure    = 'Present'
            ValueName = 'MyValue'
            ValueType = 'Binary'
            ValueData = '0x00'
            Force     = $true
        }
    }
}
