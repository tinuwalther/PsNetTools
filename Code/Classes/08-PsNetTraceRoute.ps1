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

