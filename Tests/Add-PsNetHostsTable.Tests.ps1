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
        if(($CurrentOS -eq 'Mac') -or ($CurrentOS -eq 'Linux')){
            $current   = (id -u)
            $IsAdmin   = ($current -eq 0)
        }
    
        # For Windows only
        if($CurrentOS -eq 'Win'){
            $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
            $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        }

        Mock Add-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }
    
    it "[NEG] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
        {Add-PsNetHostsEntry -path 'C:\Temp\hosts' -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch} | should -Not -Throw
        {Add-PsNetHostsEntry -path 'C:\Temp\hosts' -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch} | should -ExpectedType PSCustomObject
    }

    if($IsAdmin){
        Mock Add-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
        it "[POS] [$($CurrentOS)] [Admin] Testing Add-PsNetHostsEntry"{
            {Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch} | Should -Not -Throw
            {Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch} | Should -ExpectedType PSCustomObject
        }
    }
    else{
        Mock Add-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
        it "[POS] [$($CurrentOS)] Testing Add-PsNetHostsEntry"{
            {(Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded} | Should -Not -Throw
            {(Add-PsNetHostsEntry -IPAddress '127.0.0.1' -Hostname tinu -FullyQualifiedName tinu.walther.ch).Succeeded} | Should -ExpectedType PSCustomObject
        }
    }

}

Pop-Location