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

    [CmdletBinding(SupportsShouldProcess = $True)]
    param(
        [ValidateSet('IPv4', 'IPv6')]        
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [String] $IpVersion
    )  
    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            $CurrentOS = [OSType]::Windows
        }
        else {
            if ($IsMacOS) { $CurrentOS = [OSType]::Mac }
            if ($IsLinux) { $CurrentOS = [OSType]::Linux }
            if ($IsWindows) { $CurrentOS = [OSType]::Windows }
        }
    }
    
    process {
        $item = $IpVersion
        if ($PSCmdlet.ShouldProcess($item)){
            return [PsNetRoutingTable]::GetNetRoutingTable($CurrentOS, $IpVersion)
        }
    }
    
    end {
    }
}