function Get-PsNetHostsTable {

    <#

    .SYNOPSIS
       Get-PsNetHostsTable - Get hostsfile

    .DESCRIPTION
       Format the hostsfile to an object

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetHostsTable

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Path
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
        return [PsNetHostsTable]::GetPsNetHostsTable($CurrentOS, $Path)
    }
    
    end {
    }
}

