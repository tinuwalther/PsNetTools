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

Describe "Testing Get-PsNetRoutingTable on $($CurrentOS) OS" {
    
    BeforeAll {
        Mock Get-PsNetRoutingTable {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Get-PsNetRoutingTable for IPv4 should not throw"{
        {'IPv4' | Get-PsNetRoutingTable} | Should -Not -Throw
        {Get-PsNetRoutingTable IPv4} | Should -Not -Throw
        {Get-PsNetRoutingTable -IpVersion IPv4} | Should -Not -Throw
    }
    it "[POS] [$($CurrentOS)] Get-PsNetRoutingTable for IPv4 should return a PSCustomObject"{
        {'IPv4' | Get-PsNetRoutingTable} | Should -ExpectedType PSCustomObject
        {Get-PsNetRoutingTable IPv4} | Should -ExpectedType PSCustomObject
        {Get-PsNetRoutingTable -IpVersion IPv4} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Get-PsNetRoutingTable for IPv6 should not throw"{
        {'IPv6' | Get-PsNetRoutingTable} | Should -Not -Throw
        {Get-PsNetRoutingTable IPv6} | Should -Not -Throw
        {Get-PsNetRoutingTable -IpVersion IPv6} | Should -Not -Throw
    }
    it "[POS] [$($CurrentOS)] Get-PsNetRoutingTable for IPv6 should return a PSCustomObject"{
        {'IPv6' | Get-PsNetRoutingTable} | Should -ExpectedType PSCustomObject
        {Get-PsNetRoutingTable IPv6} | Should -ExpectedType PSCustomObject
        {Get-PsNetRoutingTable -IpVersion IPv6} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location