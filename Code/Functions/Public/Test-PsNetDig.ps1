function Test-PsNetDig{

    <#

    .SYNOPSIS
       Test-PsNetDig - PowerShell domain information groper

    .DESCRIPTION
       Resolves a hostname or an ip address

    .PARAMETER Destination
       Name or IP Address to resolve

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
       'sbb.ch','ubs.ch' | Test-PsNetDig

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String] $Destination
    ) 
       
    begin {
    }
    
    process {
        return [PsNetTools]::dig($Destination)
    }
    
    end {
    }

}
