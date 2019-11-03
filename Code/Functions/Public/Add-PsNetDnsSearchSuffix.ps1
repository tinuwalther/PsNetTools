function Add-PsNetDnsSearchSuffix{

    <#

    .SYNOPSIS
       Add-PsNetDnsSearchSuffix

    .DESCRIPTION
       Running this command with elevated privilege.
       Adding any entries to the DnsSearchSuffixList

    .PARAMETER NewDNSSearchSuffix
       DNSSearchSuffix to add
 
    .EXAMPLE
       Add-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'

    .INPUTS
       String Array

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
        [String[]]$NewDNSSearchSuffix
    )

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
        foreach($item in $NewDNSSearchSuffix){
            [PsNetDnsClient]::AddDnsSearchSuffix($CurrentOS,$item)
        }
    }

    end{
        return $obj
    }
}
