Configuration SetBuiltInAccount {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        ServiceSet ExampleServiceSet {
            Name           = @(
                'Dhcp'
                'SstpSvc'
            )
            Ensure         = 'Present'
            BuiltInAccount = 'LocalService'
            State          = 'Ignore'
        }
    }
}
