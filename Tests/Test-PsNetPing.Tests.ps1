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

Describe "Testing Test-PsNetPing on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetPing {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
           
    it "[POS] [$($CurrentOS)] Testing Test-PsNetPing with IP Address as parameter(s)"{
        {Test-PsNetPing -Destination '127.0.0.1'} | Should -not -Throw
        {Test-PsNetPing -Destination '127.0.0.1'} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetPing with two Hostnames as parameter(s)"{
        {Test-PsNetPing -Destination sbb.ch, google.com} | Should -not -Throw
        {Test-PsNetPing -Destination sbb.ch, google.com} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location