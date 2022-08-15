Configuration AddMembers {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        GroupSet GroupSet {
            GroupName = @(
                'Administrators'
                'GroupName1'
            )
            Ensure = 'Present'
            MembersToInclude = @(
                'Username1'
                'Username2'
            )
        }
    }
}
