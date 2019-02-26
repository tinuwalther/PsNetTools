Class PsNetPingType {

    [bool]   $Succeeded
    [String] $Destination
    [String] $StatusDescription
    [int]    $Port
    [int]    $MinTimeout
    [int]    $MaxTimeout
    [int]    $TimeMs

    PsNetPingType(
        [bool] $Succeeded, [String] $Destination, [String] $StatusDescription, [int] $Port, [int] $MinTimeout, [int] $MaxTimeout, [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.Destination       = $Destination
        $this.StatusDescription = $StatusDescription
        $this.Port              = $Port
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
    [PsNetPingType] static tping([String] $TargetName, [int] $TcpPort, [int] $mintimeout, [int] $maxtimeout) {

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
        return [PsNetPingType]::New($tcpsucceeded, $TargetName, $description, $TcpPort, $mintimeout, $maxtimeout, $duration)
    }

    [PsNetPingType] static uping([String] $TargetName, [int] $UdpPort, [int] $mintimeout, [int] $maxtimeout) {

        [DateTime] $start        = Get-Date
        [bool]     $udpsucceeded = $false
        [String]   $description  = $null
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
            $description  = 'UDP Test success'
        }
        catch{
            $description = ($_.Exception.Message -split ':')[1]
            $error.Clear()
        }
    
        if (-not([String]::IsNullOrEmpty($receivebytes))) {
            $returndata   = $dgram.GetString($receivebytes)
            $udpsucceeded = $true
        } 
    
        $udpclient.Close()
        $udpclient.Dispose()

        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetPingType]::New($udpsucceeded, $TargetName, $description, $UdpPort, $mintimeout, $maxtimeout, $duration)
    }

    #endregion
}

