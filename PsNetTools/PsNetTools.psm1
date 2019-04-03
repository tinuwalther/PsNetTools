<#
    Generated at 03/29/2019 08:27:31 by Martin Walther
    using module ..\PsNetTools\PsNetTools.psm1
#>
#region namespace PsNetTools
Class PsNetError {

    [bool]   $Succeeded = $false
    [String] $Function
    [String] $FullyQualifiedErrorId
    [String] $ErrorMessage
    [String] $ErrorCategory
    [String] $CategoryActivity
    [String] $CategoryTargetName
    [String] $ExceptionFullName

    PsNetError([String] $Function, [Object]$ErrorObject){
        $this.Function              = $Function
        $this.FullyQualifiedErrorId = $ErrorObject.FullyQualifiedErrorId
        $this.ErrorMessage          = $ErrorObject.Exception.Message
        $this.ErrorCategory         = $ErrorObject.CategoryInfo.Category
        $this.CategoryActivity      = $ErrorObject.CategoryInfo.Activity
        $this.CategoryTargetName    = $ErrorObject.CategoryInfo.TargetName
        $this.ExceptionFullName     = $ErrorObject.Exception.GetType().FullName
    }

}

Class PsNetDigType {

    [bool]   $Succeeded
    [String] $InputString
    [String] $Destination
    [Array]  $IpV4Address
    [Array]  $IpV6Address
    [int]    $TimeMs

    PsNetDigType(
        [bool]   $Succeeded, 
        [String] $InputString, 
        [String] $Destination, 
        [Array]  $IpV4Address, 
        [Array]  $IpV6Address, 
        [int]    $TimeMs
    ) {
        $this.Succeeded   = $Succeeded
        $this.InputString = $InputString
        $this.Destination = $Destination
        $this.IpV4Address = $IpV4Address
        $this.IpV6Address = $IpV6Address
        $this.TimeMs      = $TimeMs
    }
    #endregion

}

Class PsNetDig {

    <#
        [PsNetDig]::dig('sbb.ch')
        [PsNetDig]::dig('google.com')
        [PsNetDig]::dig('8.8.8.8')
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetDig(){
        
    }
    #endregion
    
    #region methods
    [PsNetDigType]static dig() {
        return [PsNetDigType]::New()
    }

    [PsNetDigType]static dig([String] $InputString) {
        
        [bool]     $IsIpAddress = $false
        [DateTime] $start       = Get-Date
        [Array]    $dnsreturn   = $null
        [Array]    $collection  = $null
        [Array]    $ipv4address = $null
        [Array]    $ipv6address = $null
        [String]   $TargetName  = $null

        try {
            $InputString = [ipaddress]$InputString
            $IsIpAddress = $true
        }
        catch {
            $Error.Clear()
        }

        # InputType is IPv4Address
        if($IsIpAddress){
            $dnsreturn = [System.Net.Dns]::GetHostByAddress($InputString)
            if(-not([String]::IsNullOrEmpty($dnsreturn))){
                $TargetName = $dnsreturn.hostname
                $collection = $dnsreturn.AddressList
            }
        }

        # InputType is Hostname
        else{
            $dnsreturn = [System.Net.Dns]::GetHostAddressesAsync($InputString).GetAwaiter().GetResult()
            if(-not([String]::IsNullOrEmpty($dnsreturn))){
                $TargetName = [System.Net.Dns]::GetHostByName($InputString).Hostname
                $collection = $dnsreturn
            }
        }

        foreach($item in $collection){
            if($($item.AddressFamily) -eq 'InterNetwork'){
                $ipv4address += $item.IPAddressToString
            }
            if($($item.AddressFamily) -eq 'InterNetworkV6'){
                $ipv6address += $item.IPAddressToString
            }
        }

        $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
        return [PsNetDigType]::New($true, $InputString, $TargetName, $ipv4address, $ipv6address, $duration)
    }
    #endregion

}

Class PsNetPingType {

    hidden [bool]   $Succeeded
    [String] $Destination
    [String] $StatusDescription
    [int]    $MinTimeout
    [int]    $MaxTimeout
    [int]    $TimeMs

}

Class PsNetIcmpPingType : PsNetPingType {

    #$true, $IcmpSucceeded, $Destination, $IPAddress, $Roundtrip, $bytes, $buffer, $StatusMsg, $timeout, $timeout

    [bool]$IcmpSucceeded
    [string]$IPAddress
    [int] $BytesSend
    [int] $BytesReceived

    PsNetIcmpPingType(
        [bool]   $Succeeded, 
        [bool]   $IcmpSucceeded, 
        [String] $Destination, 
        [string] $IPAddress,
        [int]    $TimeMs,  
        [int]    $BytesSend,
        [int]    $BytesReceived, 
        [String] $StatusDescription,
        [int]    $MaxTimeout,
        [int]    $MinTimeout
    ){
        $this.Succeeded         = $Succeeded
        $this.IcmpSucceeded     = $IcmpSucceeded
        $this.Destination       = $Destination
        $this.IPAddress         = $IPAddress
        $this.MinTimeout        = $MinTimeout
        $this.MaxTimeout        = $MaxTimeout
        $this.TimeMs            = $TimeMs
        $this.BytesSend         = $BytesSend
        $this.BytesReceived     = $BytesReceived
        $this.StatusDescription = $StatusDescription
    }
}

Class PsNetTpingType : PsNetPingType {

    [bool]   $TcpSucceeded
    [int]    $TcpPort

    PsNetTpingType(
        [bool] $Succeeded, 
        [bool] $TcpSucceeded, 
        [String] $Destination, 
        [String] $StatusDescription, 
        [int] $Port, 
        [int] $MinTimeout, 
        [int] $MaxTimeout, 
        [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.Destination       = $Destination
        $this.TcpSucceeded      = $TcpSucceeded
        $this.TcpPort           = $Port
        $this.MinTimeout        = $MinTimeout
        $this.MaxTimeout        = $MaxTimeout
        if($TimeMs -gt $MaxTimeout){
            $this.TimeMs = $MaxTimeout
        }
        else{
            $this.TimeMs = $TimeMs
        }
        $this.StatusDescription = $StatusDescription
    }
}

Class PsNetUpingType : PsNetPingType {

    [bool]   $UdpSucceeded
    [int]    $UdpPort

    PsNetUpingType(
        [bool] $Succeeded, 
        [bool] $UdpSucceeded, 
        [String] $Destination, 
        [String] $StatusDescription, 
        [int] $Port, 
        [int] $MinTimeout, 
        [int] $MaxTimeout, 
        [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.Destination       = $Destination
        $this.UdpSucceeded      = $UdpSucceeded
        $this.UdpPort           = $Port
        $this.MinTimeout        = $MinTimeout
        $this.MaxTimeout        = $MaxTimeout
        if($TimeMs -gt $MaxTimeout){
            $this.TimeMs = $MaxTimeout
        }
        else{
            $this.TimeMs = $TimeMs
        }
        $this.StatusDescription = $StatusDescription
    }
}

Class PsNetWebType : PsNetPingType {

    hidden [bool]   $Succeeded
    [bool]   $HttpSucceeded
    [String] $ResponsedUrl
    [bool]   $NoProxy

    PsNetWebType(
        [bool] $Succeeded, 
        [bool] $HttpSucceeded, 
        [String] $Destination, 
        [String] $Url, 
        [String] $StatusDescription, 
        [bool] $Proxy, 
        [int] $MinTimeout, 
        [int] $MaxTimeout, 
        [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.HttpSucceeded     = $HttpSucceeded
        $this.Destination       = $Destination
        $this.ResponsedUrl      = $Url
        $this.StatusDescription = $StatusDescription
        $this.NoProxy           = $Proxy
        $this.MinTimeout        = $MinTimeout
        $this.MaxTimeout        = $MaxTimeout
        if($TimeMs -gt $MaxTimeout){
            $this.TimeMs = $MaxTimeout
        }
        else{
            $this.TimeMs = $TimeMs
        }
    }
}

Class PsNetPing {

    <#
        [PsNetPing]::ping('sbb.ch')
        [PsNetPing]::tping('sbb.ch', 80, 100)
        [PsNetPing]::uping('sbb.ch', 53, 100)
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
    [PsNetIcmpPingType]static ping([String]$destination) {

        $function   = 'ping()'
    
        [object]$reply     = $null
        [int]$Roundtrip    = $null
        [int]$bytes        = 0
        [int]$buffer       = $null
        [string]$IPAddress = 'could not find host'
        [string]$StatusMsg = $null
        [int]$timeout      = 1000
        [bool]$IcmpSucceeded = $false
        
        $pingsender  = [System.Net.NetworkInformation.Ping]::new()
        $datagram    = new-object System.Text.ASCIIEncoding
        # Create a buffer of 32 bytes of data to be transmitted
        [byte[]] $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        
        try{
            $pingoptions = [System.Net.NetworkInformation.PingOptions]::new(64, $true)  
            $reply       = $pingsender.Send($destination, $timeout, $buffersize, $pingoptions)
            $Roundtrip   = $reply.RoundtripTime
            $buffer      = $reply.Buffer.Length
            $bytes       = $buffersize.Length
        }
        catch{
            $error.Clear()
        }
    
        try{
            if(-not([String]::IsNullOrEmpty($reply.Address))){
                $IPAddress = $reply.Address
            }
            else{
            }
        }
        catch{
            $error.clear()
        }
    
        switch($reply.Status){
            'TtlExpired' {$StatusMsg = "ICMP $($reply.Status.ToString())"}
            'TimedOut'   {$StatusMsg = "ICMP $($reply.Status.ToString())"}
            'Success'    {$IcmpSucceeded = $true; $StatusMsg = "ICMP $($reply.Status.ToString())"}
            default      {$StatusMsg = "Please check the name and try again"}
        }
        
        return [PsNetIcmpPingType]::New($true, $IcmpSucceeded, $Destination, $IPAddress, $Roundtrip, $bytes, $buffer, $StatusMsg, $timeout, 0)
    }

    [void]static ping([String]$destination,[bool]$show) {

        $function   = 'ping()'
    
        [object]$reply     = $null
        [int]$Roundtrip    = $null
        [int]$bytes        = 0
        [int]$buffer       = $null
        [string]$IPAddress = 'could not find host'
        [string]$StatusMsg = $null
        [int]$timeout      = 1000
        
        $pingsender  = [System.Net.NetworkInformation.Ping]::new()
        $datagram    = new-object System.Text.ASCIIEncoding
        # Create a buffer of 32 bytes of data to be transmitted
        [byte[]] $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        
        try{
            $pingoptions = [System.Net.NetworkInformation.PingOptions]::new(64, $true)  
            $reply       = $pingsender.Send($destination, $timeout, $buffersize, $pingoptions)
            $Roundtrip   = $reply.RoundtripTime
            $buffer      = $reply.Buffer.Length
            $bytes       = $buffersize.Length
        }
        catch{
            $error.Clear()
        }
    
        try{
            if(-not([String]::IsNullOrEmpty($reply.Address))){
                $IPAddress = $reply.Address
            }
            else{
            }
        }
        catch{
            $error.clear()
        }
    
        switch($reply.Status){
            'TtlExpired' {$StatusMsg = "ICMP $($reply.Status.ToString())"}
            'TimedOut'   {$StatusMsg = "ICMP $($reply.Status.ToString())"}
            'Success'    {$StatusMsg = "ICMP $($reply.Status.ToString())"}
            default      {$StatusMsg = "Please check the name and try again"}
        }

        Write-Host "ICMP ping $Destination, IPAddress: $IPAddress, time: $Roundtrip, send: $bytes, received: $buffer, $StatusMsg"
    }

    [PsNetTpingType] static tping([String] $TargetName, [int] $TcpPort, [int] $mintimeout, [int] $maxtimeout) {

        [DateTime] $start        = Get-Date
        [bool]     $tcpsucceeded = $false
        [String]   $description  = $null
        [bool]     $WaitOne      = $false
        [Object]   $tcpclient    = $null
        [Object]   $connect      = $null
        
        $tcpclient = New-Object System.Net.Sockets.TcpClient
        $connect   = $TcpClient.BeginConnect($TargetName,$TcpPort,$null,$null)
        Start-Sleep -Milliseconds (20 + $mintimeout)
        $WaitOne  = $connect.AsyncWaitHandle.WaitOne($maxtimeout,$false) 
        if($WaitOne){
            try{
                $tcpsucceeded = $tcpclient.Connected
                if($tcpsucceeded){
                    $tcpclient.EndConnect($connect)
                    $description  = 'TCP Test success'
                }
                else{
                    $description  = 'TCP Test failed'
                }
            }
            catch{
                $description = $_.Exception.Message
                $error.Clear()
            }
        }
        $tcpclient.Close()
        $tcpclient.Dispose()

        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetTpingType]::New($true, $tcpsucceeded, $TargetName, $description, $TcpPort, $mintimeout, $maxtimeout, $duration)
    }

    [PsNetUpingType] static uping([String] $TargetName, [int] $UdpPort, [int] $mintimeout, [int] $maxtimeout) {

        [DateTime] $start        = Get-Date
        [bool]     $udpsucceeded = $false
        [String]   $description  = $null
        [Object]   $udpclient    = $null
        [Object]   $connect      = $null
        [bool]     $WaitOne      = $false
        [string]   $returndata   = $null

        $receivebytes   = $null

        $udpclient = New-Object System.Net.Sockets.UdpClient
        try{
            $connect   = $udpclient.Connect($TargetName,$UdpPort)
            $WaitOne   = $udpclient.Client.ReceiveTimeout = $maxtimeout
            
            $dgram = new-object system.text.asciiencoding
            $byte  = $dgram.GetBytes("TEST")
            [void]$udpclient.Send($byte,$byte.length)
            $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)
            Start-Sleep -Milliseconds (20 + $mintimeout)

            try{
                $receivebytes = $udpclient.Receive([ref]$remoteendpoint) 
                $description  = 'UDP Test success'
            }
            catch{
                $description = ($_.Exception.Message -split ': ')[1]
                $error.Clear()
            }
        
            if (-not([String]::IsNullOrEmpty($receivebytes))) {
                $returndata   = $dgram.GetString($receivebytes)
                $udpsucceeded = $true
            } 
        
        }
        catch{
            $description = ($_.Exception.Message -split ': ')[1]
            $error.Clear()
        }

        $udpclient.Close()
        $udpclient.Dispose()

        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetUpingType]::New($true, $udpsucceeded, $TargetName, $description, $UdpPort, $mintimeout, $maxtimeout, $duration)
    }

    #endregion
}

Class PsNetWeb {

    <#
        [PsNetWeb]::wping('https://sbb.ch', 1000, $true) 
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetWeb(){
        $this.Message = "Loading PsNetWeb"
    }
    #endregion
    
    #region methods
    [PsNetWebType] static wping([String]$url, [int] $mintimeout, [int] $maxtimeout) {
    
        [DateTime] $start     = Get-Date
        [bool]     $webreturn = $false
        [String]   $description = $null
        [Object]   $responseuri = $null

        $webreqest = [system.Net.HttpWebRequest]::Create($url)
        $webreqest.Timeout = $maxtimeout
        Start-Sleep -Milliseconds (20 + $mintimeout)

        try{
            $response    = $webreqest.GetResponse()
            $responseuri = $response.ResponseUri
            $statuscode  = $response.StatusCode
            $description = $response.StatusDescription
            if($statuscode -eq 'OK'){
                $webreturn = $true
            }
            $response.Close()
        }
        catch {
            $description = ($_.Exception.Message -split ': ')[1]
            $error.Clear()
        }
        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetWebType]::New($true, $webreturn, $Url, $responseuri, $description, $false, $mintimeout, $maxtimeout, $duration)
            
    }
    
    [PsNetWebType] static wping([String]$url, [int] $mintimeout, [int] $maxtimeout,[bool]$noproxy) {
    
        [DateTime] $start       = Get-Date
        [bool]     $webreturn   = $false
        [String]   $description = $null
        [Object]   $responseuri = $null

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
            $description = $response.StatusDescription
            $response.Close()
            if($statuscode -eq 'OK'){
                $webreturn = $true
            }
            $response.Close()
        }
        catch {
            $description = ($_.Exception.Message -split ': ')[1]
            $error.Clear()
        }
        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetWebType]::New($true, $webreturn, $Url, $responseuri, $description, $true, $mintimeout, $maxtimeout, $duration)   

    }

    [PsNetWebType] static ftpping([String]$uri,[int]$timeout,[PSCredential]$creds) {

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

Class PsNetAdapterType {

    [bool]   $Succeeded
    [int]    $Index
    hidden [Object] $adapter
    hidden [Object] $IpV4properties
    [String] $Name
    [String] $Description
    [String] $NetworkInterfaceType
    [String] $OperationalStatus
    [String] $PhysicalAddres
    [String] $IpVersion
    [bool]   $IsAPIPAEnabled
    [Object] $IpV4Addresses
    [Object] $IpV6Addresses

    PsNetAdapterType (
        [bool]   $Succeeded,
        [Object] $IpV4properties,
        [Object] $adapter,
        [String] $IpVersion,
        [Object] $IpV4Addresses,
        [Object] $IpV6Addresses
    ) {
        $this.Succeeded            = $Succeeded
        $this.Index                = $IpV4properties.Index
        $this.Name                 = $adapter.Name
        $this.Description          = $adapter.Description
        $this.NetworkInterfaceType = $adapter.NetworkInterfaceType
        $this.OperationalStatus    = $adapter.OperationalStatus
        $this.PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
        $this.IpVersion            = $IpVersion
        $this.IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
        $this.IpV4Addresses        = $IpV4Addresses
        $this.IpV6Addresses        = $IpV6Addresses
    }

}

Class PsNetAdapterConfigType : PsNetAdapterType {

    [Object] $Id
    [Single] $Speed
    [bool]   $IsReceiveOnly
    [bool]   $SupportsMulticast

    [bool]   $IsDnsEnabled
    [bool]   $IsDynamicDnsEnabled
    [Object] $DnsSuffix
    [Object] $DnsAddresses
    [Object] $DhcpServerAddresses
    [Object] $WinsServersAddresses

    [String] $Mtu
    [bool]   $IsForwardingEnabled
    [bool]   $IsAPIPAActive
    [bool]   $IsDhcpEnabled
    [bool]   $UsesWins

    [Object] $GatewayIpV4Addresses
    [Object] $GatewayIpV6Addresses

    <#

    #Succeeded            = $true
    #Name                 = $adapter.Name
    #Description          = $adapter.Description
    #NetworkInterfaceType = $adapter.NetworkInterfaceType
    #OperationalStatus    = $adapter.OperationalStatus
    #PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
    #IpVersion            = $IpVersion
    #IpV4Addresses        = $IpV4Addresses
    #IpV6Addresses        = $IpV6Addresses
    #IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive

    Id                   = $adapter.Id
    Speed                = $adapter.Speed
    IsReceiveOnly        = $adapter.IsReceiveOnly
    SupportsMulticast    = $adapter.SupportsMulticast

    IsDnsEnabled         = $properties.IsDnsEnabled
    IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
    DnsSuffix            = $properties.DnsSuffix
    DnsAddresses         = $properties.DnsAddresses
    DhcpServerAddresses  = $properties.DhcpServerAddresses
    WinsServersAddresses = $properties.WinsServersAddresses

    Index                = $IpV4properties.Index
    Mtu                  = $IpV4properties.Mtu
    IsForwardingEnabled  = $IpV4properties.IsForwardingEnabled
    IsAPIPAActive        = $IpV4properties.IsAutomaticPrivateAddressingEnabled
    IsDhcpEnabled        = $IpV4properties.IsDhcpEnabled
    UsesWins             = $IpV4properties.UsesWins

    GatewayIpV4Addresses = $GatewayIpV4Addresses
    GatewayIpV6Addresses = $GatewayIpV6Addresses
    
    #>

    PsNetAdapterConfigType (
        [Object] $adapter,
        [Object] $properties,
        [Object] $IpV4properties,
        [String] $IpVersion,
        [Object] $IpV4Addresses,
        [Object] $IpV6Addresses,
        [String] $GatewayIpV4Addresses,
        [String] $GatewayIpV6Addresses    
    ) {
        $this.Id                   = $adapter.Id
        $this.Speed                = $adapter.Speed
        $this.IsReceiveOnly        = $adapter.IsReceiveOnly
        $this.SupportsMulticast    = $adapter.SupportsMulticast
    
        $this.IsDnsEnabled         = $properties.IsDnsEnabled
        $this.IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
        $this.DnsSuffix            = $properties.DnsSuffix
        $this.DnsAddresses         = $properties.DnsAddresses
        $this.DhcpServerAddresses  = $properties.DhcpServerAddresses
        $this.WinsServersAddresses = $properties.WinsServersAddresses
    
        $this.Index                = $IpV4properties.Index
        $this.Mtu                  = $IpV4properties.Mtu
        $this.IsForwardingEnabled  = $IpV4properties.IsForwardingEnabled
        $this.IsAPIPAActive        = $IpV4properties.IsAutomaticPrivateAddressingEnabled
        $this.IsDhcpEnabled        = $IpV4properties.IsDhcpEnabled
        $this.UsesWins             = $IpV4properties.UsesWins
    
        $this.GatewayIpV4Addresses = $GatewayIpV4Addresses
        $this.GatewayIpV6Addresses = $GatewayIpV6Addresses
        }
}

Class PsNetAdapter {

    <#
        [PsNetAdapter]::listadapters()
        [PsNetAdapter]::listadapterconfig()
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
    [object] static listadapters(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'listadapters()'
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
                    $resultset += [PsNetAdapterType]::New($true,$IpV4properties,$adapter,$IpVersion,$IpV4Addresses,$IpV6Addresses)
                }
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }  
        return $resultset              
    }

    [object] static listadapterconfig(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'listadapterconfig()'
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
                        Id                   = $adapter.Id
                        Name                 = $adapter.Name
                        Description          = $adapter.Description
                        NetworkInterfaceType = $adapter.NetworkInterfaceType
                        OperationalStatus    = $adapter.OperationalStatus
                        Speed                = $adapter.Speed
                        IsReceiveOnly        = $adapter.IsReceiveOnly
                        SupportsMulticast    = $adapter.SupportsMulticast
                        PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
                        IpVersion            = $IpVersion
                        IpV4Addresses        = $IpV4Addresses
                        IpV6Addresses        = $IpV6Addresses
                        IsDnsEnabled         = $properties.IsDnsEnabled
                        IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
                        DnsSuffix            = $properties.DnsSuffix
                        DnsAddresses         = $properties.DnsAddresses
                        DhcpServerAddresses  = $properties.DhcpServerAddresses
                        WinsServersAddresses = $properties.WinsServersAddresses
                        Index                = $IpV4properties.Index
                        Mtu                  = $IpV4properties.Mtu
                        IsForwardingEnabled  = $IpV4properties.IsForwardingEnabled
                        IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
                        IsAPIPAActive        = $IpV4properties.IsAutomaticPrivateAddressingEnabled
                        IsDhcpEnabled        = $IpV4properties.IsDhcpEnabled
                        UsesWins             = $IpV4properties.UsesWins
                        GatewayIpV4Addresses = $GatewayIpV4Addresses
                        GatewayIpV6Addresses = $GatewayIpV6Addresses
                    }
                    $resultset += $obj
                }
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }                
        return $resultset
    }
    #endregion
}

Class PsNetHostsTableType {

    [bool]   $Succeeded
    [String] $IpVersion
    [String] $IpAddress
    [String] $Compuername
    [String] $FullyQualifiedName
    [String] $Message

    PsNetHostsTableType (
        [bool]   $Succeeded,
        [String] $IpVersion,
        [String] $IpAddress,
        [String] $Compuername,
        [String] $FullyQualifiedName,
        [String] $Message
        ) {
        $this.Succeeded          = $Succeeded
        $this.IpVersion          = $IpVersion
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
                $ipv6pattern = '^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'

                $filecontent = Get-Content -Path $Path
                if($filecontent -match $ipv4pattern){
                    $string = ($filecontent | Select-String -Pattern $ipv4pattern)
                    for ($i = 0; $i -lt $string.Length; $i++){
                        if($string[$i] -notmatch '#'){
                            $line = ($string[$i]) -Split '\s+'
                            $resultset += [PsNetHostsTableType]::New($true,'IPv4',$line[0],$line[1],$line[2],$null)
                        }
                    }
                }
                if($filecontent -match $ipv6pattern){
                    $string = ($filecontent | Select-String -Pattern $ipv6pattern)
                    for ($i = 0; $i -lt $string.Length; $i++){
                        if($string[$i] -notmatch '#'){
                            $line = ($string[$i]) -Split '\s+'
                            $resultset += [PsNetHostsTableType]::New($true,'IPv6',$line[0],$line[1],$line[2],$null)
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
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }                
        return $resultset
    }

    [object] static FormatIPv4RoutingTable([OSType]$CurrentOS,[Object]$routeprint){

        $function   = 'FormatIPv4RoutingTable()'
        $IPv4Table  = @()
        $resultset  = @()

        try{
            
            $ipv4pattern = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'

            if($CurrentOS -eq [OSType]::Linux){

                $IPv4Table = $routeprint -replace 'Kernel IP routing table'

                $IPv4Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[0] -match $ipv4pattern){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true
                                AddressFamily = 'IPv4'
                                Destination   = $string[0]
                                Gateway       = $string[1]
                                Genmask       = $string[2]
                                Flags         = $string[3]
                                MSSWindow     = $string[4]
                                irtt          = $string[5]
                                Iface         = $string[6]
                            }
                            $resultset += $obj
                        }
                    }
                }    

            }
            if($CurrentOS -eq [OSType]::Mac){

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

                $IPv4Table = $routeprint
                
                $IPv4Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[1] -match $ipv4pattern){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true
                                AddressFamily = 'IPv4'
                                Destination   = $string[1]
                                Gateway       = $string[3]
                                Netmask       = $string[2]
                                Interface     = $string[4]
                                Metric        = $string[5]
                            }
                            $resultset += $obj
                        }
                    }
                }
            }
            if([String]::IsNullOrEmpty($resultset)){
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    AddressFamily = 'IPv4'
                    Destination   = {}
                    Gateway       = {}
                    Netmask       = {}
                    Interface     = {}
                    Metric        = {}
                }
                $resultset += $obj
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }                
        return $resultset
    }

    [object] static FormatIPv6RoutingTable([OSType]$CurrentOS,[Object]$routeprint){

        $function   = 'FormatIPv6RoutingTable()'
        $IPv6Table  = @()
        $resultset  = @()

        try{

            $ipv6pattern = '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'

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

                $IPv6Table = $routeprint

                $IPv6Table | ForEach-Object{
                    $string = $_ -split '\s+'
                    if($string){
                        if($string[3] -match $ipv6pattern){
                            $obj = [PSCustomObject]@{
                                Succeeded     = $true 
                                AddressFamily = 'IPv6'
                                Destination   = $string[3]
                                Gateway       = $string[4]
                                Index         = $string[1]
                                Metric        = $string[2]
                            }
                            $resultset += $obj
                        }
                    }
                }
            } 
            if([String]::IsNullOrEmpty($resultset)){
                $obj = [PSCustomObject]@{
                    Succeeded     = $true
                    AddressFamily = 'IPv6'
                    Destination   = {}
                    Gateway       = {}
                    Netmask       = {}
                    Interface     = {}
                    Metric        = {}
                }
                $resultset += $obj
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }                
        return $resultset
    }

    #endregion
}

Class PsNetTracertType {

    hidden [bool] $Succeeded
    [int]         $Hops
    [int]         $Time
    [int]         $RTT
    [int]         $Send
    [int]         $Received
    [String]      $Destination
    [String]      $Hostname
    [String]      $IPAddress
    [String]      $Status
    [String]      $Message

    PsNetTracertType(
        [bool]        $Succeeded,
        [int]         $Hops,
        [int]         $Time,
        [int]         $RTT,
        [int]         $Send,
        [int]         $Received,
        [String]      $Destination,
        [String]      $Hostname,
        [String]      $IPAddress,
        [String]      $Status,
        [String]      $Message
    ) {
        $this.Succeeded   = $Succeeded
        $this.Hops        = $Hops
        $this.Time        = $Time
        $this.RTT         = $RTT
        $this.Send        = $Send
        $this.Received    = $Received
        $this.Destination = $Destination
        $this.Hostname    = $Hostname
        $this.IPAddress   = $IPAddress
        $this.Status      = $Status
        $this.Message     = $Message
    }
}

Class PsNetTracert {

    <#
        https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.ping.send?view=netframework-4.7.2
        If the ICMP echo reply message is not received within the time specified by the timeout parameter, 
        the ICMP echo fails, and the Status property is set to TimedOut. 

        [PsNetTracert]::tracert('www.sbb.ch',1000,15) | ft
        [PsNetTracert]::tracert('www.google.com',1000,15) | ft
        [PsNetTracert]::tracert('8.8.8.8',1000,15) | ft
        [PsNetTracert]::tracert('www.microsoft.com',1000,15) | ft
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetTracert(){
        $this.Message = "Loading PsNetTracert"
    }
    #endregion

    #region methods
    [object]static tracert([String]$destination,[int]$timeout,[int]$hops) {

        $function   = 'tracert()'
        $resultset  = @()

        $reply      = $null
        $duration   = $null
        $Roundtrip  = $null
        $bytes      = $null
        $buffer     = $null
        $IPAddress  = '*'
        $StatusMsg  = $null

        $pingsender  = [System.Net.NetworkInformation.Ping]::new()
        $datagram    = new-object System.Text.ASCIIEncoding
        # Create a buffer of 32 bytes of data to be transmitted
        [byte[]] $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

        for($hop = 1; $hop -le $hops; $hop ++){

            $ExitFlag  = $false
            $dnsreturn = $null
    
            try{
                [DateTime] $start = Get-Date
                $pingoptions = [System.Net.NetworkInformation.PingOptions]::new($hop, $true)  
                $reply       = $pingsender.Send($destination, $timeout, $buffersize, $pingoptions)
                $duration    = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                $Roundtrip   = $reply.RoundtripTime
                $buffer      = $reply.Buffer.Length
                $bytes       = $buffersize.Length
            }
            catch{
                $dnsreturn = 'Get no IP Address'
                $error.Clear()
            }
    
            try{
                if(-not([String]::IsNullOrEmpty($reply.Address))){
                    $IPAddress = $reply.Address
                    $dnsreturn = [System.Net.Dns]::GetHostByAddress($IPAddress).HostName
                }
                else{
                    $dnsreturn = '*'
                }
            }
            catch{
                $dnsreturn = 'Could not resolve'
                $error.clear()
            }
    
            switch($reply.Status){
                'TtlExpired' {
                    # TtlExpired means we've found an address, but there are more addresses
                    $StatusMsg = 'Go to next address'
                }
                'TimedOut'   {
                    # TimedOut means this ttl is no good, we should continue searching
                    $StatusMsg = 'Continue searching'
                }
                'Success'    {
                    # Success means the tracert has completed
                    $StatusMsg = 'Trace route completed'
                    $ExitFlag  = $true
                }
            }

            $resultset += [PsNetTracertType]::new($true,$hop,$duration,$Roundtrip,$bytes,$buffer,$destination,$dnsreturn,$IPAddress,$reply.Status.ToString(),$StatusMsg)

            if($ExitFlag){
                break
                $pingsender.Dispose()
            }
    
        }
        return $resultset
    }

    [void]static tracert([String]$destination,[int]$timeout,[int]$hops,[bool]$show) {

        $function   = 'tracert()'

        $reply      = $null
        $Roundtrip  = $null
        $bytes      = $null
        $buffer     = $null
        $IPAddress  = '*'
        $StatusMsg  = $null

        Write-Host "Trace route $Destination over $hops Hops:`n"
        Write-Host "Hops, RTT, Send, Received, Destination, Hostname, IPAddress, Status, Messages"

        $pingsender  = [System.Net.NetworkInformation.Ping]::new()
        $datagram    = new-object System.Text.ASCIIEncoding
        # Create a buffer of 32 bytes of data to be transmitted
        [byte[]] $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

        for($hop = 1; $hop -le $hops; $hop ++){

            $ExitFlag  = $false
            $dnsreturn = $null
    
            try{
                $pingoptions = [System.Net.NetworkInformation.PingOptions]::new($hop, $true)  
                $reply       = $pingsender.Send($destination, $timeout, $buffersize, $pingoptions)
                $Roundtrip   = $reply.RoundtripTime
                $buffer      = $reply.Buffer.Length
                $bytes       = $buffersize.Length
            }
            catch{
                $dnsreturn = 'Get no IP Address'
                $error.Clear()
            }
    
            try{
                if(-not([String]::IsNullOrEmpty($reply.Address))){
                    $IPAddress = $reply.Address
                    $dnsreturn = [System.Net.Dns]::GetHostByAddress($IPAddress).HostName
                }
                else{
                    $dnsreturn = '*'
                }
            }
            catch{
                $dnsreturn = 'Could not resolve'
                $error.clear()
            }
    
            switch($reply.Status){
                'TtlExpired' {
                    # TtlExpired means we've found an address, but there are more addresses
                    $StatusMsg = 'Go to next address'
                }
                'TimedOut'   {
                    # TimedOut means this ttl is no good, we should continue searching
                    $StatusMsg = 'Continue searching'
                }
                'Success'    {
                    # Success means the tracert has completed
                    $StatusMsg = 'Trace route completed'
                    $ExitFlag  = $true
                }
            }
            Write-Host "$hop, $Roundtrip, $bytes, $buffer, $destination, $dnsreturn, $IPAddress, $($reply.Status.ToString()), $StatusMsg"
            
            if($ExitFlag){
                break
                $pingsender.Dispose()
            }
    
        }
    }
    #endregion
}

function Add-PsNetHostsEntry {

    <#

    .SYNOPSIS
       Add entries to the hosts-file

    .DESCRIPTION
       Running this command with elevated privilege.
       Add any entries to the hosts-file

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

    .INPUTS
       Hashtable

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

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
        return [PsNetHostsTable]::AddPsNetHostsEntry($CurrentOS, $Path, $IPAddress, $Hostname, $FullyQualifiedName)
    }
    
    end {
    }
}

function Get-PsNetAdapterConfiguration{

    <#

    .SYNOPSIS
       Get Network Adapter Configuration

    .DESCRIPTION
       List network adapter configuraion for all adapters

    .EXAMPLE
       Get-PsNetAdapterConfiguration

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

   [CmdletBinding()]
   param()   
   begin {
   }

   process {
       return [PsNetAdapter]::listadapterconfig()
   }

   end {
   }

}

function Get-PsNetAdapters{

    <#

    .SYNOPSIS
       Get Network Adapters

    .DESCRIPTION
       List all network adapters
 
    .EXAMPLE
       Get-PsNetAdapters

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param()  
      
    begin {
    }
    
    process {
        return [PsNetAdapter]::listadapters()
    }
    
    end {
    }

}
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
      Get the Routing Table

    .DESCRIPTION
      Format the Routing Table to an object

    .PARAMETER IpVersion
      IPv4 or IPv6
 
    .EXAMPLE
      Get-PsNetRoutingTable -IpVersion IPv4
    
    .EXAMPLE
      Get-PsNetRoutingTable -IpVersion IPv6

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

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$Hostsentry
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
        return [PsNetHostsTable]::RemovePsNetHostsEntry($CurrentOS, $Path, $Hostsentry)
    }
    
    end {
    }
}

function Start-PsNetPortListener {

    <#

    .SYNOPSIS
       Start a TCP Portlistener

    .DESCRIPTION
       Temporarily listen on a given TCP port for connections dumps connections to the screen

    .PARAMETER TcpPort
       The TCP port that the listener should attach to

    .PARAMETER MaxTimeout
       MaxTimeout in milliseconds to wait, default is 5000

    .EXAMPLE
       Start-PsNetPortListener -TcpPort 443, Listening on TCP port 443, press CTRL+C to cancel

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
        [Parameter(Mandatory = $true)]
        [Int]$TcpPort,

        [Parameter(Mandatory = $false)]
        [Int]$MaxTimeout = 5000
    )

    $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, $TcpPort)    
    $listener = New-Object System.Net.Sockets.TcpListener $endpoint
    
    $listener.server.ReceiveTimeout = $MaxTimeout
    $listener.start()  

    try {
        Write-Host "Listening on TCP port $TcpPort, press CTRL+C to cancel"

        While ($true){
            if (!$listener.Pending()){
                Start-Sleep -Seconds 1
                continue
            }
            $client = $listener.AcceptTcpClient()
            $client.client.RemoteEndPoint | Add-Member -NotePropertyName DateTime -NotePropertyValue (Get-Date) -PassThru
            $client.close()
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
        $obj
        $error.Clear()
    }
    finally{
        $listener.stop()
        Write-host "Listener Closed Safely"
    }
}
function Test-PsNetDig{

    <#

    .SYNOPSIS
      Domain information groper

    .DESCRIPTION
      Resolves a hostname to the IP addresses or an IP Address to the hostname.

    .PARAMETER Destination
      Hostname or IP Address or Alias
 
    .EXAMPLE
      Resolve a hostname to the IP Address
      Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
      Resolve an IP address to the hostname
      Test-PsNetDig -Destination '127.0.0.1','194.150.245.142'

    .EXAMPLE
      Resolve an array of hostnames to the IP Address
      Test-PsNetDig -Destination sbb.ch, google.com

    .EXAMPLE
      Resolve an array of hostnames to the IP Address with ValueFromPipeline
      sbb.ch, google.com | Test-PsNetDig

    .INPUTS
      Hashtable

    .OUTPUTS
      PSCustomObject

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [ValidateLength(4,255)]
        [String[]] $Destination
    ) 
       
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }
    
    process {
        foreach($item in $Destination){
            try{
                $resultset += [PsNetDig]::dig($item)
            }
            catch {
                $resultset += [PsNetError]::New("$($function)($item)", $_)
                $error.Clear()
            }
        }
    }
    
    end {
        return $resultset
    }

}
function Test-PsNetPing{

    <#

    .SYNOPSIS
      Test ICMP echo

    .DESCRIPTION
      Attempts to send an ICMP echo message to a remote computer and receive a corresponding ICMP echo reply message from the remote computer.

    .PARAMETER Destination
      A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER try
      Number of attempts to send ICMP echo message

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch -try 5

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com

    .EXAMPLE
      Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com -try 3

    .INPUTS
      Hashtable

    .OUTPUTS
      String

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateLength(4,255)]
        [String[]] $Destination,

        [Parameter(Mandatory=$false)]
        [Int] $try = 0
    )    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {

		foreach($item in $Destination){
      try{
        if($try -gt 0){
          for ($i = 0; $i -lt $try; $i++){
            [PsNetPing]::ping($item,$true)
            Start-Sleep -Seconds 1
          }
        }
        else{
          $resultset += [PsNetPing]::ping($item)
        }
      }
      catch{
        $resultset += [PsNetError]::New("$($function)($item)", $_)
        $error.Clear()
      }
		}
	}

	end {
		return $resultset
	}
}
function Test-PsNetTping{

    <#

    .SYNOPSIS
      Test the connectivity over a Tcp port

    .DESCRIPTION
      Test connectivity to an endpoint over the specified Tcp port

    .PARAMETER Destination
      A String or an Array of Strings with Names or IP Addresses to test <string>

    .PARAMETER CommonTcpPort
      One of the Tcp ports for SMB, HTTP, HTTPS, WINRM, WINRMS, LDAP, LDAPS

    .PARAMETER TcpPort
      An Integer or an Array of Integers with Tcp Ports to test <int>

    .PARAMETER MinTimeout
      Min. Timeout in ms, default is 0

    .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

    .EXAMPLE
      Test the connectivity to one Destination and one Tcp Port with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch -TcpPort 443 -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to one Destination and one CommonTcpPort with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch -CommonTcpPort HTTPS -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to two Destinations and one Tcp Port with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 100

    .EXAMPLE
      Test the connectivity to two Destinations and two Tcp Ports with a max. timeout of 100ms
      Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80, 443 -MaxTimeout 100 | Format-Table

    .INPUTS
      Hashtable

    .OUTPUTS
      PSCustomObject

    .NOTES
      Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateLength(4,255)]
        [String[]] $Destination,

        [Parameter(ParameterSetName = "CommonTCPPort", Mandatory = $True, Position = 1)]
        [ValidateSet('SMB','HTTP','HTTPS','RDP','WINRM','WINRMS','LDAP','LDAPS')]
        [String] $CommonTcpPort,

        [Parameter(ParameterSetName = "RemotePort", Mandatory = $True)]
        [Alias('RemotePort')] [ValidateRange(1,65535)]
        [Int[]] $TcpPort,

        [Parameter(Mandatory=$false)]
        [Int] $MinTimeout = 0,

        [Parameter(Mandatory=$false)]
        [Int] $MaxTimeout = 1000
    )    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {
		$AttemptTcpTest = ($PSCmdlet.ParameterSetName -eq "CommonTCPPort") -or ($PSCmdlet.ParameterSetName -eq "RemotePort")
		if ($AttemptTcpTest){
			switch ($CommonTCPPort){
			"HTTP"   {$TcpPort = 80}
			"HTTPS"  {$TcpPort = 443}
			"RDP"    {$TcpPort = 3389}
			"SMB"    {$TcpPort = 445}
			"LDAP"   {$TcpPort = 389}
			"LDAPS"  {$TcpPort = 636}
			"WINRM"  {$TcpPort = 5985}
			"WINRMS" {$TcpPort = 5986}
			}
		}

		foreach($item in $Destination){
			foreach($port in $TcpPort){
				try{
					$resultset += [PsNetPing]::tping($item, $port, $MinTimeout, $MaxTimeout)
				}
				catch{
					$resultset += [PsNetError]::New("$($function)($item)", $_)
					$error.Clear()
				}
			}
		}
	}

	end {
		return $resultset
	}
}
function Test-PsNetTracert {

    <#

   .SYNOPSIS
      Test Trace Route

   .DESCRIPTION
      Test Trace Route to a destination

   .PARAMETER Destination
      A String or an Array of Strings with Url's to test

   .PARAMETER MaxHops
      Max gateways, routers to test, default is 30

   .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000

   .PARAMETER Show
      Show the output for each item online
 
   .EXAMPLE
      Test-PsNetTracert -Destination 'www.sbb.ch'

   .EXAMPLE
      Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 | Format-Table -AutoSize

   .EXAMPLE
      Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 -Show

   .INPUTS
      Hashtable

   .OUTPUTS
      PSCustomObject

   .NOTES
      Author: Martin Walther

   .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [ValidateLength(4,255)]
         [String[]] $Destination,

         [Parameter(Mandatory=$false)]
         [Int] $MaxHops = 30,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000,
 
         [Parameter(Mandatory=$false)]
         [Switch] $Show
    )  
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {
      foreach($item in $Destination){
        if($Show){
            [PsNetTracert]::tracert($item,$MaxTimeout,$MaxHops,$true)
        }
        else{
            $resultset += [PsNetTracert]::tracert($item,$MaxTimeout,$MaxHops)
            return $resultset
        }
      }
    }

    end{
    }
}
function Test-PsNetUping{

    <#

   .SYNOPSIS
      Test the connectivity over an Udp port

   .DESCRIPTION
      Test connectivity to an endpoint over the specified Udp port

   .PARAMETER Destination
      A String or an Array of Strings with Names or IP Addresses to test <string>

   .PARAMETER UdpPort
      An Integer or an Array of Integers with Udp Ports to test <int>

   .PARAMETER MinTimeout
      Min. Timeout in ms, default is 0

   .PARAMETER MaxTimeout
      Max. Timeout in ms, default is 1000
 
   .EXAMPLE
      Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100

   .EXAMPLE
      Test the connectivity to one Destination and one Udp Port with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch -UdpPort 53 -MaxTimeout 100

   .EXAMPLE
      Test the connectivity to two Destinations and one Udp Port with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 100

    EXAMPLE
      Test the connectivity to two Destinations and two Udp Ports with a max. timeout of 100ms
      Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100 | Format-Table

   .INPUTS
      Hashtable

   .OUTPUTS
      PSCustomObject

   .NOTES
      Author: Martin Walther

   .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [ValidateLength(4,255)]
         [String[]] $Destination,

         [Parameter(ParameterSetName = "RemotePort", Mandatory = $True)]
         [Alias('RemotePort')] [ValidateRange(1,65535)]
         [Int[]] $UdpPort,
 
         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000
    )    
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

	process {
		foreach($item in $Destination){
			foreach($port in $UdpPort){
                try{
                    $resultset += [PsNetPing]::uping($item, $port, $MinTimeout, $MaxTimeout)
                }
				catch{
					$resultset += [PsNetError]::New("$($function)($item)", $_)
					$error.Clear()
				}
			}
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
      Test-PsNetWping -Destination 'https://sbb.ch'

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000

   .EXAMPLE
      Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000 -NoProxy | Format-Table

   .INPUTS
      Hashtable

   .OUTPUTS
      PSCustomObject

   .NOTES
      Author: Martin Walther

   .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [ValidateLength(4,255)]
         [String[]] $Destination,

         [Parameter(Mandatory=$false)]
         [Int] $MinTimeout = 0,

         [Parameter(Mandatory=$false)]
         [Int] $MaxTimeout = 1000,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }

    process {
        if($NoProxy) {
            foreach($item in $Destination){
                if($item -notmatch '^http'){
                    $item = "http://$($item)"
                }
                try{
                    $resultset += [PsNetWeb]::wping($item, $MinTimeout, $MaxTimeout, $true)
                }
				catch{
					$resultset += [PsNetError]::New("$($function)($item)", $_)
					$error.Clear()
				}
            }
        }
        else{
            foreach($item in $Destination){
                if($item -notmatch '^http'){
                    $item = "http://$($item)"
                }
                try{
                    $resultset += [PsNetWeb]::wping($item, $MinTimeout, $MaxTimeout)
                }
				catch{
					$resultset += [PsNetError]::New("$($function)($item)", $_)
					$error.Clear()
				}
            }
        }
    }

    end {
        return $resultset
    }

}
#endregion
