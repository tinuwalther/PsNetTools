<#
    Generated at 02/19/2019 20:07:40 by Martin Walther
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
    [object]static tping([String] $TargetName, [int] $TcpPort, [int] $mintimeout, [int] $maxtimeout) {

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
                Start-Sleep -Milliseconds (20 + $mintimeout)
                $patience  = $connect.AsyncWaitHandle.WaitOne($maxtimeout,$false) 
                if(!($patience)){
                    $tcpsucceeded = $false
                }
                else{
                    $tcpsucceeded = $tcpclient.Connected
                    if($tcpsucceeded){
                        $tcpclient.EndConnect($connect)
                    }
                }
                $tcpclient.Close()
                $tcpclient.Dispose()
                $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
                
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    TargetName    = $TargetName
                    TcpPort       = $TcpPort
                    TcpSucceeded  = $tcpsucceeded

                    Duration      = "$($duration)ms"
                    MinTimeout    = "$($mintimeout)ms"
                    MaxTimeout    = "$($maxtimeout)ms"
                }
                $resultset += $obj
        
            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $TargetName
                    TcpPort       = $TcpPort
                    TcpSucceeded  = $false

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
        return $resultset    
    }

    [object]static uping([String] $TargetName, [int] $UdpPort, [int] $mintimeout, [int] $maxtimeout) {

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
                $patience  = $udpclient.Client.ReceiveTimeout = $maxtimeout
                
                $dgram = new-object system.text.asciiencoding
                $byte  = $dgram.GetBytes("TEST")
                [void]$udpclient.Send($byte,$byte.length)
                $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)
                Start-Sleep -Milliseconds (20 + $mintimeout)

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
                $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
                
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    TargetName    = $TargetName
                    UdpPort       = $UdpPort
                    UdpSucceeded  = $udpsucceeded

                    Duration      = "$($duration)ms"
                    MinTimeout    = "$($mintimeout)ms"
                    MaxTimeout    = "$($maxtimeout)ms"
                }
                $resultset += $obj
                    
            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $TargetName
                    UdpPort       = $UdpPort
                    UdpSucceeded  = $false

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
        return $resultset    
    }

    [object]static wping([String]$url, [int] $mintimeout, [int] $maxtimeout) {

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
                $webreqest.Timeout = $maxtimeout
                Start-Sleep -Milliseconds (20 + $mintimeout)

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode

                        Duration      = "$($duration)ms"
                        MinTimeout    = "$($mintimeout)ms"
                        MaxTimeout    = "$($maxtimeout)ms"
                    }
                    $resultset += $obj

                } catch [Exception]{
                    $obj = [PSCustomObject]@{
                        Succeeded     = $false
                        TargetName    = $Url
                        StatusCode    = $false

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

            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $Url
                    StatusCode    = $false

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
        return $resultset    
    }
    
    [object]static wping([String]$url, [int] $mintimeout, [int] $maxtimeout,[bool]$noproxy) {

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
                $webreqest.Timeout = $maxtimeout
                if($noproxy){
                    $webreqest.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
                }
                Start-Sleep -Milliseconds (20 + $mintimeout)

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode

                        Duration      = "$($duration)ms"
                        MinTimeout    = "$($mintimeout)ms"
                        MaxTimeout    = "$($maxtimeout)ms"
                    }
                    $resultset += $obj

                } catch {
                    $obj = [PSCustomObject]@{
                        Succeeded     = $false
                        TargetName    = $Url
                        StatusCode    = $false

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

            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $Url
                    StatusCode    = $false

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
                        Succeeded     = $false
                        TargetName    = $Uri
                        StatusCode    = $false

                        Function           = $function
                        Message            = $($_.Exception.Message)
                        Category           = $($_.CategoryInfo).Category
                        Exception          = $($_.Exception.GetType().FullName)
                        CategoryActivity   = $($_.CategoryInfo).Activity
                        CategoryTargetName = $($_.CategoryInfo).TargetName
                    }
                    $resultset += $obj
                    $Error.Clear()
                }

            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $Uri
                    StatusCode    = $false

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

function Add-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Add-PsNetHostsEntry

    .DESCRIPTION
       Add an entry in the hosts-file

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .PARAMETER IPAddress
       IP Address to add

    .PARAMETER Hostname
       Hostname to add

    .PARAMETER FullyQualifiedName
       FullyQualifiedName to add
 
    .EXAMPLE
       Add-PsNetHostsEntry -IPAddress 127.0.0.1 -Hostname tinu -FullyQualifiedName tinu.walther.ch

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$IPAddress,

        [Parameter(Mandatory = $true)]
        [String]$Hostname,

        [Parameter(Mandatory = $true)]
        [String]$FullyQualifiedName
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
        return [PsNetHostsTable]::AddPsNetHostEntry($CurrentOS, $Path, $IPAddress, $Hostname, $FullyQualifiedName)
    }
    
    end {
    }
}

function Get-PsNetAdapterConfiguration{
   <#

   .SYNOPSIS
      Get-PsNetAdapterConfiguration

   .DESCRIPTION
      List network adapter configuraion for all adapters

   .PARAMETER

   .EXAMPLE
      Get-PsNetAdapterConfiguration

    .NOTES
      Author: Martin Walther

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
       Get-PsNetAdapters

    .DESCRIPTION
       List all network adapters

    .PARAMETER
 
    .EXAMPLE
       Get-PsNetAdapters

    .NOTES
       Author: Martin Walther

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
       Get-PsNetHostsTable

    .DESCRIPTION
       Format the hostsfile to an object

    .PARAMETER Path
       Path to the hostsfile, can be empty
 
    .EXAMPLE
       Get-PsNetHostsTable -Path "$($env:windir)\system32\drivers\etc\hosts"

    .NOTES
       Author: Martin Walther

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
       Get-PsNetRoutingTable

    .DESCRIPTION
       Format the Routing Table to an object

    .PARAMETER IpVersion
       IPv4 or IPv6
 
    .EXAMPLE
       Get-PsNetRoutingTable -IpVersion IPv4

    .NOTES
       Author: Martin Walther

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
function Remove-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Remove-PsNetHostsEntry

    .DESCRIPTION
       Remove an entry in the hosts-file

    .PARAMETER Path
       Path to the hostsfile, can be empty

    .PARAMETER IPAddress
       IP Address to remove
 
    .EXAMPLE
       Remove-PsNetHostsEntry -IPAddress 127.0.0.1

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$IPAddress
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
        return [PsNetHostsTable]::RemovePsNetHostEntry($CurrentOS, $Path, $IPAddress)
    }
    
    end {
    }
}

function Test-PsNetDig{

    <#

    .SYNOPSIS
       Test-PsNetDig

    .DESCRIPTION
       Resolves a hostname or an ip address

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to resolve
 
    .EXAMPLE
       Test-PsNetDig -Destination sbb.ch, ubs.com

    .EXAMPLE
       'sbb.ch','ubs.ch' | Test-PsNetDig

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [String[]] $Destination
    ) 
       
    begin {
      $resultset = @()
   }
    
    process {
      foreach($item in $Destination){
         $resultset += [PsNetDig]::dig($item)
      }
    }
    
    end {
      return $resultset
    }

}
function Test-PsNetTping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to test

    .PARAMETER TcpPort
       Tcp Port to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000

    .EXAMPLE
       Test-PsNetTping -Destination sbb.ch, ubs.com -TcpPort 80 -MaxTimeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String[]] $Destination,

        [Parameter(Mandatory=$true)]
        [Int] $TcpPort,

        [Parameter(Mandatory=$false)]
        [Int] $MinTimeout = 0,

        [Parameter(Mandatory=$false)]
        [Int] $MaxTimeout = 1000
   )    
    begin {
       $resultset = @()
    }

    process {
       foreach($item in $Destination){
         $resultset += [PsNetPing]::tping($item, $TcpPort, $MinTimeout, $MaxTimeout)
      }
    }

    end {
      return $resultset
   }
}
function Test-PsNetUping{

    <#

    .SYNOPSIS
       Test-PsNetUping

    .DESCRIPTION
       Test connectivity to an endpoint over the specified Udp port

    .PARAMETER Destination
       A String or an Array of Strings with Names or IP Addresses to test

    .PARAMETER UdpPort
       Udp Port to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000
 
    .EXAMPLE
       Test-PsNetUping -Destination sbb.ch, ubs.com -UdpPort 53 -MaxTimeout 100

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String[]] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000
    )    
    begin {
      $resultset = @()
   }

    process {
      foreach($item in $Destination){
         $resultset += [PsNetPing]::uping($item, $UdpPort, $MinTimeout, $MaxTimeout)
      }
    }

    end {
      return $resultset
    }

}
function Test-PsNetWping{

    <#

    .SYNOPSIS
       Test-PsNetWping

    .DESCRIPTION
       Test web request to an Url

    .PARAMETER Destination
       A String or an Array of Strings with Url's to test

    .PARAMETER MinTimeout
       Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
       Max. Timeout in ms, default is 1000

    .PARAMETER NoProxy
      Test web request without a proxy
 
    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch', 'https://ubs.com' -MaxTimeout 1000

    .EXAMPLE
       Test-PsNetWping -Destination 'https://sbb.ch', 'https://ubs.com' -MaxTimeout 1000 -NoProxy

    .NOTES
       Author: Martin Walther

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String[]] $Destination,

         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
      $resultset = @()
    }

    process {
      if($NoProxy) {
         foreach($item in $Destination){
            if($item -notmatch '^http'){
               $item = "http://$($item)"
            }
            $resultset += [PsNetPing]::wping($item, $MinTimeout, $MaxTimeout, $true)
         }
      }
      else{
         foreach($item in $Destination){
            if($item -notmatch '^http'){
               $item = "http://$($item)"
            }
            $resultset += [PsNetPing]::wping($item, $MinTimeout, $MaxTimeout)
         }
      }
    }

    end {
      return $resultset
    }

}
#endregion
