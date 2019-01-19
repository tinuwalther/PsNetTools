<#
    using module ..\PsNetTools\PsNetTools.psm1

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
    [PsNetTools]::wping('https://sbb.ch', 1000, $true) 

#>
Class PsNetTools {

    #region Properties with default values
    #endregion

    #region Constructor
    PsNetTools(){
        Write-Host "Loading PsNetTools"
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
                    $true
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
                            $resultset = [PSCustomObject]@{
                                TargetName  = $computer
                                IpV4Address = $ipv4address
                                IpV6Address = $ipv6address
                            }
                        }
                    }
                    else{
                        return $null
                    }
                }
                elseif($TargetName.GetType() -eq [String]){
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

    [string]static tping([String] $TargetName) {
        $function  = 'tping()'
        return "$($function): No TcpPort and Timeout specified!"
    }

    [string]static tping([String] $TargetName, [int] $TcpPort) {
        $function  = 'tping()'
        return "$($function): No TcpPort or Timeout specified!"
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
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [string]static uping() {
        return "Usage: [PsNetTools]::uping('sbb.ch', 53, 100)"
    }

    [string]static uping([String] $TargetName) {
        $function  = 'uping()'
        return "$($function): No UdpPort and Timeout specified!"
    }

    [string]static uping([String] $TargetName, [int] $UdpPort) {
        $function  = 'uping()'
        return "$($function): No UdpPort or Timeout specified!"
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
                return "WARNING: $($_.Exception.Message)"
                $error.Clear()
            }                
        }    
        return $resultset    
    }

    [string]static wping() {
        return "Usage: [PsNetTools]::wping('https://sbb.ch', 1000)"
   }

    [string]static wping([String]$url) {
        $function  = 'wping()'
        return "$($function): No timeout specified!"
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

                    $obj = [PSCustomObject]@{
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
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

                    $obj = [PSCustomObject]@{
                        TargetName    = $Url
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
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
    #endregion
}

function PsNetDig{
    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true)]
         [String] $Destination
    )    
    return [PsNetTools]::dig($Destination)
}

function PsNetTping{
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

function PsNetUping{
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

function PsNetWping{
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

Export-ModuleMember -Function PsNetDig, PsNetTping, PsNetUping, PsNetWping