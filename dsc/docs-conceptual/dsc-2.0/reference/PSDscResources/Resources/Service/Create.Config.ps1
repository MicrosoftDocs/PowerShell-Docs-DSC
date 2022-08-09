Configuration Create {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Service ExampleService {
            Name   = 'Service1'
            Ensure = 'Present'
            Path   = 'C:\FilePath\MyServiceExecutable.exe'
        }
    }
}
