Configuration Install {
    param(
        [Parameter (Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter (Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogPath
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node Localhost {
        WindowsPackageCab ExampleWindowsPackageCab {
            Name       = $Name
            Ensure     = 'Present'
            SourcePath = $SourcePath
            LogPath    = $LogPath
        }
    }
}