function GetTraceRoute{

    param(
        [string] $Destination,
        [int] $maxTimeout = 1000,
        [int] $maxHops    = 30,
        [switch] $show    = $false
    )

    if($show){
        Write-Output "Trace route $Destination over $maxHops Hops"
    }

    $resultset   = @()

    $pingsender  = [System.Net.NetworkInformation.Ping]::new()
    $datagram    = new-object System.Text.ASCIIEncoding
    $buffersize  = $datagram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    for($ttl = 1; $ttl -le $maxHops; $ttl ++){

        $ExitFlag  = $false
        $dnsreturn = $null
        [DateTime] $start = Get-Date

        try{
            $pingoptions = [System.Net.NetworkInformation.PingOptions]::new($ttl, $true)        
            $reply       = $pingsender.Send($destination, $maxTimeout, $buffersize, $pingoptions)
        }
        catch{
            $error.Clear()
        }
        $time = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))

        try{
            if(-not([String]::IsNullOrEmpty($reply.Address))){
                $dnsreturn = [System.Net.Dns]::GetHostByAddress($reply.Address).HostName
            }
        }
        catch{
            $dnsreturn = 'Could not resolve'
            $error.clear()
        }

        switch($reply.Status){
            'TtlExpired' {
                # TtlExpired means we've found an address, but there are more addresses
                $IPAddress = $reply.Address
                $Status    = 'Running, there are more addresses'
            }
            'TimedOut'   {
                # TimedOut means this ttl is no good, we should continue searching
                $IPAddress = $reply.Address
                $Status    = 'Request timed out, continue searching'
            }
            'Success'    {
                # Success means the tracert has completed
                $IPAddress = $reply.Address
                $Status    = 'Success, trace route has completed'
                $ExitFlag  = $true
            }
        }

        $obj = [PSCustomObject]@{
            TTL         = $ttl
            TimeMs      = $time
            Destination = $destination
            Hostname    = $dnsreturn
            IPAddress   = $IPAddress
            Status      = $Status
        }
        $resultset += $obj

        if($show){$obj}
        if($ExitFlag){break}
    }
    if($show -eq $false){
        return $resultset
    }
}
