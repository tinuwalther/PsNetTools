function Get-PsNetHostsTable {

    <#

    .SYNOPSIS
       Get the content of the hostsfile

    .DESCRIPTION
       Format the content of the hostsfile to an object

    .PARAMETER Path
       Path to the hostsfile, can be empty
 
    .EXAMPLE
       Get-PsNetHostsTable -Path "$($env:windir)\system32\drivers\etc\hosts"

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Path
    )

    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
    }
    
    process {
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
        if([String]::IsNullOrEmpty($Path)){
            if(($CurrentOS -eq [OSType]::Windows) -and ([String]::IsNullOrEmpty($Path))){
                $Path = "$($env:windir)\system32\drivers\etc\hosts"
            }
            else{
                $Path = "/etc/hosts"
            }
        }
        return [PsNetHostsTable]::GetPsNetHostsTable($CurrentOS, $Path)
    }
    
    end {
    }
}

