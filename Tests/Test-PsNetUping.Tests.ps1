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

Describe "Testing Test-PsNetUping on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetUping {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[POS] [$($CurrentOS)] Test-PsNetUping -WhatIf should not throw"{
        {Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -WhatIf} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetUping with Hostname as parameter(s) should not throw"{
        {Test-PsNetUping 'sbb.ch' 53 } | Should -not -Throw
        {Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -MaxTimeout 1000} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Test-PsNetUping with Hostname as parameter(s) should return a PSCustomObject"{
        {Test-PsNetUping 'sbb.ch' 53} | Should -ExpectedType PSCustomObject
        {Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetUping with two Hostnames as parameter(s) should not throw"{
        {Test-PsNetUping sbb.ch, google.com 53} | Should -not -Throw
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 1000} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetUping with two Hostnames as parameter(s) should return a PSCustomObject"{
        {Test-PsNetUping sbb.ch, google.com 53} | Should -ExpectedType PSCustomObject
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetUping with two Hostnames and UdpPorts as parameter(s) should not throw"{
        {Test-PsNetUping sbb.ch, google.com 53,139} | Should -not -Throw
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53,139 -MaxTimeout 1000} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetUping with two Hostnames and UdpPorts as parameter(s) should return a PSCustomObject"{
        {Test-PsNetUping sbb.ch, google.com 53,139} | Should -ExpectedType PSCustomObject
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53,139 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location