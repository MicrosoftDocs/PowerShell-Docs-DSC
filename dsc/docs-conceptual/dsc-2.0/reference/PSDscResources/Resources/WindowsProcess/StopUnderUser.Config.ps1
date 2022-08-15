Configuration StopUnderUser {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential)
    )

    Import-DSCResource -ModuleName 'PSDscResources'

    Node localhost {
        WindowsProcess ExampleWindowsProcess {
            Path       = 'C:\Windows\System32\gpresult.exe'
            Arguments  = ''
            Credential = $Credential
            Ensure     = 'Absent'
        }
    }
}
