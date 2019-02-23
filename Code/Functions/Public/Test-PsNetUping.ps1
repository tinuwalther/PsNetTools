function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER UdpPort
       An Integer or an Array of Integers with Udp Ports to test <int>

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String[]] $Destination,

         [Parameter(Mandatory=$true)]
         [Int[]] $UdpPort,
 
         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000
    )    
    begin {
      $resultset = @()
   }

    process {
      foreach($item in $Destination){
         foreach($port in $UdpPort){
            $resultset += [PsNetPing]::uping($item, $port, $MinTimeout, $MaxTimeout)
         }
      }
    }

    end {
      return $resultset
    }

}
