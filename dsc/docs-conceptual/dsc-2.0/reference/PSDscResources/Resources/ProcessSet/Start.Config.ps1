Configuration Start {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        ProcessSet ExampleProcessSet {
            Path   = @(
                'C:\Windows\System32\cmd.exe'
                'C:\TestPath\TestProcess.exe'
            )
            Ensure = 'Present'
        }
    }
}
