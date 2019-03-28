function Test-PsNetPing{

    <#

    .SYNOPSIS
      Test ICMP echo

    .DESCRIPTION
      Attempts to send an ICMP echo message to a remote computer and receive a corresponding ICMP echo reply message from the remote computer.

    .PARAMETER Destination
      A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER try
      Number of attempts to send ICMP echo message

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch -try 5

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com -try 3

    .INPUTS
      Hashtable

    .OUTPUTS
      String

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateLength(4,255)]
        [String[]] $Destination,

        [Parameter(Mandatory=$false)]
        [Int] $try = 0
    )    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {

		foreach($item in $Destination){
      try{
        if($try -gt 0){
          for ($i = 0; $i -lt $try; $i++){
            [PsNetPing]::ping($item)
            Start-Sleep -Seconds 2
          }
        }
        else{
          $resultset += [PsNetPing]::ping($item)
        }
      }
      catch{
        $resultset += [PsNetError]::New("$($function)($item)", $_)
        $error.Clear()
      }
		}
	}

	end {
		return $resultset
	}
}
