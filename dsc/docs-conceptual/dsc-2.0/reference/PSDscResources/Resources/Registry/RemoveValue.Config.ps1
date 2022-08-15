Configuration RemoveValue {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Registry ExampleRegistry {
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
            Ensure    = 'Absent'
            ValueName = 'MyValue'
        }
    }
}
