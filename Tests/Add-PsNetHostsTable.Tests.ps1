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
    
    if(($CurrentOS -eq 'Mac') -or ($CurrentOS -eq 'Linux')){
        $current   = (id -u)
        $IsAdmin   = ($current -eq 0)
    }

    # For Windows only
    if($CurrentOS -eq 'Win'){
        $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

    it "[NEG] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
        (Add-PsNetHostsEntry -path 'C:\Temp\hosts' -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded | should BeFalse
    }
    if($IsAdmin){
        it "[POS] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
            (Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded | should BeTrue
        }
    }
    else{
        it "[POS] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
            (Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded | should BeFalse
        }
    }

}

Pop-Location