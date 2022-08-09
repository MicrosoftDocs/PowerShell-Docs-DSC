Configuration SetMembers {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Group ExampleGroup {
            GroupName = 'GroupName1'
            Ensure    = 'Present'
            Members   = @(
                'Username1'
                'Username2'
            )
        }
    }
}
