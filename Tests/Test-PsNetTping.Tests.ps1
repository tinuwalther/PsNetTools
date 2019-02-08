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

Describe "Testing Test-PsNetTping on $($CurrentOS) OS" {
           
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetTping with false Hostname as parameter(s)"{
        (Test-PsNetTping -Destination 'sbb.powershell' -TcpPort 443 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[NEG] [$($CurrentOS)] Testing Test-PsNetTping with false Port as parameter(s)"{
        (Test-PsNetTping -Destination 'sbb.ch' -TcpPort 443443 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[NEG] [$($CurrentOS)] Testing Test-PsNetTping with false IP Address as parameter(s)"{
        (Test-PsNetTping -Destination '255.255.255.256' -TcpPort 443 -MaxTimeout 1000).Succeeded | should BeFalse
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTping with Hostname as parameter(s)"{
        (Test-PsNetTping -Destination 'sbb.ch' -TcpPort 443 -MaxTimeout 1000).Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTping with IP Address as parameter(s)"{
        (Test-PsNetTping -Destination '194.150.245.142' -TcpPort 443 -MaxTimeout 1000).Succeeded | should BeTrue
    }

}

Pop-Location