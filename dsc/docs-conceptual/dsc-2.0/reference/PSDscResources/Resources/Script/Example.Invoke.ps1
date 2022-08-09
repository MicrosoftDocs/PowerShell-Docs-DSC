[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $FilePath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $FileContent
)

begin {
    $SharedParameters = @{
        Name       = 'Script'
        ModuleName = 'PSDscResource'
        Properties = @{
            SetScript = {
                $streamWriter = New-Object -TypeName 'System.IO.StreamWriter' -ArgumentList @(
                    $using:FilePath
                )
                $streamWriter.WriteLine($using:FileContent)
                $streamWriter.Close()
            }
            TestScript = {
                if (Test-Path -Path $using:FilePath) {
                    $fileContent = Get-Content -Path $using:filePath -Raw
                    return ($fileContent -eq $using:FileContent)
                } else {
                    return $false
                }
            }
            GetScript = {
                $fileContent = $null

                if (Test-Path -Path $using:FilePath) {
                    $fileContent = Get-Content -Path $using:filePath -Raw
                }

                return @{
                    Result = $fileContent
                }
            }
        }
    }
}

process {
    $TestResult = Invoke-DscResource -Method Test @SharedParameters

    if ($TestResult.InDesiredState) {
        Invoke-DscResource -Method Get @SharedParameters
    } else {
        Invoke-DscResource -Method Set @SharedParameters
    }
}
