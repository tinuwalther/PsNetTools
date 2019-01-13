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

    #endregion
}
