function Test-PsNetTping{

    <#

    .SYNOPSIS
       Test-PsNetUping - Test Tcp connectivity

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
       Name or IP Address to test

    .PARAMETER TcpPort
       Tcp Port to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000

       .NOTES
       Author: Martin Walther

    .EXAMPLE
       Test-PsNetTping -Destination sbb.ch -TcpPort 443 -Timeout 100

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $Destination,

        [Parameter(Mandatory=$true)]
        [Int] $TcpPort,

        [Parameter(Mandatory=$false)]
        [Int] $MinTimeout = 0,

        [Parameter(Mandatory=$false)]
        [Int] $MaxTimeout = 1000
   )    
    begin {
    }

    process {
        return [PsNetPing]::tping($Destination, $TcpPort, $MinTimeout, $MaxTimeout)
    }

    end {
    }
}
