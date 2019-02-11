function Test-PsNetWping{

    <#

    .SYNOPSIS
       Test-PsNetWping

    .DESCRIPTION
       Test web request to an Url

    .PARAMETER Destination
       Url to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000

    .PARAMETER NoProxy
      Test web request without a proxy
 
    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000

    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
    }

    process {
      if($Destination -notmatch '^http'){
         $Destination = "http://$($Destination)"
      }
      if($NoProxy) {
         return [PsNetPing]::wping($Destination, $MinTimeout, $MaxTimeout, $true)
      }
      else{
         return [PsNetPing]::wping($Destination, $MinTimeout, $MaxTimeout)
      }
    }

    end {
    }

}
