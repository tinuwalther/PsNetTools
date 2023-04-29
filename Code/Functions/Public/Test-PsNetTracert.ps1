function Test-PsNetTracert {

	<#

   .SYNOPSIS
      Test Trace Route

   .DESCRIPTION
      Test Trace Route to a destination

   .PARAMETER Destination
      A String or an Array of Strings with Url's to test

   .PARAMETER MaxHops
      Max gateways, routers to test, default is 30

   .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

   .PARAMETER Show
      Show the output for each item online
 
   .EXAMPLE
      Test-PsNetTracert -Destination 'www.sbb.ch'

   .EXAMPLE
      Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 | Format-Table -AutoSize

   .EXAMPLE
      Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 -Show

   .INPUTS
      Hashtable

   .OUTPUTS
      PSCustomObject

   .NOTES
      Author: Martin Walther

   .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

	[CmdletBinding(SupportsShouldProcess = $True)]
	param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0
		)]
		[ValidateLength(4, 255)]
		[String[]] $Destination,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 1
		)]
		[Int] $MaxHops = 30,

		[Parameter(
			Mandatory = $false
		)]
		[Int] $MaxTimeout = 1000,
 
		[Parameter(
			Mandatory = $false
		)]
		[Switch] $Show
	)  
	begin {
		$function = $($MyInvocation.MyCommand.Name)
		Write-Verbose "Running $function"
		$resultset = @()
	}

	process {
		foreach ($item in $Destination) {
			if ($PSCmdlet.ShouldProcess($item)) {
				if ($Show) {
					[PsNetTracert]::tracert($item, $MaxTimeout, $MaxHops, $true)
				}
				else {
					$resultset += [PsNetTracert]::tracert($item, $MaxTimeout, $MaxHops)
					return $resultset
				}
			}
		}
	}

	end {
	}
}