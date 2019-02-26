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
                        $obj = [PSCustomObject]@{
                            Succeeded          = $true
                            IpAddress          = $line[0]
                            Compuername        = $line[1]
                            FullyQualifiedName = $line[2]
                        }
                        $resultset += $obj
                    }
                }
                else{
                    $obj = [PSCustomObject]@{
                        Succeeded          = $true
                        IpAddress          = '{}'
                        Compuername        = '{}'
                        FullyQualifiedName = '{}'
                    }
                    $resultset += $obj
                }
            }
            else{
                $obj = [PSCustomObject]@{
                    Succeeded  = $false
                    Message    = "$Path not found"
                }
                $resultset += $obj
            }
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded          = $false
                Function           = $function
                Message            = $($_.Exception.Message)
                Category           = $($_.CategoryInfo).Category
                Exception          = $($_.Exception.GetType().FullName)
                CategoryActivity   = $($_.CategoryInfo).Activity
                CategoryTargetName = $($_.CategoryInfo).TargetName
            }
            $resultset += $obj
            $error.Clear()
        }
        return $resultset
    }

    [object] static AddPsNetHostEntry([OSType]$CurrentOS, [String]$Path, [String]$IPAddress, [String]$Hostname, [String]$FullyQualifiedName) {

        $function  = 'AddPsNetHostEntry'
        $resultset = @()
        $index     = -1
        $ok        = $null

        $hostsfile = $Path

        if(Test-Path -Path $Path){

            # For Mac and Linux
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){
                
                $current   = (id -u)
                $IsAdmin   = ($current -eq 0)
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
                
                if($IsAdmin){
                    try{
                        $BackupSavedAt = $null
                        [System.Collections.ArrayList]$filecontent = Get-Content $hostsfile

                        $newfilecontent = ($filecontent | Select-String -Pattern "^$($IPAddress)\s+")
                        if($newfilecontent){
                            $index = $filecontent.IndexOf($newfilecontent)
                        } 

                        if($index -gt 0){
                            $Succeeded     = $true
                            $OkMessage     = 'Entry already exists'
                            $Entry         = $newfilecontent
                        }

                        $addcontent = "$($IPAddress) $($Hostname) $($FullyQualifiedName)"
                        if(-not(Test-Path $savefile)){ 
                            $ok = Copy-Item -Path $hostsfile -Destination $savefile -PassThru -Force
                        }
                        if($ok){
                            $content = Add-Content -Value $addcontent -Path $hostsfile -PassThru -ErrorAction Stop
                            if($content.length -gt 0){
                                $Succeeded     = $true
                                $OkMessage     = 'Entry added'
                                $Entry         = $addcontent
                                $BackupSavedAt = $ok.FullName
                            }
                            else{
                                Copy-Item -Path $savefile -Destination $hostsfile -Force
                                throw "Add-Content: it's an empty string, restored $savefile"
                            }
                        }  
                        else {
                            throw "Add-Content: Could not save $($savefile)"
                        }
                        $obj = [PSCustomObject]@{
                            Succeeded     = $Succeeded
                            Message       = $OkMessage
                            Entry         = $Entry
                            BackupSavedAt = $BackupSavedAt
                        }
                        $resultset += $obj
                    }
                    catch {
                        $obj = [PSCustomObject]@{
                            Succeeded          = $false
                            Function           = $function
                            Message            = $($_.Exception.Message)
                            Category           = $($_.CategoryInfo).Category
                            Exception          = $($_.Exception.GetType().FullName)
                            CategoryActivity   = $($_.CategoryInfo).Activity
                            CategoryTargetName = $($_.CategoryInfo).TargetName
                        }
                        $resultset += $obj
                        $error.Clear()
                    }
                }
                else{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                }
            }

            # For Windows only
            if($CurrentOS -eq [OSType]::Windows){
                
                $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $savefile  = "$($env:HOME)\hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"

                if($IsAdmin){
                    try{
                        $BackupSavedAt = $null
                        [System.Collections.ArrayList]$filecontent = Get-Content $hostsfile

                        $newfilecontent = ($filecontent | Select-String -Pattern "^$($IPAddress)\s+")
                        if($newfilecontent){
                            $index = $filecontent.IndexOf($newfilecontent)
                        } 

                        if($index -gt 0){
                            $Succeeded     = $true
                            $OkMessage     = 'Entry already exists'
                            $Entry         = $newfilecontent
                        }
                        else{
                            $addcontent = "$($IPAddress) $($Hostname) $($FullyQualifiedName)"
                            if(-not(Test-Path $savefile)){ 
                                $ok = Copy-Item -Path $hostsfile -Destination $savefile -PassThru -Force
                            }
                            if($ok){
                                $content = Add-Content -Value $addcontent -Path $hostsfile -PassThru
                                if($content.length -gt 0){
                                    $Succeeded     = $true
                                    $OkMessage     = 'Entry added'
                                    $Entry         = $addcontent
                                    $BackupSavedAt = $ok.FullName
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
                        $obj = [PSCustomObject]@{
                            Succeeded     = $Succeeded
                            Message       = $OkMessage
                            Entry         = $Entry
                            BackupSavedAt = $BackupSavedAt
                        }
                        $resultset += $obj    
                    }
                    catch {
                        $obj = [PSCustomObject]@{
                            Succeeded          = $false
                            Function           = $function
                            Message            = $($_.Exception.Message)
                            Category           = $($_.CategoryInfo).Category
                            Exception          = $($_.Exception.GetType().FullName)
                            CategoryActivity   = $($_.CategoryInfo).Activity
                            CategoryTargetName = $($_.CategoryInfo).TargetName
                        }
                        $resultset += $obj
                        $error.Clear()
                    }
                }
                else{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                }
            }
        }
        else{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                Function   = $function
                Message    = "$Path not found"
            }
            $resultset += $obj
        }
        return $resultset
    }

    [object] static RemovePsNetHostEntry([OSType]$CurrentOS, [String]$Path, [String]$Hostsentry) {

        $function  = 'RemovePsNetHostEntry'
        $resultset = @()
        $index     = -1
        $ok        = $null

        $hostsfile = $Path

        if(Test-Path -Path $Path){

            # For Mac and Linux
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){
                
                $current   = (id -u)
                $IsAdmin   = ($current -eq 0)
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
                
                if($IsAdmin){
                    try{
                        $BackupSavedAt = $null
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
                                        $Succeeded     = $true
                                        $OkMessage     = 'Entry removed'
                                        $Entry         = $newfilecontent
                                        $BackupSavedAt = $ok.FullName
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
                            $Succeeded = $true
                            $OkMessage = "Entry not available"
                            $Entry     = $Hostsentry
                        }
                        $obj = [PSCustomObject]@{
                            Succeeded     = $Succeeded
                            Message       = $OkMessage
                            Entry         = $Entry
                            BackupSavedAt = $BackupSavedAt
                        }
                        $resultset += $obj    
                    }
                    catch {
                        $obj = [PSCustomObject]@{
                            Succeeded          = $false
                            Function           = $function
                            Message            = $($_.Exception.Message)
                            Category           = $($_.CategoryInfo).Category
                            Exception          = $($_.Exception.GetType().FullName)
                            CategoryActivity   = $($_.CategoryInfo).Activity
                            CategoryTargetName = $($_.CategoryInfo).TargetName
                        }
                        $resultset += $obj
                        $error.Clear()
                    }
                }
                else{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                }
            }
        
            # For Windows only
            if($CurrentOS -eq [OSType]::Windows){
                
                $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $savefile  = "$($env:HOME)\hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"

                if($IsAdmin){
                    try{
                        $BackupSavedAt = $null
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
                                    $filecontent | Out-File -FilePath $hostsfile -Encoding default -Force
                                    if($hostsfile.length -gt 0){
                                        $Succeeded     = $true
                                        $OkMessage     = 'Entry removed'
                                        $Entry         = $newfilecontent
                                        $BackupSavedAt = $ok.FullName
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
                            $Succeeded = $true
                            $OkMessage = "Entry not available"
                            $Entry     = $Hostsentry
                        }
                        $obj = [PSCustomObject]@{
                            Succeeded     = $Succeeded
                            Message       = $OkMessage
                            Entry         = $Entry
                            BackupSavedAt = $BackupSavedAt
                        }
                        $resultset += $obj    
                    }
                    catch {
                        $obj = [PSCustomObject]@{
                            Succeeded          = $false
                            Function           = $function
                            Message            = $($_.Exception.Message)
                            Category           = $($_.CategoryInfo).Category
                            Exception          = $($_.Exception.GetType().FullName)
                            CategoryActivity   = $($_.CategoryInfo).Activity
                            CategoryTargetName = $($_.CategoryInfo).TargetName
                        }
                        $resultset += $obj
                        $error.Clear()
                    }
                }
                else{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                }
            }
        }
        else{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                Function   = $function
                Message    = "$Path not found"
            }
            $resultset += $obj
        }
        return $resultset
    }

    #endregion
}

