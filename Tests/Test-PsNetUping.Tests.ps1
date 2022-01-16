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
    
    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with Hostname as parameter(s)"{
        {Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with two Hostnames as parameter(s)"{
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with two Hostnames and UdpPorts as parameter(s)"{
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53,139 -MaxTimeout 1000} | Should -not -Throw
        {Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53,139 -MaxTimeout 1000} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location