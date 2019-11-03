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

Describe "Testing Add-PsNetDnsSearchSuffix on $($CurrentOS) OS" {
    
    it "[POS] [$($CurrentOS)] Testing Add-PsNetDnsSearchSuffix"{
        {Add-PsNetDnsSearchSuffix -NewDNSSearchSuffix 'test.local'} | Should Not Throw
    }

}

Pop-Location
