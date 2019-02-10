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

Describe "Testing Add-PsNetHostsEntry on $($CurrentOS) OS" {
    
    it "[NEG] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
        (Add-PsNetHostsEntry -path 'C:\Temp\hosts' -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded | should BeFalse
    }

    it "[POS] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
        (Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded | should BeTrue
    }

}

Pop-Location