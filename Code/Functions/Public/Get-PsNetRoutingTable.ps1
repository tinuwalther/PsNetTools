function Get-PsNetRoutingTable {

    <#

    .SYNOPSIS
      Get the Routing Table

    .DESCRIPTION
      Format the Routing Table to an object

    .PARAMETER IpVersion
      IPv4 or IPv6
 
    .EXAMPLE
      Get-PsNetRoutingTable -IpVersion IPv4
    
    .EXAMPLE
      Get-PsNetRoutingTable -IpVersion IPv6

    .INPUTS

    .OUTPUTS
      PSCustomObject

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [ValidateSet('IPv4','IPv6')]        
        [Parameter(Mandatory=$true)]
        [String] $IpVersion
    )  
    
    begin {
      $function = $($MyInvocation.MyCommand.Name)
      Write-Verbose "Running $function"
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
        return [PsNetRoutingTable]::GetNetRoutingTable($CurrentOS, $IpVersion)
    }
    
    end {
    }
}