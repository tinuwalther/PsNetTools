Class PsNetPingType {

    hidden [bool]   $Succeeded
    [String] $TimeStamp
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
        [String] $TimeStamp,
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
        $this.TimeStamp         = $TimeStamp
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
        [String] $TimeStamp,
        [String] $Destination, 
        [String] $StatusDescription, 
        [int] $Port, 
        [int] $MinTimeout, 
        [int] $MaxTimeout, 
        [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.TimeStamp         = $TimeStamp
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
        [String] $TimeStamp,
        [String] $Destination, 
        [String] $StatusDescription, 
        [int] $Port, 
        [int] $MinTimeout, 
        [int] $MaxTimeout, 
        [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.TimeStamp         = $TimeStamp
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
        [String] $TimeStamp,
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
        $this.TimeStamp         = $TimeStamp
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
        [PsNetPing]::tping('sbb.ch', 80, 100, 1000)
        [PsNetPing]::uping('sbb.ch', 53, 100, 1000)
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
        
        return [PsNetIcmpPingType]::New($true, $IcmpSucceeded, $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), $Destination, $IPAddress, $Roundtrip, $bytes, $buffer, $StatusMsg, $timeout, 0)
    }

    [void]static ping([String]$destination,[bool]$show) {

        $function   = 'ping()'
    
        [DateTime] $start  = Get-Date
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

        Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff') ICMP ping $Destination, IPAddress: $IPAddress, time: $Roundtrip, send: $bytes, received: $buffer, $StatusMsg"
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
        return [PsNetTpingType]::New($true, $tcpsucceeded, $TargetName, $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), $description, $TcpPort, $mintimeout, $maxtimeout, $duration)
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
        return [PsNetUpingType]::New($true, $udpsucceeded, $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), $TargetName, $description, $UdpPort, $mintimeout, $maxtimeout, $duration)
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
        return [PsNetWebType]::New($true, $webreturn, $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), $Url, $responseuri, $description, $false, $mintimeout, $maxtimeout, $duration)
            
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
        return [PsNetWebType]::New($true, $webreturn, $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), $Url, $responseuri, $description, $true, $mintimeout, $maxtimeout, $duration)   

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

