function Test-PsNetUping{

    <#

   .SYNOPSIS
      Test the connectivity over a Udp port

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

   .EXAMPLE
      Test the connectivity to one Destination and one Udp Port with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch -UdpPort 53 -MaxTimeout 100

   .EXAMPLE
      Test the connectivity to two Destinations and one Udp Port with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 100

    EXAMPLE
      Test the connectivity to two Destinations and two Udp Ports with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100 | Format-Table

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

         [Parameter(ParameterSetName = "RemotePort", Mandatory = $True)]
         [Alias('RemotePort')] [ValidateRange(1,65535)]
         [Int[]] $UdpPort,
 
         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000
    )    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

	process {
		foreach($item in $Destination){
			foreach($port in $UdpPort){
                try{
                    $resultset += [PsNetPing]::uping($item, $port, $MinTimeout, $MaxTimeout)
                }
				catch{
					$resultset += [PsNetError]::New("$($function)($item)", $_)
					$error.Clear()
				}
			}
		}
	}

	end {
		return $resultset
	}

}
