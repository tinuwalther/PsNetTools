function Get-PsNetAdapterConfiguration{

    <#

    .SYNOPSIS
       Get Network Adapter Configuration

    .DESCRIPTION
       List network adapter configuraion for all adapters

    .EXAMPLE
       Get-PsNetAdapterConfiguration

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
       return [PsNetAdapter]::listadapterconfig()
   }

   end {
   }

}

