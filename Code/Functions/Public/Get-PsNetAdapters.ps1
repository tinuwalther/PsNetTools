function Get-PsNetAdapters{

    <#

    .SYNOPSIS
       Get Network Adapters

    .DESCRIPTION
       List all network adapters
 
    .EXAMPLE
       Get-PsNetAdapters

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param()  
      
    begin {
      $function = $($MyInvocation.MyCommand.Name)
      Write-Verbose "Running $function"
   }
    
    process {
        return [PsNetAdapter]::listadapters()
    }
    
    end {
    }

}
