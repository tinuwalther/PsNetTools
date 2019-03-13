function GetTraceRoute{

    <#
        https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.ping.send?view=netframework-4.7.2
        If the ICMP echo reply message is not received within the time specified by the timeout parameter, 
        the ICMP echo fails, and the Status property is set to TimedOut. 

        GetTraceRoute -Destination 'gkb.ch' -maxTimeout 1000 -maxHops 15 -show | ft
        GetTraceRoute -Destination 'sbb.ch' -maxTimeout 1000 -maxHops 15 -show | ft
        GetTraceRoute -Destination 'google.com' -maxTimeout 1000 -maxHops 15 -show | ft
        GetTraceRoute -Destination 'ubs.com' -maxTimeout 1000 -maxHops 15 -show | ft
    #>
    param(
        [string] $Destination,
        [int] $maxTimeout = 10000,
        [int] $maxHops    = 30,
        [switch] $show    = $false
    )

    if($show){
        Write-Output "Trace route $Destination over $maxHops Hops"
    }

    $resultset   = @()

    $pingsender  = [System.Net.NetworkInformation.Ping]::new()
    $datagram    = new-object System.Text.ASCIIEncoding
    [byte[]] $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    for($hop = 1; $hop -le $maxHops; $hop ++){

        $ExitFlag  = $false
        $dnsreturn = $null
        $DontFragment = '*'
        $ttl = '*'

        try{
            $pingoptions = [System.Net.NetworkInformation.PingOptions]::new($hop, $true)  
            $reply       = $pingsender.Send($destination, $maxTimeout, $buffersize, $pingoptions)
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
                $IPAddress = '*'
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
                $message    = 'Go to next address'
            }
            'TimedOut'   {
                # TimedOut means this ttl is no good, we should continue searching
                $message    = 'Continue searching'
            }
            'Success'    {
                # Success means the tracert has completed
                $ttl         = $reply.Options.Ttl
                $DontFragment = $reply.Options.DontFragment
                $message    = 'Trace route completed'
                $ExitFlag  = $true
            }
        }
        
        $obj = [PSCustomObject]@{
            Hops          = $hop
            RTT           = $Roundtrip
            Buffer        = $buffer
            Bytes         = $bytes
            TTL           = $ttl
            Destination   = $destination
            Hostname      = $dnsreturn
            IPAddress     = $IPAddress
            Status        = $reply.Status.ToString()
            Message       = $message
            DontFragment  = $DontFragment
        }
        $resultset += $obj

        if($show){$obj}
        if($ExitFlag){
            break
            $pingsender.Dispose()
        }
    }
    if($show -eq $false){
        return $resultset
    }
}
