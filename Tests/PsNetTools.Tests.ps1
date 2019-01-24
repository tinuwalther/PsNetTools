#using module ..\PsNetTools\PsNetTools.psm1

$TestsPath  = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName
set-location  -Path $RootFolder.FullName

Import-Module .\PsNetTools -Force
Import-Module -Name Pester -Force

Describe "Testing class PsNetTools" {

    if($PSVersionTable.PSVersion.Major -lt 6){
        $IsWindows = $true
    }

    Context "Testing method PsNetDig" {  
        
        if($IsMacOS){
            it "[NEG] [Mac] Testing PsNetDig with false Hostname as parameter(s)"{
                (PsNetDig -Destination 'sbb.powershell') | should match 'Device not configured'
            }
                    
            it "[NEG] [Mac] Testing PsNetDig with false IP Address as parameter(s)"{
                (PsNetDig -Destination '255.255.255.256') | should match 'Device not configured'
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing PsNetDig with false Hostname as parameter(s)"{
                (PsNetDig -Destination 'sbb.powershell') | should match 'No such host is known'
            }
                
            it "[NEG] [Win] Testing PsNetDig with false IP Address as parameter(s)"{
                (PsNetDig -Destination '255.255.255.256') | should match 'No such host is known'
            }
        }
    
        it "[POS] [Any] Testing PsNetDig with Hostname as parameter(s)"{
            (PsNetDig -Destination 'sbb.ch') | should BeOfType [Object]
        }

        it "[POS] [Any] Testing PsNetDig with IP Address as parameter(s)"{
            (PsNetDig -Destination '127.0.0.1') | should BeOfType [Object]
        }

    }
        
    Context "Testing method PsNetTping" {     
       
        if($IsMacOS){
            it "[NEG] [Mac] Testing PsNetTping with false Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.powershell' -TcpPort 443 -Timeout 1000) | should match 'Device not configured'
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing PsNetTping with false Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.powershell' -TcpPort 443 -Timeout 1000) | should match 'No such host is known'
            }
        }

        it "[NEG] [Any] Testing PsNetTping with false Port as parameter(s)"{
            (PsNetTping -Destination 'sbb.ch' -TcpPort 443443 -Timeout 1000) | should match 'Parameter name: port'
        }

        if($IsMacOS){
            it "[NEG] [Mac] Testing PsNetTping with false IP Address as parameter(s)"{
                (PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000) | should match 'Permission denied'
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing PsNetTping with false IP Address as parameter(s)"{
                (PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000) | should match 'The requested address is not valid'
            }
        }

        it "[POS] [Any] Testing PsNetTping with Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.ch' -TcpPort 443 -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] [Any] Testing PsNetTping with IP Address as parameter(s)"{
            (PsNetTping -Destination '194.150.245.142' -TcpPort 443 -Timeout 1000) | should BeOfType [Object]
        }

    }

    Context "Testing method PsNetUping" {
        
        it "[NEG] [Any] Testing PsNetUping with false Port as parameter(s)"{
            (PsNetUping -Destination 'sbb.ch' -UdpPort 443443 -Timeout 1000) | should match 'Parameter name: port'
        }

        it "[NEG] [Any] Testing PsNetUping with false IP Address as parameter(s)"{
            (PsNetUping -Destination '255.255.255.255' -UdpPort 53 -Timeout 1000).UdpSucceeded | should be $false
        }

        it "[POS] [Any] Testing PsNetUping with Hostname as parameter(s)"{
            (PsNetUping -Destination 'sbb.ch' -UdpPort 53 -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] [Any] Testing PsNetUping with IP Address as parameter(s)"{
            (PsNetUping -Destination '194.150.245.142' -UdpPort 53 -Timeout 1000) | should BeOfType [Object]
        }

    }

    Context "Testing method PsNetWping" {
        
        if($IsMacOS){
            it "[NEG] [Mac] Testing PsNetWping with false Uri as parameter(s)"{
            (PsNetWping -Destination 'https:sbb.ch' -Timeout 1000) | should match 'Invalid URI'
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing PsNetWping with false Uri as parameter(s)"{
            (PsNetWping -Destination 'https:sbb.ch' -Timeout 1000) | should match 'Invalid URI'
            }
        }

        it "[POS] [Any] Testing PsNetWping without noproxy parameter(s)"{
            (PsNetWping -Destination 'https://sbb.ch' -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] [Any] Testing PsNetWping with all parameter(s)"{
            (PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy) | should BeOfType [Object]
        }

    }

}

Pop-Location