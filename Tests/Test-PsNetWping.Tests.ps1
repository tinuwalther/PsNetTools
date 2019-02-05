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

Describe "Testing Test-PsNetWping on $($CurrentOS) OS" {
        
    it "[NEG] [$($CurrentOS)] Testing Test-PsNetWping with false Uri as parameter(s)"{
        (Test-PsNetWping -Destination 'https:sbb.ch' -Timeout 2500).Succeeded | should BeFalse
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetWping without noproxy parameter(s)"{
        (Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 2500).Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetWping with all parameter(s)"{
        (Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 2500 -NoProxy).Succeeded | should BeTrue
    }

}

Pop-Location