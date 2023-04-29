function Test-PsNetWping {

    <#

   .SYNOPSIS
      Test-PsNetWping

   .DESCRIPTION
      Test web request to an Url

   .PARAMETER Destination
      A String or an Array of Strings with Url's to test

   .PARAMETER MinTimeout
      Min. Timeout in ms, default is 0

   .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

   .PARAMETER NoProxy
      Test web request without a proxy
 
   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch'

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000 -NoProxy | Format-Table

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
            Mandatory = $false
        )]
        [Int] $MinTimeout = 0,

        [Parameter(
            Mandatory = $false
        )]
        [Int] $MaxTimeout = 1000,
 
        [Parameter(
            Mandatory = $false
        )]
        [Switch] $NoProxy
    )  
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {
        if ($NoProxy) {
            foreach ($item in $Destination) {
                if ($PSCmdlet.ShouldProcess($item)) {
                    if ($item -notmatch '^http') {
                        $item = "http://$($item)"
                    }
                    try {
                        $resultset += [PsNetWeb]::wping($item, $MinTimeout, $MaxTimeout, $true)
                    }
                    catch {
                        $resultset += [PsNetError]::New("$($function)($item)", $_)
                        $error.Clear()
                    }
                }
            }
        }
        else {
            foreach ($item in $Destination) {
                if ($PSCmdlet.ShouldProcess($item)) {
                    if ($item -notmatch '^http') {
                        $item = "http://$($item)"
                    }
                    try {
                        $resultset += [PsNetWeb]::wping($item, $MinTimeout, $MaxTimeout)
                    }
                    catch {
                        $resultset += [PsNetError]::New("$($function)($item)", $_)
                        $error.Clear()
                    }
                }
            }
        }
    }

    end {
        return $resultset
    }

}
