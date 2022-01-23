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

Describe "Testing Remove-PsNetHostsEntry on $($CurrentOS) OS" {
    
    BeforeAll {
        Mock Remove-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[POS] [$($CurrentOS)] Remove-PsNetHostsEntry should not throw"{
        {'127.0.0.1 test' | Remove-PsNetHostsEntry } | Should -Not -Throw
        {Remove-PsNetHostsEntry '127.0.0.1 test'} | Should -Not -Throw
        {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 test'} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Remove-PsNetHostsEntry should return a PSCustomObject"{
        {'127.0.0.1 test' | Remove-PsNetHostsEntry } | Should -ExpectedType PSCustomObject
        {Remove-PsNetHostsEntry '127.0.0.1 test'} | Should -ExpectedType PSCustomObject
        {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 test'} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
