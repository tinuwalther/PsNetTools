$TestsPath  = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName
Set-Location  -Path $RootFolder.FullName

if($PSVersionTable.PSVersion.Major -lt 6){
    $CurrentOS = 'Win'
}
else{
    if($IsMacOS){$CurrentOS = 'Mac'}
    if($IsLinux){$CurrentOS = 'Lnx'}
    if($IsWindows){$CurrentOS = 'Win'}
}

Describe "Testing Start-PsNetPortListener on $($CurrentOS) OS" {
    
    BeforeAll {
        Mock Start-PsNetPortListener {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[POS] [$($CurrentOS)] Testing Start-PsNetPortListener"{
        {Start-PsNetPortListener -TcpPort 443} | Should -Not -Throw
        {Start-PsNetPortListener -TcpPort 443} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
