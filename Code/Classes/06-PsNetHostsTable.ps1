Class PsNetHostsTableType {

    [bool]   $Succeeded
    [String] $IpAddress
    [String] $Compuername
    [String] $FullyQualifiedName
    [String] $Message

    PsNetHostsTableType (
        [bool]   $Succeeded,
        [String] $IpAddress,
        [String] $Compuername,
        [String] $FullyQualifiedName,
        [String] $Message
        ) {
        $this.Succeeded          = $Succeeded
        $this.IpAddress          = $IpAddress
        $this.Compuername        = $Compuername
        $this.FullyQualifiedName = $FullyQualifiedName
        $this.Message            = $Message
    }
}

Class PsNetHostsEntryType {

    [bool]   $Succeeded
    [String] $HostsEntry
    [String] $BackupPath
    [String] $Message

    PsNetHostsEntryType (
        [bool]   $Succeeded,
        [String] $HostsEntry,
        [String] $BackupPath,
        [String] $Message
    ) {
        $this.Succeeded   = $Succeeded
        $this.HostsEntry  = $HostsEntry
        $this.BackupPath  = $BackupPath
        $this.Message     = $Message
    }
}

enum OSType {
    Linux
    Mac
    Windows
}

Class PsNetHostsTable {

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetHostsTable(){
        $this.Message = "Loading PsNetHostsTable"
    }
    #endregion
    
    #region methods
    [object] static GetPsNetHostsTable([OSType]$CurrentOS, [String]$Path) {

        $function    = 'GetPsNetHostsTable()'
        $filecontent = @()
        $resultset   = @()

        try{
            if(Test-Path -Path $Path){
                $ipv4pattern = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
                $filecontent = Get-Content -Path $Path
                if($filecontent -match $ipv4pattern){
                    $string = ($filecontent | Select-String -Pattern $ipv4pattern).Line
                    for ($i = 0; $i -lt $string.Length; $i++){
                        $line = ($string[$i]) -Split '\s+'
                        $resultset += [PsNetHostsTableType]::New($true,$line[0],$line[1],$line[2],$null)
                    }
                }
                else{
                    $resultset += [PsNetHostsTableType]::New($true,'{}','{}','{}',$null)
                }
            }
            else{
                $resultset += [PsNetHostsTableType]::New($false,'{}','{}','{}',"$Path not found")
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }
        return $resultset
    }

    [object] static AddPsNetHostsEntry([OSType]$CurrentOS, [String]$Path, [String]$IPAddress, [String]$Hostname, [String]$FullyQualifiedName) {

        $function  = 'AddPsNetHostsEntry'
        $resultset = @()
        $index     = -1
        $IsAdmin   = $false
        $savefile  = $null
        $ok        = $null

        $hostsfile = $Path

        if(Test-Path -Path $Path){

            # For Mac and Linux
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){
                $current   = (id -u)
                $IsAdmin   = ($current -eq 0)
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
            }

            # For Windows only
            if($CurrentOS -eq [OSType]::Windows){
                $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $savefile  = "$($env:HOME)\hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
            }

            if($IsAdmin){
                try{
                    #$BackupSavedAt = $null
                    [System.Collections.ArrayList]$filecontent = Get-Content $hostsfile

                    $newfilecontent = ($filecontent | Select-String -Pattern "^$($IPAddress)\s+")
                    if($newfilecontent){
                        $index = $filecontent.IndexOf($newfilecontent)
                    } 
                    if($index -gt 0){
                        $resultset += [PsNetHostsEntryType]::New($true,$newfilecontent,$null,'Entry already exists')
                    }

                    $addcontent = "$($IPAddress) $($Hostname) $($FullyQualifiedName)"
                    if(-not(Test-Path $savefile)){ 
                        $ok = Copy-Item -Path $hostsfile -Destination $savefile -PassThru -Force
                    }
                    if($ok){
                        $content = Add-Content -Value $addcontent -Path $hostsfile -PassThru -ErrorAction Stop
                        if($content.length -gt 0){
                            $resultset += [PsNetHostsEntryType]::New($true,$addcontent,$($ok.FullName),'Entry added')
                        }
                        else{
                            Copy-Item -Path $savefile -Destination $hostsfile -Force
                            throw "Add-Content: it's an empty string, restored $savefile"
                        }
                    }  
                    else {
                        throw "Add-Content: Could not save $($savefile)"
                    }
                }
                catch {
                    $resultset += [PsNetError]::New("$($function)()", $_)
                    $error.Clear()
                }
            }
            else{
                $resultset += [PsNetHostsEntryType]::New($false,$null,$null,'Running this command with elevated privileges')
            }
        }
        else{
            $resultset += [PsNetHostsEntryType]::New($false,$null,$null,"$Path not found")
        }
        return $resultset
    }

    [object] static RemovePsNetHostsEntry([OSType]$CurrentOS, [String]$Path, [String]$Hostsentry) {

        $function  = 'RemovePsNetHostsEntry'
        $resultset = @()
        $index     = -1
        $IsAdmin   = $false
        $savefile  = $null
        $ok        = $null

        $hostsfile = $Path

        if(Test-Path -Path $Path){

            # For Mac and Linux
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){
                $current   = (id -u)
                $IsAdmin   = ($current -eq 0)
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
            }
        
            # For Windows only
            if($CurrentOS -eq [OSType]::Windows){
                $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $savefile  = "$($env:HOME)\hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
            }
            if($IsAdmin){
                try{
                    #$BackupSavedAt = $null
                    [System.Collections.ArrayList]$filecontent = Get-Content $hostsfile

                    $newfilecontent = ($filecontent | Select-String -Pattern "^$($Hostsentry)")
                    if($newfilecontent){
                        $index = $filecontent.IndexOf($newfilecontent)
                    } 
                    if($index -gt 0){
                        $filecontent.RemoveAt($index)
                        if([String]::IsNullOrEmpty($filecontent)){
                            throw "RemoveAt: raised an error"
                        }
                        else{
                            if(-not(Test-Path $savefile)){ 
                                $ok = Copy-Item -Path $hostsfile -Destination $savefile -PassThru -Force
                            }
                            if($ok){
                                if([String]::IsNullOrEmpty($filecontent)){
                                    throw "Set-Content: Value is an empty String"
                                }
                                $filecontent | Out-File -FilePath $hostsfile -Encoding default -Force -ErrorAction Stop
                                if($hostsfile.length -gt 0){
                                    $resultset += [PsNetHostsEntryType]::New($true,$newfilecontent,$($ok.FullName),'Entry removed')
                                }
                                else{
                                    Copy-Item -Path $savefile -Destination $hostsfile -Force
                                    throw "Set-Content: File is empty, restored $savefile"
                                }
                            }
                            else{
                                throw "Set-Content: Could not save $($savefile)"
                            }
                        }
                    }
                    else{
                        $resultset += [PsNetHostsEntryType]::New($true,$Hostsentry,$null,'Entry not available')
                    }
                }
                catch {
                    $resultset += [PsNetError]::New("$($function)()", $_)
                    $error.Clear()
                }
            }
            else{
                $resultset += [PsNetHostsEntryType]::New($false,$null,$null,'Running this command with elevated privileges')
            }
        }
        else{
            $resultset += [PsNetHostsEntryType]::New($false,$null,$null,"$Path not found")
        }
        return $resultset
    }

    #endregion
}

