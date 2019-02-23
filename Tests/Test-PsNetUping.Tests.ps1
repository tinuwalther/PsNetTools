$TestsPath  = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName
Set-Location  -Path $RootFolder.FullName

Import-Module .\PsNetTools -Force
if(!(Get-Module Pester)){
    Import-Module -Name Pester
}

if($PSVersionTable.PSVersion.Major -lt 6){
    $CurrentOS = 'Win'
}
else{
    if($IsMacOS){$CurrentOS = 'Mac'}
    if($IsLinux){$CurrentOS = 'Lnx'}
    if($IsWindows){$CurrentOS = 'Win'}
}

Describe "Testing Test-PsNetUping on $($CurrentOS) OS" {
    
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetUping with false Hostname as parameter(s)"{
        (Test-PsNetUping -Destination 'sbb.powershell' -UdpPort 443 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[NEG] [$($CurrentOS)] Testing Test-PsNetUping with false Port as parameter(s)"{
        (Test-PsNetUping -Destination 'sbb.ch' -UdpPort 443443 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[NEG] [$($CurrentOS)] Testing Test-PsNetUping with false IP Address as parameter(s)"{
        (Test-PsNetUping -Destination '255.255.255.256' -UdpPort 53 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with Hostname as parameter(s)"{
        (Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -MaxTimeout 1000).Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with IP Address as parameter(s)"{
        (Test-PsNetUping -Destination '194.150.245.142' -UdpPort 53 -MaxTimeout 1000).Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with two Hostnames as parameter(s)"{
        $ret = Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 1000
        foreach($item in $ret){
            $item.Succeeded  | should BeTrue
        }
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetUping with two Hostnames and UdpPorts as parameter(s)"{
        $ret = Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53,139 -MaxTimeout 1000
        foreach($item in $ret){
            $item.Succeeded  | should BeTrue
        }
    }

}

Pop-Location