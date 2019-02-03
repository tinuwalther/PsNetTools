function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping - Test Udp connectivity

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       Name or IP Address to test

    .PARAMETER UdpPort
       Udp Port to test

    .PARAMETER Timeout
       Max. Timeout in ms

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch -UdpPort 53 -Timeout 100

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
         [Parameter(Mandatory=$true)]
         [Int] $Timeout
    )    
    begin {
    }

    process {
        return [PsNetPing]::uping($Destination, $UdpPort, $Timeout)
    }

    end {
    }

}
