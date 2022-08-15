Configuration RemoveMembers {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Group ExampleGroup {
            GroupName        = 'GroupName1'
            Ensure           = 'Present'
            MembersToExclude = @(
                'Username1'
                'Username2'
            )
        }
    }
}
