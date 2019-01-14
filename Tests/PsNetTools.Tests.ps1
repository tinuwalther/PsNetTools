using module ..\PsNetTools\PsNetTools.psm1


Describe "Testing dig" {
        
    it "Testing dig without parameters"{
        ([PsNetTools]::dig()) | should match 'Usage:'
    }
                
    it "Testing dig with all parameters"{
        ([PsNetTools]::dig('sbb.ch')) | should BeOfType [Object]
    }

}
    
Describe "Testing tping" {
        
    it "Testing tping without parameters"{
        ([PsNetTools]::tping()) | should match 'Usage:'
    }
                
    it "Testing tping with all parameters"{
        ([PsNetTools]::tping('sbb.ch', 443, 1000)) | should BeOfType [Object]
    }

}

Describe "Testing uping" {
        
    it "Testing uping without parameters"{
        ([PsNetTools]::uping()) | should match 'Usage:'
    }
                
    it "Testing uping with all parameters"{
        ([PsNetTools]::uping('sbb.ch', 53, 1000)) | should BeOfType [Object]
    }

}

Describe "Testing wping" {
        
    it "Testing wping without parameters"{
        ([PsNetTools]::wping()) | should match 'Usage:'
    }
                
    it "Testing wping with all parameters"{
        ([PsNetTools]::wping('https://sbb.ch', 1000)) | should BeOfType [Object]
    }

}


Pop-Location