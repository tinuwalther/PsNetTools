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

Describe "Testing Test-PsNetPing on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetPing {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
           
    it "[POS] [$($CurrentOS)] Test-PsNetPing -WhatIf should not throw"{
        {'127.0.0.1' | Test-PsNetPing -WhatIf} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetPing with IP Address as parameter(s) should not throw"{
        {'127.0.0.1' | Test-PsNetPing} | Should -not -Throw
        {Test-PsNetPing '127.0.0.1'} | Should -not -Throw
        {Test-PsNetPing -Destination '127.0.0.1'} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetPing with IP Address as parameter(s) should return a PSCustomObject"{
        {'127.0.0.1' | Test-PsNetPing} | Should -ExpectedType PSCustomObject
        {Test-PsNetPing '127.0.0.1'} | Should -ExpectedType PSCustomObject
        {Test-PsNetPing -Destination '127.0.0.1'} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetPing with two Hostnames as parameter(s) should not throw"{
        {'sbb.ch', 'google.com' | Test-PsNetPing} | Should -not -Throw
        {Test-PsNetPing sbb.ch, google.com} | Should -not -Throw
        {Test-PsNetPing -Destination sbb.ch, google.com} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetPing with two Hostnames as parameter(s) should return a PSCustomObject"{
        {'sbb.ch', 'google.com' | Test-PsNetPing} | Should -ExpectedType PSCustomObject
        {Test-PsNetPing sbb.ch, google.com} | Should -ExpectedType PSCustomObject
        {Test-PsNetPing -Destination sbb.ch, google.com} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location