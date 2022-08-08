Configuration Start {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        ServiceSet ExampleServiceSet {
            Name   = @(
                'Dhcp'
                'MpsSvc'
            )
            Ensure = 'Present'
            State  = 'Running'
        }
    }
}