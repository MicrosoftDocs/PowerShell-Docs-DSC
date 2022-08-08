Configuration UpdateStartupType {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Service ExampleService {
            Name        = 'Service1'
            Ensure      = 'Present'
            StartupType = 'Manual'
            State       = 'Ignore'
        }
    }
}
