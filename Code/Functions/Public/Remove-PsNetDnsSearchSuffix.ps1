function Remove-PsNetDnsSearchSuffix{

    <#

    .SYNOPSIS
       Remove-PsNetDnsSearchSuffix

    .DESCRIPTION
       Running this command with elevated privilege.
       Remove any entries from the DnsSearchSuffixList

    .PARAMETER DNSSearchSuffix
       DNSSearchSuffix to remove
 
    .EXAMPLE
       Remove-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'

    .INPUTS
       String Array

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>
    
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [String[]]$DNSSearchSuffix
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
        foreach($item in $DNSSearchSuffix){
            if ($PSCmdlet.ShouldProcess($item)){
                [PsNetDnsClient]::RemoveDnsSearchSuffix($CurrentOS,$item)
            }
        }
    }

    end{
    }
}
