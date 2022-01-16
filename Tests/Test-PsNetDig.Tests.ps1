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

Describe "Testing Test-PsNetDig on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetDig {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
          
    it "[POS] [$($CurrentOS)] Testing Test-PsNetDig "{
        {Test-PsNetDig -Destination '127.0.0.1'} | Should -Not -Throw
        {Test-PsNetDig -Destination '127.0.0.1'} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetDig with two Hostnames as parameter(s)"{
        {Test-PsNetDig -Destination sbb.ch, google.com} | Should -Not -Throw
        {Test-PsNetDig -Destination sbb.ch, google.com} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location