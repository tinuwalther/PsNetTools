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

Describe "Testing Test-PsNetWping on $($CurrentOS) OS" {
      
    BeforeAll {
        Mock Test-PsNetWping {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
        
    it "[POS] [$($CurrentOS)] Testing Test-PsNetWping without noproxy parameter(s)"{
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -not -Throw
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetWping with all parameter(s)"{
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -not -Throw
        {Test-PsNetWping -Destination 'https://sbb.ch' -MinTimeout 1000 -MaxTimeout 2500 -NoProxy} | Should -ExpectedType PSCustomObject
    }

    it "[POS] [$($CurrentOS)] Testing Test-PsNetWping with two Uri's as parameter(s)"{
        {Test-PsNetWping -Destination sbb.ch, google.com -MaxTimeout 2500} | Should -not -Throw
        {Test-PsNetWping -Destination sbb.ch, google.com -MaxTimeout 2500} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location