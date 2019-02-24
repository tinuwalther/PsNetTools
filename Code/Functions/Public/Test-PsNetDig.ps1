function Test-PsNetDig{

    <#

    .SYNOPSIS
      Domain information groper

    .DESCRIPTION
      Resolves a hostname to the IP addresses or an IP Address to the hostname.

    .PARAMETER Destination
      Hostname or IP Address or Alias or WebUrl as String or String-Array
 
    .EXAMPLE
      Resolve a hostname to the IP Address
      Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
      Resolve an array of hostnames to the IP Address
      Test-PsNetDig -Destination sbb.ch, google.com

    .EXAMPLE
      Resolve an array of hostnames to the IP Address with ValueFromPipeline
      sbb.ch, google.com | Test-PsNetDig

    .INPUTS
      Hashtable

    .OUTPUTS
      PSCustomObject
      TargetName  : sbb.ch
      IpV4Address : 194.150.245.142
      IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
      Duration    : 4ms

    .NOTES
      Author: Martin Walther

    .LINK
      https://tinuwalther.github.io/

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
