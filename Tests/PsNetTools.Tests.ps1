#using module ..\PsNetTools\PsNetTools.psm1
Import-Module ..\PsNetTools\PsNetTools.psm1 -Force

Describe "Testing class PsNetTools" {

    Context "Testing method PsNetDig" {  
        
        if($IsMacOS){
            it "[NEG] Testing PsNetDig with false Hostname as parameter(s)"{
                (PsNetDig -Destination 'sbb.66') | should match 'Device not configured'
            }
                    
            it "[NEG] Testing PsNetDig with false IP Address as parameter(s)"{
                (PsNetDig -Destination '127.0.0.255') | should match 'Device not configured'
            }
        }

        if($IsWindows){
            it "[NEG] Testing PsNetDig with false Hostname as parameter(s)"{
                (PsNetDig -Destination 'sbb.66') | should match 'No such host is known'
            }
                    
            it "[NEG] Testing PsNetDig with false IP Address as parameter(s)"{
                (PsNetDig -Destination '127.0.0.255') | should match 'The requested name is valid'
            }
        }

        it "[POS] Testing PsNetDig with Hostname as parameter(s)"{
            (PsNetDig -Destination 'sbb.ch') | should BeOfType [Object]
        }

        it "[POS] Testing PsNetDig with IP Address as parameter(s)"{
            (PsNetDig -Destination '127.0.0.1') | should BeOfType [Object]
        }

    }
        
    Context "Testing method PsNetTping" {     
       
        if($IsMacOS){
            it "[NEG] Testing PsNetTping with false Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.66' -TcpPort 443 -Timeout 1000) | should match 'Device not configured'
            }
        }

        if($IsWindows){
            it "[NEG] Testing PsNetTping with false Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.66' -TcpPort 443 -Timeout 1000) | should match 'No such host is known'
            }
        }

        it "[NEG] Testing PsNetTping with false Port as parameter(s)"{
            (PsNetTping -Destination 'sbb.ch' -TcpPort 443443 -Timeout 1000) | should match 'Parameter name: port'
        }

        if($IsMacOS){
            it "[NEG] Testing PsNetTping with false IP Address as parameter(s)"{
                (PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000) | should match 'Permission denied'
            }
        }

        if($IsWindows){
            it "[NEG] Testing PsNetTping with false IP Address as parameter(s)"{
                (PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000) | should match 'The requested address is not valid'
            }
        }

        it "[POS] Testing PsNetTping with Hostname as parameter(s)"{
            (PsNetTping -Destination 'sbb.ch' -TcpPort 443 -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] Testing PsNetTping with IP Address as parameter(s)"{
            (PsNetTping -Destination '194.150.245.142' -TcpPort 443 -Timeout 1000) | should BeOfType [Object]
        }

    }

    Context "Testing method PsNetUping" {
        
        it "[NEG] Testing PsNetUping with false Port as parameter(s)"{
            (PsNetUping -Destination 'sbb.ch' -UdpPort 443443 -Timeout 1000) | should match 'Parameter name: port'
        }

        it "[NEG] Testing PsNetUping with false IP Address as parameter(s)"{
            (PsNetUping -Destination '255.255.255.255' -UdpPort 53 -Timeout 1000).UdpSucceeded | should be $false
        }

        it "[POS] Testing PsNetUping with Hostname as parameter(s)"{
            (PsNetUping -Destination 'sbb.ch' -UdpPort 53 -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] Testing PsNetUping with IP Address as parameter(s)"{
            (PsNetUping -Destination '194.150.245.142' -UdpPort 53 -Timeout 1000) | should BeOfType [Object]
        }

    }

    Context "Testing method PsNetWping" {
        
        if($IsMacOS){
            it "[NEG] Testing PsNetWping with false protocol as parameter(s)"{
            (PsNetWping -Destination 'file://sbb.ch' -Timeout 1000) | should match 'Could not find file'
            }
        }

        if($IsWindows){
            it "[NEG] Testing PsNetWping with false protocol as parameter(s)"{
            (PsNetWping -Destination 'file://sbb.ch' -Timeout 1000) | should match 'The UNC path should be of the form'
            }
        }

        it "[POS] Testing PsNetWping without noproxy parameter(s)"{
            (PsNetWping -Destination 'https://sbb.ch' -Timeout 1000) | should BeOfType [Object]
        }

        it "[POS] Testing PsNetWping with all parameter(s)"{
            (PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy) | should BeOfType [Object]
        }

    }

}

Pop-Location