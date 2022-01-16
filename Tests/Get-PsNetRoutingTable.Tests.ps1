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

    it "[POS] [$($CurrentOS)] Testing Get-PsNetRoutingTable for IPv4"{
        {Get-PsNetRoutingTable -IpVersion IPv4} | Should -Not -Throw
        {Get-PsNetRoutingTable -IpVersion IPv4} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Get-PsNetRoutingTable for IPv6"{
        {Get-PsNetRoutingTable -IpVersion IPv6} | Should -Not -Throw
        {Get-PsNetRoutingTable -IpVersion IPv6} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location