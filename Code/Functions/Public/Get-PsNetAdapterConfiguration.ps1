function Get-PsNetAdapterConfiguration{
   <#

   .SYNOPSIS
      Get-PsNetAdapterConfiguration - List network adapter configuraion

   .DESCRIPTION
      List network adapter configuraion for all adapters

   .NOTES
      Author: Martin Walther

   .EXAMPLE
      Get-PsNetAdapterConfiguration

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

