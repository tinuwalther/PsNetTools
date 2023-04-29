function Remove-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Remove an entry from the hostsfile

    .DESCRIPTION
       Running this command with elevated privilege.   
       Backup the hostsfile and remove an entry from the hostsfile

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .PARAMETER Hostsentry
       IP Address and hostname to remove
 
    .EXAMPLE
       Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'

    .INPUTS
       Hashtable

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
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [String]$Hostsentry,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
        )]
        [String]$Path
    )

    begin {
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
    
    process {
        $item =$Hostsentry
        if ($PSCmdlet.ShouldProcess($item)){
            if([String]::IsNullOrEmpty($Path)){
                if(($CurrentOS -eq [OSType]::Windows) -and ([String]::IsNullOrEmpty($Path))){
                    $Path = "$($env:windir)\system32\drivers\etc\hosts"
                }
                else{
                    $Path = "/etc/hosts"
                }
            }
            return [PsNetHostsTable]::RemovePsNetHostsEntry($CurrentOS, $Path, $Hostsentry)
        }
    }
    
    end {
    }
}

