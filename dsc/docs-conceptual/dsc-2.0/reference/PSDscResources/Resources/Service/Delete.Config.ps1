Configuration Delete {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Service ExampleService {
            Name   = 'Service1'
            Ensure = 'Absent'
        }
    }
}
