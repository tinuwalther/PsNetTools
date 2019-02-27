function Add-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Add entries to the hosts-file

    .DESCRIPTION
       Running this command with elevated privilege.
       Add any entries to the hosts-file

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .PARAMETER IPAddress
       IP Address to add

    .PARAMETER Hostname
       Hostname to add

    .PARAMETER FullyQualifiedName
       FullyQualifiedName to add
 
    .EXAMPLE
       Add-PsNetHostsEntry -IPAddress 127.0.0.1 -Hostname tinu -FullyQualifiedName tinu.walther.ch

    .INPUTS
       Hashtable

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://tinuwalther.github.io/

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$IPAddress,

        [Parameter(Mandatory = $true)]
        [String]$Hostname,

        [Parameter(Mandatory = $true)]
        [String]$FullyQualifiedName
    )

    begin {
    }
    
    process {
        if($PSVersionTable.PSVersion.Major -lt 6){
            $CurrentOS = [OSType]::Windows
        }
        else{
            if($IsMacOS)  {
                $CurrentOS = [OSType]::Mac
            }
            if($IsLinux)  {
                $CurrentOS = [OSType]::Linux
            }
            if($IsWindows){
                $CurrentOS = [OSType]::Windows
            }
        }
        if([String]::IsNullOrEmpty($Path)){
            if(($CurrentOS -eq [OSType]::Windows) -and ([String]::IsNullOrEmpty($Path))){
                $Path = "$($env:windir)\system32\drivers\etc\hosts"
            }
            else{
                $Path = "/etc/hosts"
            }
        }
        return [PsNetHostsTable]::AddPsNetHostEntry($CurrentOS, $Path, $IPAddress, $Hostname, $FullyQualifiedName)
    }
    
    end {
    }
}

