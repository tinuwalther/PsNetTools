function Get-PsNetAdapterConfiguration{
   <#

   .SYNOPSIS
      Get-PsNetAdapterConfiguration

   .DESCRIPTION
      List network adapter configuraion for all adapters

   .PARAMETER

   .EXAMPLE
      Get-PsNetAdapterConfiguration

    .NOTES
      Author: Martin Walther

   #>

   [CmdletBinding()]
   param()   
   begin {
   }

   process {
       return [PsNetAdapter]::GetNetadapterConfiguration()
   }

   end {
   }

}

