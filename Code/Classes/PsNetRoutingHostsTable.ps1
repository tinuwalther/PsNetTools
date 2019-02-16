enum OSType {
    Linux
    Mac
    Windows
}

Class PsNetRoutingTable{

    <#
        [PsNetRoutingTable]::GetNetRoutingTable()
        https://msdn.microsoft.com/en-us/library/hh872448(v=vs.85).aspx
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetRoutingTable(){
        $this.Message = "Loading PsNetRoutingTable"
    }
    #endregion
    
    #region methods
    [object] static GetNetRoutingTable([OSType]$CurrentOS,[String]$IpVersion) {

        $function   = 'GetNetRoutingTable()'
        $routeprint = $null
        $resultset  = @()

        try{
            $routeprint = netstat -rn
            if($IpVersion -eq 'IPv4'){
                $resultset += [PsNetRoutingTable]::FormatIPv4RoutingTable($CurrentOS,$routeprint)
            }
            if($IpVersion -eq 'IPv6'){
                $resultset += [PsNetRoutingTable]::FormatIPv6RoutingTable($CurrentOS,$routeprint)
            }
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                Function   = $function
                Activity   = $($_.CategoryInfo).Activity
                Message    = $($_.Exception.Message)
                Category   = $($_.CategoryInfo).Category
                Exception  = $($_.Exception.GetType().FullName)
                TargetName = $($_.CategoryInfo).TargetName
            }
            $resultset += $obj
            $error.Clear()
        }                
        return $resultset
    }

    [object] static FormatIPv4RoutingTable([OSType]$CurrentOS,[Object]$routeprint){

        $function   = 'FormatIPv4RoutingTable()'
        $IPv4Table  = @()
        $resultset  = @()

        try{
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){

                $InterfaceList       = $routeprint -match 'Routing tables'
                $IPv4RouteTable      = $routeprint -match 'Internet:'
                $IPv6RouteTable      = $routeprint -match 'Internet6:'

                #$InterfaceListIndex  = $routeprint.IndexOf($InterfaceList) + 1
                $IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)
                $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

                for ($i = 0; $i -lt $routeprint.Length; $i++){
                    if($i -eq $IPv4RouteTableIndex){
                        for ($i = $IPv4RouteTableIndex; $i -lt $IPv6RouteTableIndex -1; $i++){
                            $IPv4Table += $routeprint[$i]
                        }
                    }
                }

                if($IPv4Table -contains $IPv4RouteTable){
                    $IPv4Table = $IPv4Table -replace $IPv4RouteTable 
                }
                $IPv4Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[3] -match '^\d'){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true
                                AddressFamily = 'IPv4'
                                Destination   = $string[0]
                                Gateway       = $string[1]
                                Flags         = $string[2]
                                Refs          = $string[3]
                                Use           = $string[4]
                                Netif         = $string[5]
                                Expire        = $string[6]
                            }
                            $resultset += $obj
                        }
                    }
                }

            }
            if($CurrentOS -eq [OSType]::Windows){

                $InterfaceList       = $routeprint -match 'Interface List'
                $IPv4RouteTable      = $routeprint -match 'IPv4 Route Table'
                $IPv6RouteTable      = $routeprint -match 'IPv6 Route Table'

                #$InterfaceListIndex  = $routeprint.IndexOf($InterfaceList)
                $IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)
                $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

                for ($i = 0; $i -lt $routeprint.Length; $i++){
                    if($i -eq $IPv4RouteTableIndex){
                        for ($i = $IPv4RouteTableIndex; $i -lt $IPv6RouteTableIndex -1; $i++){
                            $IPv4Table += $routeprint[$i]
                        }
                    }
                }

                if($IPv4Table -contains '='){
                    $IPv4Table = $IPv4Table -replace '=' 
                }
                $IPv4Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[5] -match '^\d'){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true
                                AddressFamily = 'IPv4'
                                Destination   = $string[1]
                                Netmask       = $string[2]
                                Gateway       = $string[3]
                                Interface     = $string[4]
                                Metric        = $string[5]
                            }
                            $resultset += $obj
                        }
                    }
                }
            }
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                Function   = $function
                Activity   = $($_.CategoryInfo).Activity
                Message    = $($_.Exception.Message)
                Category   = $($_.CategoryInfo).Category
                Exception  = $($_.Exception.GetType().FullName)
                TargetName = $($_.CategoryInfo).TargetName
            }
            $resultset += $obj
            $error.Clear()
        }                
        return $resultset
    }

    [object] static FormatIPv6RoutingTable([OSType]$CurrentOS,[Object]$routeprint){

        $function   = 'FormatIPv6RoutingTable()'
        $IPv6Table  = @()
        $resultset  = @()

        try{
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){

                $InterfaceList       = $routeprint -match 'Routing tables'
                $IPv4RouteTable      = $routeprint -match 'Internet:'
                $IPv6RouteTable      = $routeprint -match 'Internet6:'

                #$InterfaceListIndex  = $routeprint.IndexOf($InterfaceList) + 1
                #$IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)
                $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

                for ($i = 0; $i -lt $routeprint.Length; $i++){
                    if($i -eq $IPv6RouteTableIndex){
                        for ($i = $IPv6RouteTableIndex; $i -lt $routeprint.Length -1; $i++){
                            $IPv6Table += $routeprint[$i]
                        }
                    }
                }

                if($IPv6Table -contains $IPv6RouteTable){
                    $IPv6Table = $IPv6Table -replace $IPv6RouteTable 
                }
                $IPv6Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[0] -notmatch '^\Destination'){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true 
                                AddressFamily = 'IPv6'
                                Destination   = $string[0]
                                Gateway       = $string[1]
                                Flags         = $string[2]
                                Netif         = $string[3]
                                Expire        = $string[4]
                            }
                            $resultset += $obj
                        }
                    }
                }

            }
            if($CurrentOS -eq [OSType]::Windows){

                $InterfaceList       = $routeprint -match 'Interface List'
                $IPv4RouteTable      = $routeprint -match 'IPv4 Route Table'
                $IPv6RouteTable      = $routeprint -match 'IPv6 Route Table'

                #$InterfaceListIndex  = $routeprint.IndexOf($InterfaceList)
                #$IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)
                $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

                for ($i = 0; $i -lt $routeprint.Length; $i++){
                    if($i -eq $IPv6RouteTableIndex){
                        for ($i = $IPv6RouteTableIndex; $i -lt $routeprint.Length -1; $i++){
                            $IPv6Table += $routeprint[$i]
                        }
                    }
                }

                if($IPv6Table -contains '='){
                    $IPv6Table = $IPv6Table -replace '=' 
                }
                $IPv6Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[1] -match '^\d'){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true 
                                AddressFamily = 'IPv6'
                                Index         = $string[1]
                                Metric        = $string[2]
                                Destination   = $string[3]
                                Gateway       = $string[4]
                            }
                            $resultset += $obj
                        }
                    }
                }
            } 
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                Function   = $function
                Activity   = $($_.CategoryInfo).Activity
                Message    = $($_.Exception.Message)
                Category   = $($_.CategoryInfo).Category
                Exception  = $($_.Exception.GetType().FullName)
                TargetName = $($_.CategoryInfo).TargetName
            }
            $resultset += $obj
            $error.Clear()
        }                
        return $resultset
    }
    #endregion
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
                Succeeded  = $false
                Function   = $function
                Activity   = $($_.CategoryInfo).Activity
                Message    = $($_.Exception.Message)
                Category   = $($_.CategoryInfo).Category
                Exception  = $($_.Exception.GetType().FullName)
                TargetName = $($_.CategoryInfo).TargetName
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
                
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
                
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
                catch [UnauthorizedAccessException]{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                    $error.Clear()
                    Remove-Item $savefile -Force
                }
                catch {
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Activity   = $($_.CategoryInfo).Activity
                        Message    = $($_.Exception.Message)
                        Category   = $($_.CategoryInfo).Category
                        Exception  = $($_.Exception.GetType().FullName)
                        TargetName = $($_.CategoryInfo).TargetName
                    }
                    $resultset += $obj
                    $error.Clear()
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
                            Succeeded  = $false
                            Function   = $function
                            Activity   = $($_.CategoryInfo).Activity
                            Message    = $($_.Exception.Message)
                            Category   = $($_.CategoryInfo).Category
                            Exception  = $($_.Exception.GetType().FullName)
                            TargetName = $($_.CategoryInfo).TargetName
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

    [object] static RemovePsNetHostEntry([OSType]$CurrentOS, [String]$Path, [String]$IPAddress) {

        $function  = 'RemovePsNetHostEntry'
        $resultset = @()
        $index     = -1
        $ok        = $null

        $hostsfile = $Path

        if(Test-Path -Path $Path){

            # For Mac and Linux
            if(($CurrentOS -eq [OSType]::Mac) -or ($CurrentOS -eq [OSType]::Linux)){
                
                $savefile  = "$($env:HOME)/hosts_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
                
                try{
                    $BackupSavedAt = $null
                    [System.Collections.ArrayList]$filecontent = Get-Content $hostsfile

                    $newfilecontent = ($filecontent | Select-String -Pattern "^$($IPAddress)\s+")
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
                        $Entry     = $IPAddress
                    }
                    $obj = [PSCustomObject]@{
                        Succeeded     = $Succeeded
                        Message       = $OkMessage
                        Entry         = $Entry
                        BackupSavedAt = $BackupSavedAt
                    }
                    $resultset += $obj    
                }
                catch [UnauthorizedAccessException]{
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Message    = "Running this command with elevated privileges"
                    }
                    $resultset += $obj
                    $error.Clear()
                    Remove-Item $savefile -Force
                }
                catch {
                    $obj = [PSCustomObject]@{
                        Succeeded  = $false
                        Function   = $function
                        Activity   = $($_.CategoryInfo).Activity
                        Message    = $($_.Exception.Message)
                        Category   = $($_.CategoryInfo).Category
                        Exception  = $($_.Exception.GetType().FullName)
                        TargetName = $($_.CategoryInfo).TargetName
                    }
                    $resultset += $obj
                    $error.Clear()
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
                            $Entry     = $IPAddress
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
                            Succeeded  = $false
                            Function   = $function
                            Activity   = $($_.CategoryInfo).Activity
                            Message    = $($_.Exception.Message)
                            Category   = $($_.CategoryInfo).Category
                            Exception  = $($_.Exception.GetType().FullName)
                            TargetName = $($_.CategoryInfo).TargetName
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

