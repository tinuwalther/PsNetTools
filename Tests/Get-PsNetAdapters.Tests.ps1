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

Describe "Testing Get-PsNetAdapters on $($CurrentOS) OS" {
    
    it "[POS] [$($CurrentOS)] Testing Get-PsNetAdapters"{
        (Get-PsNetAdapters).Succeeded | should BeTrue
    }

    it "[POS] [$($CurrentOS)] Testing Get-PsNetAdapterConfiguration"{
        (Get-PsNetAdapterConfiguration).Succeeded | should BeTrue
    }

}

Pop-Location