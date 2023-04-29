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

Describe "Testing Test-PsNetDig on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetDig {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
          
    it "[POS] [$($CurrentOS)] Test-PsNetDig -WhatIf should not throw"{
        {'127.0.0.1' | Test-PsNetDig -WhatIf} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetDig should not throw"{
        {'127.0.0.1' | Test-PsNetDig} | Should -Not -Throw
        {Test-PsNetDig '127.0.0.1'} | Should -Not -Throw
        {Test-PsNetDig -Destination '127.0.0.1'} | Should -Not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetDig should return a PSCustomObject"{
        {'127.0.0.1' | Test-PsNetDig} | Should -ExpectedType PSCustomObject
        {Test-PsNetDig '127.0.0.1'} | Should -ExpectedType PSCustomObject
        {Test-PsNetDig -Destination '127.0.0.1'} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetDig with two Hostnames as parameter(s) should not throw"{
        {'sbb.ch', 'google.com' | Test-PsNetDig} | Should -Not -Throw
        {Test-PsNetDig 'sbb.ch', 'google.com'} | Should -Not -Throw
        {Test-PsNetDig -Destination sbb.ch, google.com} | Should -Not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetDig with two Hostnames as parameter(s) should return a PSCustomObject"{
        {'sbb.ch', 'google.com' | Test-PsNetDig} | Should -ExpectedType PSCustomObject
        {Test-PsNetDig 'sbb.ch', 'google.com'} | Should -ExpectedType PSCustomObject
        {Test-PsNetDig -Destination sbb.ch, google.com} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location