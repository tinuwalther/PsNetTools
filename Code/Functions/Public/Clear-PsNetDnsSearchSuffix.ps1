function Clear-PsNetDnsSearchSuffix{

    <#

    .SYNOPSIS
       Clear-PsNetDnsSearchSuffix

    .DESCRIPTION
       Running this command with elevated privilege.
       Remove all entries from the DnsSearchSuffixList

    .EXAMPLE
       Clear-PsNetDnsSearchSuffix

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>
    
    [CmdletBinding()]
    param()

    begin{
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        if($PSVersionTable.PSVersion.Major -lt 6){
            $CurrentOS = [OSType]::Windows
        }
        else{
            if($IsMacOS)  {
                $CurrentOS = [OSType]::Mac
            }
            if($IsLinux)  {
                $CurrentOS = [OSType]::Linux
            }
            if($IsWindows){
                $CurrentOS = [OSType]::Windows
            }
        }
    }

    process{
        [PsNetDnsClient]::ClearDnsSearchSuffix($CurrentOS)
    }

    end{
        return $obj
    }
}
