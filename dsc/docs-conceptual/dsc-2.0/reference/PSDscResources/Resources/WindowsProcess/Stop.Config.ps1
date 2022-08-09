Configuration Stop {
    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsProcess ExampleWindowsProcess {
            Path      = 'C:\Windows\System32\gpresult.exe'
            Arguments = ''
            Ensure    = 'Absent'
        }
    }
}
