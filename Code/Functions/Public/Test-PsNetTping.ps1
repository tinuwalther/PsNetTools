function Test-PsNetTping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER TcpPort
       An Integer or an Array of Integers with Tcp Ports to test <int>

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000

    .EXAMPLE
       Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80, 443 -MaxTimeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String[]] $Destination,

        [Parameter(Mandatory=$true)]
        [Int[]] $TcpPort,

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
          foreach($port in $TcpPort){
            $resultset += [PsNetPing]::tping($item, $port, $MinTimeout, $MaxTimeout)
         }
      }
    }

    end {
      return $resultset
   }
}
