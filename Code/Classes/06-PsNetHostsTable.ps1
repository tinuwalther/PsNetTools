Class PsNetHostsTableType {

    [bool]   $Succeeded
    [String] $IpVersion
    [String] $IpAddress
    [String] $ComputerName
    [String] $FullyQualifiedName
    [String] $Message

    PsNetHostsTableType (
        [bool]   $Succeeded,
        [String] $IpVersion,
        [String] $IpAddress,
        [String] $ComputerName,
        [String] $FullyQualifiedName,
        [String] $Message
        ) {
        $this.Succeeded          = $Succeeded
        $this.IpVersion          = $IpVersion
        $this.IpAddress          = $IpAddress
        $this.ComputerName        = $ComputerName
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
                $ipv6pattern = '^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'
                $fqdnregex   = '(?=^.{1,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'

                $filecontent = Get-Content -Path $Path
                if($filecontent -match $ipv4pattern){
                    $string = ($filecontent | Select-String -Pattern $ipv4pattern)
                    for ($i = 0; $i -lt $string.Length; $i++){
                        if($string[$i] -notmatch '#'){
                            $line = ($string[$i]) -Split '\s+'
                            if($line[2] -match $fqdnregex){
                                $computername = $line[1]
                                $fqdn         = $line[2]
                                $comment      = 'Mapping IP Address to Computername (to FQDN) is well'
                            }
                            else{
                                if($line[1] -match '\.'){
                                    $computername = $line[2]
                                    $fqdn         = $line[1]
                                    $comment      = 'Mapping IP Address to Computername (to FQDN) is wrong'
                                }
                                else{
                                    $computername = $line[1]
                                    $fqdn         = $line[2]
                                    $comment      = 'Mapping IP Address to Computername (to FQDN) is well'
                                }
                            }
                            $resultset += [PsNetHostsTableType]::New($true,'IPv4',$line[0],$computername,$fqdn,$comment)
                        }
                    }
                }
                if($filecontent -match $ipv6pattern){
                    $string = ($filecontent | Select-String -Pattern $ipv6pattern)
                    for ($i = 0; $i -lt $string.Length; $i++){
                        if($string[$i] -notmatch '#'){
                            $line = ($string[$i]) -Split '\s+'
                            if($line[2] -match $fqdnregex){
                                $computername = $line[1]
                                $fqdn         = $line[2]
                                $comment      = 'Mapping IP Address to Computername (to FQDN) is well'
                            }
                            else{
                                if($line[1] -match '\.'){
                                    $computername = $line[2]
                                    $fqdn         = $line[1]
                                    $comment      = 'Mapping IP Address to Computername (to FQDN) is wrong'
                                }
                                else{
                                    $computername = $line[1]
                                    $fqdn         = $line[2]
                                    $comment      = 'Mapping IP Address to Computername (to FQDN) is well'
                                }
                            }
                            $resultset += [PsNetHostsTableType]::New($true,'IPv6',$line[0],$computername,$fqdn,$comment)
                        }
                    }
                }
                if([String]::IsNullOrEmpty($resultset)){
                    $resultset += [PsNetHostsTableType]::New($true,$null,$null,$null,$null,'No active entries')
                }
            }
            else{
                $resultset += [PsNetHostsTableType]::New($false,$null,$null,$null,"$Path not found")
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

