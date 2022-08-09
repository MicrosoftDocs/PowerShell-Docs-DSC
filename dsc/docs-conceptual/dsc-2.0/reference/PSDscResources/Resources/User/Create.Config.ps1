Configuration Create {
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $PasswordCredential
    )

    Import-DscResource -ModuleName PSDscResources

    Node localhost {
        User ExampleUser {
            Ensure   = 'Present'
            UserName = 'SomeUserName'
            Password = $PasswordCredential
        }
    }
}
