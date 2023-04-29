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

Describe "Testing Get-PsNetDnsSearchSuffix on $($CurrentOS) OS" {

    BeforeAll {
        Mock Get-PsNetDnsSearchSuffix {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Get-PsNetDnsSearchSuffix -WhatIf should not throw"{
        {Get-PsNetDnsSearchSuffix -WhatIf} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetDnsSearchSuffix should not throw"{
        {Get-PsNetDnsSearchSuffix} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetDnsSearchSuffix should return a PSCustomObject"{
        {Get-PsNetDnsSearchSuffix} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
