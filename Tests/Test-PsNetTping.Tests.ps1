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

Describe "Testing Test-PsNetTping on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetTPing {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
           
    it "[POS] [$($CurrentOS)] Testing Test-PsNetTping with IP Address as parameter(s)"{
        {Test-PsNetTping -Destination '194.150.245.142' -TcpPort 443 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetTping -Destination '194.150.245.142' -TcpPort 443 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTping with two Hostnames as parameter(s)"{
        {Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTping with two Hostnames and TcpPorts as parameter(s)"{
        {Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80,443 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80,443 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location