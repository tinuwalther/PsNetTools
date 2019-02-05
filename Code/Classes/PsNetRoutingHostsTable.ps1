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
    [object] static GetNetRoutingTable([OSType]$CurrentOS, [Int]$interfaceindex, [String]$IpVersion) {

        $function   = 'GetNetRoutingTable()'
        $ostypespec = $null
        $routeprint = $null
        $resultset  = @()

        try{
            if($CurrentOS -eq [OSType]::Linux){
                $ostypespec = 'Pinguin'
            }
            if($CurrentOS -eq [OSType]::Mac){
                $ostypespec = 'Apfel'
            }
            if($CurrentOS -eq [OSType]::Windows){
                $routeprint = netstat -rn
            }
            if($IpVersion -eq 'IPv4'){
                $resultset += [PsNetRoutingTable]::FormatIPv4RoutingTable($routeprint)
            }
            if($IpVersion -eq 'IPv6'){
                $resultset += [PsNetRoutingTable]::FormatIPv6RoutingTable($routeprint)
            }
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                CurrentOS  = $CurrentOS
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

    [object] static FormatIPv4RoutingTable([Object]$routeprint){

        $function   = 'FormatIPv4RoutingTable()'
        $resultset  = @()

        try{
            $InterfaceList = $routeprint -match 'Interface List'
            $InterfaceListIndex = $routeprint.IndexOf($InterfaceList)

            $IPv4RouteTable = $routeprint -match 'IPv4 Route Table'
            $IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)

            $IPv6RouteTable = $routeprint -match 'IPv6 Route Table'
            $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

            $Interfaces = @()
            $IPv4Table  = @()

            for ($i = 0; $i -lt $routeprint.Length; $i++){
                
                if($i -eq $InterfaceListIndex){
                    for ($i = $InterfaceListIndex; $i -lt $IPv4RouteTableIndex -1; $i++){
                        $Interfaces += $routeprint[$i]
                    }
                }

                if($i -eq $IPv4RouteTableIndex){
                    for ($i = $IPv4RouteTableIndex; $i -lt $IPv6RouteTableIndex -1; $i++){
                        $IPv4Table += $routeprint[$i]
                    }
                }

            }

            $IPv4Table -replace '=' | ForEach-Object{
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
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
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

    [object] static FormatIPv6RoutingTable([Object]$routeprint){

        $function   = 'FormatIPv6RoutingTable()'
        $resultset  = @()

        try{
            $InterfaceList = $routeprint -match 'Interface List'
            $InterfaceListIndex = $routeprint.IndexOf($InterfaceList)

            $IPv4RouteTable = $routeprint -match 'IPv4 Route Table'
            $IPv4RouteTableIndex = $routeprint.IndexOf($IPv4RouteTable)

            $IPv6RouteTable = $routeprint -match 'IPv6 Route Table'
            $IPv6RouteTableIndex = $routeprint.IndexOf($IPv6RouteTable)

            $Interfaces = @()
            $IPv6Table  = @()

            for ($i = 0; $i -lt $routeprint.Length; $i++){
                
                if($i -eq $InterfaceListIndex){
                    for ($i = $InterfaceListIndex; $i -lt $IPv4RouteTableIndex -1; $i++){
                        $Interfaces += $routeprint[$i]
                    }
                }

                if($i -eq $IPv6RouteTableIndex){
                    for ($i = $IPv6RouteTableIndex; $i -lt $routeprint.Length -1; $i++){
                        $IPv6Table += $routeprint[$i]
                    }
                }

            }

            $IPv6Table -replace '=' | ForEach-Object{
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
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
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

