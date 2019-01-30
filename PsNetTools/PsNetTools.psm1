<#
    using module ..\PsNetTools\PsNetTools.psm1

    dig - domain information groper
    [PsNetTools]::dig('sbb.ch')

    tping - tcp port scanner
    [PsNetTools]::tping('sbb.ch', 80, 100)

    uping - udp port scanner
    [PsNetTools]::uping('sbb.ch', 53, 100)

    wping - http web request scanner
    [PsNetTools]::wping('https://sbb.ch', 1000, $true) 

#>
Class PsNetTools {

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetTools(){
        $this.Message = "Loading PsNetTools"
    }
    #endregion
    
    #region methods
    [string]static dig() {
        return "Usage: [PsNetTools]::dig('sbb.ch')"
    }

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
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }
        }
        return $resultset
    }

    [string]static tping() {
        return "Usage: [PsNetTools]::tping('sbb.ch', 443, 100)"
    }

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
                    TargetName    = $TargetName
                    TcpPort       = $TcpPort
                    TcpSucceeded  = $tcpsucceeded
                    Duration      = "$($duration)ms"
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
        
            } catch {
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [string]static uping() {
        return "Usage: [PsNetTools]::uping('sbb.ch', 53, 100)"
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
                    #Write-Warning $($Error[0])
                    $udpsucceeded = $false
                    $Error.Clear()
                }
            
                if (-not([String]::IsNullOrEmpty($receivebytes))) {
                    [string]$returndata = $dgram.GetString($receivebytes)
                    $udpsucceeded = $true
                } 
            
                $udpclient.Close()
                $udpclient.Dispose()
                $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                
                $obj = [PSCustomObject]@{
                    TargetName    = $TargetName
                    UdpPort       = $UdpPort
                    UdpSucceeded  = $udpsucceeded
                    Duration      = "$($duration)ms"
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
                    
            } catch {
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [string]static wping() {
        return "Usage: [PsNetTools]::wping('https://sbb.ch', 1000)"
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
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch [Exception]{
                    return "WARNING: $($_.Exception.Message)"
                    $Error.Clear()
                }

            } catch {
                return "WARNING: $($_.Exception.Message)"
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
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch {
                    return "WARNING: $($_.Exception.Message)"
                    $Error.Clear()
                }

            } catch {
                return "WARNING: $($_.Exception.Message)"
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
                        TargetName    = $Uri
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch {
                    return "WARNING: $($_.Exception.Message)"
                    $Error.Clear()
                }

            } catch {
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
        }    
        return $resultset
    }

    [object]static netadapterconfig([int]$InterfaceIndex){

        $function  = 'netadapterconfig()'
        $resultset = @()

        if(([String]::IsNullOrEmpty($InterfaceIndex))){
            Write-Warning "$($function): Empty InterfaceIndex specified!"
        }
        else{
            try {
                $objWin32 = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {
                    ($_.InterfaceIndex -eq $InterfaceIndex)
                }
            } catch {
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
    
            if($objWin32){
    
                $IPV4Addresspattern = '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'
                $IPV6Addresspattern = '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'
                $IPV4Subnetpattern = '^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$'
                $IPV6Subnetpattern = '^\d+$'
    
                $obj = [PSCustomObject]@{
    
                    Index                       = $objWin32.Index
                    InterfaceIndex              = $objWin32.InterfaceIndex
                    NetworkInterfaceDescription = $objWin32.Description
    
                    IPV4Address                 = $objWin32.IPAddress -match $IPV4Addresspattern
                    IPV4DefaultGateway          = $objWin32.DefaultIPGateway -match $IPV4Addresspattern
                    IPV4SubnetMask              = $objWin32.IPSubnet -match $IPV4Subnetpattern
                    
                    IPV6Address                 = $objWin32.IPAddress -match $IPV6Addresspattern
                    IPV6DefaultGateway          = $objWin32.DefaultIPGateway -match $IPV6Addresspattern
                    IPV6SubnetMask              = $objWin32.IPSubnet -match $IPV6Subnetpattern
    
                    DNSHostName                 = $objWin32.DNSHostName
                    DNSDomain                   = $objWin32.DNSDomain
                    DNSServerSearchOrder        = $objWin32.DNSServerSearchOrder
                    DNSDomainSuffixSearchOrder  = $objWin32.DNSDomainSuffixSearchOrder
                    MACAddress                  = $objWin32.MACAddress
    
                }
                $resultset += $obj

            }
        }
        return $resultset
    }

    [object] static GetNetadapters(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'GetNetadapters()'
        $resultset = @()

        try{
            $nics = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
            foreach($adapter in $nics){

                $properties  = $adapter.GetIPProperties()
                
                $GatewayIpV4Addresses = @()
                $GatewayIpV6Addresses = @()

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
                    
                    IpV4Addresses        = $null
                    IpV6Addresses        = $null
                    PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'

                    IsDnsEnabled         = $properties.IsDnsEnabled
                    IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
                    DnsSuffix            = $properties.DnsSuffix
                    DnsAddresses         = $properties.DnsAddresses
                    DhcpServerAddresses  = $properties.DhcpServerAddresses
            
                    WinsServersAddresses = $properties.WinsServersAddresses

                    GatewayIpV4Addresses = $GatewayIpV4Addresses
                    GatewayIpV6Addresses = $GatewayIpV6Addresses
            
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
        }                
        return $resultset
    }
    #endregion
}

function Test-PsNetDig{
    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination
    )    
    return [PsNetTools]::dig($Destination)
}

function Test-PsNetTping{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $Destination,

        [Parameter(Mandatory=$true)]
        [Int] $TcpPort,

        [Parameter(Mandatory=$true)]
        [Int] $Timeout
 )    
    return [PsNetTools]::tping($Destination, $TcpPort, $Timeout)
}

function Test-PsNetUping{
    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $UdpPort,
 
         [Parameter(Mandatory=$true)]
         [Int] $Timeout
    )    
    return [PsNetTools]::uping($Destination, $UdpPort, $Timeout)
}

function Test-PsNetWping{
    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination,

         [Parameter(Mandatory=$true)]
         [Int] $Timeout,
 
         [Parameter(Mandatory=$false)]
         [Switch] $NoProxy
    )  
    if($NoProxy) {
        return [PsNetTools]::wping($Destination, $Timeout, $true)
    }
    else{
        return [PsNetTools]::wping($Destination, $Timeout)
    }
}

function Get-PsNetAdapters{
    [CmdletBinding()]
    param()    
    return [PsNetTools]::GetNetadapters()
}
