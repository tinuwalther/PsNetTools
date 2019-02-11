function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       Name or IP Address to test

    .PARAMETER UdpPort
       Udp Port to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch -UdpPort 53 -Timeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000
    )    
    begin {
    }

    process {
        return [PsNetPing]::uping($Destination, $UdpPort, $MinTimeout, $MaxTimeout)
    }

    end {
    }

}
