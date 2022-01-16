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

Describe "Testing Remove-PsNetHostsEntry on $($CurrentOS) OS" {
    
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

        Mock Remove-PsNetHostsEntry {
            return [PSCustomObject]@{
                Succeeded = $true
            }
        }
    }

    it "[NEG] [$($CurrentOS)] Testing Remove-PsNetHostsEntry"{
        {Remove-PsNetHostsEntry -path 'C:\Temp\hosts' -Hostsentry '127.0.0.1 tinu'} | Should -Not -Throw
        {Remove-PsNetHostsEntry -path 'C:\Temp\hosts' -Hostsentry '127.0.0.1 tinu'} | Should -ExpectedType PSCustomObject
    }

    if($IsAdmin){
        it "[POS] [$($CurrentOS)] [Admin] Testing Remove-PsNetHostsEntry"{
            {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'} | Should -Not -Throw
            {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'} | Should -ExpectedType PSCustomObject
        }
    }
    else {
        it "[POS] [$($CurrentOS)] Testing Remove-PsNetHostsEntry"{
            {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'} | Should -Not -Throw
            {Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'} | Should -ExpectedType PSCustomObject
        }
    }

}

Pop-Location