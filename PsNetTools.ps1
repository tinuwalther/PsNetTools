<#
    dig - domain information groper
    [PsNetTools]::dig() 
    [PsNetTools]::dig('') 
    [PsNetTools]::dig('sbb.ch')
    [PsNetTools]::dig('sbb.chr')
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



    #endregion
}
