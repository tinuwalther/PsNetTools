<#
    dig - domain information groper
    [PsNetTools]::dig() 
    [PsNetTools]::dig('') 
    [PsNetTools]::dig('sbb.ch')
    [PsNetTools]::dig('sbb.chr')

    tping - tcp port scanner
    [PsNetTools]::tping() 
    [PsNetTools]::tping('sbb.ch') 
    [PsNetTools]::tping('sbb.ch', 80) 
    [PsNetTools]::tping('sbb.ch', 80, 100)

    uping - udp port scanner
    [PsNetTools]::uping() 
    [PsNetTools]::uping('sbb.ch') 
    [PsNetTools]::uping('sbb.ch', 53) 
    [PsNetTools]::uping('sbb.ch', 53, 100)

    wping - http web request scanner
    [PsNetTools]::wping() 
    [PsNetTools]::wping('https://sbb.ch') 
    [PsNetTools]::wping('https://sbb.ch', 1000) 
    [PsNetTools]::wping('https://sbb.ch', 1000, 'noproxy') 

#>
Class PsNetTools {

    #region Properties with default values
    #endregion

    #region Constructor
    #endregion
    
    #region methods
    [void]static dig() {
        $function  = 'dig()'
        Write-Warning "$($function): No TargetName specified!"
    }

    [object]static dig([String] $TargetName) {
        
        $function  = 'dig()'
        $resultset = $null

        if([String]::IsNullOrEmpty($TargetName)){
            Write-Warning "$($function): Empty TargetName specified!"
        }
        else{
            $addresses   = $null
            $ipv4address = $null
            $ipv6address = $null
            try {
                $addresses = [System.Net.Dns]::GetHostAddressesAsync($TargetName).GetAwaiter().GetResult()
                if(-not([String]::IsNullOrEmpty($addresses))){
                    foreach($item in $addresses){
                        if($($item.AddressFamily) -eq 'InterNetwork'){
                            $ipv4address = $item.IPAddressToString
                        }
                        if($($item.AddressFamily) -eq 'InterNetworkV6'){
                            $ipv6address = $item.IPAddressToString
                        }
                        $resultset = [PSCustomObject]@{
                            TargetName  = $TargetName
                            IpV4Address = $ipv4address
                            IpV6Address = $ipv6address
                        }
                    }
                }
                else{
                    return $null
                }
            } 
            catch {
                Write-Warning "$($function): Could not resolve $TargetName!"
                $error.Clear()
            }
        }
        return $resultset
    }

    [void]static tping() {
        $function  = 'tping()'
        Write-Warning "$($function): No Target specified!"
    }

    [void]static tping([String] $TargetName) {
        $function  = 'tping()'
        Write-Warning "$($function): No TcpPort and Timeout specified!"
    }

    [void]static tping([String] $TargetName, [int] $TcpPort) {
        $function  = 'tping()'
        Write-Warning "$($function): No TcpPort or Timeout specified!"
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
        
                $obj = [PSCustomObject]@{
                    TargetName    = $TargetName
                    TcpPort       = $TcpPort
                    TcpSucceeded  = $tcpsucceeded
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
        
            } catch {
                Write-Warning "$($function): Could not connect to $TargetName over tcpport $TcpPort within $($Timeout)ms!"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [void]static uping() {
        $function  = 'uping()'
        Write-Warning "$($function): No Target specified!"
    }

    [void]static uping([String] $TargetName) {
        $function  = 'uping()'
        Write-Warning "$($function): No UdpPort and Timeout specified!"
    }

    [void]static uping([String] $TargetName, [int] $UdpPort) {
        $function  = 'uping()'
        Write-Warning "$($function): No UdpPort or Timeout specified!"
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
            
                $obj = [PSCustomObject]@{
                    TargetName    = $TargetName
                    UdpPort       = $UdpPort
                    UdpSucceeded  = $udpsucceeded
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj
                    
            } catch {
                Write-Warning "$($function): Could not connect to $TargetName over udpport $UdpPort within $($Timeout)ms!"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [void]static wping() {
        $function  = 'wping()'
        Write-Warning "$($function): No Url specified!"
    }

    [void]static wping([String]$url) {
        $function  = 'wping()'
        Write-Warning "$($function): No timeout specified!"
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
                $webreqest = [system.Net.HttpWebRequest]::Create($url)
                $webreqest.Timeout = $timeout

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                }
                catch [Exception]{
                    $statuscode = $($_.Exception.Message)
                    $Error.Clear()
                }

                $obj = [PSCustomObject]@{
                    TargetName    = $Url
                    ResponseUri   = $responseuri
                    StatusCode    = $statuscode
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj

            } catch {
                Write-Warning "$($function): Could not connect to $Url within $($Timeout)ms!"
                $error.Clear()
            }                
        }    
        return $resultset    
    }
    
    [object]static wping([String]$url,[int]$timeout,[String]$noproxy) {

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
                $webreqest = [system.Net.HttpWebRequest]::Create($url)
                $webreqest.Timeout = $timeout
                $webreqest.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()

                try{
                    $response    = $webreqest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                }
                catch [Exception]{
                    $statuscode = $($_.Exception.Message)
                    $Error.Clear()
                }

                $obj = [PSCustomObject]@{
                    TargetName    = $Url
                    ResponseUri   = $responseuri
                    StatusCode    = $statuscode
                    MaxTimeout    = "$($Timeout)ms"
                }
                $resultset += $obj

            } catch {
                Write-Warning "$($function): Could not connect to $Url within $($Timeout)ms!"
                $error.Clear()
            }                
        }    
        return $resultset    
    }
    #endregion
}
