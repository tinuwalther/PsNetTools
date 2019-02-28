Class PsNetAdapterType {

    [bool]   $Succeeded
    [int]    $Index
    hidden [Object] $adapter
    [String] $Name
    [String] $Description
    [String] $NetworkInterfaceType
    [String] $OperationalStatus
    [String] $PhysicalAddres
    [String] $IpVersion
    [bool]   $IsAPIPAEnabled
    [Object] $IpV4Addresses
    [Object] $IpV6Addresses

    PsNetAdapterType (
        [bool]   $Succeeded,
        [int]    $Index,
        [Object] $adapter,
        [String] $IpVersion,
        [bool]   $IsAPIPAEnabled,
        [Object] $IpV4Addresses,
        [Object] $IpV6Addresses
    ) {
        $this.Succeeded            = $Succeeded
        $this.Index                = $Index
        $this.Name                 = $adapter.Name
        $this.Description          = $adapter.Description
        $this.NetworkInterfaceType = $adapter.NetworkInterfaceType
        $this.OperationalStatus    = $adapter.OperationalStatus
        $this.PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
        $this.IpVersion            = $IpVersion
        $this.IsAPIPAEnabled       = $IsAPIPAEnabled
        $this.IpV4Addresses        = $IpV4Addresses
        $this.IpV6Addresses        = $IpV6Addresses
    }

}

Class PsNetAdapter {

    <#
        [PsNetAdapter]::listadapters
        [PsNetAdapter]::listadapterconfig
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetAdapter(){
        $this.Message = "Loading PsNetAdapter"
    }
    #endregion

    #region methods
    [object] static listadapters(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'listadapters()'
        $resultset = @()

        try{
            $nics = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
            foreach($adapter in $nics){

                if($adapter.NetworkInterfaceType -notmatch 'Loopback'){

                    $IpVersion      = @()
                    $properties     = $adapter.GetIPProperties()
                    $IpV4properties = $properties.GetIPv4Properties()
                    $IpV4Addresses  = @()
                    $IpV6Addresses  = @()

                    $IpV4 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv4
                    $IpV6 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv6
                
                    if($adapter.Supports($IpV4)){
                        $IpVersion += 'IPv4'
                    }
                
                    if($adapter.Supports($IpV6)){
                        $IpVersion += 'IPv6'
                    }
                
                    foreach ($ip in $properties.UnicastAddresses) {
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork){
                            $IpV4Addresses += $ip.Address.ToString()
                        }
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork6){
                            $IpV6Addresses += $ip.Address.ToString()
                        }
                    }
                    <#
                    $obj = [PSCustomObject]@{
                        Succeeded            = $true
                        Index                = $IpV4properties.Index

                        Name                 = $adapter.Name
                        Description          = $adapter.Description
                        NetworkInterfaceType = $adapter.NetworkInterfaceType
                        OperationalStatus    = $adapter.OperationalStatus
                        PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'

                        IpVersion            = $IpVersion
                        IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
                        IpV4Addresses        = $IpV4Addresses
                        IpV6Addresses        = $IpV6Addresses
                    }
                    $resultset += $obj
                    #>
                    $resultset += [PsNetAdapterType]::New($true,$IpV4properties.Index,$adapter,$IpVersion,$IpV4properties.IsAutomaticPrivateAddressingActive,$IpV4Addresses,$IpV6Addresses)
                }
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }  
        return $resultset              
    }

    [object] static listadapterconfig(){

        #https://docs.microsoft.com/en-us/dotnet/api/system.net.networkinformation.networkinterface.getipproperties?view=netframework-4.7.2#System_Net_NetworkInformation_NetworkInterface_GetIPProperties

        $function  = 'listadapterconfig()'
        $resultset = @()

        try{
            $nics = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
            foreach($adapter in $nics){

                if($adapter.NetworkInterfaceType -notmatch 'Loopback'){

                    $IpV4Addresses = @()
                    $IpV6Addresses = @()

                    $IpVersion            = @()
                    $GatewayIpV4Addresses = @()
                    $GatewayIpV6Addresses = @()
    
                    $properties     = $adapter.GetIPProperties()
                    $IpV4properties = $properties.GetIPv4Properties()
                    $IpV6properties = $properties.GetIPv6Properties()
                                
                    $IpV4 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv4
                    $IpV6 = [System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv6
                
                    if($adapter.Supports($IpV4)){
                        $IpVersion += 'IPv4'
                    }
                
                    if($adapter.Supports($IpV6)){
                        $IpVersion += 'IPv6'
                    }
    
                    foreach ($ip in $properties.UnicastAddresses) {
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork){
                            $IpV4Addresses += $ip.Address.ToString()
                        }
                        if ($ip.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork6){
                            $IpV6Addresses += $ip.Address.ToString()
                        }
                    }

                    foreach($gateway in $properties.GatewayAddresses){
                        if($gateway.Address.AddressFamily -eq 'InterNetwork6'){
                            $GatewayIpV6Addresses += $gateway.Address.IPAddressToString
                        }
                        if($gateway.Address.AddressFamily -eq 'InterNetwork'){
                            $GatewayIpV4Addresses += $gateway.Address.IPAddressToString
                        }
                    }

                    $obj = [PSCustomObject]@{
                        Succeeded            = $true
                        Index                = $IpV4properties.Index

                        Id                   = $adapter.Id
                        Name                 = $adapter.Name
                        Description          = $adapter.Description
                        NetworkInterfaceType = $adapter.NetworkInterfaceType
                        OperationalStatus    = $adapter.OperationalStatus
                        Speed                = $adapter.Speed
                        IsReceiveOnly        = $adapter.IsReceiveOnly
                        SupportsMulticast    = $adapter.SupportsMulticast
                        PhysicalAddres       = $adapter.GetPhysicalAddress().ToString() -replace '..(?!$)', '$&:'
                
                        IpVersion            = $IpVersion
                        IpV4Addresses        = $IpV4Addresses
                        IpV6Addresses        = $IpV6Addresses
                        
                        IsDnsEnabled         = $properties.IsDnsEnabled
                        IsDynamicDnsEnabled  = $properties.IsDynamicDnsEnabled
                        DnsSuffix            = $properties.DnsSuffix
                        DnsAddresses         = $properties.DnsAddresses
                        DhcpServerAddresses  = $properties.DhcpServerAddresses
                        WinsServersAddresses = $properties.WinsServersAddresses
                        
                        Mtu                  = $IpV4properties.Mtu
                        IsForwardingEnabled  = $IpV4properties.IsForwardingEnabled
                        IsAPIPAEnabled       = $IpV4properties.IsAutomaticPrivateAddressingActive
                        IsAPIPAActive        = $IpV4properties.IsAutomaticPrivateAddressingEnabled
                        IsDhcpEnabled        = $IpV4properties.IsDhcpEnabled
                        UsesWins             = $IpV4properties.UsesWins

                        GatewayIpV4Addresses = $GatewayIpV4Addresses
                        GatewayIpV6Addresses = $GatewayIpV6Addresses
                    }
                    $resultset += $obj
                }
            }
        }
        catch{
            $resultset += [PsNetError]::New("$($function)()", $_)
            $error.Clear()
        }                
        return $resultset
    }
    #endregion
}

