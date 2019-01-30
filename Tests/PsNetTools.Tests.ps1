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

    Context "Testing method Test-PsNetDig" {  
        
        if($IsMacOS){
            it "[NEG] [Mac] Testing Test-PsNetDig with false Hostname as parameter(s)"{
                (Test-PsNetDig -Destination 'sbb.powershell').Succeeded | should not BeTrue
            }
                    
            it "[NEG] [Mac] Testing Test-PsNetDig with false IP Address as parameter(s)"{
                (Test-PsNetDig -Destination '255.255.255.256').Succeeded | should not BeTrue
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing Test-PsNetDig with false Hostname as parameter(s)"{
                (Test-PsNetDig -Destination 'sbb.powershell').Succeeded | should not BeTrue
            }
                
            it "[NEG] [Win] Testing Test-PsNetDig with false IP Address as parameter(s)"{
                (Test-PsNetDig -Destination '255.255.255.256').Succeeded | should not BeTrue
            }
        }
    
        it "[POS] [Any] Testing Test-PsNetDig with Hostname as parameter(s)"{
            (Test-PsNetDig -Destination 'sbb.ch').Succeeded | should BeTrue
        }

        it "[POS] [Any] Testing Test-PsNetDig with IP Address as parameter(s)"{
            (Test-PsNetDig -Destination '127.0.0.1').Succeeded | should BeTrue
        }

    }
        
    Context "Testing method Test-PsNetTping" {     
       
        if($IsMacOS){
            it "[NEG] [Mac] Testing Test-PsNetTping with false Hostname as parameter(s)"{
            (Test-PsNetTping -Destination 'sbb.powershell' -TcpPort 443 -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing Test-PsNetTping with false Hostname as parameter(s)"{
            (Test-PsNetTping -Destination 'sbb.powershell' -TcpPort 443 -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        it "[NEG] [Any] Testing Test-PsNetTping with false Port as parameter(s)"{
            (Test-PsNetTping -Destination 'sbb.ch' -TcpPort 443443 -Timeout 1000).Succeeded | should not BeTrue
        }

        if($IsMacOS){
            it "[NEG] [Mac] Testing Test-PsNetTping with false IP Address as parameter(s)"{
                (Test-PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing Test-PsNetTping with false IP Address as parameter(s)"{
                (Test-PsNetTping -Destination '255.255.255.255' -TcpPort 443 -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        it "[POS] [Any] Testing Test-PsNetTping with Hostname as parameter(s)"{
            (Test-PsNetTping -Destination 'sbb.ch' -TcpPort 443 -Timeout 1000).Succeeded | should BeTrue
        }

        it "[POS] [Any] Testing Test-PsNetTping with IP Address as parameter(s)"{
            (Test-PsNetTping -Destination '194.150.245.142' -TcpPort 443 -Timeout 1000).Succeeded | should BeTrue
        }

    }

    Context "Testing method Test-PsNetUping" {
        
        it "[NEG] [Any] Testing Test-PsNetUping with false Port as parameter(s)"{
            (Test-PsNetUping -Destination 'sbb.ch' -UdpPort 443443 -Timeout 1000).Succeeded | should not BeTrue
        }

        it "[NEG] [Any] Testing Test-PsNetUping with false IP Address as parameter(s)"{
            (Test-PsNetUping -Destination '255.255.255.255' -UdpPort 53 -Timeout 1000).Succeeded | should not BeTrue
        }

        it "[POS] [Any] Testing Test-PsNetUping with Hostname as parameter(s)"{
            (Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -Timeout 1000).Succeeded | should BeTrue
        }

        it "[POS] [Any] Testing Test-PsNetUping with IP Address as parameter(s)"{
            (Test-PsNetUping -Destination '194.150.245.142' -UdpPort 53 -Timeout 1000).Succeeded | should BeTrue
        }

    }

    Context "Testing method Test-PsNetWping" {
        
        if($IsMacOS){
            it "[NEG] [Mac] Testing Test-PsNetWping with false Uri as parameter(s)"{
            (Test-PsNetWping -Destination 'https:sbb.ch' -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        if($IsWindows){
            it "[NEG] [Win] Testing Test-PsNetWping with false Uri as parameter(s)"{
            (Test-PsNetWping -Destination 'https:sbb.ch' -Timeout 1000).Succeeded | should not BeTrue
            }
        }

        it "[POS] [Any] Testing Test-PsNetWping without noproxy parameter(s)"{
            (Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000).Succeeded | should BeTrue
        }

        it "[POS] [Any] Testing Test-PsNetWping with all parameter(s)"{
            (Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy).Succeeded | should BeTrue
        }

    }

    Context "Testing method Get-PsNetAdapters" {
    
        it "[POS] [Any] Testing Get-PsNetAdapters"{
            (Get-PsNetAdapters).Succeeded | should BeTrue
        }

        it "[POS] [Any] Testing Get-PsNetAdapterConfiguration"{
            (Get-PsNetAdapterConfiguration).Succeeded | should BeTrue
        }
    }

}

Pop-Location