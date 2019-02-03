#From Stephane van Gulick (Thanks!)

Write-Host "[BUILD] [START] Launching Build Process" -ForegroundColor Yellow	

# Retrieve parent folder
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$ModuleName = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName

$CodeSourcePath = Join-Path -Path $Root -ChildPath "Code"

$ExportPath = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psm1"
if(Test-Path $ExportPath){
    Write-Host "[BUILD] [PSM1 ] PSM1 file detected. Deleting..." -ForegroundColor Yellow
    Remove-Item -Path $ExportPath -Force
}
$Date = Get-Date
"<#" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    Generated at $($Date) by Martin Walther" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    using module ..\$($ModuleName)\$($ModuleName).psm1" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"#>" | out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[BUILD] [Code ] Loading Class, public and private functions" -ForegroundColor Yellow

$PublicClasses    = Get-ChildItem -Path "$CodeSourcePath\Classes\" -Filter *.ps1 | sort-object Name
$PrivateFunctions = Get-ChildItem -Path "$CodeSourcePath\Functions\Private" -Filter *.ps1
$PublicFunctions  = Get-ChildItem -Path "$CodeSourcePath\Functions\Public" -Filter *.ps1

$MainPSM1Contents = @()
$MainPSM1Contents += $PublicClasses
$MainPSM1Contents += $PrivateFunctions
$MainPSM1Contents += $PublicFunctions

#Creating PSM1
Write-Host "[BUILD] [START] [PSM1] Building Module PSM1" -ForegroundColor Yellow
"#region namespace $($ModuleName)" | out-File -FilePath $ExportPath -Encoding utf8 -Append
Foreach($file in $MainPSM1Contents){
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}
"#endregion" | out-File -FilePath $ExportPath -Encoding utf8 -Append

$PostContentPath = Join-Path -Path $Current -ChildPath "03_postContent.ps1"
if(Test-Path $PostContentPath){
    Write-Host "[BUILD] [START] [POST] Adding post content" -ForegroundColor Yellow
    $file = Get-item $PostContentPath
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}
Write-Host "[BUILD] [END  ] [PSM1] building Module PSM1 " -ForegroundColor Yellow

Write-Host "[BUILD] [START] [PSD1] Manifest PSD1" -ForegroundColor Yellow
Write-Host "[BUILD] [PSD1 ] Adding functions to export" -ForegroundColor Yellow
$FunctionsToExport = $PublicFunctions.BaseName
$Manifest = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"
Update-ModuleManifest -Path $Manifest -FunctionsToExport $FunctionsToExport
Write-Host "[BUILD] [END  ] [PSD1] building Manifest" -ForegroundColor Yellow

$Test = ((Get-Item $Root)).FullName
$TestFolderPath = Join-Path -Path $Test -ChildPath 'Tests'

if(Test-Path $TestFolderPath){
    Write-Host "[TESTS] [START] Launching of Testing Process" -ForegroundColor Yellow
    $Result = Invoke-Pester $TestFolderPath -Show Failed -PassThru
    Write-Host "[TESTS] [END ] End of Testing Process" -ForegroundColor Yellow
    if($Result.FailedCount -eq 0){
        Write-Host "[BUILD] [END  ] [OK] All Tests are passed, ready to merge" -ForegroundColor GREEN
    }
}