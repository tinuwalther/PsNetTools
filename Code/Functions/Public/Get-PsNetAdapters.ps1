function Get-PsNetAdapters{

    <#

    .SYNOPSIS
       Get-PsNetAdapters - List network adapters

    .DESCRIPTION
       List all network adapters

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetAdapters

    #>

    [CmdletBinding()]
    param()  
      
    begin {
    }
    
    process {
        return [PsNetTools]::GetNetadapters() | Where-Object OperationalStatus -eq Up
    }
    
    end {
    }

}
