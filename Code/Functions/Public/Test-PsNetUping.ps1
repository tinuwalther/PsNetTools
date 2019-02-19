function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to test

    .PARAMETER UdpPort
       Udp Port to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String[]] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
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
         $resultset += [PsNetPing]::uping($item, $UdpPort, $MinTimeout, $MaxTimeout)
      }
    }

    end {
      return $resultset
    }

}
