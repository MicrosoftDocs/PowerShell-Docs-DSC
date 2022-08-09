Configuration Start {
    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsProcess ExampleWindowsProcess {
            Path      = 'C:\Windows\System32\gpresult.exe'
            Arguments = '/h C:\gp2.htm'
            Ensure    = 'Present'
        }
    }
}
