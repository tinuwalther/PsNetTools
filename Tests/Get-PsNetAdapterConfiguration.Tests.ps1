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
    
    it "[POS] [$($CurrentOS)] Testing Get-PsNetAdapterConfiguration"{
        {Get-PsNetAdapterConfiguration} | Should -Not -Throw
        {Get-PsNetAdapterConfiguration} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
