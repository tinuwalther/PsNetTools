# Retrieve parent folder
if(Get-Module PsNetTools){Remove-Module PsNetTools}
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$ModuleName       = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName
$ModuleDefinition = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"

$Test = ((Get-Item $Root)).FullName
$TestFolderPath = Join-Path -Path $Test -ChildPath 'Tests'

if(Test-Path $TestFolderPath){

    if(!(Get-Module Pester)){
        Import-Module -Name Pester -MinimumVersion 4.4.0
    }

    Import-Module $ModuleDefinition

    Write-Host "[TESTS] [START] Test all functions before build" -ForegroundColor Yellow
    $Result = Invoke-Pester -Path $TestFolderPath -PassThru
    Write-Host "[TESTS] [END ] End of Testing Process" -ForegroundColor Yellow
    if($Result.FailedCount -eq 0){
        Write-Host "[BUILD] [END ] [OK] All Tests are passed, ready to merge" -ForegroundColor GREEN
    }
}