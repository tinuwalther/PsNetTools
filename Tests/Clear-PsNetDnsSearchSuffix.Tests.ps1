$TestsPath  = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName
Set-Location  -Path $RootFolder.FullName

if($PSVersionTable.PSVersion.Major -lt 6){
    $CurrentOS = 'Win'
}
else{
    if($IsMacOS){$CurrentOS = 'Mac'}
    if($IsLinux){$CurrentOS = 'Lnx'}
    if($IsWindows){$CurrentOS = 'Win'}
}

Describe "Testing Clear-PsNetDnsSearchSuffix on $($CurrentOS) OS" {

    BeforeAll {
        Mock Clear-PsNetDnsSearchSuffix {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Clear-PsNetDnsSearchSuffix should not throw"{
        {Clear-PsNetDnsSearchSuffix} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Clear-PsNetDnsSearchSuffix should return a PSCustomObject"{
        {Clear-PsNetDnsSearchSuffix} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
