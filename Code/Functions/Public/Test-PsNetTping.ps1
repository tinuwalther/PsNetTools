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

    .PARAMETER Timeout
       Max. Timeout in ms

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

        [Parameter(Mandatory=$true)]
        [Int] $Timeout
    )    
    begin {
    }

    process {
        return [PsNetTools]::tping($Destination, $TcpPort, $Timeout)
    }

    end {
    }
}
