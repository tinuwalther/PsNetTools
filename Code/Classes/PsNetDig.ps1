Class PsNetDig {

    <#
        [PsNetDig]::dig('sbb.ch')
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetDig(){
        $this.Message = "Loading PsNetDig"
    }
    #endregion
    
    #region methods
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
                                Succeeded    = $true
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
                                Succeeded   = $true
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
                $obj = [PSCustomObject]@{
                    Succeeded          = $false
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

