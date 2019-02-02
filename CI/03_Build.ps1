#From Stephane van Gulick (Thanks!)

Write-Host "[BUILD][START] Launching Build Process" -ForegroundColor RED -BackgroundColor White

# Retrieve parent folder
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$ModuleName = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName

$CodeSourcePath = Join-Path -Path $Root -ChildPath "Code"

$ExportPath = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psm1"
if(Test-Path $ExportPath){
    Write-Host "[BUILD][PSM1] PSM1 file detected. Deleting..." -ForegroundColor RED -BackgroundColor White
    Remove-Item -Path $ExportPath -Force
}
$Date = Get-Date
"<#" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    Generated at $($Date) by Martin Walther" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    using module ..\$($ModuleName)\$($ModuleName).psm1" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"#>" | out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[BUILD][Code] Loading Class, public and private functions" -ForegroundColor RED -BackgroundColor White

$PublicClasses    = Get-ChildItem -Path "$CodeSourcePath\Classes\" -Filter *.ps1 | sort-object Name
$PrivateFunctions = Get-ChildItem -Path "$CodeSourcePath\Functions\Private" -Filter *.ps1
$PublicFunctions  = Get-ChildItem -Path "$CodeSourcePath\Functions\Public" -Filter *.ps1

$MainPSM1Contents = @()
$MainPSM1Contents += $PublicClasses
$MainPSM1Contents += $PrivateFunctions
$MainPSM1Contents += $PublicFunctions

#Creating PSM1
Write-Host "[BUILD][START][PSM1] Building Module PSM1" -ForegroundColor RED -BackgroundColor White
Foreach($file in $MainPSM1Contents){
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}

$PostContentPath = Join-Path -Path $Current -ChildPath "03_postContent.ps1"
if(Test-Path $PostContentPath){
    Write-Host "[BUILD][START][POST] Adding post content" -ForegroundColor RED -BackgroundColor White
    $file = Get-item $PostContentPath
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}
Write-Host "[BUILD][END][PSM1] building Module PSM1 " -ForegroundColor RED -BackgroundColor White

Write-Host "[BUILD][START][PSD1] Manifest PSD1" -ForegroundColor RED -BackgroundColor White
Write-Host "[BUILD][PSD1] Adding functions to export" -ForegroundColor RED -BackgroundColor White
$FunctionsToExport = $PublicFunctions.BaseName
$Manifest = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"
Update-ModuleManifest -Path $Manifest -FunctionsToExport $FunctionsToExport
Write-Host "[BUILD][END][PSD1] building Manifest" -ForegroundColor RED -BackgroundColor White

Write-Host "[BUILD][END] End of Build Process" -ForegroundColor RED -BackgroundColor White

$Test = ((Get-Item $Root)).FullName
$TestFolderPath = Join-Path -Path $Test -ChildPath 'Tests'

if(Test-Path $TestFolderPath){
    Write-Host "[TESTS][START] Launching of Testing Process" -ForegroundColor RED -BackgroundColor White
    $Result = Invoke-Pester $TestFolderPath -Show All -PassThru
    if($Result.FailedCount -gt 0){
        $Result.TestResult
    }
    Write-Host "[TESTS][END] End of Testing Process" -ForegroundColor RED -BackgroundColor White
}