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

Describe "Testing Remove-PsNetHostsEntry on $($CurrentOS) OS" {
    
    it "[NEG] [$($CurrentOS)] Testing Remove-PsNetHostsEntry"{
        (Remove-PsNetHostsEntry -path 'C:\Temp\hosts' -Hostsentry '127.0.0.1 tinu').Succeeded | should BeFalse
    }
    if($CurrentOS -eq 'Win'){
        it "[POS] [$($CurrentOS)] Testing Remove-PsNetHostsEntry"{
            (Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu').Succeeded | should BeTrue
        }
    }
    else {
        it "[POS] [$($CurrentOS)] Testing Remove-PsNetHostsEntry"{
            (Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu').Succeeded | should BeTrue
        }
    }

}

Pop-Location