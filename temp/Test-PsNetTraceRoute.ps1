function Test-PsNetTraceRoute{

    <#

    .SYNOPSIS
        Domain information groper

    .DESCRIPTION
        Resolves a hostname to the IP addresses or an IP Address to the hostname.

    .PARAMETER Destination
        Hostname or IP Address or Alias
    
    .EXAMPLE
        Resolve a hostname to the IP Address
        Test-PsNetDig -Destination sbb.ch

    .EXAMPLE
        Resolve an IP address to the hostname
        Test-PsNetDig -Destination '127.0.0.1','194.150.245.142'

    .EXAMPLE
        Resolve an array of hostnames to the IP Address
        Test-PsNetDig -Destination sbb.ch, google.com

    .EXAMPLE
        Resolve an array of hostnames to the IP Address with ValueFromPipeline
        sbb.ch, google.com | Test-PsNetDig

    .INPUTS
        Hashtable

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author: Martin Walther

    .LINK
        https://github.com/tinuwalther/PsNetTools

        https://stackoverflow.com/questions/142614/traceroute-and-ping-in-c-sharp

        https://gitlab.com/sbrl/TraceRoutePlus/blob/master/TraceRoutePlus/Traceroute.cs

    Usage: tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout] 
                [-R] [-S srcaddr] [-4] [-6] target_name

    Options:
        -d                 Do not resolve addresses to hostnames.
        -h maximum_hops    Maximum number of hops to search for target.
        -j host-list       Loose source route along host-list (IPv4-only).
        -w timeout         Wait timeout milliseconds for each reply.
        -R                 Trace round-trip path (IPv6-only).
        -S srcaddr         Source address to use (IPv6-only).
        -4                 Force using IPv4.
        -6                 Force using IPv6.

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory= $true,ValueFromPipeline = $true)]
        [ValidateLength(4,255)]
        [String[]] $Destination,

        [Parameter(ParameterSetName = "IPversion", Mandatory = $True)]
        [ValidateSet('IPv4','IPv6')]
        [String] $IPversion,

        [Parameter(Mandatory=$false)]
        [Int] $MaxHops = 30,

        [Parameter(Mandatory=$false)]
        [Int] $MaxTimeout = 1000
    ) 
        
    begin {
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
        $resultset = @()
    }
    
    process {
        $ip = ($PSCmdlet.ParameterSetName -eq "IPversion")
        if($ip){
            switch ($IPversion){
                'IPv4' {$version = '-4'}
                'IPv6' {$version = '-6'}
            }
            tracert -h $MaxHops -w $MaxTimeout $version $Destination
        }
        else{
            tracert -h $MaxHops -w $MaxTimeout $Destination
        }
    }
    
    end {
        return $resultset
    }

}    