function Get-PsNetRoutingTable{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [Int] $InterfaceIndex
    )  
    
    begin {
    }
    
    process {
        if($PSVersionTable.PSVersion.Major -lt 6){
            $CurrentOS = [OSType]::Windows
        }
        else{
            if($IsMacOS)  {$CurrentOS = [OSType]::Mac}
            if($IsLinux)  {$CurrentOS = [OSType]::Linux}
            if($IsWindows){$CurrentOS = [OSType]::Windows}
        }
        return [PsNetTools]::GetNetRoutingTable($CurrentOS, $InterfaceIndex)
    }
    
    end {
    }
}