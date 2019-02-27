function Test-PsNetDig{

    <#

    .SYNOPSIS
      Domain information groper

    .DESCRIPTION
      Resolves a hostname to the IP addresses or an IP Address to the hostname.

    .PARAMETER Destination
      Hostname or IP Address or Alias
 
    .EXAMPLE
      Resolve a hostname to the IP Address
      Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
      Resolve an IP address to the hostname
      Test-PsNetDig -Destination '127.0.0.1','194.150.245.142'

    .EXAMPLE
      Resolve an array of hostnames to the IP Address
      Test-PsNetDig -Destination sbb.ch, google.com

    .EXAMPLE
      Resolve an array of hostnames to the IP Address with ValueFromPipeline
      sbb.ch, google.com | Test-PsNetDig

    .INPUTS
      Hashtable

    .OUTPUTS
      PSCustomObject
      TargetName  : sbb.ch
      IpV4Address : 194.150.245.142
      IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
      Duration    : 4ms

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String[]] $Destination
    ) 
       
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }
    
    process {
        foreach($item in $Destination){
            try{
                $resultset += [PsNetDig]::dig($item)
            }
            catch {
                $resultset += [PsNetError]::New("$($function)($item)", $_)
                $error.Clear()
            }
        }
    }
    
    end {
        return $resultset
    }

}
