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

Describe "Testing Get-PsNetAdapterConfiguration on $($CurrentOS) OS" {

    BeforeAll {
        Mock Get-PsNetAdapterConfiguration {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[POS] [$($CurrentOS)] Get-PsNetAdapterConfiguration -WhatIf should not throw"{
        {Get-PsNetAdapterConfiguration -WhatIf} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetAdapterConfiguration should not throw"{
        {Get-PsNetAdapterConfiguration} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetAdapterConfiguration should return a PSCustomObject"{
        {Get-PsNetAdapterConfiguration} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
