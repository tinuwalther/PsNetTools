function Test-PsNetDig{

    <#

    .SYNOPSIS
       Test-PsNetDig

    .DESCRIPTION
       Resolves a hostname or an ip address

    .PARAMETER Destination
       Name or IP Address to resolve
 
    .EXAMPLE
       Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
       'sbb.ch','ubs.ch' | Test-PsNetDig

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String] $Destination
    ) 
       
    begin {
    }
    
    process {
        return [PsNetDig]::dig($Destination)
    }
    
    end {
    }

}
