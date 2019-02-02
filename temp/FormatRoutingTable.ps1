[object] static FormatRoutingTable([String]$routprint){

    $function   = 'FormatRoutingTable()'
    $resultset  = @()

    try{
        $obj = [PSCustomObject]@{
            Succeeded  = $true
            Destination = $null
            Netmask     = $null
            Gateway     = $null
            Interface   = $null
            Metric      = $null
        }
        $resultset += $obj
    }
    catch{
        $obj = [PSCustomObject]@{
            Succeeded  = $false
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
