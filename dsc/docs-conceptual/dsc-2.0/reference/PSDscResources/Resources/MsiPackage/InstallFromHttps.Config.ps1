Configuration InstallPackageFromHttps {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        MsiPackage ExampleMsiPackage {
            ProductId = '{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}'
            Path      = 'https://contoso.com/example.msi'
            Ensure    = 'Present'
        }
    }
}
