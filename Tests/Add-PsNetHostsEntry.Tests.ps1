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

Describe "Testing Add-PsNetHostsEntry on $($CurrentOS) OS" {

    BeforeAll {
        Mock Add-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[POS] [$($CurrentOS)] Add-PsNetHostsEntry should not throw"{
        {'127.0.0.1', 'test', 'test.local' | Add-PsNetHostsEntry} | Should -Not -Throw
        {Add-PsNetHostsEntry '127.0.0.1' 'test' 'test.local'} | Should -Not -Throw
        {Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname 'test' -FullyQualifiedName 'test.local'} | Should -Not -Throw
    }   

    it "[POS] [$($CurrentOS)] Add-PsNetHostsEntry should return a PSCustomObject"{
        {'127.0.0.1', 'test', 'test.local' | Add-PsNetHostsEntry} | Should -ExpectedType PSCustomObject
        {Add-PsNetHostsEntry '127.0.0.1' 'test' 'test.local'} | Should -ExpectedType PSCustomObject
        {Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname 'test' -FullyQualifiedName 'test.local'} | Should -ExpectedType PSCustomObject
    }    
}

Pop-Location
