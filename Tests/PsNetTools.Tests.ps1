using module ..\PsNetTools\PsNetTools.psm1

Describe "Testing class PsNetTools" {

    Context "Testing method dig" {  
          
        it "[NEG] Testing dig without parameter(s)"{
            ([PsNetTools]::dig()) | should match 'Usage:'
        }

        it "[NEG] Testing dig with false Hostname as parameter(s)"{
            ([PsNetTools]::dig('sbb.66')) | should match 'No such host is known'
        }
                
        it "[NEG] Testing dig with false IP Address as parameter(s)"{
            ([PsNetTools]::dig('127.0.0.255')) | should match 'The requested name is valid'
        }
                
        it "[POS] Testing dig with Hostname as parameter(s)"{
            ([PsNetTools]::dig('sbb.ch')) | should BeOfType [Object]
        }

        it "[POS] Testing dig with IP Address as parameter(s)"{
            ([PsNetTools]::dig('127.0.0.1')) | should BeOfType [Object]
        }

    }
        
    Context "Testing method tping" {     
       
        it "[NEG] Testing tping without parameter(s)"{
            ([PsNetTools]::tping()) | should match 'Usage:'
        }
                
        it "[NEG] Testing tping with false Hostname as parameter(s)"{
            ([PsNetTools]::tping('sbb.66', 443, 1000)) | should match 'No such host is known'
        }

        it "[NEG] Testing tping with false Port as parameter(s)"{
            ([PsNetTools]::tping('sbb.ch', 443443, 1000)) | should match 'Parameter name: port'
        }

        it "[NEG] Testing tping with false IP Address as parameter(s)"{
            ([PsNetTools]::tping('255.255.255.255', 443, 1000)) | should match 'The requested address is not valid'
        }

        it "[POS] Testing tping with Hostname as parameter(s)"{
            ([PsNetTools]::tping('sbb.ch', 443, 1000)) | should BeOfType [Object]
        }

        it "[POS] Testing tping with IP Address as parameter(s)"{
            ([PsNetTools]::tping('194.150.245.142', 443, 1000)) | should BeOfType [Object]
        }

    }

    Context "Testing method uping" {
        
        it "[NEG] Testing uping without parameter(s)"{
            ([PsNetTools]::uping()) | should match 'Usage:'
        }
                
        it "[NEG] Testing uping with false Port as parameter(s)"{
            ([PsNetTools]::uping('sbb.ch', 443443, 1000)) | should match 'Parameter name: port'
        }

        it "[NEG] Testing uping with false IP Address as parameter(s)"{
            ([PsNetTools]::uping('255.255.255.255', 443, 1000)).UdpSucceeded | should be $false
        }

        it "[POS] Testing uping with Hostname as parameter(s)"{
            ([PsNetTools]::uping('sbb.ch', 443, 1000)) | should BeOfType [Object]
        }

        it "[POS] Testing uping with IP Address as parameter(s)"{
            ([PsNetTools]::uping('194.150.245.142', 443, 1000)) | should BeOfType [Object]
        }

    }

    Context "Testing method wping" {
        
        it "[NEG] Testing wping without parameter(s)"{
            ([PsNetTools]::wping()) | should match 'Usage:'
        }
                
        it "[NEG] Testing wping with false Hostname as parameter(s)"{
            ([PsNetTools]::wping('file://sbb.66', 1000)) | should match 'The UNC path should be of the form'
        }

        it "[POS] Testing wping without noproxy parameter(s)"{
            ([PsNetTools]::wping('https://sbb.ch', 1000)) | should BeOfType [Object]
        }

        it "[POS] Testing wping with all parameter(s)"{
            ([PsNetTools]::wping('https://sbb.ch', 1000, 'noproxy')) | should BeOfType [Object]
        }

    }

}

Pop-Location