function Set-NewHostEntry{
    <#
        Add host entry to hosts file
    #>
    param(
        [Parameter(Mandatory = $true)][String] $IPAddress = '',
        [Parameter(Mandatory = $true)][String] $Hostname = '',
        [Parameter(Mandatory = $false)][String]$FQDN = '',
        [Parameter(Mandatory = $false)][String]$Comment = ''
    )
    $function = $($MyInvocation.MyCommand.Name)
    if($psdebug){Write-Verbose $function -Verbose}

    $ret  = $null
    $save = $false

    try{
        $hostsfile = "$($env:windir)\System32\drivers\etc\hosts"
        $savefile  = "$($hostsfile)_$(Get-Date -Format 'yyyymmdd-hhmmss').txt"
        $content = Get-Content $hostsfile
        if(-not([string]::IsNullOrEmpty($Comment))){
            if(!($content -match $comment)){
                $content += "`r`n# $($Comment)"
                $ret = $($Comment)
            }
        }
        if(!($content -match $IPAddress)){
            $content += "$($IPAddress) $($Hostname) $($FQDN)"
            $ret = "$($IPAddress) $($Hostname) $($FQDN)"
            $save = $true
        }
        if($save){
            if(-not(Test-Path $savefile)){
                Copy-Item -Path $hostsfile -Destination $savefile
            }
            Set-Content -Value $content -Path $hostsfile
        }
    }
    catch [Exception]{
        $error.clear()
    }
    return $ret
}
