function Test-PsNetTping{

    <#

    .SYNOPSIS
      Test the connectivity over a Tcp port

    .DESCRIPTION
      Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
      A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER CommonTcpPort
      One of the Tcp ports for SMB, HTTP, HTTPS, WINRM, WINRMS, LDAP, LDAPS

    .PARAMETER TcpPort
      An Integer or an Array of Integers with Tcp Ports to test <int>

    .PARAMETER MinTimeout
      Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

    .EXAMPLE
      Test the connectivity to one Destination and one Tcp Port with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch -TcpPort 443 -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to one Destination and one CommonTcpPort with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch -CommonTcpPort HTTPS -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to two Destinations and one Tcp Port with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to two Destinations and two Tcp Ports with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80, 443 -MaxTimeout 100 | Format-Table

    .INPUTS
      Hashtable

    .OUTPUTS
      PSCustomObject

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String[]] $Destination,

        [Parameter(ParameterSetName = "CommonTCPPort", Mandatory = $True, Position = 1)]
        [ValidateSet('SMB','HTTP','HTTPS','RDP','WINRM','WINRMS','LDAP','LDAPS')]
        [String] $CommonTcpPort,

        [Parameter(ParameterSetName = "RemotePort", Mandatory = $True)]
        [Alias('RemotePort')] [ValidateRange(1,65535)]
        [Int[]] $TcpPort,

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
		$AttemptTcpTest = ($PSCmdlet.ParameterSetName -eq "CommonTCPPort") -or ($PSCmdlet.ParameterSetName -eq "RemotePort")
		if ($AttemptTcpTest){
			switch ($CommonTCPPort){
			"HTTP"   {$TcpPort = 80}
			"HTTPS"  {$TcpPort = 443}
			"RDP"    {$TcpPort = 3389}
			"SMB"    {$TcpPort = 445}
			"LDAP"   {$TcpPort = 389}
			"LDAPS"  {$TcpPort = 636}
			"WINRM"  {$TcpPort = 5985}
			"WINRMS" {$TcpPort = 5986}
			}
		}

		foreach($item in $Destination){
			foreach($port in $TcpPort){
				try{
					$resultset += [PsNetPing]::tping($item, $port, $MinTimeout, $MaxTimeout)
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
