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
    
    it "[POS] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
        {Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname 'test' -FullyQualifiedName 'test.local'} | Should Not Throw
    }
    
}

Pop-Location
