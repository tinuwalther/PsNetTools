$TestsPath = Split-Path $MyInvocation.MyCommand.Path

$RootFolder = (Get-Item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName

Set-Location -Path $RootFolder.FullName

Write-Verbose "Importing module"

#Import-Module .\PsNetTools -Force

Context "Testing PsNetTools"{

    Describe "Testing dig" {
        
        it "Testing dig without parameters"{
            ([PsNetTools]::dig()) | should be $null
        }
                
        it "Testing dig with all parameters"{
            ([PsNetTools]::dig('sbb.ch')) | should BeOfType [Object]
        }

    }
    
    Describe "Testing tping" {
        
        it "Testing tping without parameters"{
            ([PsNetTools]::tping()) | should be $null
        }
                
        it "Testing tping with all parameters"{
            ([PsNetTools]::tping('sbb.ch', 443, 1000)) | should BeOfType [Object]
        }

    }

    Describe "Testing uping" {
        
        it "Testing uping without parameters"{
            ([PsNetTools]::uping()) | should be $null
        }
                
        it "Testing uping with all parameters"{
            ([PsNetTools]::uping('sbb.ch', 53, 1000)) | should BeOfType [Object]
        }

    }

    Describe "Testing wping" {
        
        it "Testing wping without parameters"{
            ([PsNetTools]::wping()) | should be $null
        }
                
        it "Testing wping with all parameters"{
            ([PsNetTools]::wping('https://sbb.ch', 1000)) | should BeOfType [Object]
        }

    }

}

Pop-Location