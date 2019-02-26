Class PsNetPingType {

    [bool]   $Succeeded
    [String] $Destination
    [int]    $Port
    [int]    $MinTimeout
    [int]    $MaxTimeout
    [int]    $TimeMs

    PsNetPingType(
        [bool] $Succeeded, [String] $Destination, [int] $Port, [int] $MinTimeout, [int] $MaxTimeout, [int] $TimeMs
    ){
        $this.Succeeded   = $Succeeded
        $this.Destination = $Destination
        $this.Port        = $Port
        $this.MinTimeout  = $MinTimeout
        $this.MaxTimeout  = $MaxTimeout
        if($TimeMs -gt $MaxTimeout){
            $this.TimeMs = $MaxTimeout
        }
        else{
            $this.TimeMs      = $TimeMs
        }
    }
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
    [PsNetPingType] static tping([String] $TargetName, [int] $TcpPort, [int] $mintimeout, [int] $maxtimeout) {

        [DateTime] $start        = Get-Date
        [bool]     $tcpsucceeded = $false
        [bool]     $WaitOne      = $false
        [Object]   $tcpclient    = $null
        [Object]   $connect      = $null
        
        $tcpclient = New-Object System.Net.Sockets.TcpClient
        $connect   = $TcpClient.BeginConnect($TargetName,$TcpPort,$null,$null)
        Start-Sleep -Milliseconds (20 + $mintimeout)
        $WaitOne  = $connect.AsyncWaitHandle.WaitOne($maxtimeout,$false) 
        if($WaitOne){
            $tcpsucceeded = $tcpclient.Connected
            if($tcpsucceeded){
                $tcpclient.EndConnect($connect)
            }
        }
        $tcpclient.Close()
        $tcpclient.Dispose()

        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetPingType]::New($tcpsucceeded, $TargetName, $TcpPort, $mintimeout, $maxtimeout, $duration)
    }

    [PsNetPingType] static uping([String] $TargetName, [int] $UdpPort, [int] $mintimeout, [int] $maxtimeout) {

        [DateTime] $start        = Get-Date
        [bool]     $udpsucceeded = $false
        [Object]   $udpclient    = $null
        [Object]   $connect      = $null
        [bool]     $WaitOne      = $false
        [string]   $returndata   = $null

        $receivebytes   = $null

        $udpclient = New-Object System.Net.Sockets.UdpClient
        $connect   = $udpclient.Connect($TargetName,$UdpPort)
        $WaitOne   = $udpclient.Client.ReceiveTimeout = $maxtimeout
        
        $dgram = new-object system.text.asciiencoding
        $byte  = $dgram.GetBytes("TEST")
        [void]$udpclient.Send($byte,$byte.length)
        $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)
        Start-Sleep -Milliseconds (20 + $mintimeout)

        try{
            $receivebytes = $udpclient.Receive([ref]$remoteendpoint) 
        }
        catch{
            $error.Clear()
        }
    
        if (-not([String]::IsNullOrEmpty($receivebytes))) {
            $returndata   = $dgram.GetString($receivebytes)
            $udpsucceeded = $true
        } 
    
        $udpclient.Close()
        $udpclient.Dispose()

        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetPingType]::New($udpsucceeded, $TargetName, $UdpPort, $mintimeout, $maxtimeout, $duration)
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

