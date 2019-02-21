function Test-PsNetDig{

    <#

    .SYNOPSIS
       Test-PsNetDig

    .DESCRIPTION
       Resolves a hostname or an ip address

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to resolve
 
    .EXAMPLE
       Test-PsNetDig -Destination sbb.ch, google.com

    .EXAMPLE
       sbb.ch, google.com | Test-PsNetDig

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String[]] $Destination
    ) 
       
    begin {
      $resultset = @()
   }
    
    process {
      foreach($item in $Destination){
         $resultset += [PsNetDig]::dig($item)
      }
    }
    
    end {
      return $resultset
    }

}
