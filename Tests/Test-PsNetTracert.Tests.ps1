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

Describe "Testing Test-PsNetTracert on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetTracert {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[POS] [$($CurrentOS)] Test-PsNetTracert with Hostname as parameter(s) should not throw"{
        {'www.sbb.ch' | Test-PsNetTracert} | Should -not -Throw
        {Test-PsNetTracert 'www.sbb.ch' 1} | Should -not -Throw
        {Test-PsNetTracert -Destination 'www.sbb.ch' -MaxHops 1} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetTracert with Hostname as parameter(s) should return a PSCustomObject"{
        {'www.sbb.ch' | Test-PsNetTracert} | Should -ExpectedType PSCustomObject
        {Test-PsNetTracert 'www.sbb.ch' 1} | Should -ExpectedType PSCustomObject
        {Test-PsNetTracert -Destination 'www.sbb.ch' -MaxHops 1} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Test-PsNetTracert with two Hostnames as parameter(s) should not throw"{
        {'www.sbb.ch', 'www.google.com' | Test-PsNetTracert} | Should -not -Throw
        {Test-PsNetTracert 'www.microsoft.com', 'www.google.com' 1} | Should -not -Throw
        {Test-PsNetTracert -Destination 'www.microsoft.com', 'www.google.com' -MaxHops 1} | Should -not -Throw
    }
    it "[POS] [$($CurrentOS)] Test-PsNetTracert with two Hostnames as parameter(s) should return a PSCustomObject"{
        {'www.sbb.ch', 'www.google.com' | Test-PsNetTracert} | Should -ExpectedType PSCustomObject
        {Test-PsNetTracert 'www.microsoft.com', 'www.google.com' 1} | Should -ExpectedType PSCustomObject
        {Test-PsNetTracert -Destination 'www.microsoft.com', 'www.google.com' -MaxHops 1} | Should -ExpectedType PSCustomObject
    }
}

Pop-Location