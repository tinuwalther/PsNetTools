function Test-PsNetWping{

    <#

   .SYNOPSIS
      Test-PsNetWping

   .DESCRIPTION
      Test web request to an Url

   .PARAMETER Destination
      A String or an Array of Strings with Url's to test

   .PARAMETER MinTimeout
      Min. Timeout in ms, default is 0

   .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

   .PARAMETER NoProxy
      Test web request without a proxy
 
   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch'

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000 -NoProxy

   .INPUTS
      Hashtable

   .OUTPUTS
      PSCustomObject

   .NOTES
      Author: Martin Walther

   .LINK
      https://tinuwalther.github.io/

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String[]] $Destination,

         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
      $resultset = @()
    }

    process {
      if($NoProxy) {
         foreach($item in $Destination){
            if($item -notmatch '^http'){
               $item = "http://$($item)"
            }
            $resultset += [PsNetPing]::wping($item, $MinTimeout, $MaxTimeout, $true)
         }
      }
      else{
         foreach($item in $Destination){
            if($item -notmatch '^http'){
               $item = "http://$($item)"
            }
            $resultset += [PsNetPing]::wping($item, $MinTimeout, $MaxTimeout)
         }
      }
    }

    end {
      return $resultset
    }

}
