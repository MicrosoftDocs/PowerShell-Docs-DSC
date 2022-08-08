Configuration CreatePathVariable  {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Environment ExampleEnvironment {
            Name   = 'TestPathEnvironmentVariable'
            Value  = 'TestValue'
            Ensure = 'Present'
            Path   = $true
            Target = @(
                'Process'
                'Machine'
            )
        }
    }
}
