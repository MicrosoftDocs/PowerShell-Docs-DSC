Configuration RemoveKey {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Registry ExampleRegistry {
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\MyNewKey'
            Ensure    = 'Absent'
            ValueName = ''
        }
    }
}
