Class PsNetDnsClientType {

    [bool]   $Succeeded
    [String] $ComputerName
    [Object] $DnsSearchSuffix
    [String] $TimeStamp
    [int]    $TimeMs

    PsNetDnsClientType(
        [bool]   $Succeeded, 
        [String] $ComputerName, 
        [Object] $DnsSearchSuffix, 
        [String] $TimeStamp,
        [int]    $TimeMs
    ) {
        $this.Succeeded       = $Succeeded
        $this.ComputerName     = $ComputerName
        $this.DnsSearchSuffix = $DnsSearchSuffix
        $this.TimeStamp       = $TimeStamp
        $this.TimeMs          = $TimeMs
    }
    #endregion

}

Class PsNetDnsClient {

    # [PsNetDnsClient]::GetDnsSearchSuffix('Windows')

    PsNetDnsClient(){}

    [PsNetDnsClientType] static GetDnsSearchSuffix([OSType]$CurrentOS){

        [String]   $function           = 'GetDnsSearchSuffix()'
        [DateTime] $start              = Get-Date
        [Object]   $SuffixSearchList   = $null
        [String]   $ComputerName       = $null
        [PsNetDnsClientType]$resultset = $null

        # For Windows only
        if($CurrentOS -eq [OSType]::Windows){
            try{
                $ComputerName     = $env:ComputerName
                $SuffixSearchList = (Get-DnsClientGlobalSetting).SuffixSearchList
            }
            catch {
                $resultset += [PsNetError]::New("$($function)()", $_)
                $error.Clear()
            }
        }

        # For Linux and Mac only
        if(($CurrentOS -eq [OSType]::Linux) -or ($CurrentOS -eq [OSType]::Mac)){
            try{
                $ComputerName     = hostname
                $SuffixSearchList = (Get-Content -Path '/etc/resolv.conf' | Select-String -Pattern 'search\s\S+') -replace 'search\s'
            }
            catch {
                $resultset += [PsNetError]::New("$($function)()", $_)
                $error.Clear()
            }
        }

        $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
        $resultset = [PsNetDnsClientType]::New($true,$ComputerName,$SuffixSearchList,$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),$duration)
        return $resultset

    }

    [PsNetDnsClientType] static ClearDnsSearchSuffix([OSType]$CurrentOS){

        [String]   $function = 'ClearDnsSearchSuffix()'
        [DateTime] $start    = Get-Date
        [PsNetDnsClientType]$resultset = $null

        # For Windows only
        if($CurrentOS -eq [OSType]::Windows){
            $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
            $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            if($IsAdmin){
                try{
                   $SuffixSearchList = (Set-DnsClientGlobalSetting -SuffixSearchList @() -PassThru).SuffixSearchList
                   $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
                   $resultset = [PsNetDnsClientType]::New($true,$env:ComputerName,$SuffixSearchList,$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),$duration)
                }
                catch {
                    $resultset += [PsNetError]::New("$($function)()", $_)
                    $error.Clear()
                }
            }
            else{
                $resultset += [PsNetDnsClientType]::New($false,$env:ComputerName,'Running this command with elevated privileges',$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),0)
            }

        }

        return $resultset

    }

    [PsNetDnsClientType] static AddDnsSearchSuffix([OSType]$CurrentOS,[String]$NewEntry){

        [String]   $function = 'AddDnsSearchSuffix()'
        [DateTime] $start    = Get-Date
        [PsNetDnsClientType]$resultset = $null

        # For Windows only
        if($CurrentOS -eq [OSType]::Windows){
            $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
            $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            if($IsAdmin){
                try{
                    [System.Collections.ArrayList]$aryDNSSuffixes = (Get-DnsClientGlobalSetting).SuffixSearchList
                    if($aryDNSSuffixes -contains $NewEntry){
                        $resultset += [PsNetDnsClientType]::New($false,$env:ComputerName,"$NewEntry already exists",$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),0)
                    }
                    else{
                        $aryDNSSuffixes += $NewEntry
                        $SuffixSearchList = (Set-DnsClientGlobalSetting -SuffixSearchList $aryDNSSuffixes -PassThru).SuffixSearchList
                        $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
                        $resultset = [PsNetDnsClientType]::New($true,$env:ComputerName,$SuffixSearchList,$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),$duration)
                    }
                }
                catch {
                    $resultset += [PsNetError]::New("$($function)()", $_)
                    $error.Clear()
                }
            }
            else{
                $resultset += [PsNetDnsClientType]::New($false,$env:ComputerName,'Running this command with elevated privileges',$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),0)
            }

        }

        return $resultset

    }

    [PsNetDnsClientType] static RemoveDnsSearchSuffix([OSType]$CurrentOS,[String]$Entry){

        [String]   $function = 'RemoveDnsSearchSuffix()'
        [DateTime] $start    = Get-Date
        [PsNetDnsClientType]$resultset = $null

        # For Windows only
        if($CurrentOS -eq [OSType]::Windows){
            $current   = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
            $IsAdmin   = $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            if($IsAdmin){
                try{
                    [System.Collections.ArrayList]$aryDNSSuffixes = (Get-DnsClientGlobalSetting).SuffixSearchList
                    if($aryDNSSuffixes -contains $Entry){
                        $aryDNSSuffixes.Remove($Entry)
                        $SuffixSearchList = (Set-DnsClientGlobalSetting -SuffixSearchList $aryDNSSuffixes -PassThru).SuffixSearchList
                        $duration = $([math]::round(((New-TimeSpan $($start) $(Get-Date)).TotalMilliseconds),0))
                        $resultset = [PsNetDnsClientType]::New($true,$env:ComputerName,$SuffixSearchList,$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),$duration)
                    }
                    else{
                        $resultset += [PsNetDnsClientType]::New($false,$env:ComputerName,"$Entry not exists",$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),0)
                   }
                }
                catch {
                    $resultset += [PsNetError]::New("$($function)()", $_)
                    $error.Clear()
                }
            }
            else{
                $resultset += [PsNetDnsClientType]::New($false,$env:ComputerName,'Running this command with elevated privileges',$(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'),0)
            }

        }

        return $resultset

    }

}