Class PsNetDigType {

    [bool]   $Succeeded
    [String] $InputString
    [String] $Destination
    [Array]  $IpV4Address
    [Array]  $IpV6Address
    [int]    $TimeMs

    PsNetDigType(
        [bool]   $Succeeded, 
        [String] $InputString, 
        [String] $Destination, 
        [Array]  $IpV4Address, 
        [Array]  $IpV6Address, 
        [int]    $TimeMs
    ) {
        $this.Succeeded   = $Succeeded
        $this.InputString = $InputString
        $this.Destination = $Destination
        $this.IpV4Address = $IpV4Address
        $this.IpV6Address = $IpV6Address
        $this.TimeMs      = $TimeMs
    }
    #endregion

}

Class PsNetDig {

    <#
        [PsNetDig]::dig('sbb.ch')
        [PsNetDig]::dig('google.com')
        [PsNetDig]::dig('8.8.8.8')
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetDig(){
        
    }
    #endregion
    
    #region methods
    [PsNetDigType]static dig() {
        return [PsNetDigType]::New()
    }

    [PsNetDigType]static dig([String] $InputString) {
        
        [DateTime] $start       = Get-Date
        [Array]    $dnsreturn   = $null
        [Array]    $collection  = $null
        [Array]    $ipv4address = $null
        [Array]    $ipv6address = $null
        [String]   $TargetName  = $null

        $dnsreturn = [System.Net.Dns]::GetHostEntry($InputString)
        if(-not([String]::IsNullOrEmpty($dnsreturn))){
            $TargetName = $dnsreturn.hostname
            $collection = $dnsreturn.AddressList
        }
        
        foreach($item in $collection){
            if($($item.AddressFamily) -eq [System.Net.Sockets.AddressFamily]::InterNetwork){
                $ipv4address += $item.IPAddressToString
            }
            if($($item.AddressFamily) -eq [System.Net.Sockets.AddressFamily]::InterNetworkV6){
                $ipv6address += $item.IPAddressToString
            }
        }

        $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
        return [PsNetDigType]::New($true, $InputString, $TargetName, $ipv4address, $ipv6address, $duration)
    }
    #endregion

}

