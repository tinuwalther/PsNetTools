function Remove-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Remove-PsNetHostsEntry

    .DESCRIPTION
       Remove an entry in the hosts-file

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .PARAMETER Hostsentry
       IP Address to remove
 
    .EXAMPLE
       Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$Hostsentry
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
        return [PsNetHostsTable]::RemovePsNetHostEntry($CurrentOS, $Path, $Hostsentry)
    }
    
    end {
    }
}

