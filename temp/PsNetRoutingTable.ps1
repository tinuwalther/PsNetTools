Class PsNetRoutingTable{

    <#
        [PsNetRoutingTable]::GetNetRoutingTable()
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetRoutingTable(){
        $this.Message = "Loading PsNetRoutingTable"
    }
    #endregion
    
    #region methods
    [object] static GetNetRoutingTable([OSType]$CurrentOS, [Int]$interfaceindex) {

        $function   = 'GetNetRoutingTable()'
        $ostypespec = $null
        $command    = $null
        $routeprint = $null
        $resultset  = @()

        try{
            if($CurrentOS -eq [OSType]::Linux){
                $ostypespec = 'Pinguin'
            }
            if($CurrentOS -eq [OSType]::Mac){
                $ostypespec = 'Apfel'
            }
            if($CurrentOS -eq [OSType]::Windows){
                $ostypespec = 'Fenster'
                if($interfaceindex){
                    $routeprint = Get-NetRoute -InterfaceIndex $interfaceindex
                }else{
                    $routeprint = Get-NetRoute
                }
            }

            $obj = [PSCustomObject]@{
                Succeeded          = $true
                CurrentOS          = $CurrentOS
                Publish            = $routeprint.Publish
                Protocol           = $routeprint.Protocol
                Store              = $routeprint.Store
                AddressFamily      = $routeprint.AddressFamily
                State              = $routeprint.State
                ifIndex            = $routeprint.ifIndex
                Caption            = $routeprint.Caption
                Description        = $routeprint.Description
                ElementName        = $routeprint.ElementName
                InstanceID         = $routeprint.InstanceID
                AdminDistance      = $routeprint.AdminDistance
                DestinationAddress = $routeprint.DestinationAddress
                IsStatic           = $routeprint.IsStatic
                RouteMetric        = $routeprint.RouteMetric
                TypeOfRoute        = $routeprint.TypeOfRoute
                CompartmentId      = $routeprint.CompartmentId
                DestinationPrefix  = $routeprint.DestinationPrefix
                InterfaceAlias     = $routeprint.InterfaceAlias
                InterfaceIndex     = $routeprint.InterfaceIndex
                InterfaceMetric    = $routeprint.InterfaceMetric
                NextHop            = $routeprint.NextHop
                PreferredLifetime  = $routeprint.PreferredLifetime
                ValidLifetime      = $routeprint.ValidLifetime
            }
            $resultset += $obj
        }
        catch{
            $obj = [PSCustomObject]@{
                Succeeded  = $false
                CurrentOS  = $CurrentOS
                Activity   = $($_.CategoryInfo).Activity
                Message    = $($_.Exception.Message)
                Category   = $($_.CategoryInfo).Category
                Exception  = $($_.Exception.GetType().FullName)
                TargetName = $($_.CategoryInfo).TargetName
            }
            $resultset += $obj
            $error.Clear()
        }                
        return $resultset
    }
    #endregion

}

