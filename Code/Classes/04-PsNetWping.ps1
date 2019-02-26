Class PsNetWebType {

    [bool]   $Succeeded
    [String] $Destination
    [String] $Url
    [String] $StatusDescription
    [bool]   $NoProxy
    [int]    $MinTimeout
    [int]    $MaxTimeout
    [int]    $TimeMs

    PsNetWebType(
        [bool] $Succeeded, [String] $Destination, [String] $Url, [String] $StatusDescription, [bool] $Proxy, [int] $MinTimeout, [int] $MaxTimeout, [int] $TimeMs
    ){
        $this.Succeeded         = $Succeeded
        $this.Destination       = $Destination
        $this.Url               = $Url
        $this.StatusDescription = $StatusDescription
        $this.NoProxy           = $Proxy
        $this.MinTimeout        = $MinTimeout
        $this.MaxTimeout        = $MaxTimeout
        if($TimeMs -gt $MaxTimeout){
            $this.TimeMs = $MaxTimeout
        }
        else{
            $this.TimeMs = $TimeMs
        }
    }
}

Class PsNetWeb {

    <#
        [PsNetWeb]::wping('https://sbb.ch', 1000, $true) 
    #>

    #region Properties with default values
    [String]$Message = $null
    #endregion

    #region Constructor
    PsNetWeb(){
        $this.Message = "Loading PsNetWeb"
    }
    #endregion
    
    #region methods
    [PsNetWebType] static wping([String]$url, [int] $mintimeout, [int] $maxtimeout) {
    
        [DateTime] $start     = Get-Date
        [bool]     $webreturn = $false
        [String]   $description = $null
        [Object]   $responseuri = $null

        $webreqest = [system.Net.HttpWebRequest]::Create($url)
        $webreqest.Timeout = $maxtimeout
        Start-Sleep -Milliseconds (20 + $mintimeout)

        try{
            $response    = $webreqest.GetResponse()
            $responseuri = $response.ResponseUri
            $statuscode  = $response.StatusCode
            $description = $response.StatusDescription
            if($statuscode -eq 'OK'){
                $webreturn = $true
            }
            $response.Close()
        }
        catch {
            $description = ($_.Exception.Message -split ':')[1]
            $error.Clear()
        }
        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetWebType]::New($webreturn, $Url, $responseuri, $description, $false, $mintimeout, $maxtimeout, $duration)
            
    }
    
    [PsNetWebType] static wping([String]$url, [int] $mintimeout, [int] $maxtimeout,[bool]$noproxy) {
    
        [DateTime] $start       = Get-Date
        [bool]     $webreturn   = $false
        [String]   $description = $null
        [Object]   $responseuri = $null

        $webreqest = [system.Net.HttpWebRequest]::Create($url)
        $webreqest.Timeout = $maxtimeout
        if($noproxy){
            $webreqest.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
        }
        Start-Sleep -Milliseconds (20 + $mintimeout)

        try{
            $response    = $webreqest.GetResponse()
            $responseuri = $response.ResponseUri
            $statuscode  = $response.StatusCode
            $description = $response.StatusDescription
            $response.Close()
            if($statuscode -eq 'OK'){
                $webreturn = $true
            }
            $response.Close()
        }
        catch {
            $description = ($_.Exception.Message -split ':')[1]
            $error.Clear()
        }
        $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0) -(20 + $mintimeout) )
        return [PsNetWebType]::New($webreturn, $Url, $responseuri, $description, $true, $mintimeout, $maxtimeout, $duration)   

    }

    [PsNetWebType] static ftpping([String]$uri,[int]$timeout,[PSCredential]$creds) {

        #https://www.opentechguides.com/how-to/article/powershell/154/directory-listing.html

        $function  = 'ftpping()'
        $resultset = @()
    
        if(([String]::IsNullOrEmpty($uri))){
            Write-Warning "$($function): Empty Uri specified!"
        }
        else{
            $ftprequest  = $null
            $response    = $null
            $responseuri = $null
            $statuscode  = $null

            try {
                $start      = Get-Date
                $ftprequest = [System.Net.FtpWebRequest]::Create($uri)
                $ftprequest.Credentials = New-Object System.Net.NetworkCredential($creds.UserName, $creds.Password)
                $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
                $ftprequest.Timeout = $timeout

                try{
                    $response    = $ftprequest.GetResponse()
                    $responseuri = $response.ResponseUri
                    $statuscode  = $response.StatusCode
                    $response.Close()
                    $duration = $([math]::round(((New-TimeSpan $($start) $(get-date)).TotalMilliseconds),0))
                    
                    $obj = [PSCustomObject]@{
                        Succeeded     = $true
                        TargetName    = $Uri
                        ResponseUri   = $responseuri
                        StatusCode    = $statuscode
                        Duration      = "$($duration)ms"
                        MaxTimeout    = "$($Timeout)ms"
                    }
                    $resultset += $obj

                } catch {
                    $obj = [PSCustomObject]@{
                        Succeeded     = $false
                        TargetName    = $Uri
                        StatusCode    = $false

                        Function           = $function
                        Message            = $($_.Exception.Message)
                        Category           = $($_.CategoryInfo).Category
                        Exception          = $($_.Exception.GetType().FullName)
                        CategoryActivity   = $($_.CategoryInfo).Activity
                        CategoryTargetName = $($_.CategoryInfo).TargetName
                    }
                    $resultset += $obj
                    $Error.Clear()
                }

            } catch {
                $obj = [PSCustomObject]@{
                    Succeeded     = $false
                    TargetName    = $Uri
                    StatusCode    = $false

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

