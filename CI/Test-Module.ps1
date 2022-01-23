# Retrieve parent folder
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$ModuleName = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName
$Manifest = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"

Import-Module $Manifest -Force

if(!(Get-Module Pester)){
    Import-Module -Name Pester -MinimumVersion 4.4.0
}

$Test = ((Get-Item $Root)).FullName
$TestFolderPath = Join-Path -Path $Test -ChildPath 'Tests'

if(Test-Path $TestFolderPath){
    Write-Host "[TESTS] [START] Launching of Testing Process" -ForegroundColor Yellow
    $Result = Invoke-Pester $TestFolderPath -Output Detailed -PassThru
    Write-Host "[TESTS] [END ] End of Testing Process" -ForegroundColor Yellow
    if($Result.FailedCount -eq 0){
        Write-Host "[BUILD] [END ] [OK] All Tests are passed, ready to merge" -ForegroundColor GREEN
    }
}