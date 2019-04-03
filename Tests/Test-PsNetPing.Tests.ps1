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

Describe "Testing Test-PsNetPing on $($CurrentOS) OS" {
           
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetPing with false Hostname as parameter(s)"{
        {Test-PsNetPing -Destination 'sbb.powershell'} | Should -not -Throw
    }

    it "[NEG] [$($CurrentOS)] Testing Test-PsNetPing with false IP Address as parameter(s)"{
        {Test-PsNetPing -Destination '255.255.255.256'} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetPing with Hostname as parameter(s)"{
        {Test-PsNetPing -Destination 'sbb.ch'} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetPing with IP Address as parameter(s)"{
        {Test-PsNetPing -Destination '127.0.0.1'} | Should -not -Throw
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetPing with two Hostnames as parameter(s)"{
        $ret = Test-PsNetPing -Destination sbb.ch, google.com
        foreach($item in $ret){
            {$item} | Should -not -Throw
        }
    }

}

Pop-Location