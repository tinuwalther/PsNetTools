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

Describe "Testing Get-PsNetHostsTable on $($CurrentOS) OS" {

    BeforeAll {
        Mock Get-PsNetHostsTable {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Get-PsNetHostsTable -WhatIf should not throw"{
        {'C:\Temp\hosts' | Get-PsNetHostsTable -WhatIf} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetHostsTable should not throw"{
        {'C:\Temp\hosts' | Get-PsNetHostsTable} | Should -Not -Throw
        {Get-PsNetHostsTable 'C:\Temp\hosts'} | Should -Not -Throw
        {Get-PsNetHostsTable -path 'C:\Temp\hosts'} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] Get-PsNetHostsTable should return a PSCustomObject"{
        {'C:\Temp\hosts' | Get-PsNetHostsTable} | Should -ExpectedType PSCustomObject
        {Get-PsNetHostsTable 'C:\Temp\hosts'} | Should -ExpectedType PSCustomObject
        {Get-PsNetHostsTable -path 'C:\Temp\hosts'} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location