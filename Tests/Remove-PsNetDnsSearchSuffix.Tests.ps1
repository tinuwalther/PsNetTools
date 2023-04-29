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

Describe "Testing Remove-PsNetDnsSearchSuffix on $($CurrentOS) OS" {
    
    BeforeAll {
        Mock Remove-PsNetDnsSearchSuffix {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Remove-PsNetDnsSearchSuffix -WhatIf should not throw"{
        {'test.local' | Remove-PsNetDnsSearchSuffix -WhatIf } | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Remove-PsNetDnsSearchSuffix should not throw"{
        {'test.local' | Remove-PsNetDnsSearchSuffix} | Should -Not -Throw
        {Remove-PsNetDnsSearchSuffix 'test.local'} | Should -Not -Throw
        {Remove-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Remove-PsNetDnsSearchSuffix should return a PSCustomObject"{
        {'test.local' | Remove-PsNetDnsSearchSuffix} | Should -ExpectedType PSCustomObject
        {Remove-PsNetDnsSearchSuffix 'test.local'} | Should -ExpectedType PSCustomObject
        {Remove-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
