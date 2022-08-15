Configuration CreateNonPathVariable  {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Environment ExampleEnvironment {
            Name   = 'TestEnvironmentVariable'
            Value  = 'TestValue'
            Ensure = 'Present'
            Path   = $false
            Target = @(
                'Process'
                'Machine'
            )
        }
    }
}
