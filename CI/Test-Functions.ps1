# Retrieve parent folder
if(Get-Module PsNetTools){Remove-Module PsNetTools}
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$CodeSourcePath   = Join-Path -Path $Root -ChildPath "Code"
$PrivateFunctions = Get-ChildItem -Path (Join-Path $CodeSourcePath -ChildPath 'Functions\Private*.ps1')
$PublicFunctions  = Get-ChildItem -Path (Join-Path $CodeSourcePath -ChildPath 'Functions\Public*.ps1')

$AllFunctions = @()
$AllFunctions += $PrivateFunctions
$AllFunctions += $PublicFunctions
$AllFunctions | ForEach-Object { Invoke-Command $($_) }

$Test = ((Get-Item $Root)).FullName
$TestFolderPath = Join-Path -Path $Test -ChildPath 'Tests'

if(Test-Path $TestFolderPath){

    if(!(Get-Module Pester)){
        Import-Module -Name Pester -MinimumVersion 4.4.0
    }

    Write-Host "[TESTS] [START] Test all functions before build" -ForegroundColor Yellow
    $Result = Invoke-Pester -Path $TestFolderPath -PassThru
    Write-Host "[TESTS] [END ] End of Testing Process" -ForegroundColor Yellow
    if($Result.FailedCount -eq 0){
        Write-Host "[BUILD] [END ] [OK] All Tests are passed, ready to merge" -ForegroundColor GREEN
    }
}