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

Describe "Testing Add-PsNetDnsSearchSuffix on $($CurrentOS) OS" {
    
    BeforeAll {
        Mock Add-PsNetDnsSearchSuffix {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Add-PsNetDnsSearchSuffix -WhatIf should not throw"{
        {'test.local' | Add-PsNetDnsSearchSuffix -WhatIf} | Should -Not -Throw
    }
    
    it "[POS] [$($CurrentOS)] Add-PsNetDnsSearchSuffix should not throw"{
        {'test.local' | Add-PsNetDnsSearchSuffix} | Should -Not -Throw
        {Add-PsNetDnsSearchSuffix 'test.local'} | Should -Not -Throw
        {Add-PsNetDnsSearchSuffix -NewDNSSearchSuffix 'test.local'} | Should -Not -Throw
    }
    
    it "[POS] [$($CurrentOS)] Add-PsNetDnsSearchSuffix should return a PSCustomObject"{
        {'test.local' | Add-PsNetDnsSearchSuffix} | Should -ExpectedType PSCustomObject
        {Add-PsNetDnsSearchSuffix 'test.local'} | Should -ExpectedType PSCustomObject
        {Add-PsNetDnsSearchSuffix -NewDNSSearchSuffix 'test.local'} | Should -ExpectedType PSCustomObject
    }
}

Pop-Location
