function Test-PsNetWping{

    <#

    .SYNOPSIS
       Test-PsNetWping - Test web request

    .DESCRIPTION
       Test web request to an Url

    .PARAMETER Destination
       Url to test

    .PARAMETER Timeout
       Max. Timeout in ms

    .PARAMETER NoProxy
       Test web request without a proxy

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000

    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $Timeout,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
    }

    process {
        if($NoProxy) {
            return [PsNetTools]::wping($Destination, $Timeout, $true)
        }
        else{
            return [PsNetTools]::wping($Destination, $Timeout)
        }
    }

    end {
    }

}
