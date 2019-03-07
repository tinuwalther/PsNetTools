<#
    Gets the IP route information from the IP routing table.
    https://docs.microsoft.com/en-us/powershell/module/nettcpip/get-netroute?view=win10-ps

    Modifies an entry or entries in the IP routing table.
    https://docs.microsoft.com/en-us/powershell/module/nettcpip/set-netroute?view=win10-ps

    Creates a route in the IP routing table.
    https://docs.microsoft.com/en-us/powershell/module/nettcpip/new-netroute?view=win10-ps

    Removes IP routes from the IP routing table.
    https://docs.microsoft.com/en-us/powershell/module/nettcpip/remove-netroute?view=win10-ps

#>

function Add-RouteEntry{
    param(
        [Parameter(Mandatory = $true)][String]$IPAddress = '',
        [Parameter(Mandatory = $true)][String]$Mask      = '',
        [Parameter(Mandatory = $true)][String]$Gateway   = '',
        [Parameter(Mandatory = $true)][String]$Metric    = ''
    )
    $function = $($MyInvocation.MyCommand.Name)
    if($psdebug){Write-Verbose $function -Verbose}
    
    $route = $null
    $ret   = $null

    try{
        if(-not(Test-Path "$($script:Scriptpath)\Routetable.log")){
            route.exe print | Out-File -FilePath "$($script:Scriptpath)\RouteTable.txt" -Append -Encoding default
        }
        $route = route.exe print | select-string -Pattern $IPAddress
        if([string]::IsNullOrEmpty($route)){
            $ret = route.exe add -p $IPAddress mask $Mask $Gateway
        }
    }
    catch{}
    return $ret
}

function Update-RouteEntry{
    param(
        [Parameter(Mandatory = $true)][String]$IPAddress = '',
        [Parameter(Mandatory = $true)][String]$Mask      = '',
        [Parameter(Mandatory = $true)][String]$Gateway   = '',
        [Parameter(Mandatory = $true)][String]$Metric    = ''
    )
    $function = $($MyInvocation.MyCommand.Name)
    if($psdebug){Write-Verbose $function -Verbose}
    
    $route = $null
    $ret   = $null

    try{
        if(-not(Test-Path "$($script:Scriptpath)\Routetable.log")){
            route.exe print | Out-File -FilePath "$($script:Scriptpath)\RouteTable.txt" -Append -Encoding default
        }
        $route = route.exe print | select-string -Pattern $IPAddress
        if(-not([string]::IsNullOrEmpty($route))){
            $ret = route.exe CHANGE -p $IPAddress MASK $Mask $Gateway METRIC $Metric
        }
    }
    catch{}
    return $ret
}
