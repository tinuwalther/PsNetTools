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

Describe "Testing Test-PsNetTracert on $($CurrentOS) OS" {

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTracert with Hostname as parameter(s)"{
        (Test-PsNetTracert -Destination 'www.sbb.ch').Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTracert with IP Address as parameter(s)"{
        (Test-PsNetTracert -Destination '8.8.8.8').Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetTracert with two Hostnames as parameter(s)"{
        $ret = Test-PsNetTracert -Destination 'www.microsoft.com', 'www.google.com'
        foreach($item in $ret){
            $item.Succeeded  | should BeTrue
        }
    }

}

Pop-Location