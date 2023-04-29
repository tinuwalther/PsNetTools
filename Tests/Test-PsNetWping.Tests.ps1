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

Describe "Testing Test-PsNetWping on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetWping {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
        
    it "[POS] [$($CurrentOS)] Test-PsNetWping -WhatIf should not throw"{
        {'https://sbb.ch' | Test-PsNetWping -WhatIf} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetWping without noproxy parameter(s) should not throw"{
        {'https://sbb.ch' | Test-PsNetWping} | Should -not -Throw
        {Test-PsNetWping 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -not -Throw
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetWping without noproxy parameter(s) should return a PSCustomObject"{
        {'https://sbb.ch' | Test-PsNetWping} | Should -ExpectedType PSCustomObject
        {Test-PsNetWping 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetWping with all parameter(s) should not throw"{
        {Test-PsNetWping 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -not -Throw
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetWping with all parameter(s) should return a PSCustomObject"{
        {Test-PsNetWping 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -ExpectedType PSCustomObject
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetWping with two Uri's as parameter(s) should not throw"{
        {Test-PsNetWping sbb.ch, google.com -MaxTimeout 2500} | Should -not -Throw
        {Test-PsNetWping -Destination sbb.ch, google.com -MaxTimeout 2500} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetWping with two Uri's as parameter(s) should return a PSCustomObject"{
        {Test-PsNetWping sbb.ch, google.com -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
        {Test-PsNetWping -Destination sbb.ch, google.com -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location