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

Describe "Testing Test-PsNetDig on $($CurrentOS) OS" {
            
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetDig with false Hostname as parameter(s)"{
        (Test-PsNetDig -Destination 'sbb.powershell').Succeeded | should BeFalse
    }
        
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetDig with false IP Address as parameter(s)"{
        (Test-PsNetDig -Destination '255.255.255.256').Succeeded | should BeFalse
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetDig with Hostname as parameter(s)"{
        (Test-PsNetDig -Destination 'sbb.ch').Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetDig with IP Address as parameter(s)"{
        (Test-PsNetDig -Destination '127.0.0.1').Succeeded | should BeTrue
    }

}

Pop-Location