Configuration StartUnderUser {
    [CmdletBinding()]
    param(
       [System.Management.Automation.PSCredential]
       [System.Management.Automation.Credential()]
       $Credential = (Get-Credential)
    )

    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsProcess ExampleWindowsProcess {
            Path       = 'C:\Windows\System32\gpresult.exe'
            Arguments  = '/h C:\gp2.htm'
            Credential = $Credential
            Ensure     = 'Present'
        }
    }
}
