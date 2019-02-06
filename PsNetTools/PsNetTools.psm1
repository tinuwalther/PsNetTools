<#
    Generated at 02/06/2019 20:32:49 by Martin Walther
    using module ..\PsNetTools\PsNetTools.psm1
#>
#region namespace PsNetTools
Class PsNetAdapter {

    <#
        [PsNetAdapter]::GetNetAdapters
        [PsNetAdapter]::GetNetadapterConfiguration
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetAdapter(){
        $this.Message = "Loading PsNetAdapter"
    }
    #endregion

    #region methods
    [object] static GetNetadapters(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'GetNetadapters()'
        $resultset = @()

        try{
            $nics = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
            foreach($adapter in $nics){

                if($adapter.NetworkInterfaceType -notmatch 'Loopback'){

                    $IpVersion      = @()
                    $properties     = $adapter.GetIPProperties()
                    $IpV4properties = $properties.GetIPv4Properties()
                    $IpV4Addresses  = @()
                    $IpV6Addresses  = @()

                    $IpV4 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv4
                    $IpV6 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv6
                
                    if($adapter.Supports($IpV4)){
                        $IpVersion += 'IPv4'
                    }
                
                    if($adapter.Supports($IpV6)){
                        $IpVersion += 'IPv6'
                    }
                
                    foreach ($ip in $properties.UnicastAddresses) {
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork){
                            $IpV4Addresses += $ip.Address.ToString()
                        }
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork6){
                            $IpV6Addresses += $ip.Address.ToString()
                        }
                    }

                    $obj = [PSCustomObject]@{
                        Succeeded            = $true
                        Index                = $IpV4properties.Index
                        Name                 = $adapter.Name
                        Description          = $adapter.Description
                        NetworkInterfaceType = $adapter.NetworkInterfaceType
                        OperationalStatus    = $adapter.OperationalStatus
                        IpVersion            = $IpVersion
                        IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
                        IpV4Addresses        = $IpV4Addresses
                        IpV6Addresses        = $IpV6Addresses
                        PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
                    }
                    $resultset += $obj
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

    [object] static GetNetadapterConfiguration(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'GetNetadapterConfigurations()'
        $resultset = @()

        try{
            $nics = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
            foreach($adapter in $nics){

                if($adapter.NetworkInterfaceType -notmatch 'Loopback'){

                    $IpV4Addresses = @()
                    $IpV6Addresses = @()

                    $IpVersion            = @()
                    $GatewayIpV4Addresses = @()
                    $GatewayIpV6Addresses = @()
    
                    $properties     = $adapter.GetIPProperties()
                    $IpV4properties = $properties.GetIPv4Properties()
                    $IpV6properties = $properties.GetIPv6Properties()
                                
                    $IpV4 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv4
                    $IpV6 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv6
                
                    if($adapter.Supports($IpV4)){
                        $IpVersion += 'IPv4'
                    }
                
                    if($adapter.Supports($IpV6)){
                        $IpVersion += 'IPv6'
                    }
    
                    foreach ($ip in $properties.UnicastAddresses) {
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork){
                            $IpV4Addresses += $ip.Address.ToString()
                        }
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork6){
                            $IpV6Addresses += $ip.Address.ToString()
                        }
                    }

                    foreach($gateway in $properties.GatewayAddresses){
                        if($gateway.Address.AddressFamily -eq 'InterNetwork6'){
                            $GatewayIpV6Addresses += $gateway.Address.IPAddressToString
                        }
                        if($gateway.Address.AddressFamily -eq 'InterNetwork'){
                            $GatewayIpV4Addresses += $gateway.Address.IPAddressToString
                        }
                    }

                    $obj = [PSCustomObject]@{
                        Succeeded            = $true
                        Index                = $IpV4properties.Index
                        Id                   = $adapter.Id
                        Name                 = $adapter.Name
                        Description          = $adapter.Description
                        NetworkInterfaceType = $adapter.NetworkInterfaceType
                        OperationalStatus    = $adapter.OperationalStatus
                        Speed                = $adapter.Speed
                        IsReceiveOnly        = $adapter.IsReceiveOnly
                        SupportsMulticast    = $adapter.SupportsMulticast
                
                        IpVersion            = $IpVersion
                        IpV4Addresses        = $IpV4Addresses
                        IpV6Addresses        = $IpV6Addresses
                        PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
                        
                        IsDnsEnabled         = $properties.IsDnsEnabled
                        IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
                        DnsSuffix            = $properties.DnsSuffix
                        DnsAddresses         = $properties.DnsAddresses
                        
                        Mtu                  = $IpV4properties.Mtu
                
                        IsForwardingEnabled  = $IpV4properties.IsForwardingEnabled
                        
                        IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
                        IsAPIPAActive        = $IpV4properties.IsAutomaticPrivateAddressingEnabled
                
                        IsDhcpEnabled        = $IpV4properties.IsDhcpEnabled
                        DhcpServerAddresses  = $properties.DhcpServerAddresses
                        
                        UsesWins             = $IpV4properties.UsesWins
                        WinsServersAddresses = $properties.WinsServersAddresses
                 
                        GatewayIpV4Addresses = $GatewayIpV4Addresses
                        GatewayIpV6Addresses = $GatewayIpV6Addresses
                    }
                    $resultset += $obj
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

Class PsNetDig {

    <#
        [PsNetDig]::dig('sbb.ch')
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetDig(){
        $this.Message = "Loading PsNetDig"
    }
    #endregion
    
    #region methods
    [object]static dig([String] $TargetName) {
        
        $function  = 'dig()'
        $resultset = $null

        if([String]::IsNullOrEmpty($TargetName)){
            Write-Warning "$($function): Empty TargetName specified!"
        }
        else{
            $computer    = $null
            $addresses   = $null
            $ipv4address = $null
            $ipv6address = $null
            $ipv4pattern = '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'
            try {
                if($TargetName -match $ipv4pattern){
                    $start     = Get-Date
                    $addresses = [System.Net.Dns]::GetHostByAddress($TargetName)
                    if(-not([String]::IsNullOrEmpty($addresses))){
                        $computer = $addresses.hostname
                        foreach($item in $addresses.AddressList){
                            if($($item.AddressFamily) -eq 'InterNetwork'){
                                $ipv4address = $item.IPAddressToString
                            }
                            if($($item.AddressFamily) -eq 'InterNetworkV6'){
                                $ipv6address = $item.IPAddressToString
                            }
                            $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                            
                            $resultset = [PSCustomObject]@{
                                Succeeded    = $true
                                TargetName  = $computer
                                IpV4Address = $ipv4address
                                IpV6Address = $ipv6address
                                Duration    = "$($duration)ms"
                            }
                        }
                    }
                    else{
                        return $null
                    }
                }
                elseif($TargetName.GetType() -eq [String]){
                    $start     = Get-Date
                    $addresses = [System.Net.Dns]::GetHostAddressesAsync($TargetName).GetAwaiter().GetResult()
                    if(-not([String]::IsNullOrEmpty($addresses))){
                        foreach($item in $addresses){
                            if($($item.AddressFamily) -eq 'InterNetwork'){
                                $ipv4address = $item.IPAddressToString
                            }
                            if($($item.AddressFamily) -eq 'InterNetworkV6'){
                                $ipv6address = $item.IPAddressToString
                            }
                            $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                            
                            $resultset = [PSCustomObject]@{
                                Succeeded   = $true
                                TargetName  = $TargetName
                                IpV4Address = $ipv4address
                                IpV6Address = $ipv6address
                                Duration    = "$($duration)ms"
                            }
                        }
                    }
                    else{
                        return $null
                    }
                }
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
        return $resultset
    }
    #endregion
}

Class PsNetPing {

    <#
        [PsNetPing]::tping('sbb.ch', 80, 100)
        [PsNetPing]::uping('sbb.ch', 53, 100)
        [PsNetPing]::wping('https://sbb.ch', 1000, $true) 
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetPing(){
        $this.Message = "Loading PsNetPing"
    }
    #endregion
    
    #region methods
    [object]static tping([String] $TargetName, [int] $TcpPort, [int] $Timeout) {

        $function  = 'tping()'
        $resultset = @()

        if(([String]::IsNullOrEmpty($TargetName))){
            Write-Warning "$($function): Empty TargetName specified!"
        }
        else{
            $tcpclient    = $null
            $connect      = $null
            $patience     = $null
            $tcpsucceeded = $null

            try {
                $start     = Get-Date
                $tcpclient = New-Object System.Net.Sockets.TcpClient
                $connect   = $TcpClient.BeginConnect($TargetName,$TcpPort,$null,$null)
                $patience  = $connect.AsyncWaitHandle.WaitOne($Timeout,$false) 
                if(!($patience)){
                    $tcpsucceeded = $false
                }
                else{
                    $tcpsucceeded = $tcpclient.Connected
                    $tcpclient.EndConnect($connect)
                }
                $tcpclient.Close()
                $tcpclient.Dispose()
                $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    TargetName    = $TargetName
                    TcpPort       = $TcpPort
                    TcpSucceeded  = $tcpsucceeded
                    Duration      = "$($duration)ms"
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
        
            } catch {
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
        return $resultset    
    }

    [object]static uping([String] $TargetName, [int] $UdpPort, [int] $Timeout) {

        $function  = 'uping()'
        $resultset = @()

        if(([String]::IsNullOrEmpty($TargetName))){
            Write-Warning "$($function): Empty TargetName specified!"
        }
        else{
            $udpclient      = $null
            $connect        = $null
            $patience       = $null
            $udpsucceeded   = $null
            $dgram          = $null
            $byte           = $null
            $remoteendpoint = $null
            $receivebytes   = $null

            try {
                $start     = Get-Date
                $udpclient = New-Object System.Net.Sockets.UdpClient
                $connect   = $udpclient.Connect($TargetName,$UdpPort)
                $patience  = $udpclient.Client.ReceiveTimeout = $Timeout
                
                $dgram = new-object system.text.asciiencoding
                $byte  = $dgram.GetBytes("TEST")
                [void]$udpclient.Send($byte,$byte.length)
                $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)
            
                try{
                    $receivebytes = $udpclient.Receive([ref]$remoteendpoint) 
                }
                catch{
                    $udpsucceeded = $false
                    $error.Clear()
                }
            
                if (-not([String]::IsNullOrEmpty($receivebytes))) {
                    [string]$returndata = $dgram.GetString($receivebytes)
                    $udpsucceeded = $true
                } 
            
                $udpclient.Close()
                $udpclient.Dispose()
                $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    TargetName    = $TargetName
                    UdpPort       = $UdpPort
                    UdpSucceeded  = $udpsucceeded
                    Duration      = "$($duration)ms"
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
                    
            } catch {
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
        return $resultset    
    }

    [object]static wping([String]$url,[int]$timeout) {

        $function  = 'wping()'
        $resultset = @()
    
        if(([String]::IsNullOrEmpty($url))){
            Write-Warning "$($function): Empty Url specified!"
        }
        else{
            $webreqest   = $null
            $response    = $null
            $responseuri = $null
            $statuscode  = $null

            try {
                $start     = Get-Date
                $webreqest = [system.Net.HttpWebRequest]::Create($url)
                $webreqest.Timeout = $timeout

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch [Exception]{
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

            } catch {
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
        return $resultset    
    }
    
    [object]static wping([String]$url,[int]$timeout,[bool]$noproxy) {

        $function  = 'wping()'
        $resultset = @()
    
        if(([String]::IsNullOrEmpty($url))){
            Write-Warning "$($function): Empty Url specified!"
        }
        else{
            $webreqest   = $null
            $response    = $null
            $responseuri = $null
            $statuscode  = $null

            try {
                $start     = Get-Date
                $webreqest = [system.Net.HttpWebRequest]::Create($url)
                $webreqest.Timeout = $timeout
                if($noproxy){
                    $webreqest.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
                }

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch {
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

            } catch {
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
        return $resultset    
    }

    [object]static ftpping([String]$uri,[int]$timeout,[PSCredential]$creds) {

        #https://www.opentechguides.com/how-to/article/powershell/154/directory-listing.html

        $function  = 'ftpping()'
        $resultset = @()
    
        if(([String]::IsNullOrEmpty($uri))){
            Write-Warning "$($function): Empty Uri specified!"
        }
        else{
            $ftprequest  = $null
            $response    = $null
            $responseuri = $null
            $statuscode  = $null

            try {
                $start      = Get-Date
                $ftprequest = [System.Net.FtpWebRequest]::Create($uri)
                $ftprequest.Credentials = New-Object System.Net.NetworkCredential($creds.UserName, $creds.Password)
                $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
                $ftprequest.Timeout = $timeout

                try{
                    $response    = $ftprequest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Uri
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch {
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
                    $Error.Clear()
                }

            } catch {
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
        return $resultset
    }
    #endregion
}

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
    #endregion
}

function Get-PsNetAdapterConfiguration{
   <#

   .SYNOPSIS
      Get-PsNetAdapterConfiguration - List network adapter configuraion

   .DESCRIPTION
      List network adapter configuraion for all adapters

   .NOTES
      Author: Martin Walther

   .EXAMPLE
      Get-PsNetAdapterConfiguration

   #>

   [CmdletBinding()]
   param()   
   begin {
   }

   process {
       return [PsNetAdapter]::GetNetadapterConfiguration()
   }

   end {
   }

}

function Get-PsNetAdapters{

    <#

    .SYNOPSIS
       Get-PsNetAdapters - List network adapters

    .DESCRIPTION
       List all network adapters

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetAdapters

    #>

    [CmdletBinding()]
    param()  
      
    begin {
    }
    
    process {
        return [PsNetAdapter]::GetNetadapters()
    }
    
    end {
    }

}
function Get-PsNetHostsTable {

    <#

    .SYNOPSIS
       Get-PsNetHostsTable - Get hostsfile

    .DESCRIPTION
       Format the hostsfile to an object

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetHostsTable

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Path
    )

    begin {
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

function Get-PsNetRoutingTable {

    <#

    .SYNOPSIS
       Get-PsNetRoutingTable - Get Routing Table

    .DESCRIPTION
       Format the Routing Table to an object

    .PARAMETER IpVersion
       IPv4 or IPv6

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetRoutingTable

    #>

    [CmdletBinding()]
    param(
        [ValidateSet('IPv4','IPv6')]        
        [Parameter(Mandatory=$true)]
        [String] $IpVersion
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
        return [PsNetRoutingTable]::GetNetRoutingTable($CurrentOS, $IpVersion)
    }
    
    end {
    }
}
function Test-PsNetDig{

    <#

    .SYNOPSIS
       Test-PsNetDig - PowerShell domain information groper

    .DESCRIPTION
       Resolves a hostname or an ip address

    .PARAMETER Destination
       Name or IP Address to resolve

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
       'sbb.ch','ubs.ch' | Test-PsNetDig

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String] $Destination
    ) 
       
    begin {
    }
    
    process {
        return [PsNetDig]::dig($Destination)
    }
    
    end {
    }

}
function Test-PsNetTping{

    <#

    .SYNOPSIS
       Test-PsNetUping - Test Tcp connectivity

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
       Name or IP Address to test

    .PARAMETER TcpPort
       Tcp Port to test

    .PARAMETER Timeout
       Max. Timeout in ms

    .NOTES
       Author: Martin Walther

    .EXAMPLE
       Test-PsNetTping -Destination sbb.ch -TcpPort 443 -Timeout 100

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $Destination,

        [Parameter(Mandatory=$true)]
        [Int] $TcpPort,

        [Parameter(Mandatory=$true)]
        [Int] $Timeout
    )    
    begin {
    }

    process {
        return [PsNetPing]::tping($Destination, $TcpPort, $Timeout)
    }

    end {
    }
}
function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping - Test Udp connectivity

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       Name or IP Address to test

    .PARAMETER UdpPort
       Udp Port to test

    .PARAMETER Timeout
       Max. Timeout in ms

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch -UdpPort 53 -Timeout 100

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
         [Parameter(Mandatory=$true)]
         [Int] $Timeout
    )    
    begin {
    }

    process {
        return [PsNetPing]::uping($Destination, $UdpPort, $Timeout)
    }

    end {
    }

}
function Test-PsNetWping{

    <#

    .SYNOPSIS
       Test-PsNetWping - Test web request

    .DESCRIPTION
       Test web request to an Url

    .PARAMETER Destination
       Url to test

    .PARAMETER Timeout
       Max. Timeout in ms

    .PARAMETER NoProxy
       Test web request without a proxy

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000

    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $Timeout,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
    }

    process {
        if($NoProxy) {
            return [PsNetPing]::wping($Destination, $Timeout, $true)
        }
        else{
            return [PsNetPing]::wping($Destination, $Timeout)
        }
    }

    end {
    }

}
#endregion
