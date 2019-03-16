function Copy-ToVirtualMachine{

    <#

    .SYNOPSIS
       Copy from Hyper-V Host to VM

    .DESCRIPTION
       Copy content over an PSSession from the Hyper-V Host to a VM

    .PARAMETER vmname
       VM name to copy to

    .PARAMETER creds
       Credentials of the VM to copy to

    .PARAMETER Source
       Source folder on the Hyper-V Host
 
    .PARAMETER Destination
       Destination folder on the VM
 
    .EXAMPLE
    Copy-ToVirtualMachine -VMName 'Server01' - creds $creds -Source 'C:\Export\*' -Destination 'C:\Import'

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $VMName,

        [Parameter(Mandatory=$true)]
        [PSCredential] $creds,

        [Parameter(Mandatory=$false)]
        [String] $Source = 'D:\Export\*',

        [Parameter(Mandatory=$false)]
        [String] $Destination = 'C:\Import'
    )
    
    $function = $($MyInvocation.MyCommand.Name)
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.ffff') Starting $function" -ForegroundColor Yellow
    $rsession = New-PSSession -VMName $VMName -Credential $creds
    Copy-Item -ToSession $rsession -Path $Source -Destination $Destination -Force -Recurse
    Remove-PSSession -Session $rsession
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.ffff') End $function" -ForegroundColor Yellow
}

function Copy-ToHyperVHost{

    <#

    .SYNOPSIS
       Copy from a VM to the Hyper-V Host

    .DESCRIPTION
       Copy content over an PSSession from a VM to the Hyper-V Host

    .PARAMETER vmname
       VM name to copy to

    .PARAMETER creds
       Credentials of the VM to copy to

    .PARAMETER Source
       Source folder on the Hyper-V Host
 
    .PARAMETER Destination
       Destination folder on the VM
 
    .EXAMPLE
    Copy-ToVirtualMachine -VMName 'Server01' - creds $creds -Source 'C:\Export\*' -Destination 'C:\Import'

    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $VMName,

        [Parameter(Mandatory=$true)]
        [PSCredential] $creds,

        [Parameter(Mandatory=$false)]
        [String] $Source = 'C:\Export\*',

        [Parameter(Mandatory=$false)]
        [String] $Destination = 'D:\Import'
    )

    $function = $($MyInvocation.MyCommand.Name)
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.ffff') Starting $function" -ForegroundColor Yellow
    $rsession = New-PSSession -VMName $VMName -Credential $creds
    Copy-Item -FromSession $rsession -Path $Source -Destination $Destination -Force -Recurse
    Remove-PSSession -Session $rsession
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.ffff') End $function" -ForegroundColor Yellow
}

$vmname  = 'W2K16RC-SRV03'
$creds   = Get-Credential -Message "Enter the credentials to connect to $vmname" -UserName 'Administrator'
