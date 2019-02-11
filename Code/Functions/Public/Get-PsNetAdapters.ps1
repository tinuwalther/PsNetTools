function Get-PsNetAdapters{

    <#

    .SYNOPSIS
       Get-PsNetAdapters

    .DESCRIPTION
       List all network adapters

    .PARAMETER
 
    .EXAMPLE
       Get-PsNetAdapters

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param()  
      
    begin {
    }
    
    process {
        return [PsNetAdapter]::GetNetadapters()
    }
    
    end {
    }

}
