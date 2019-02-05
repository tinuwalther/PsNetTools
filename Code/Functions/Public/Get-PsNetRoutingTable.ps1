function Get-PsNetRoutingTable {

    <#

    .SYNOPSIS
       Get-PsNetRoutingTable - Get Routing Table

    .DESCRIPTION
       Format the Routing Table to an object

    .PARAMETER IpVersion
       IPv4 or IPv6

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetRoutingTable

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [Int] $InterfaceIndex,

        [ValidateSet('IPv4','IPv6')]        
        [Parameter(Mandatory=$true)]
        [String] $IpVersion
    )  
    
    begin {
    }
    
    process {
        if($PSVersionTable.PSVersion.Major -lt 6){
            $CurrentOS = [OSType]::Windows
        }
        else{
            if($IsMacOS)  {$CurrentOS = [OSType]::Mac}
            if($IsLinux)  {$CurrentOS = [OSType]::Linux}
            if($IsWindows){$CurrentOS = [OSType]::Windows}
        }
        return [PsNetRoutingTable]::GetNetRoutingTable($CurrentOS, $InterfaceIndex, $IpVersion)
    }
    
    end {
    }
}