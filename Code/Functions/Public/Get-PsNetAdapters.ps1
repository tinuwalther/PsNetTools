function Get-PsNetAdapters {

    <#

    .SYNOPSIS
       Get Network Adapters

    .DESCRIPTION
       List all network adapters
 
    .EXAMPLE
       Get-PsNetAdapters

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding(SupportsShouldProcess = $True)]
    param()  
      
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
    }
    
    process {
        if ($PSCmdlet.ShouldProcess('all network adapters')){
            return [PsNetAdapter]::listadapters()
        }
    }
    
    end {
    }

}
